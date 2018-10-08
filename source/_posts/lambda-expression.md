---
title: Lambda 表达式
date: 2018-09-24 23:41:31
tags: 
    - Java
    - Lambda
    - Book
---
讲讲 java 中 Lambda 表达式的那些故事。
<!--more-->

# 1. Java 8 新特性 

## 1.1 一个例子：
```java
Collections.sort(inventory, new Comparator<Apple>() {
    public int compare(Apple a1, Apple a2) {
        return a1.getWeight().conpareTo(a2.getWeight());
    }
})
```

在 java 8 中可以使用下面的简洁写法来代替：
```java
inventory.sort(comparing(Apple::getWeight));
```

## 1.2 函数式编程范式的基石
- 没有共享的可变数据 => synchorized代价往往很大
- 将方法和函数即代码传递给其他方法的能力

## 1.3 编程语言的目的在于操作值
- 值在程序运行过程中可以传递，被称为一等值
- 值是 java 中的一等公民，但其他很多概念，如方法和类则是二等公民
- 在运行时传递方法能将方法变为一等公民，Java 8 的设计者将这个功能加入到了 Java 8 中

## 1.4 方法引用
### 一个例子：用方法引用简化方法调用
```java
File[] hiddenFiles = new File(".").listFiles(new FileFilter() {
    public boolean accept(File file) {
        return file.isHideden();
    } 
});
```

```java
File[] hiddenFiles = new File(".").listFiles(File::isHidden);
```

### 方法引用的语法
- 使用符号::即表示将这个方法作为值进行传递，即将方法传递给另一个方法a

## 1.5 Lambda - 匿名函数
- Lambda 是（命名）函数成为一等值之外，更广义的将函数作为值的思想之一。
- 当没有方便的方法和类可用，Lambda 表达式会更加简洁。
- 特别是对那些只用一次的方法，使用 Lambda 免去了为其书写定义的烦恼。

# 2. 通过行为参数化传递代码
## 2.1 策略模式
- 定义一族算法（通过一个接口来统一），把它们封装起来，然后在运行时选择一个算法
- 这种模式下，唯一重要的代码是算法实现，即一个方法，但是一般要通过定义一个对象来传递该方法。这种做法类似于在“内联”地传递代码。

## 2.2 克服啰嗦
- 使用策略模式将行为传递给方法时，不得不申明“策略”的实现类，并实例化“策略”来传递方法，相当的啰嗦
- 使用 Java 的匿名类机制，可以同时声明并实例化一个类 => 但是仍然笨重且产生了一些令人费解的问题
- 使用 Lambda 是最优解法

## 2.3 Java 中行为参数化实例
### 使用 Comparator 来排序
- Java 8 中，List自带的 sort 方法，其行为可以用 java.util.Comparator 来参数化
```java
public interface Comparator<T> {
    public int compare(T o1, T o2);
}
```
```java
inventory.sort((Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeight()))
```

### 用 Runnable 来执行代码块
```java
public interface Runnabl {
    public void run();
}
```
```java
Thread t = new Thread(() -> System.out.println("Hello world!"));
```

# 3. Lambda 表达式
## 3.1 管中窥豹
### Lambda 表达式特点
- 匿名：没有明确的名称，写得少而想得多
- 函数： 不像方法那样属于某个特定的类，但同方法一样拥有参数列表、函数主体、返回类型，还可能有可抛出的异常列表
- 传递： 可以作为参数传递给方法或存储在变量中
- 简洁：无需像匿名类那样写很多模版代码
### Lambda 表达式组成
- 参数列表
- 箭头
- Lambda 主体
### Lambda 表达式例子

    (String s) -> s.length()
    (Apple a) -> a.getWeight() > 150
    (int x, int y) -> {
        System.out.println("Result:");
        System.out.printlm(x + y);
    }
    () -> 42
    (Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeight())

### 注意：
- return 是一个流程控制语句，在 Lambda 中使用它时必须要加上花括号


## 3.2 When and Where
### 在哪里使用 Lambda 表达式- 函数式接口上
- 仅定义了一个抽象方法的接口为函数式接口
- 定义了默认方法的接口中，只要它只定义了一个抽象方法，它就仍然是函数式接口
- Lambda 允许直接以内联的形式为函数式接口的抽象方法提供实现，并把整个表达式作为函数式接口的实例
- Java 语言设计者也曾考虑过添加函数类型，但是为了避免语言变得更加复杂，采用只有需要函数式接口的时候才能传递 Lambda 的方式。

### 函数描述符
- 函数式接口的抽象方法的签名基本就是 Lambda 表达式的签名，我们将这种抽象方法叫做函数描述符

## 3.3 环绕执行模式

- 使用环绕执行模式优化文件读取的代码，四步骤：

```java
public static String processFile() throw IOException {
    try (BufferedReader br = 
        new BufferedReader(new FileReader("data.txt"))) {
        return br.readLine();
    }
}
```

```java
public interface BufferedReaderProcessor {
    String process(BufferedReader b) throw IOException;
}

public static Strin processFile(BufferedReaderProcesor p) throws IOException {
    ...
}
```

```java
public static String processFile(BufferedReaderProcesor p) throws IOException {
    try (BufferedReader br = 
        new BufferedReader(new FileReader("data.txt"))) {
        return p.process(br);
    }
}
```

```java
String oneline = processFile((BufferedReader br) -> br.readLine());
String twoLine = processFile((BufferedReader br) -> br.readLine() + br.readLine())
```

- 这里的不便之处在于我们需要自定义函数式接口来传递 Lambda 表达式。

## 3.4 使用函数式接口

- Predicate<T> 接口定义了一个名叫 test 的方法，接受泛型 T 对象，返回一个 boolean。
- Consumer<T> 接口定义了一个名叫 accept 的方法，用于访问类型 T 对象并执行某些操作。
- Function<T, R> 接口定义了一个叫 apply 的方法，接受一个泛型 T 对象，返回一个泛型 R 对象，可用于创建映射（map）。
- 原始类型特化接口：避免自动装箱和拆箱，如 IntPredicate 接口
- 任何函数式接口都不允许抛出受检异常，如果需要，可以自定义函数是借口并声明受检异常，或者使用 try/catch 块

## 3.5 类型检查、推断和限制

### 类型检查的过程
- 首先，找出接受 Lambda 表达式的方法的声明
- 确认函数式接口的声明，绑定泛型
- 找到函数式接口中定义的方法啊，检查方法返回值是否和 Lambda 表达式返回值匹配

### 同样的 Lambda，不同的函数式接口
- 有了目标类型的概念下，同一个 Lambda 表达式就可以与不同的函数式接口联系起来，只要其抽象方法的签名可以兼容
- 若一个 Lambda 的主体是一个语句表达式，它就和一个返回 void 的函数描述符兼容

### 类型推断
- Java 编译器会从上下文推断出用什么函数式接口来配合 Lambda 表达式
- 可以免去在 Lambda 语法中标注参数类型
- 例子：

```java
Comparator<Apple> c = (Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeight());
```
```java
Comparator<Apple> c = (a1, a2) -> a1.getWeight().compareTo(a2.getWeight());
```

### 使用局部变量
- Lambda 可以没有限制的捕获实例变量和静态变量，但局部变量必须显示声明为 final，或事实上是 final。
- 实例变量在堆中，局部变量在栈上。如果 Lambda 可以使用局部变量，则可能会在分配该变量的线程将这个变量回收之后去访问这个变量，因此，Java 在访问自由变量时，实际是在访问其副本，而不是访问原始变量。如果局部变量仅仅赋值一次那就没有什么区别了。
- 不鼓励使用改变外部变量的典型命令式编程模式，它会阻碍并行处理。

### 方法引用：Lambda 表达式的快捷写法
- 指向静态方法的方法引用，如 Integer::parseInt
- 指向任意类型实例方法的方法引用：String::length
- 指向现有对象的实例方法的引用：instanceObj::getXX