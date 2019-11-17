---
title: Java 中的 volatile 和 synchronize 关键字解读
date: 2019-11-17 22:36:06
toc: true
tags:
    - Java
    - Volatile
    - Synchronize
---

读 **Concurrent Patterns and Best Practices**，遇到两篇参考文章

- 写于 2001 年的 [Double-checked locking: Clever, but broken](https://www.javaworld.com/article/2074979/double-checked-locking--clever--but-broken.html?page=2)，对 DCL 实现懒加载单例模式存在的问题进行了深刻的探讨，同时阐述了 synchronize 关键字的作用
- 写于 2018 年的博客 [Java Volatile Keyword](http://tutorials.jenkov.com/java-concurrency/volatile.html)，详细阐述了 volatile 关键字的作用

一番阅读之后，撰写此文备忘。

<!--more-->

## 1 Java Volatile Keyword

### 1.1 Volatile 主要作用

Volatile 关键字用于表明其修饰的变量存储在主存 (main memory) 中。

- 每次读取 volatile 变量都会从主存 (main memory) 中去取其值，而不是从 CPU cache
- 每次向 volatile 变量赋值都会直接将值写到主存 (main memory)，而不仅仅是 CPU cache

### 1.2 Volatile 解决的问题

#### 1.2.1 可见性问题

考虑被多个线程共同访问的如下数据结构

```java
public class SharedObject {
  public int counter = 0;
}
```

若线程 1 改变了 counter 的值，无法保证运行线程一的 CPU 的缓存中的 counter 变量值和主存中的 counter 变量值相等，其它线程也可能无法读取到被线程 1 改变后的 counter 变量值。由于变量值还未被写回主存造成的其它线程无法读取到某变量最新值的问题，被称作 **Visibility Problem**.

Volatile 关键字则保证其所修饰的变量被修改后马上会写回主存，同时也保证读取其所修饰的变量时是从主存读取。

#### 1.2.2 可见性问题-增强

Java 中的 volatile 关键字除了提供可见性保障本身，还带来了如下特性

- 若线程 A 修改了 volatile 变量的值，随后线程 B 读取该值，那么在线程 A 修改 volatile 变量前对它可见的那些值，也将在线程 B 读取该 volatile 变量后对 线程 B 可见
- 若线程 A 读取了 volatile 变量的值，会触发线程 A 从主存重读当前线程 A 已经可见的值

#### 1.2.3 指令重排优化带来的问题

Java 虚拟机和 CPU 等出于性能考虑，可能会对程序代码进行重新排序，如

- 编译器可以不按照代码书写的顺序生成指令
- 编译器可以选择将变量存储在寄存器中而非主存中
- 处理器可以乱序执行指令
- 缓存可以变更提交最新变量值到主存的顺序

JMM (Java Memory Model) 中指出: so long as the environment maintains as-if-serial semantics -- that is, so long as you achieve the same result as you would have if the instructions were executed in a strictly sequential environment，就可以对代码执行的顺序进行为所欲为的改变。这种改变在单线程运行程序的情况下不会出现任何问题，但是在多线程情况下

- 一个线程可以读取另一个线程写入了的内存空间
- 一个线程以某种顺序对一些变量进行了修改，另一个线程观察到这些值的改变顺序却并非如此
- 一个线程修改了某个变量的值，但是选择先放在寄存器中，另一个线程则无法看到这个更改

会导致程序运行结果不可预测。为了（部分）解决指令重排 (instruction reordering) 带来的这一问题，volatile 关键字提供了 **happens-before** 保证。博客中对这种保证的描述如下

```text
- Reads from and writes to other variables cannot be reordered to occur after a write to a volatile variable, if the reads / writes originally occurred before the write to the volatile variable.The reads / writes before a write to a volatile variable are guaranteed to "happen before" the write to the volatile variable. Notice that it is still possible for e.g. reads / writes of other variables located after a write to a volatile to be reordered to occur before that write to the volatile. Just not the other way around. From after to before is allowed, but from before to after is not allowed.
- Reads from and writes to other variables cannot be reordered to occur before a read of a volatile variable, if the reads / writes originally occurred after the read of the volatile variable. Notice that it is possible for reads of other variables that occur before the read of a volatile variable can be reordered to occur after the read of the volatile. Just not the other way around. From before to after is allowed, but from after to before is not allowed.
```

像绕口令一样，在下读了两遍，翻译为

- 若代码中对其它变量的读写在对 volatile 变量的写入之前，则这些语句不能被重排到 volatile 变量的写入之后。而在 volatile 变量写入后写入其它变量的语句则可能被重排到写入 volatile 变量的语句之前。即只能从后向前重排，不能从前向后重排。
- 若代码中对其它变量的读写在对 volatile 变量对读取之后，则这些语句不能被重排到 volatile 变量的读取之前。而在 volatile 变量读取前读取其它变量的语句则可能被重排到读取 volatile 变量的语句后面。即只能从前向后重排，不能从后向前重排。

之所以说 volatile 部分解决了指令重排带来的问题，是因为如上翻译所言，volatile 并不能保证某个代码块区域内的代码完全不会被重排。

### 1.2.4 volatile 的局限性

volatile 无法提供原子性 (atomicity) 保证。当为 volatile 变量的赋值计算依赖于此变量之前的值时，由于读取变量值、计算变量值、写回变量值并非为一个原子操作，在多线程情况下，**race conditon** 产生在这三个环节，程序可能会得到错误的执行结果。

## 2 Synchorize

从懒加载单例模式的实现说开去，首先给出不考虑多线程的版本：

```java
class SomeClass {
  private Resource resource = null;
  public Resource getResource() {
    if (resource == null)
      resource = new Resource();
    return resource;
  }
}
```

上述代码在多线程下会在 resource 是否为 null 的条件判断处产生 race condition，为了解决这个问题，可以直接使用 synchronise 关键字同步整个方法：

```java
class SomeClass {
  private Resource resource = null;
  public synchronize Resource getResource() {
    if (resource == null) {
      if (resource == null)
        resource = new Resource();
    }
    return resource;
  }
}
```

但是这种做法会造成 getResource 方法的运行速度变得缓慢（时间花费可达未加锁版本的 100 倍）。懒加载本来就是为了追求效率，如此使用 synchronize 关键字的做法严重拖慢了程序运行效率，是不可取的。于是有人提出了 DCL (Double-Check Locking) 方法：

```java
class SomeClass {
  private Resource resource = null;
  public Resource getResource() {
    if (resource == null) {
      synchronized {
        if (resource == null)
          resource = new Resource();
      }
    }
    return resource;
  }
}
```

按照预想，上面写法的第一重检查让大多数的 getResource 调用不会到达 synchronize 行，同时又通过 synchronize 和第二重检查避免了 race condition，但是事实没有想象的这般美好。

考虑以下情况，线程 A 正在同步块中执行 new 语句，与此同时线程 B 刚进入 getResource 方法。new 语句将会 1) 为 Resource 对象在内存中分配空间，2) 调用 Resource 的构造方法，3)初始化 Resource 的各字段，4) 赋值 SomeClass 的 resource 字段一个指向该新创建的 Resource 对象的指针。由于线程 B 本身未在同步块中，它看见的以上操作的顺序和线程 A 实际的操作顺序可能会有差别。比如线程 B 看见的步骤可能为 1-4-2-3，那么线程 B 进行第一重判断的时候可能会判定 resource 已经存在，但是实际上该对象可能还未被初始化完成。

无数编程高手前赴后继想要修复 DCL 存在的问题，比如使用 volatile 关键字来保证 Resource 的创建过程中不会出现指令重排：

```java
class SomeClass {
  private volatile Resource resource = null;
  public Resource getResource() {
    if (resource == null) {
      synchronized {
        if (resource == null)
          resource = new Resource();
      }
    }
    return resource;
  }
}
```

这种目前被广为接受的 DCL 实现单例的写法也是存在风险的（讽刺的是这个风险十几年前就被指出来了但是现在却仍然被大多数人所不知）。

volatile 既保证了 Resource 对象的创建顺序，又保证了 resource 字段创建后马上被刷新到主存，还保证了其它线程在读取 resource 字段时候是从主存中读取，但是值得注意的是 Resource 对象中的字段读取的正确性往往被忽略掉了。

其它线程在读取 Resource 对象字段的时候，拿到的 Resource 对象内部的字段可能是其它线程的 CPU 缓存中的脏值，因为这些字段在上述描述下未加 volatile 修饰，不会在读取之前执行所谓的 Read Barrier 指令，无法保证其正确性。

如果要一条道走到黑，使用 DCL 来创建懒加载单例对象，那么除了上面的代码块，还需要保证 Resource 中的字段及这些字段的所有子字段都是 volatile 修饰的。

## 3 理解 volatile 和 synchronize

### 3.1 基础解读

- volatile 修饰的变量的更新会立刻写到缓存，并保证其它线程对这一改变的可见性
- synchronize 如其名，用于保证其修饰的代码块同一时刻只能被一个线程执行

### 3.2 从 JMM 角度解读

volatile 和 synchronize 都是为了解决 Java 内存模型的既有设计在多线程世界下可能带来的问题的关键字。

volatile 用于保证单个变量的值在 CPU 缓存和主存之间的一致性，保证多线程同一时刻读取其修饰字段值结果的可见性。可用于解决单线程写，多线程读情况下某字段值的可见性问题。

线程运行到 synchronize 代码块，获取锁和释放锁都会触发当前线程的 CPU 缓存和主存之间的数据同步。当获取锁时，当前线程会从主存同步数据到 CPU 缓存的变量中；当释放锁时，当前线程会将 CPU 缓存的数据同步到主存中。

## 4 再议懒加载单例模式的实现

上面的最后一种实现懒加载单例的方法已经使用了 synchronize 关键字，为什么不用 volatile 关键字特殊处理还是不能解决线程间的并发访问问题并留下隐患呢？这是因为第一重判断在同步代码块之外，只有多个线程都 synchronize 在同一个对象上时，才能保证代码执行如同单线程那般无误，而 DCL 显然没有做到这样。

完全摒弃 DCL 的思路，可以考虑如下实现方式懒加载的单例模式

```java
class MySingleton {
  public static Resource resource = new Resource();
}
```

同时 DCL 对 32 位长原始数字类型的懒加载初始化也是可以的，其原因在此不表。

## 5 Dictionary

### 5.1 Critical Section

The critical section is a code segment where the shared variables can be accessed.

### 5.2 Race Condition

A race condition is a situation that may occur insude a critical section. This happens when the result of multiple thread execution in critical section differs according to the order in which the threads execut.

Race conditions in cridical sections can be avoided if the critical section is treated as an atomic instruction. Also, proper thread synchronization using locks or atomic variables can prevent race conditions.

## 6. Reference

- [Race Condition, Critical Section and Semaphore](https://www.tutorialspoint.com/race-condition-critical-section-and-semaphore)
