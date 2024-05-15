---
title: Note for Linear Logic
date: 2024-05-14 10:18:44
tags:
  - Logic
  - Linear Logic
  - Programming Language
---

This is my note learning [Linear Logic](https://www.cs.cmu.edu/~fp/courses/15816-s12/schedule.html) by **Frank Pfenning**.

<!--more-->

## Linear Logic

The notation below shows how to tracks all the ephemeral propositions in the judgment explicitly during inference:

$$
\underbrace{A_1~pers,\dots,A_n~pers}_\Gamma;\underbrace{B_1~eph,\dots,B_n~eph}_\Delta\vdash C~eph
$$

in which $\Delta$ is the $\mathit{resources}$ and $C$ as the goal we have to achieve. We have to use all the resources in $\Delta$ $\mathit{exactly~once}$ in the proof that we can achieve C.

Structural rules:

$$
\dfrac{\Gamma,A~pers;\Delta,A~eph\vdash C~eph}
{\Gamma,A~pers;\Delta\vdash C~eph}
\mathsf{copy}
$$

We use sequent calculus to express linear logic, in which **left rules** show how to **use** a proposition (achieve a goal), **right rules** show how to **prove** a proposition. Each proposition $\Delta\vdash P$ actually means $\Delta\vdash P~eph$.

$$
\scriptsize
\begin{array}{cccc}
  & Right~rules && Left~rules \\
  &&&\\
  \begin{array}{c}
    Simultaneous \\
    Conjunction
  \end{array}
  &
  \dfrac{
    \Delta\vdash A
    \quad
    \Delta'\vdash B
    }
  {\Delta,\Delta'\vdash A\otimes B}
  \otimes R
  && 
  \dfrac{
    \Delta A,B\vdash C
    }
  {\Delta,A\otimes B\vdash C}
  \otimes L
  \\ 
  &&&\\
  \begin{array}{c}
    Linear \\
    Implication
  \end{array}
  &
  \dfrac{\Delta,A\vdash B}
  {\Delta\vdash A\multimap B}
  \multimap R
  &&
  \dfrac{\Delta\vdash A\quad\Delta',B\vdash C}
  {\Delta,\Delta',A\multimap B\vdash C}
  \multimap L
  \\
  &&&\\
  \begin{array}{c}
    Multiplicative \\
    Unit
  \end{array}
  &
  \dfrac{}
  {\cdot\vdash 1}
  1 R
  &&
  \dfrac{\Delta\vdash C}
  {\Delta,1\vdash C}
  1 L
  \\
  &&&\\
  \begin{array}{c}
    Alternative \\
    Conjunction
  \end{array} 
  &
  \dfrac{\Delta\vdash A\quad\Delta\vdash B}
  {\Delta\vdash A\,\&\,B}
  \& R
  &&
  \dfrac{\Delta,A\vdash C}
  {\Delta A\,\&\,B\vdash C}
  \& L_1
  ~~
  \dfrac{\Delta,B\vdash C}
  {\Delta A\,\&\,B\vdash C}
  \& L_2
  \\
  &&&\\
  \begin{array}{c}
    Additive \\
    Unit
  \end{array} 
  &
  \dfrac{}
  {\Delta\vdash\top}
  \top R
  &&
  no~\top L~rule
  \\
  &&&\\
  Disjunction
  &
  \dfrac{\Delta\vdash A}
  {\Delta\vdash A\oplus B}
  \oplus R_1
  \quad
  \dfrac{\Delta\vdash B}
  {\Delta\vdash A\oplus B}
  \oplus R_2
  &&
  \dfrac{\Delta,A\vdash C\quad\Delta,B\vdash C}
  {\Delta,A\oplus B\vdash C}
  \oplus L
  \\
  &&&\\
  \begin{array}{c}
    Disjunction \\
    Unit
  \end{array} 
  &
  No~0R~rule
  &&
  \dfrac{}
  {\Delta,0\vdash C}
  0L
  \\
  &&&\\
  Of~Course!
  &
  \dfrac{\Gamma;\cdot\vdash A~eph}
  {\Gamma;\cdot\vdash!A~eph}
  \,!R
  &&
  \dfrac{\Gamma,A~pers;\Delta\vdash C~eph}
  {\Gamma;\Delta,!A~eph\vdash C~eph}
  \,!L
  \\
\end{array}
$$

## Linear Logic vs Intuitionistic Logic

- there is no weakening in Linear Logic like the following rule
$$
\dfrac{\Delta\vdash C}
{\Delta,A\vdash C}
\mathsf{weakening}
$$
- there is no contraction in Linear Logic like the following rule
$$
\dfrac{\Delta,A,A\vdash C}
{\Delta,A\vdash C}
\mathsf{contraction}
$$

## Local Harmony

### Local Completeness - Identity Expansion

In natural deduction, we justify that the proof for the original proposition can be reconstructed via Elimination and then Introduction to show that the Elimination and Introduction rules match for local completeness.

However, in sequent calculus, we need to show that the identity rule at a compound type can be expanded to the identity rule at smaller types. Or in another words, we can construct the identity rule on compound type based on identity rules on smaller types using left and right rules.

$$
\scriptsize
\begin{array}{cccc}
  A\otimes B
  &
  \dfrac{}
  {A\otimes B\vdash A\otimes B}
  id_{A\otimes B}
  &
  \rightarrow_E
  &
  \dfrac{
    \dfrac{
      \dfrac{}
      {A\vdash A}
      id_A
      \quad
      \dfrac{}
      {B\vdash B}
      id_B
    }
    {A,B\vdash A\otimes B}
    \otimes R
  }
  {A\otimes B\vdash A\otimes B}
  \otimes L
  \\
  &&&\\
  A\multimap B
  &
  \dfrac{}
  {A\multimap B\vdash A\multimap B}
  id_{A\multimap B}
  &
  \rightarrow_E
  &
  \dfrac{
    \dfrac{
      \dfrac{}
      {A\vdash A}
      id_A
      \quad
      \dfrac{}
      {B\vdash B}
      id_B
    }
    {A\multimap B,A\vdash B}
    \multimap L
  }
  {A\multimap B\vdash A\multimap B}
  \multimap R
  \\
  &&&\\
  1
  &
  \dfrac{}
  {1\vdash 1}
  id_{1}
  &
  \rightarrow_E
  &
  \dfrac{
    \dfrac{
    }
    {\cdot\vdash 1}
    1 R
  }
  {1\vdash 1}
  1 L
  \\
  &&&\\
  A\,\& B
  &
  \dfrac{}
  {A\,\& B\vdash A\,\& B}
  id_{A\,\& B}
  &
  \rightarrow_E
  &
  \dfrac{
    \dfrac{
      \dfrac{}
      {A\vdash A}
      id_A
    }
    {A\,\& B\vdash A}
    \&\,L_1
    \quad
    \dfrac{
      \dfrac{}
      {B\vdash B}
      id_B
    }
    {A\,\& B\vdash B}
    \&\,L_2
  }
  {A\,\& B\vdash A\,\& B}
  \&\,R
  \\
  &&&\\
  \top
  &
  \dfrac{}
  {\top\vdash \top}
  id_{top}
  &
  \rightarrow_E
  &
  \dfrac{
  }
  {\top\vdash \top}
  \top R
  \\
  &&&\\
  A\oplus B
  &
  \dfrac{}
  {A\oplus B\vdash A\oplus B}
  id_{A\oplus B}
  &
  \rightarrow_E
  &
  \dfrac{
    \dfrac{
      \dfrac{}
      {A\vdash A}
      id_A
    }
    {A\vdash A\oplus B}
    \oplus R_1
    \quad
    \dfrac{
      \dfrac{}
      {B\vdash B}
      id_B
    }
    {B\vdash A\oplus B}
    \oplus R_2
  }
  {A\oplus B\vdash A\oplus B}
  \oplus L
  \\
  &&&\\
  0
  &
  \dfrac{}
  {0\vdash 0}
  id_{0}
  &
  \rightarrow_E
  &
  \dfrac{ 
  }
  {0\vdash 0}
  0 L
  \\
\end{array}
$$

### Local Soundness - Cut Reduction

In natural deduction, we demonstrate that a more direct proof of the conclusion of an elimination can be found thanone that first introduces and then eliminates to show that the Elimination and Introduction rules match for local soundness.

However, in sequent calculus, we need to show that we can reduce a cut at a compound type to cuts on smaller types.

$$
\tiny
\begin{array}{cccc}
  A\otimes B
  &
  \dfrac{
    \dfrac{\Delta\vdash A\quad\Delta'\vdash B}
    {\Delta,\Delta'\vdash A\otimes B}
    \otimes R
    \quad
    \dfrac{\Delta'',A, B\vdash C}
    {\Delta'',A\otimes B\vdash C}
    \otimes L
  }
  {\Delta,\Delta',\Delta''\vdash C}
  cut_{A\otimes B}
  &
  \rightarrow_R
  \dfrac{
    \Delta'\vdash B
    \quad
    \dfrac{\Delta\vdash A \quad\Delta'',A,B\vdash C}
    {\Delta,\Delta'',B\vdash C}
    cut_A
  }
  {\Delta,\Delta',\Delta''\vdash C}
  cut_B
  \\
  &&&\\
  A\multimap B
  &
  \dfrac{
    \dfrac{\Delta,A\vdash B}
    {\Delta\vdash A\multimap B}
    \multimap R
    \quad
    \dfrac{
      \Delta'\vdash A
      \quad
      \Delta'', B\vdash C
    }
    {\Delta',\Delta'',A\multimap B\vdash C}
    \multimap L
  }
  {\Delta,\Delta',\Delta''\vdash C}
  cut_{A\multimap B}
  &
  \rightarrow_R
  \dfrac{
    \Delta'',B\vdash C
    \quad
    \dfrac{\Delta'\vdash A \quad\Delta,A\vdash B}
    {\Delta,\Delta'\vdash B}
    cut_A
  }
  {\Delta,\Delta',\Delta''\vdash C}
  cut_B
  \\
\end{array}
$$
