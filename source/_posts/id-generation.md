---
title: Best Practice for Unique Identifier Generation
date: 2025-12-03 13:24:08
tags: 
  - system design
---

Unique identifiers are essential in almost any system. In an e-commerce platform, a unique ID identifies a specific order; in a payment system, it identifies a transaction. And even the users themselves are represented by such IDs. In this post, we will look at best practices for generating unique identifiers that can be used across a wide range of business systems.

## [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier#Random_UUID_probability_of_duplicates)

A UUID (Universally unique identifier) is a 128-bit number designed to provide a simple way to generate IDs that are effectively unique. In Microsoft-designed systems, the equivalent term GUID (Globally unique identifier) is used. UUIDs come in several versions, including:

- UUIDV1 generates a unique ID based on the 48-bit MAC address and a 60-bit timestamp (100-nanosecond intervals). So here the uniqueness in part on an identifier issued by a central registration authority, namely the organizationally unique identifier part of the MAC address, which is issued by the IEEE to manufactures of networking equipment. If the MAC address is sensitive data, use other versions instead. For example, the privacy hole was used to locate the creator of the [Melissa virus](https://en.wikipedia.org/wiki/Melissa_(computer_virus)).
- UUIDV4 generates a unique ID based on randomness. For variant 1, it has 122 bits out of 128 bits that are randomly generated, which provides $2^{122}$ unique identifiers.

So how unique the generated IDs are:

- UUIDV1 can generate 163 billion unique IDs per second per machine.
- For UUIDV4, collision can happen even without a problem in the implementation. But the probability is so small that it can be normally ignored and can be [computed](https://en.wikipedia.org/wiki/Universally_unique_identifier#Collisions) based on the analysis of the birthday problem. For UUIDV4, a collision is expected to happen with 50% probability in 86 years with generating 1 billion UUIDs per second.

## [Nano ID](https://zelark.github.io/nano-id-cc/)

Project Nano ID is a library for generating random IDs similar to UUID. It is possible there will be duplicate IDs created, but this probability is extremely low. 

Nano ID is different from UUID in two ways. First, it allows a larger alphabet, allowing the packing of a comparable number of unique identifiers using fewer bits. Second, many projects generate IDs in relatively small quantities. Nano ID lets developers customize ID length to fit their needs.

Nano ID even provides a [collision calculator](https://zelark.github.io/nano-id-cc/) that estimates collision likelihood based on the alphabet, ID length, and the ID generation rate. This allows users to fine-tune the ID length for their specific system, resulting in a more customizable and efficient solution.

## Snowflake

Snowflake ID is a compact and efficient for storage in databases as a single 64-bit integer. Conceptually, Snowflake IDs can be viewed as a shorter version of UUID version 1 in three aspects:

- Timestamp: Snowflake allocates 41 bits for a milliseconds-precision timestamp, whereas UUID version 1 uses 60 bits to represent 100-nanosecond intervals.
- Machine ID: Instead of embedding the 48-bit MAC address, Snowflake uses configurable data-center and machine identifiers, typically totaling 10 bits by default.
- Sequence number: Snowflake assigns 12 bits for the sequence, compared to the 13-14 bits used by UUID version 1.

Given those changes, is Snowflake also better than UUID version 4 or Nano ID? In several ways, the answer is yes:

- The ID is compact. It only needs 64 bits, compared to 84 bits for a Nano ID by default, and 128 bits for a UUID.
- The ID is time-ordered. This matters because many developers use those IDs as primary key in relational databases such as MySQL. As Michael Coburn explains in this [blog post](https://www.percona.com/blog/illustrating-primary-key-models-in-innodb-and-their-impact-on-disk-usage/), inserting rows with unordered UUIDs as primary keys results in significant fragmentation due to random-order insertion causing frequent page splits. Using an ordered primary key improves insertion performance (fewer page splits), saves disk space (pages stay more compact), and memory efficiency (cached pages tend to remain "full").
- Retrievable creation time: just as UUID version 1 was used to track generator's MAC address, Snowflake ID could be used to deduce the creation time. This may be taken as a disadvantage sometimes though.

However, Snowflake IDs also come with several drawbacks:

- Clock-drift intolerant. Apparently, when clock moves backward, for example, after syncing with a NTP server, duplicated IDs may be generated.
- Complex configuration. I personally encountered misconfiguration issues with a Snowflake ID generator in my first job back in 2019. We were using Spring Boot and our developer team incorrectly assumed that settings in `bootstrap.yml` would override those in the `application.yml` packaged in the JAR. Eventually, we had to put the configuration in a `application.yml` file along the JAR to achieve. I wrote a (Chinese) [blog post](https://blog.langinteger.com/2019/05/30/centralized-configuration/) (written in Chinese) explaining the details.

## A better UUID version 1 - [UUID version 6/7](https://uuid.ramsey.dev/en/stable/rfc4122/version6.html)

Version 1 UUIDs are not sortable and can lead to scattered database records. To address the limitation, the version 6/7 UUIDs were introduced. 

Version 6 does this by storing the time in standard byte order, instead of breaking it up and rearranging the time bytes as in version 1. All remaining fields follow the original version 1 structure.

Version 7, often referred as a time-based UUID, uses a 46-bit timestamp in milliseconds since the Unix Epoch, filling the rest with random data. Unlike version 1 and version 6, it does not embed a MAC address.

## Comparison

✅ = better (in this comparision)
❌ = worse or not supported

|          | UUID V1  | UUID V4  | Nano ID  | Snowflake | UUID V6 | UUID V7 |
|----------|----------|----------|----------|----------|----------|----------|
| Ordered  |    ❌    |    ❌    |    ❌    |    ✅    |    ✅    |   ✅    |
| Privacy  |    ❌    |    ✅    |    ✅    |    ✅    |    ❌    |   ✅    |
| ID Length|    ❌    |    ❌    |    ✅    |    ✅    |    ❌    |    ❌   |
| Customization |    ❌    |    ❌    |    ✅    |    ❌     |    ❌    |    ❌   |



