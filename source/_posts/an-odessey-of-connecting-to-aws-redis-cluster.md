---
title: An Odessey of Connecting to Amazon Redis Cluster
date: 2022-06-03 14:54:34
tags: [Redis]
---

Nowadays, Redis is an indispensable middleware in building the backend service of an app. As an ambitious team, we bought a Redis cluster under Amazon ElastiCache with the following features:

- Clustered with several shards, and each shard owns 3 nodes (each shard performs primary-replica)
- Encryption in transit enabled (or TLS) to assure no man-in-the-middle attack
- Redis AUTH enabled (of course we do not want a door without a key)

So far so good, it seems that we can concentrate on developing our product now. But wait, as the title says, the way is too long to get there!

<!--more-->

## Redis is not Reachable Outside VPC

As the [Amazon docs - Understanding ElastiCache and Amazon VPCs](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/VPCs.EC.html) describes, our EC2 and Redis instances in the same VPC can connect to each other without a problem. Following the detailed [Amazon docs - Connecting to nodes](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/nodes-connecting.html), the redis-cli is installed and we tried to connect to Redis with:

```shell
 redis-cli -c --tls -a your-pwd -h your-cluster-identifier.amazonaws.com -p your-port
```

Now we can execute Redis commands like:

```shell
SET a b EX 60
```

The redis-cli worked smoothly with clustered Redis (-c option is added in the connect command), It redirected our command to the target node that owns the slot mapped to the key and told us what happened:

```shell
-> Redirected to slot [15495] located at target-node-identifier.amazonaws.com:6379
OK
```

But wait, we have much development work to do on our local machine before deploying our code to the EC2 server. If we try to connect to Redis with earlier command, the following error will emerge:

```text
Could not connect to Redis at your-cluster-identifier.amazonaws.com:your-port: Operation timed out
```

To solve the problem, [Aws docs - Accessing ElastiCache resources from outside AWS](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/accessing-elasticache.html#access-from-outside-aws) suggests using AWS Client VPN. But the setup is a little complicated and in this way, anyone in our team has to make settings in their own machine, which will take much time and we want to find a more efficient way.

## First Try - Use Nginx as Proxy

Since our local machines cannot connect to the Redis cluster while our EC2 instance can, we can use [Nginx stream proxy module](http://nginx.org/en/docs/stream/ngx_stream_proxy_module.html) to forward our data stream of TCP connection inside Redis connection. Install Nginx dynamic module on EC2 instance with `sudo yum install nginx-mod-stream` and add the snippet below to `/etc/nginx/nginx.conf`:

```shell
stream {
    server {
        listen 12345;
        proxy_pass your-cluster-identifier.amazonaws.com:6379;
        proxy_socket_keepalive on;
        proxy_timeout 60m;
        proxy_connect_timeout 60s;
    }
}
```

Make sure the configuration is ok with `sudo nginx -t` and then reload it with `sudo nginx -s reload`. Now we get a proxy that can forward our TCP packages to the Redis cluster (one node of it), which is listening on the port number 12345 at one of our EC2 instances.

Is the problem fully resolved? It looks fine at the first glance, but when running

```shell
redis-cli -c -h ec2-ip -p 12345 --tls -a your-pwd
```

We connected to the cluster successfully, but when we execute commands like

```shell
SET a b EX 60
```

The similar words appeared on the screen again

```shell
-> Redirected to slot [15495] located at target-node-identifier.amazonaws.com:6379
```

But the line with the words `OK` never showed up. It was just stuck there and after a period of time, it alerted

```shell
Could not connect to Redis at target-node-identifier.amazonaws.com:6379: Operation timed out
```

At the same time, we tried to use our java code to connect to the Redis cluster through the proxy. We are using `Vert.x-redis` and the log showed that it also got a problem

```text
io.vertx.core.impl.NoStackTraceThrowable: Failed to connect to all nodes of the cluster
```

What was exactly going on there?

## Dive into the Redis Cluster

It seems that we can connect to the Redis cluster on some level (the redis-cli initial connect try worked) but fail to connect to other nodes. To figure it out, we need to dive into the Redis Cluster and make the internal mechanism clear.

Here comes the description from [Redis Docs - Client and Server roles in the Redis cluster protocol](https://redis.io/docs/reference/cluster-spec/#client-and-server-roles-in-the-redis-cluster-protocol)

> Since cluster nodes are not able to proxy requests, clients may be redirected to other nodes using redirection errors -MOVED and -ASK. The client is in theory free to send requests to all the nodes in the cluster, getting redirected if needed, so the client is not required to hold the state of the cluster. However, clients that are able to cache the map between keys and nodes can improve the performance in a sensible way.

We also had a look back to the [AWS docs - Finding connection endpoints](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Endpoints.html#Endpoints.Find.RedisCluster), it states that

> Which endpoints to use - Redis (cluster mode enabled) clusters: use the cluster's Configuration Endpoint for all operations that support cluster mode enabled commands

So what is the Configuration Endpoint? We cannot get a clear definition from AWS docs. StackOverflow threads like [ElasticCache - What is the difference between the configuration and node endpoint?](https://stackoverflow.com/questions/19194123/elasticcache-what-is-the-difference-between-the-configuration-and-node-endpoin) give us a feeling that it's one of the nodes in the Redis cluster. As every node in the cluster is equal, we can query from any one of them to get the whole information of all nodes. It is a proper way for AWS to assign a special URL related to one of the nodes and let the developer take it as a connection string to the cluster, thus we are free from the problem of picking one URL from all the nodes.

The real issue under the surface is ready to come out. We think the Redis Cluster is proxied with Nginx, but actually, there is only one node of it that got proxied. So redis-client on my local machine can connect to it, but failed when redirecting to others. To make the Redis Cluster fully work on local machines' redis-cli, all the nodes' URLs (or in other words, endpoint) should be proxied as the following picture demonstrates.

![redis-cli interaction](redis-cli-interaction.jpeg)

Case in `Vert.x-redis` is a little different from the redis-cli one as it is a so-called smart client with a cached internal routing table, as well as established connections to all the nodes at the very beginning. This picture illustrates a normal workflow for a smart client.

![smart client interaction](smart-client-interaction.jpeg)

If we proxy all the connections towards different nodes via different Nginx ports and change DNS to make all the hostname lookup fixed to the EC2 IP (the port problem remains), it seems that we can achieve what we want. But again, this is really a bad idea since each member of our team has to set up their own machine, which we want to avoid.

## Redis Cluster Proxy Comes to Rescue

My brilliant teammate proposes a concept called Redis Cluster Proxy that may save our life. It works like the above smart client interaction workflow. The key different thing is that the client can communicate with the proxy in standalone mode, and the proxy handles all the node cache and redirect things just like a smart client.

AWS might have noticed the call from customers (especially from China), as they posted two blogs (written in Chinese) to introduce how to deploy Redis Cluster Proxy on EC2:

- https://aws.amazon.com/cn/blogs/china/build-elasticache-for-redis-cluster-agent-service-cluster-part1/
- https://aws.amazon.com/cn/blogs/china/build-elasticache-for-redis-cluster-agent-service-cluster-part-2/

We gave them a try without hesitation, but both tools cannot work in our case:

- the [RedisLabs/redis-cluster-proxy](https://github.com/RedisLabs/redis-cluster-proxy) stopped updating 2 years ago, and the Redis TLS support is not released at that time. So this application is lack TLS support not surprisingly. Many other utils like [netease-im/camellia](https://github.com/netease-im/camellia) are in the same situation
- the [bilibili/overlord](https://github.com/bilibili/overlord) states in its documentation that `redis_auth` is not supported yet

## The Finale

The road is tough and we are still crawling forward. We may create a Redis Cluster Proxy tool with full TLS & auth support, or just adjust the Redis for dev use to cluster disabled. The first one is difficult but exciting, while the second is easy but upsetting.

One more thing I want to share with you is the difference between Aliyun Redis and AWS Redis. Aliyun Redis instance is deployed with a Redis Cluster Proxy as the default option, and you can change the settings to negotiate with the cluster directly on demand. In this way, most developers can connect to Redis Cluster instances with standalone mode, and thus reduce the complexity of software development.

