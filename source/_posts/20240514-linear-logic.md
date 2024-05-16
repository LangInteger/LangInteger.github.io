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

## 1 Formalize

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

## 2 Linear Logic vs Intuitionistic Logic

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

## 3 Harmony - Local

### 3.1 Local Completeness - Identity Expansion

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

### 3.2 Local Soundness - Cut Reduction

In natural deduction, we demonstrate that a more direct proof of the conclusion of an elimination can be found that first introduces and then eliminates to show that the Elimination and Introduction rules match for local soundness.

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
  &
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
  &
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
  &&&\\
  1
  &
  \dfrac{
    \dfrac{}
    {\cdot\vdash 1}
    1R
    \quad
    \dfrac{\Delta\vdash C}
    {\Delta,1\vdash C}
    1L
  }
  {\Delta\vdash C}
  cut_1
  &
  \rightarrow_R
  &
  \Delta\vdash C
  \\
  &&&\\
  A\& B
  &
  \dfrac{
    \dfrac{\Delta\vdash A\quad\Delta\vdash B}
    {\Delta\vdash A\,\&\,B}
    \& R
    \quad
    \dfrac{\Delta',A\vdash C}
    {\Delta', A\,\&\,B\vdash C}
    \& L_1
  }
  {\Delta,\Delta'\vdash C}
  cut_{A\& B}
  &
  \rightarrow_R
  &
  \dfrac{\Delta\vdash A\quad\Delta',A\vdash C}
  {\Delta,\Delta'\vdash C}
  cut_A
  \\
  &&&\\
  T
  &&&
  \\
  &&&\\
  A\otimes B
  &
  \dfrac{
    \dfrac{\Delta'\vdash A}
    {\Delta'\vdash A\oplus B}
    \oplus R_1
    \quad
    \dfrac{\Delta,A\vdash C\quad\Delta,B\vdash C}
    {\Delta,A\oplus B\vdash C}
    \oplus L
  }
  {
    \Delta,\Delta'\vdash C
  }
  cut_{A\otimes B}
  &
  \rightarrow_R
  &
  \dfrac{
    \Delta'\vdash A
    \quad
    \Delta,A\vdash C
  }
  {
    \Delta,\Delta'\vdash C
  }
  cut_A
  \\
  &&&\\
  0 &&&\\
\end{array}
$$

## 4 Harmony - Global

### 4.1 Linear Cut Admissibility - Soundness

The admissibility of cut can be formalized as ($\Rightarrow$ means we can prove the corresponding judgement using $\vdash$ without using cut rule): if $\begin{array}{c}\mathcal{D}\\\Delta\Rightarrow A\end{array}$ and $\begin{array}{c}\mathcal{E}\\\Delta',A\Rightarrow C\end{array}$ then $\begin{array}{c}\mathcal{F}\\\Delta,\Delta'\Rightarrow C\end{array}$

Same as the proof in intuitionistic logic, we build the proof by the combination of the last inference rule that is applied in $\mathcal{D}$ and $\mathcal{E}$. To simplify the cases we need to consider, we classify the cases as follows:

- The last inference rule is initial sequent in $\mathcal{D}$ or $\mathcal{E}$
  - Case 1: the last inference rule in $\mathcal{D}$ is initial sequent
  - Case 2: the last inference rule in $\mathcal{E}$ is initial sequent using cut formula $A$
    - There is no case for not using A, as all resources must be consumed in Linear Logic
- The last inference rule is not initial sequent in $\mathcal{D}$ and $\mathcal{E}$
  - Case 3: $A$ is the principle formula of the last inference rule (which is not initial sequent) in both $\mathcal{D}$ and $\mathcal{E}$
    - It must be derived by a left rule applied as last inference rule in $\mathcal{E}$ and by a right rule applied as last inference rule in $\mathcal{D}$. Apparently, all the cases have been covered in **Cut Reduction**. It can be proved by induction hypothesis on the smaller type, sub deduction of $\mathcal{D}$ and $\mathcal{E}$ used in the result of the reduction.
  - Case 4: $A$ is not the principle formula of the last inference rule (which is not initial sequent) in $\mathcal{D}$ 
  - Case 5: $A$ is not the principle formula of the last inference rule (which is not initial sequent) in $\mathcal{E}$ 

**Proof:** By induction on the structure of $A$, derivation $\mathcal{D}$ and $\mathcal{E}$
- Case 1: the last inference rule in $\mathcal{D}$ is initial sequent
  $$
  \mathcal{D}=
  \dfrac{}
  {A\Rightarrow A}
  init
  \quad
  \begin{array}{c}
    \mathcal{E}\\
    \Delta',A\Rightarrow C
  \end{array}
  $$
  Thus $\Delta=A$. We have $\Delta',A\Rightarrow C$, which shows $\Delta,\Delta'\Rightarrow C$.
- Case 2: the last inference rule in $\mathcal{E}$ is initial sequent
  $$
    \begin{array}{c}\mathcal{D}\\\Delta\Rightarrow A\end{array}
    \quad
    \mathcal{E}=
    \dfrac{}
    {\cdot,C\Rightarrow C}
    init
  $$
  Thus $\Delta'=\cdot$ and $A=C$. We have $\Delta\Rightarrow A$ by $\mathcal{D}$, which shows $\Delta,\Delta'\Rightarrow C$.
- Case 4: A is not the principle formula of the last inference rule (which is not initial sequent) in $\mathcal{D}$. We do case analyse by all the left rules that can be applied as the last inference rule in $\mathcal{D}$
  - Case 4.1 $\otimes L$
    $$
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1}\\
        \Delta_1,B_1, B_2\Rightarrow A
      \end{array}
    }
    {\Delta_1,B_1\otimes B_2\Rightarrow A}
    \otimes L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Delta',A\Rightarrow C
    \end{array} 
    $$
    $$
    \begin{array}{lcr}
      \Delta_1,B_1, B_2,\Delta'\Rightarrow C
      &&
      \text{By i.h. on }A, \mathcal{D_1}\text{ and }\mathcal{E}
      \\
      \Delta_1,B_1\otimes B_2,\Delta'\Rightarrow C
      &&
      \text{By rule }\otimes L\text{ on above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 4.2 $\multimap L$
    $$
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1}\\
        \Delta_1\Rightarrow B_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{D_2}\\
        \Delta_2,B_2\Rightarrow A
      \end{array}
    }
    {\Delta_1,\Delta_2,B_1\multimap B_2\Rightarrow A}
    \multimap L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Delta',A\Rightarrow C
    \end{array} 
    $$
    $$
    \begin{array}{lcr}
      \Delta_2,B_2,\Delta'\Rightarrow C
      &&
      \text{By i.h. on }A, \mathcal{D_2}\text{ and }\mathcal{E}
      \\
      \Delta_1,\Delta_2,B_1\multimap B_2,\Delta'\Rightarrow C
      &&
      \text{By rule }\multimap L\text{ on }\mathcal{D_1}\text{ and the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 4.3 $1 L$
    $$
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1}\\
        \Delta_1\Rightarrow A
      \end{array}
    }
    {\Delta_1,1\Rightarrow A}
    1 L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Delta',A\Rightarrow C
    \end{array} 
    $$ 
    $$
    \begin{array}{lcr}
      \Delta_1,\Delta'\Rightarrow C
      &&
      \text{By i.h. on }A, \mathcal{D_1}\text{ and }\mathcal{E}
      \\
      \Delta_1,1,\Delta'\Rightarrow C
      &&
      \text{By rule }1 L\text{ on the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 4.4 $\& L_1$
    $$
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1}\\
        \Delta_1,B_1\Rightarrow A
      \end{array}
    }
    {\Delta_1,B_1\,\&\,B_2\Rightarrow A}
    \& L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Delta',A\Rightarrow C
    \end{array} 
    $$
    $$
    \begin{array}{lcr}
      \Delta_1,B_1,\Delta'\Rightarrow C
      &&
      \text{By i.h. on }A, \mathcal{D_1}\text{ and }\mathcal{E}
      \\
      \Delta_1,B_1\& B_2,\Delta'\Rightarrow C
      &&
      \text{By rule }\& L\text{ on the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 4.5 $\& L_2$. The proof is symmetric to 4.4
  - Case 4.6 $\oplus L$
    $$
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1}\\
        \Delta_1,B_1\Rightarrow A
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{D_2}\\
        \Delta_2,B_2\Rightarrow A
      \end{array}
    }
    {\Delta_1,\Delta_2,B_1\oplus B_2\Rightarrow A}
    \oplus L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Delta',A\Rightarrow C
    \end{array} 
    $$ 
    $$
    \begin{array}{lcr}
      \Delta_2,B_2,\Delta'\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D_2},\mathcal{E}
      \\
      \Delta_1,\Delta_2,B_1\oplus B_2,\Delta'\Rightarrow C
      &&
      \text{By rule }\oplus L\text{ on }\mathcal{D_1}\text{ and above}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 4.7 $0 L$
    $$
    \mathcal{D}=
    \dfrac{
    }
    {\Delta_1,0\Rightarrow A}
    0 L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Delta',A\Rightarrow C
    \end{array} 
    $$ 
    $$
    \begin{array}{lcr}
      \Delta_1,\Delta',0\Rightarrow C
      &&
      \text{By rule }0L
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$

- Case 5: A is not the principle formula of the last inference rule (which is not initial sequent) in $\mathcal{E}$. We do case analyse by all the left and right rules that can be applied as the last inference rule in $\mathcal{E}$
  - Case 5.1 $\otimes L$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta_1,B_1,B_2,A\Rightarrow C
      \end{array}
    }
    {\Delta_1,B_1\otimes B_2,A\Rightarrow C}
    \otimes L
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_1,B_1,B_2\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D},\mathcal{E_1}
      \\
      \Delta,\Delta_1,B_1\otimes B_2\Rightarrow C
      &&
      \text{By rule }\otimes L\text{  on above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.2 $\multimap L$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta_1\Rightarrow B_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{E_2}\\
        \Delta_2,A,B_2\Rightarrow C
      \end{array}
    }
    {\Delta_1,\Delta_2,B_1\multimap B_2,A\Rightarrow C}
    \multimap L
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_2,B_2\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D},\mathcal{E_2}
      \\
      \Delta,\Delta_1,\Delta_2,B_1\multimap B_2\Rightarrow C
      &&
      \text{By rule }\multimap L\text{  on }\mathcal{E_1}\text{ above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.3 $1 L$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta_1,A\Rightarrow C
      \end{array}
    }
    {\Delta_1,1,A\Rightarrow C}
    1 L
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_1\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D},\mathcal{E_1}
      \\
      \Delta,\Delta_1,1\Rightarrow C
      &&
      \text{By rule }1 L\text{  on the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.4 $\& L_1$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta_1,B_1,A\Rightarrow C
      \end{array}
    }
    {\Delta_1,B_1\,\&\,B_2,A\Rightarrow C}
    \& L
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_1,B_1\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D},\mathcal{E_1}
      \\
      \Delta,\Delta_1,B_1\,\&\,B_2\Rightarrow C
      &&
      \text{By rule }\& L\text{  on the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.5 $\& L_2$. The proof is symmetric to Cae 5.4.
  - Case 5.6 $\oplus L$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta_1,B_1,A\Rightarrow C
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{E_2}\\
        \Delta_1,B_2,A\Rightarrow C
      \end{array}
    }
    {\Delta_1,B_1\oplus B_2,A\Rightarrow C}
    \oplus L
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_1,B_1\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D},\mathcal{E_1}
      \\
      \Delta,\Delta_1,B_2\Rightarrow C
      &&
      \text{By i.h. on }A,\mathcal{D},\mathcal{E_2}
      \\
      \Delta,\Delta_1,B_1\oplus B_2\Rightarrow C
      &&
      \text{By rule }\oplus L\text{  on the above lines}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.7 $0 L$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
    }
    {\Delta_1,0,A\Rightarrow C}
    0 L
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_1,0,A\Rightarrow C
      &&
      \text{By rule }0 L
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.8 $\otimes R$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta_1\Rightarrow B_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{E_2}\\
        \Delta_2,A\Rightarrow B_2
      \end{array}
    }
    {\Delta_1,\Delta_2,A\Rightarrow B_1\otimes B_2}
    \otimes R
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta_2\Rightarrow B_2
      &&
      \text{By i.h. on }A, \mathcal{D}\text{ and }\mathcal{E_1}
      \\
      \Delta,\Delta_1,\Delta_2\Rightarrow B_1\otimes B_2
      &&
      \text{By rule }\otimes R\text{ on }\mathcal{E_1}\text{ and the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.9 $\multimap R$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta',A,B_1\Rightarrow B_2
      \end{array}
    }
    {\Delta',A\Rightarrow B_1\multimap B_2}
    \multimap R
    $$
    $$
    \begin{array}{lcr}
      \Delta,\Delta',B_1\Rightarrow B_2
      &&
      \text{By i.h. on }A, \mathcal{D}\text{ and }\mathcal{E_1}
      \\
      \Delta,\Delta'\Rightarrow B_1\multimap B_2
      &&
      \text{By rule }\multimap R\text{ on the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.10 $1 R$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \cdot\Rightarrow 1
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
    }
    {\cdot,\cdot\Rightarrow 1}
    1 R
    $$
    $$
    \begin{array}{lcr}
      \cdot\Rightarrow 1
      &&
      \text{By rule }1 R
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.11 $\& R$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta',A\Rightarrow B_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{E_2}\\
        \Delta',A\Rightarrow B_2
      \end{array}
    }
    {\Delta',A\Rightarrow B_1\,\&\,B_2}
    \& R
    $$ 
    $$
    \begin{array}{lcr}
      \Delta,\Delta'\Rightarrow B_1
      &&
      \text{By i.h. on }A, \mathcal{D}\text{ and }\mathcal{E_1}
      \\
      \Delta,\Delta'\Rightarrow B_2
      &&
      \text{By i.h. on }A, \mathcal{D}\text{ and }\mathcal{E_2}
      \\
      \Delta,\Delta'\Rightarrow B_1\,\&\,B_2
      &&
      \text{By rule }\& R\text{ on the above two lines}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.12 $\top R$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
    }
    {\Delta',A\Rightarrow \top}
    \top R
    $$  
    $$
    \begin{array}{lcr}
      \Delta\Delta'\Rightarrow \top
      &&
      \text{By rule }\top R
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.13 $\oplus R_1$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Delta\Rightarrow A
    \end{array}  
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1}\\
        \Delta',A\Rightarrow B_1
      \end{array}
    }
    {\Delta',A\Rightarrow B_1\,\oplus\,B_2}
    \oplus R_1
    $$ 
    $$
    \begin{array}{lcr}
      \Delta,\Delta'\Rightarrow B_1
      &&
      \text{By i.h. on }A, \mathcal{D}\text{ and }\mathcal{E_1}
      \\
      \Delta,\Delta'\Rightarrow B_1\oplus B_2
      &&
      \text{By rule }\oplus R_1\text{ on the above line}
      \\
      \Delta,\Delta'\Rightarrow C
      &&
      \text{By equality}
      \\
    \end{array}
    $$
  - Case 5.14 $\oplus R_2$. The proof is symmetric to Case 5.13.

