---
title: Apache ZooKeeper's Strategy for Handling Network Partition
date: 2023-09-16 12:28:57
tags:
  - Distributed System
  - Zookeeper
  - Network Partition
---

TL;DR

- Zookeeper always avoids Split Brain problem with it's majority rule for quorum
- When network partition happens, the group with the majority of nodes (if it exists) can continue to serve read and write requests
- When network partition happens, the group with minority nodes can not continue to serve write requests but can continue to serve read requests with client and server properly configured. It is obvious that read requests in this case will return stale values.

<!--more-->

## 1 Configurations Related to Network Partition

These configurations can be found in [Zookeeper Administrator's Guide](https://zookeeper.apache.org/doc/r3.4.9/zookeeperAdmin.html)

### 1.1 group.x=nnnnn[:nnnnn] & weight.x=nnnnn

These two configurations have effects on the Zookeeper's election process, which are also related to the Zookeeper's behavior under network partition. Zookeeper's philosophy is always to avoid Split Brain. To achieve this, the Zookeeper quorum requires a majority to make the vote. These two configurations do not make changes to the majority rule, they just assign nodes weight or into groups and execute the majority rule based on that.

With the default (and also seems unchangeable) majority rule, Zookeeper server nodes are always split into groups that only one of them can still have the capability to vote (has enough nodes to vote over the majority). As the ZAB, which is used to broadcast messages from leader to followers, needs a vote, it is guaranteed that only one group of Zookeeper server split nodes can work on write requests continuously.

The following descriptions are from O'Reilly's Zookeeper book:

> Even worse, if some workers can’t communicate with the primary master, say because of a network partition, they may end up following the second primary master. This scenario leads to a problem commonly called split-brain: two or more parts of the system make progress independently, leading to inconsistent behavior. As part of coming up with a way to cope with master failures, it is critical that we avoid split-brain scenarios.

> It is important to choose an adequate size for the quorum. Quorums must guarantee that, regardless of delays and crashes in the system, any update request the service positively acknowledges will persist until another request supersedes it. - also can be used to avoid split-brain scenarios

### 1.2 readonlymode.enabled (server side) & canBeReadOnly (client side)

These configurations are the only two configurations directly related to Zookeeper's behavior under the network partition

With both true values to the two configurations, clients connected to Zookeeper nodes that are in the minority group under network partition will still work on read requests (with them open, it means that the application can stand with stale data).

The following descriptions are from O'Reilly's Zookeeper book:

> This feature enables a client to read (but not write) the state of ZooKeeper in the presence of a network partition. In such cases, clients that have been partitioned away can still make progress and don’t need to wait until the partition heals. It is very important to note that a ZooKeeper server that is disconnected from the rest of the ensemble might end up serving stale state in read-only mode.

## 2 Common Misunderstandings

### 2.1 An odd number of servers is needed for the majority rule

Like the descritpion [here](https://docs.confluent.io/platform/current/kafka-metadata/zk-production.html#:~:text=In%20a%20production%20environment%2C%20the,perform%20majority%20elections%20for%20leadership.), it says:

> The odd number of servers allows ZooKeeper to perform majority elections for leadership.

This is not right, the best practice for an odd number of servers is because an even number will not improve anything for the Zookeeper cluster but add overhead to maintaining extra nodes. See the examples:

- with Zookeeper cluster of 5 nodes, the quorum with default majority rule (no weight, no group) will need 5 / 2 + 1 = 3 nodes, which means we can tolerate the failure of 5 - 3 = 2 nodes
- with Zookeeper cluster of 6 nodes, the quorum with default majority rule (no weight, no group) will need 6 / 2 + 1 = 4 nodes, which means we can tolerate the failure of 6 - 4 = 2 nodes

Without improvement on failure tolerance, it does not make sense to maintain a Zookeeper cluster with an even number of ndoes.

## 3 Reference

- zookeeper O'Relly page 14 - ZooKeeper has been designed with mostly consistency and availability in mind, although it also provides read-only capability in the presence of network partitions.
- zookeeper O'Relly page 25 - The service in this state is able to make progress because there are three servers available and it really needs only two according to our assumptions - When work in quorum mdoe and quorom config < current connected services
- zookeeper O'Relly page 143 - As the server transitions to read-only mode, it cannot form a quorum with other servers because it is partitioned away
- [ZooKeeper Internals](https://zookeeper.apache.org/doc/current/zookeeperInternals.html#sc_guaranteesPropertiesDefinitions)
- [Partial Network Partitioning](https://dl.acm.org/doi/pdf/10.1145/3576192)
- [Apache Zookeeper Docs: How ZooKeeper Handles Failure Scenarios](https://cwiki.apache.org/confluence/display/ZOOKEEPER/FailureScenarios)
