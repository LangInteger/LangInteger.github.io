---
title: 震惊！ Set 家族中出了一个元素重复的叛徒
date: 2018-04-30 19:52:01
toc: true
reward: true
tags:
	- Java
	- DS
---
在 Java 源码中，对 Set 有如下定义：
> A collection that contains no duplicate elements.  More formally, sets contain no pair of elements <code>e1</code> and <code>e2</code> such that <code>e1.equals(e2)</code>, and at most one null element.

总结成一句话就是： Set 是不含重复元素的 Collection 。
<!--more-->

## 1. 偶遇神奇代码

郎先生今日偶得如下代码：
```java
public static void main(String[] args) {
        HashMap<Key, Character> test = new HashMap<>();

        Key key1 = new Key(1);
        test.put(key1, 'a');

        Key key2 = new Key(2);
        test.put(key2, 'b');

        key1.set(2);
        Set<Key> set = test.keySet();
        for (Key i: set) {
            System.out.println(i.getI() + "  " + i.hashCode() + "  " + test.get(i));
        }

    }
```
竟然输出了：
>2  33  b
>2  33  b

没错，正如我们看到的那样，程序中 test(instance of HashMap) 的 keySet() 方法得到的 test 的键值的集合 (Set<Key> set) 竟然包含两个一模一样的元素。这是怎么一回事呢？ 

## 2. 踏上寻源之旅
跟随 keySet() 方法的脚步，我们很容易就找到了方法在 HashMap 中的实现源码：

```java
    public Set<K> keySet() {
        Set<K> ks;
        return (ks = keySet) == null ? (keySet = new KeySet()) : ks;
    }

    final class KeySet extends AbstractSet<K> {
        public final int size()                 { return size; }
        public final void clear()               { HashMap.this.clear(); }
        public final Iterator<K> iterator()     { return new KeyIterator(); }
        public final boolean contains(Object o) { return containsKey(o); }
        public final boolean remove(Object key) {
            return removeNode(hash(key), key, null, false, true) != null;
        }
        public final Spliterator<K> spliterator() {
            return new KeySpliterator<>(HashMap.this, 0, -1, 0, 0);
        }
        public final void forEach(Consumer<? super K> action) {
            Node<K,V>[] tab;
            if (action == null)
                throw new NullPointerException();
            if (size > 0 && (tab = table) != null) {
                int mc = modCount;
                for (int i = 0; i < tab.length; ++i) {
                    for (Node<K,V> e = tab[i]; e != null; e = e.next)
                        action.accept(e.key);
                }
                if (modCount != mc)
                    throw new ConcurrentModificationException();
            }
        }
    }
```

keySet() 返回的实际上是 HashMap 类的一个内部类（即 KeySet ）的实例。令人震惊的是，这个 KeySet 类其实对自己的约束很少。里面有查重机制吗？么得！为什么不查重呢？因为这个东西它连自己的有实际内容的实例都没得啊！在构造 keySet() 方法返回值过程中用到的 KeySet 类的构造方法：

> keySet = new KeySet() 

其实就是 JVM默认的构造方法，所谓的 KeySet 类就是一个空壳子。

在 KeySet 类中最重要的成员方法是：

>public final void forEach(Consumer<? super K> action)

此方法实现了我们常用的 foreach 机制，也和我们生成 keySet 的初衷（即遍历 HashMap 的键的集合）相符。 forEach 方法完全依赖于 HashMap 的成员变量：

>transient Node<K,V>[] table;

借助 HashMap 键值对数组实现对键集合的遍历。
而键值对数组是在 HashMap 创建的时候初始化的，并会随着所存键值对数量的变化而 resize() 。在 HashMap 的 putVal() 方法中会根据将存键值对内容（其 key 的 hashcode 及内容）的不同，将此键值对放到键值对数组的一个新的 bucket 中、链接到原有 bucket 中的链表中或者替换原有键值对的 value 。

问题在于，这种对键值对中 key 内容的判断仅在键值对插入时进行。当 key 是可变类型且在插入 HashMap 后改变 key 值并不会引起该键值对在键值对数组中所处位置的改变。

当此时再插入一个拥有与前述键值对修改后 key 相同的 key 的键值对时，会被直接分配到 newkey 哈希值散列后对应的 bucket ，而修改过 key 的那个键值对仍然存储在 oldkey 哈希值散列后对应的 bucket 中。就出现了键值对数组中有两个键值对拥有相同 key 的情况，继而引起 keySet 集合中重复元素的出现。

总结起来，故事的发展就是： HashMap 键值对数组不具备我们想象中的对键值对中 key 值改变的监听及 rehash 功能 ==> 键值对数组出现拥有相同 key 的键值对（他们在不同的 bucket 中） ==> keySet 照葫芦画瓢画出了相同的成员。

## 3. 再谈Set其人

在 Set 类源码中，对这样的故事早有预言：
>Great care must be exercised if mutable objects are used as set elements.  The behavior of a set is not specified if the value of an object is changed in a manner that affects <tt>equals</tt> comparisons while the object is an element in the set.

Set 类及其实现子类严把入口关，对放入其中的元素进行严格检查，坚决不让重复元素放入其中。但是，若放入其中的元素是可变的且确实放入后发生了变化（如变得和另一个元素内容相同）， Set 类也无力回天咯。


## 4. 顺带复习DS
比较各种DS的特性如下：
<table style="text-align: center;">
	<tr>
		<td>DS名称</td>
		<td>null元素</td>
		<td>重复元素</td>
		<td>线程安全</td>
		<td>有序性</td>
	</tr>
	<tr>
		<td>HashMap</td>
		<td>允许（key也允许）</td>
		<td>不允许key重复</td>
		<td>非线程安全</td>
		<td>无序</td>
	</tr>
	<tr>
		<td>HashTable</td>
		<td>不允许（key也不允许）</td>
		<td>不允许key重复</td>
		<td>线程安全</td>
		<td>无序</td>
	</tr>
	<tr>
		<td>HashSet</td>
		<td>允许</td>
		<td>不允许</td>
		<td>非线程安全</td>
		<td>无序</td>
	</tr>
</table>