---
title: Spring Data JPA 简明教程
date: 2018-07-28 23:55:48
toc: true
tags:
	- Spring Data
	- Spring
	- JPA
	- Java
---

JPA 是为了整合第三方 ORM 框架建立的一套标准接口，统一了数据持久化存储的相关操作。程序员只需学习一套统一的 JPA api，而不必关心底层去做事情的 ORM 框架到底是谁。
Hibernate 等 ORM 框架是 JPA 的底层实现，本身提供了一些 CRUD 功能，但是包含业务逻辑的数据库访问操作仍然需要手写 sql 语句来实现，而 Spring-data-jpa 则提供了进行了更强大的功能，封装了一定的业务逻辑功能，最大程度上减少了手写 sql。

<!--more-->

Spring Data JPA常用功能对应的接口体系如下：

```java
public interface Repository<T, ID extends Serializable>
  public interface CrudRepository<T, ID extends Serializable>
    public interface PagingAndSortingRepository<T, ID extends Serializable>
      public interface JpaRepository<T, ID extends Serializable>
        public class SimpleJpaRepository<T, ID extends Serializable>
```

在使用Spring Data JPA时，我们一般会将自己定义的Repository接口继承JpaRepository接口，由此我们便获得了如下这些接口中定义的方法，他们的具体实现在SimpleJpaRepository类中，通过EntityManager来实现对数据库的操作。

* CrudRepository<T, ID extends Serializable>中定义的主要方法
  * \<S extends T\> S save(S entity);
  * \<S extends T> Iterable\<S> save(Iterable\<S> entities);
  * T findOne(ID id);
  * boolean exists(ID id);
  * Iterable<T> findAll();
  * Iterable<T> findAll(Iterable<ID> ids);
  * long count();
  * void delete(ID id);
  * void delete(T entity);
  * void delete(Iterable<? extends T> entities);
  * void deleteAll();

本文中的例子使用的类具有以下实体类型：

* 用户MyUser，主键为用户id，还包含用户名字段

```java
@Data
@Entity
public class MyUser {

  @Id
  private int userId;

  private String name;

  }
```

* 订单MyOrder，主键为订单id，还包括用户id和表征订单号的code

```java
@Data
@Entity
public class MyOrder {

  @Id
  private int orderId;

  private int userId;

  private String code;

}
```

* OrderUser作为一个VO类型，包含了订单号code和用户user两个字段

```java
@Data
public class OrderUser implements Serializable {
  private static final long serialVersionUID = 1L;

  private String code;

  private MyUser user;

  public OrderUser() {
  }

  public OrderUser(String code, MyUser user) {
    this.code = code;
    this.user = user;
  }
}
```

## 1. 使用继承的方法实现基本操作

### 1.1 让你的 Repository 类实现接口 JpaRepository

```java
public interface MyOrderRepository extends JpaRepository<MyOrder, Integer>
```

### 1.2 使用来自 JpaRepository 的方法


* 从PagingAndSortingRepository继承的findAll方法
* 从CrudRepository继承的count, delete,deleteAll, exists, findOne, save等方法
* 从QueryByExampleExecutor继承的count, exists, findAll, findOne等方法

## 2. 使用规范命名的方法实现查询

这应该是Spring Data JPA的一大杀器，许多常用查询只需要程序员构造出方法名就可以进行，具体用法及关键字见下。

```java
如：    MyOrder findByCode(String code);
```

主要命名规则为：find+全局修饰+By+实体属性名称+限定词+连接词+（其他实体属性）+OrderBy+排序属性+排序方向
支持的关键字还包括：

* 全局修饰符：distinct,top,first
* 关键词（限定词+连接词）：IsNull,IsNotNull,Like,NotLike,Containing,In,NotIn,IgnoreCase,Between,Equals,
* LessThan,GreaterThan,After,Before
* 排序方向：Asc,Desc

## 3. 使用@Query注解实现自定义查询

@Query注解使用JPQL语句

```java
  @Query("select o from MyOrder o where o.code in :codes")
  List<MyOrder> findOrderByCodes(@Param("codes") List<String> codes);
```

若想使用原生sql，则需要指明nativeQuery属性为true

```java
  @Query(value = "select * from my_order o where o.code in ?1", nativeQuery = true)
  List<MyOrder> findOrderByCodesUsingSql(List<String> codes);
```

另外，涉及删除和修改需要在方法上加上@Modifying注解

在多表查询方面，@Query也有一席之地，一种比较粗鲁的做法如下：

```java
  @Query("select o.code as code, u as user from MyOrder as o, MyUser as u where o.userId = u.userId")
  List<Map> findOrderUserWithoutNew();
```

返回的结果集直接以列表中的图来存储，当然我们也可以多做一点工作，定义好接收结果集的类型，这点工作就像是mybatis在mapper文件中完成的映射一样。

```java
  @Query("select new com.langinteger.gradledemo.domain.bo.OrderUser(o.code, u) from MyOrder as o, MyUser as u where o.userId = u.userId")
  List<OrderUser> findOrderUser();
```

如果不想定义实体类，也可以选择定义一个接口，接口中定义对应要取出字段的get方法声明。方法可返回这样一个接口的代理对象，再通过get方法得到所需要的值。考虑到这种方法转来转去的，就不演示了。

## 4.分页和排序

JpaRepository 继承了 PagingAndSortingRepository接口，提供了分页和排序的功能。

在我们自定义的方法中 Pageable 参数就可以进行分页查询，并返回封装好的 Page 对象，其中包括很多页面信息。比较坑爹的一点是，Spring 这些关于页面的信息中页码都是从0开始的，这也算是程序员的一种病？

```java
//定义方法
Page<MyOrder> findByUserId(int userId, Pageable pageable);
//方法使用
def orders = myOrderRepository.findByUserId(1, new PageRequest(0, 2))
```

至于排序，可以嵌在分页中定义，也可以单独定义，下面是嵌在分页请求信息中定义排序的例子：

```java
def orders = myOrderRepository.findByUserId(1, new PageRequest(0, 2, new Sort(Sort.Direction.DESC, "orderId")))

```

## 5.使用自定义的 Repository 实现动态查询

默认情况下，只需要在 XXRepository 接口同包下新建一个普通的 XXRepositoryImpl 类，在不显式 implements 的情况下，就会被默认作为该 XXRepository 的实现类。这么设计是因为如果必须 implements XXRepository，势必要去实现 JPARepository 等一众接口中的方法（实际上已经在 SimpleJpaRepository 中实现了）。也就是说，我们的整个 Repository 由两部分实现构成，一部分是由 Spring Data JPA 实现的 SimpleJpaRepository 类，另一部分则是我们自己书写的 Impl 实现类。

下面定义了了 MyOrderRepository 的实现类 MyOrderRepositoryImpl：

```java
public class MyOrderRepositoryImpl {

  @PersistenceContext
  private EntityManager em;

  public List<MyOrder> search(MyOrder order) {
    String dataSql = "select o from MyOrder o where 1 = 1";

    if(null != order && !StringUtils.isEmpty(order.getCode())) {
      dataSql += " and o.code = ?1";
    }

    Query dataQuery = em.createQuery(dataSql);

    if(null != order && !StringUtils.isEmpty(order.getCode())) {
      dataQuery.setParameter(1, order.getCode());
    }

    List<MyOrder> orders = dataQuery.getResultList();

    return orders;
  }
}
```

当然，可以想见的是，实现类中的方法必须要先在接口中进行申明，不然是找不到这个方法的。另外，除了执行 JPQL 语句，EntityManager 可以通过其 createNativeQuery 方法来执行原生 sql 语句。

这种查询的实现方式最大的问题在于，程序启动时并不会检查 sql 语句正确与否，下面我们将使用 Criteria 来构造动态查询，参数检查在构造过程中同步进行，同时免去了新建实现类的麻烦。

## 6.Criteria 构造动态查询

Criteria 其实是和 Spring Data JPA 非强相关的一套 Java API，它和原生 sql 以及 JPQL 都不同，提供了一种面向对象构建查询的方式，通过实现 JpaSpecificationExecutor 接口，可以获得其定义的如下方法：

```java
  T findOne(Specification<T> spec);
  List<T> findAll(Specification<T> spec);
  Page<T> findAll(Specification<T> spec, Pageable pageable);
  List<T> findAll(Specification<T> spec, Sort sort);
  long count(Specification<T> spec);
```

Java 源码中关于 Specification 接口的解释是：
> Specification in the sense of Domain Driven Design.

有了这些方法之后，直接在 DomainService 层通过注入的 Repository 对象调用以上方法，并将 Specification 以匿名内部类的形式创建，重写其 toPredicate 方法，便可天马行空，乱码一通，实现由 Criteria API 构造的动态查询，如下所示（groovy 书写  ）：

```java
   def order = new MyOrder()
    order.setCode("123456")

    def orders = myOrderRepository.findAll(new org.springframework.data.jpa.domain.Specification() {
      @Override
      Predicate toPredicate(Root root, CriteriaQuery query, CriteriaBuilder cb) {
        Predicate orderCodeLike = null

        if (null != order && !StringUtils.isEmpty(order.getCode())) {
          orderCodeLike = cb.like(root.<String> get("code"), "%" + order.getCode() + "%")
        }

        if (null != orderCodeLike) query.where(orderCodeLike)

        return null
      }
    })
```

这种方法有一个让人不能接受的地方是，访问数据库的逻辑被扔到了 DomainService 中，不像之前自己写的 Repository 实现类那样在 Repository 层，是对整体结构的一个挑战惹。

