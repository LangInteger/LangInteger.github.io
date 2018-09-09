---
title: Spring @Transactional两三事
date: 2018-07-13 23:14:54
toc: true
tags:
	- Spring
	- Transaction
	- Java
---
事务是指访问并可能更新数据库中各种数据项的一系列操作，这些操作要么全部成功，要么全部失败。如果说一个数据库支持事务，那么该数据库必须要具备ACID四个特性。亦即：
- 原子性（Atomicity）：事务包含的操作要么全部成功，要么全部失败
- 一致性（Consistency）：事务操作使数据库从一个一致性状态变换到另一个一致性状态
- 隔离性（Isolation）：多个用户并发访问数据库时，每个并发事务之间会互相隔离，不会互相干扰。
- 持久性（Durability）：事务操作对数据库中数据的改变是永久性的。
由此又引出事务的隔离级别、不同隔离级别会产生的不同毛病等问题。
在Spring中使用这些概念的时候，可能会和Spring中的一些具体的定义产生混淆，在此记录。
<!--more-->

## 1. Spring中的@Transactional(readonly = true)
在Service层，经常有看到在类头上加@Transactional(readonly = true)注解，再单独在一些需要进行数据库改变操作的方法上加上@Transactional的做法。看起来似乎保证了那些不需要对数据库进行更新操作的方法以只读方式进行数据库操作，既通过只读提高了执行的效率，又保障了数据的安全。但是，事实真的如此吗？
环境一：


## 2. Spring中的@Transactional面对Exception时的反应