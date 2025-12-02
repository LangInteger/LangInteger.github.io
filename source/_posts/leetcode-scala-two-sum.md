---
title: Two sum but with Scala
date: 2025-12-01 21:58:14
tags: 
  - learn-scala-by-lt
  - scala
---


As the first problem on the LeetCode, this is likely the programming question familiar to most software developers. It explains the idea of trading space for time and demonstrates the power of hashtables. While a brute force approach takes $O(n^2)$, the hashtable-based method only requires $O(n)$.

Although the algorithm is simple, many poorly written Scala solutions can be found online.

## The solution that uses non-local return 

This Medium post [Solving the ‘Two Sum Problem’ on LeetCode — Scala Solutions Walkthrough](https://medium.com/@AlexanderObregon/solving-the-two-sum-problem-on-leetcode-scala-solution-walkthrough-6160a45b451c) introduced an solution that cannot be compiled on LeetCode as of Dec 2025.

```scala
object Solution {
  def twoSum(nums: Array[Int], target: Int): Array[Int] = {
    val numMap = nums.zipWithIndex.toMap
    for (i <- nums.indices) {
      val complement = target - nums(i)
      if (numMap.contains(complement) && numMap(complement) != i) {
        return Array(i, numMap(complement))
      }
    }
    Array()
 }
}
```

The error message is as follows:

```text
Line 10 Char 6: Warning (in solution.scala)
10 |      return Array(i, numMap(complement))
   |      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   |Non local returns are no longer supported; use `boundary` and `boundary.break` in `scala.util` instead
1 warning found
```

The problem can be solved by changing to a while loop as follows:

```scala
object Solution {
    def twoSum(nums: Array[Int], target: Int): Array[Int] = {
        val numMap = nums.zipWithIndex.toMap
        var i = 0
        while i < nums.length do
            val complement = target - nums(i)
            if (numMap.contains(complement) && numMap(complement) != i) {
              return Array(i, numMap(complement))
            }
            i += 1
        Array()
    }
}
```

So what exactly is a non-local return? Based on the answers from this [stackoverflow post](https://stackoverflow.com/questions/8897507/what-is-a-non-local-return), we can summarize it as the ability to exit the function from within an inner block, such as a closure or special block syntax in languages like Ruby. Why do we want this? Because we want to be able to return out of a closure just as the same way we do from a loop body, as shown in the example above. non-local returns are common in functional programming languages, where passing functions as parameters and executing them inside one function is standard practice. 

However, although Scala claims strong support for both OOP and FP paradigms, it decided to [deprecate](https://dotty.epfl.ch/docs/reference/dropped-features/non-local-returns.html) non-local returns starting in 3.2.0. The feature was implemented by throwing an exception under the hood, which introduced hidden performance overhead, which the language designers wanted to avoid.

The recommended alternative is the `boundary` construct together with `boundary.break`. They provide an explicit and controlled form of non-local return within the `boundary` block.

```scala
import scala.collection.mutable.HashMap
import scala.util.boundary, boundary.break

object Solution {
    def twoSum(nums: Array[Int], target: Int): Array[Int] = {
        val numMap = nums.zipWithIndex.toMap
        boundary:
            for i <- nums.indices do
                val complement = target - nums(i)
                if (numMap.contains(complement) && numMap(complement) != i) then
                    break(Array(i, numMap(complement)))
            Array()
    }
}
```

## The solution in the functional style

This [Github file](https://github.com/karlkyck/leetcode/blob/master/algorithms/src/main/scala/com/karlkyck/leetcode/algorithms/twosum/Solution.scala) provides the solution in the functional style.

```scala 
object Solution {
  def twoSum(nums: Array[Int], target: Int): Array[Int] = {

    val numsMap = nums
      .zipWithIndex
      .map {
        case (num, index) => num -> index
      }
      .toMap

    nums
      .zipWithIndex
      .foldLeft(Array[Int]()) {
        case (accum, (num, index)) =>
          numsMap
            .filter {
              case (_, numsMapIndex) => numsMapIndex > index
            }
            .get(target - num)
            .map(accum.+:(_).+:(index))
            .getOrElse(accum)
      }
  }
}
```

The solution is inefficient because it has many unnecessary oprations. For example, `toMap` can automatically convert a list of `Typle2` into a map, using the first element as the key and the second as the value, so the explicit `.map` is redundant.Additionally, `foldLeft` is not the most natural way to express this logic. A clearer approach is to find the index of an item in `nums` whose complement exists in the helper `numsMap`'s keys such that their sum equals `target`. The solution then becomes:

```scala
object Solution {
  def twoSum(nums: Array[Int], target: Int): Array[Int] = {
    val numsMap = nums.zipWithIndex.toMap
    val found = nums.indices
      .indexWhere(i => numsMap.get(target - nums(i)).exists(_ != i))
    if (found == -1) Array()
    else Array(found, numsMap(target - nums(found)))
  }
}
```

The above solution is inspired by this [LeetCode solution](https://leetcode.com/problems/two-sum/solutions/4005763/scala-purely-functional-solution-on-by-a-0qq3/).