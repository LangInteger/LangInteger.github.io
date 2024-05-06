---
title: From Turing Machine to Lambda Calculus
date: 2024-05-04 12:01:22
tags:
  - Turing Machine
  - Lambda Calculus
  - Programming Language
---

In the past first semester of my Ph.D. in computer science, my attention was attracted by the study of Alonzo Church and Alan Turing, specifically, the Turing Machine developed by Alan Turing in 1936, and the lambda calculus developed by Alonzo Church in 1930, which turns out to be Turing complete and is equivalent in omputational power with Turing Machine.

<!--more-->

As it is a semster-long jouney, so many topics are covered. CS530 presents computational models from finite automaton and regular expression, context-free grammars and pushdown automata, finally to Turing machine. CS534 illustrates topics like Untyped lambda calculus, simply-typed lambda calculus, Curry-Howard Correspondence, Recursion, Polymorphism, Parametricity and Subtyping.

Among those topics, I found the following extremely important.

## 1. Hibert's 10th Problem

In 1900, mathematician David Hilbert delivered a now-famous address at the International Congress of Mathematics in Paris in which he identified 23 mathematical problems and posed them as a challenge for the coming century. The tenth problem is to devise an algorithm that tests whether a polynomial has an integral root, which we can formalize as the decidable problem of the following set $D$:

$$
D = \{p\,\vert\,p~is~a~polynomial~with~an~integral~root\}
$$

Hilbert thought there will be an algorithm for this, but it turns out to be solved in the negative. It was proved in 1970 by a Russian mathematician, Yuri Matiyasevich that the Hilbert's 10th problem is undecidable. This is not the end of the story though ,as there 

## 2. Hilbert's Entscheidungsproblem

In 1928

## 3 Curry-Howard Correspondence

## Reference

- [Deciding the Undecidable: Wrestling with Hilbert's Problems](https://math.stanford.edu/~feferman/papers/deciding.pdf)
- [Wikipedia - Entscheidungsproblem](https://en.wikipedia.org/wiki/Entscheidungsproblem)
