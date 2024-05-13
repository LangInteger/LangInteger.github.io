---
title: Notes of Constructive Logic
date: 2024-05-08 12:05:54
tags: 
  - Logic
  - Programming Language
---

This is a note for [Constructive Logic](https://www.cs.cmu.edu/~fp/courses/15317-f09/schedule.html). Logic is the study of the principles of valid inferences and demonstration,  which constitutes an important area in the disciplines of philosophy and mathematics.

<!--more-->

## 1 Inference Rule and Natural Deduction

Two principal notions of logic are **propositions** and **proofs**. One approach to build foundations for these notions is to understand the meaning of a proposition by understanding its proofs. The system of **inference rules** that arises from this point of view is **natural deduction**. The cornerstone of the foundation of logic is a clear separation of the notions of **judgment** and **proposition**.

The most important **judgment** form in logic is $\mathit{''A~is~true''}$, in which $A$ is a **proposition**. A **judgement** is **evident** if we in fact know it, or in other words, we have a **proof** for it.

The general form of an **inference rule** and the conjunction introduction rule are
$$
\dfrac{J_1\dots J_n}
      {J}
      name
\qquad
\dfrac{A\,true \qquad B\,true}
      {A\wedge B\,true}
      \wedge I
$$
in which $A$ and $B$ are **schematic variables**, $J_1\dots J_n$ are called the **premises**, the judgment $J$ is called the **conclusion**. The inference rules for **logic connectives** $\wedge$, $\vee$, $\supset$, $\top$, $\bot$ are:

$$
\small
\begin{array}{ccc}
    Introduction\,Rules &&  Elimination\,Rules \\
    && \\
    \dfrac{A\,true \qquad B\,true}
      {A\wedge B\,true}
      \wedge I
    &&
    \dfrac{A\wedge B\,true}
      {A\,true}
      \wedge E_L
    \quad
    \dfrac{A\wedge B\,true}
      {B\,true}
      \wedge E_R
    \\
    && \\
    \dfrac{}
      {\top\,true}
      \top I
    &&
    no~\top~E~rule
    \\
    && \\
    \dfrac{
        \begin{align*}
          \dfrac{}
            {A\,true}
            u \\
          &\vdots \\
          B\,true
        \end{align*}
      }
      {A\supset B\,true}
      \supset I^{u} 
    && 
    \dfrac{A\supset B\,true \qquad A\,true}
      {B\,true}
      \supset E
    \\
    && \\
    \dfrac{A\,true}
      {A\vee B\,true}
      \vee I_L
    \quad
    \dfrac{B\,true}
      {A\vee B\,true}
      \vee I_R 
    &&
    \dfrac{
        A\vee B\,true
        \quad
        \begin{array}{c}
          \dfrac{}
            {A\,true}
            u \\
          &\vdots \\
          C\,true
        \end{array} 
        \quad
        \begin{align*}
          \dfrac{}
            {B\,true}
            \omega \\
          &\vdots \\
          C\,true
        \end{align*} 
      }
      {C\,true}
      \vee E^{u,\omega}
    \\
    && \\
    no~\bot I~rule
    && 
    \dfrac{\bot\,true}
      {C\,true}
      \bot E
    \\
    && \\
\end{array}
$$

The **judgments**, **propositions** and **inference rules** we have defined so far collectively form a system of **natural deduction**. It is a minor variant of a system introduced by Gentzen aiming at devising rules to model mathematical reasoning as directly as possible.

So far, we have defined the meaning of the logical connectives by their introduction rules, which is the so-called **verificationist** approach. Another common way to define a logic connective is by a **notational definition**, which gives the meaning of the general form of a proposition in terms of another proposition whose meaning has already been defined. Some common notational definition in intuitionistic logic

$$
A\equiv B = (A\supset B)\wedge(B\supset A) \\
\neg A = (A\supset \bot)
$$

We sometimes give a notational definition and then derive introduction and eliminaton rules for the connective. It should be unerstood that these rules have a different status from those that define a connective.

## 2 Harmony of Logic Connective

In the **verificationist** definition of the logical connectives, the introduction and elimination rules we defined are in harmony. We establish two properties: **local soundness** and **local completeness** to show it.

- **Local soundness** shows that the **elimination rules are not too strong**: no matter how we apply elimination rules to the result of an introduction we cannot gain any new information. We use the below notation to show the local reduction of a deduction $\mathcal{D}$ to another deduction $\mathcal{D'}$.
$$
\begin{array}{c}
  \mathcal{D} \\
  A~true
\end{array}
\Longrightarrow_R
\begin{array}{c}
  \mathcal{D'} \\
  A~true
\end{array}
$$
- **Local completeness** shows that the **elimination rules are not too weak**: there is always a way to apply elimination rules so that we can reconstitute a proof of the original proposition from the results by applying introduction rules. We use the below notation to show the local expansion of a deduction $\mathcal{D}$ to another deduction $\mathcal{D'}$.
$$
\begin{array}{c}
  \mathcal{D} \\
  A~true
\end{array}
\Longrightarrow_E
\begin{array}{c}
  \mathcal{D'} \\
  A~true
\end{array}
$$

Another criterion we would like to apply uniformly is that both introduction and elimination rules do not refer to other propositional constants or connectives besides the one we are trying to define, which could create a dangerous dependency of the various connectives on each other.

Connectives are properly defined only if their introduction and elimination rules are in hormony in the sense that they are locally sound and complete. Next, we show how to prove them.

**Proof for local soundness:**
- Conjunction $\wedge$
  - $\wedge~E_L$
$$
\dfrac{
  \dfrac{
    \begin{array}{c}
      \mathcal{D} \\
      A~true
    \end{array}
    \quad
    \begin{array}{c}
      \mathcal{E} \\
      B~true
    \end{array}
    }
  {A\wedge B~true}
  \wedge I
}
{A~true}
E_L
\Longrightarrow_R
\begin{array}{c}
  \mathcal{D} \\
  A~true
\end{array}
$$
  - $\wedge~E_R$
$$
\dfrac{
  \dfrac{
    \begin{array}{c}
      \mathcal{D} \\
      A~true
    \end{array}
    \quad
    \begin{array}{c}
      \mathcal{E} \\
      B~true
    \end{array}
    }
  {A\wedge B~true}
  \wedge I
}
{B~true}
E_R
\Longrightarrow_R
\begin{array}{c}
  \mathcal{D} \\
  B~true
\end{array}
$$
- Implication $\supset$
  - $\supset E$
$$
\dfrac{
    \dfrac{
        \begin{align*}
          \dfrac{}
            {A\,true}
            u \\
          &\vdots \\
          B\,true
        \end{align*}
      }
      {A\supset B\,true}
      \supset I^{u} 
    \qquad 
    A\,true}
  {B\,true}
  \supset E
  \Longrightarrow
  \begin{align*}
    \dfrac{\mathcal{D}}
      {A\,true}
      u \\
    &\vdots \\
    B\,true
  \end{align*}
$$
- Disjunction $\vee$
  - $\vee E$
$$
\dfrac{
    \dfrac{
      \begin{array}{c}
        \mathcal{D} \\
        A\,true
      \end{array}
    }
    {A\vee B\,true}
    \vee I_L
    \quad
    \begin{array}{c}
      \dfrac{}
        {A\,true}
        u \\
      &\vdots \\
      C\,true
    \end{array} 
    \quad
    \begin{align*}
      \dfrac{}
        {B\,true}
        \omega \\
      &\vdots \\
      C\,true
    \end{align*} 
  }
  {C\,true}
  \vee E^{u,\omega}
  \Longrightarrow_R
  \begin{align*}
    \dfrac{\mathcal{D}}
      {A\,true}
      u \\
    &\vdots \\
    C\,true
  \end{align*}
$$
$$
\dfrac{
    \dfrac{
      \begin{array}{c}
        \mathcal{D} \\
        B\,true
      \end{array}
    }
    {A\vee B\,true}
    \vee I_L
    \quad
    \begin{array}{c}
      \dfrac{}
        {A\,true}
        u \\
      &\vdots \\
      C\,true
    \end{array} 
    \quad
    \begin{align*}
      \dfrac{}
        {B\,true}
        \omega \\
      &\vdots \\
      C\,true
    \end{align*} 
  }
  {C\,true}
  \vee E^{u,\omega}
  \Longrightarrow_R
  \begin{align*}
    \dfrac{\mathcal{D}}
      {B\,true}
      \omega \\
    &\vdots \\
    C\,true
  \end{align*}
$$
- Truth $\top$. There is no elimination rule, so there is no case to check for local soundness.
- Falsehood $\bot$
  - $\bot~E$. Local soundness is trivially satisfied since we have no introduction rule

**Proof for local completeness:**
- Conjunction $\wedge$
$$
\begin{array}{c}
  \mathcal{D} \\
  A\wedge B~true
\end{array}
\Longrightarrow_E
\dfrac{
  \dfrac{
    \begin{array}{c}
      \mathcal{D} \\
      A\wedge B~true
    \end{array}
  }
  {A~true}
  \wedge E_L
  \quad
  \dfrac{
    \begin{array}{c}
      \mathcal{D} \\
      A\wedge B~true
    \end{array}
  }
  {B~true}
  \wedge E_R
}
{A\wedge B~true}
\wedge I
$$
- Implication $\supset$
$$
\begin{array}{c}
  \mathcal{D} \\
  A\supset B~true
\end{array}
\Longrightarrow_E
\dfrac{
  \dfrac{
    \begin{array}{c}
      \mathcal{D} \\
      A\supset B~true
    \end{array}
    \quad
    \dfrac{}
    {A~true}
    u
  }
  {B~true}
  \supset E
}
{A\supset B~true}
\supset I^u
$$
- Disjunction $\vee$
  - In the proof here the elimination rule is applied last rather than first. Mostly, this is due to the notion of natural deduction. It represents the step from using the knowledge of $A\vee B~true$ and eliminating it to obtain the hypotheses $A~true$ and $B~true$ in the two cases.
$$
\begin{array}{c}
  \mathcal{D} \\
  A\vee B~true
\end{array}
\Longrightarrow_E
\dfrac{
  \begin{array}{c}
    \mathcal{D} \\
    A\vee B~true
  \end{array}
  \quad
  \dfrac{
    \dfrac{
    }
    {A~true}
    u
    \quad
  }
  {A\vee B~true}
  \vee I_L
  \quad
  \dfrac{
    \dfrac{
    }
    {B~true}
    \omega
  }
  {A\vee B~true}
  \vee I_R
}
{A\vee B~true}
\vee E^{u,\omega}
$$
- Truth $\top$
$$
\begin{array}{c}
  \mathcal{D} \\
  \top~true
\end{array}
\Longrightarrow_E
\dfrac{}
{\top~true}
\top_I
$$
- Falsehood $\bot$
  - It seems there is no case to consider since there is no introduction rule for $\bot$. Nevertheless, the following is the right local expansion.
$$
\begin{array}{c}
  \mathcal{D} \\
  \bot~true
\end{array}
\Longrightarrow_E
\dfrac{
  \begin{array}{c}
    \mathcal{D} \\
    \bot~true
  \end{array}
}
{\bot~true}
\bot_E
$$

## 3 Proof as Programs

The **computational interpretation** of **constructive proofs** on the **propositional fragment of logic** is called the **Curry-Howard isomorphism**. We use the following judgement to illustrate the relationship between proofs and programs:

$$
M:A\qquad M\text{ is a proof term for proposition }A\\
M:A\qquad M\text{ is a program of type }A
$$

This dual interpretations of the same judgement is the core of Curry-Howard isomorphism.

- conjunction $A\wedge B$ corresponds to the product type $A\times B$
- Truth $\top$ corresponds to the unite type with only one element
- implications $A\supset B$ corresponds to the function type $A\rightarrow B$
- disjunction $A\vee B$ corresponds to the sum type $A+B$
- Falsehood $\bot$ corresponds to the empty type with zero element

## 4 Intuitionistic Instead of Classical

The specific interpretation of the truth judgment underlying these rules is **intuitionistic** or **constructive**. This differs from the **classical** or **Boolean** interpretation of truth.

Classical logic is based on the principle that every proposition must be true or false. It will accept the proposition $A\vee(A\supset B)$ as true for arbitrary $A$ and $B$. In contrast, intuitionistic logic is based on explicit evidence, and evidence for a disjunction requires evidence for one of the disjuncts. **TBD**: intuitionisti logic has a direct connection to functional computation, which classical logic lacks.

**Classical logic** can be characterized by a number of equivalent axioms:
- Proof by Contradiction
- Law of the Excluded Middle: $A\vee \neg A$
- Double-Negation Elimination: $\neg\neg A\supset A$
- Peirce's Law: $((A\supset B)\supset A)\supset A$

We might consider making the logic we have seen so far classical by adding any rule that corresponds to one of these aximos like:
$$
\dfrac{}
  {A\vee\neg A\,true}
  LEM
\quad
or
\quad
\dfrac{\neg\neg A\,true}
  {A\,true}
  DNE
$$

**TBD**: there is a **double-negation translation** that translates any classical theorem into one that is intuitionisti valid.

## 5 Sequent Calculus

Sequent calculus is another formal system for **proof search** in **natural deduction**. It is designed to exactly capture the notion of a **verification**.

**Verifications($A\uparrow$)** and **uses($A\downarrow$)** are a pair of comcepts that capture the proof search strategies to use introduction rules from the bottom up and elimination rules from the top down. **Verifications** are defined for each introduction rule. **Uses** are defined for each elimination rule.

When constructing a **verification**, we are generally in a state of the following form:

$$
\begin{array}{ccc}
  A_1\downarrow & \dots & A_n\downarrow \\
  & \vdots & \\
  & C\uparrow & \\
\end{array}
$$

A **sequent** is a local notation for such a partially complete verification. We write

$$
A_1\,\mathsf{left},\dots,A_n\,\mathsf{left}\Longrightarrow C\,\mathsf{right}
$$

The judgements on the left are assumptions called **antecedents**, the judgment on the right side is the conclusion called the **succedent**. The rules taht define the $A\,\mathsf{left}$ and $A\,\mathsf{right}$ judgment are systematically constructed from the introduction and elimination rules.

- **Introduction rules** already work from the conclusion to the premises (**bottom-up**), the mapping is straightforward
- **Elimination rules** work **top-down**, so they have to be flipped upside-down in order to work as sequent rules

The **right and left rules** are constructed as follows from **verifications and uses** one by one for $\wedge$, $\top$, $\supset$, $\vee$, $\bot$

$$
\small
\begin{array}{ccc}
  verifications/uses & & right/left~rules \\
  & & \\
  \dfrac{A\uparrow\quad B\uparrow}
  {A\wedge B\uparrow}
  \wedge I
  & &
  \dfrac{\Gamma\Longrightarrow A \quad \Gamma\Longrightarrow B}
  {\Gamma\Longrightarrow A\wedge B}
  \wedge R
  \\
  &&\\
  \dfrac{A\wedge B\downarrow}
  {A\downarrow}
  \wedge E_L 
  & &
  \dfrac{\Gamma,A\wedge B,A\Longrightarrow C}
  {\Gamma,A\wedge B\Longrightarrow C}
  \wedge L_1  
  \\
  &&\\
  \dfrac{A\wedge B\downarrow}
  {B\downarrow}
  \wedge E_R
  & &
  \dfrac{\Gamma,A\wedge B,B\Longrightarrow C}
  {\Gamma,A\wedge B\Longrightarrow C}
  \wedge L_2
  \\
  &&\\
  \dfrac{}
  {\top\uparrow}
  \top I  
  & &
  \dfrac{}
  {\Gamma\Longrightarrow\top}
  \top R 
  \\
  &&\\
  \dfrac{
      \begin{align*}
        \dfrac{}
          {A\downarrow}
          u \\
        &\vdots \\
        B\uparrow
      \end{align*}
    }
    {A\supset B\uparrow}
    \supset I^{u} 
  && 
  \dfrac{\Gamma,A\Longrightarrow B}
    {\Gamma\Longrightarrow A\supset B}
    \supset R
  \\
  &&\\
  \dfrac{A\supset B\downarrow\quad A\uparrow}
  {B\downarrow}
  \supset E
  &&
  \dfrac{
    \Gamma,A\supset B\Longrightarrow A \quad
    \Gamma,A\supset B,B\Longrightarrow C
  }
  {\Gamma,A\supset B\Longrightarrow C}
  \supset L
  \\
  &&\\
  \dfrac{A\uparrow}
  {A\vee B\uparrow}
  \vee I_L
  & &
  \dfrac{\Gamma\Longrightarrow A}
  {\Gamma\Longrightarrow A\vee B}
  \vee R_1
  \\
  &&\\
  \dfrac{B\uparrow}
  {A\vee B\uparrow}
  \vee I_R
  & &
  \dfrac{\Gamma\Longrightarrow B}
  {\Gamma\Longrightarrow A\vee B}
  \vee R_2
  \\
  &&\\
  \dfrac{
      A\vee B\downarrow
      \quad
      \begin{array}{c}
        \dfrac{}
          {A\downarrow}
          u \\
        &\vdots \\
        C\uparrow
      \end{array} 
      \quad
      \begin{align*}
        \dfrac{}
          {B\downarrow}
          \omega \\
        &\vdots \\
        C\uparrow
      \end{align*} 
    }
    {C\uparrow}
    \vee E^{u,\omega}
  & &
  \dfrac{
    \Gamma,A\vee B,A\Longrightarrow C \quad
    \Gamma,A\vee B,B\Longrightarrow C
  }
  {\Gamma,A\vee B\Longrightarrow C}
  \vee L
  \\
  &&\\
  \dfrac{\bot\downarrow}
  {C\uparrow}
  \bot E
  & &
  \dfrac{}
  {\Gamma,\bot\Longrightarrow C}
  \bot L
  \\
  &&\\
  \dfrac{P\downarrow}
  {P\uparrow}
  \downarrow\uparrow
  & &
  \dfrac{}
  {\Gamma,P\Longrightarrow P}
  init
  \\
\end{array}
$$

Same as introduction and elimination rules, connectives are properly defined only if their left and right rules are in hormony. To show this, we introduce two theorems.

**Identity Theorem**: For any proposition $A$, we have $A\Longrightarrow A$. This is the global version of the **local completeness** property for each individual connective. This can be explained as:

- If we assume $A~left$ we can prove $A~right$
- The left rules of the sequent calculus are strong enough so that we can reconstitute a proof of $A$ from the assumption A

**Proof:** By induction on the structure of $A$.
- Case: $A=P$. Then
$$
\dfrac{}
{P\Longrightarrow P}
\mathsf{init}
$$
- Case: $A = A_1 \wedge A_2$. By i.h. on $A_1$ and weakening, we have $A_1\wedge A_2,A_1\Longrightarrow A_1$. By i.h. on $A_2$ and weakening, we have $A_1\wedge A_2,A_2\Longrightarrow A_2$. Then
$$
\dfrac{
  \dfrac{A_1\wedge A_2,A_1\Longrightarrow A_1}
  {A_1\wedge A_2\Longrightarrow A_1}
  \wedge L_1
  \quad
  \dfrac{A_1\wedge A_2,A_2\Longrightarrow A_2}
  {A_1\wedge A_2\Longrightarrow A_2}
  \wedge L_2
}
{A_1\wedge A_2\Longrightarrow A_1\wedge A_2}
\wedge R
$$
- Case: $A=A_1\supset A_2$. By i.h. on $A_1$ and weakening, we have $A_1\supset A_2,A_1\supset A_2,A_1\Longrightarrow A_1$. By i.h. on $A_2$ and weakening, we have $A_1\supset A_2,A_1\supset A_2,A_1,A_2\Longrightarrow A_2$. Then
$$
\dfrac{
  \dfrac{
    A_1\supset A_2,A_1\supset A_2,A_1\Longrightarrow A_1
    \quad 
    A_1\supset A_2,A_1\supset A_2,A_1,A_2\Longrightarrow A_2}
  {A_1\supset A_2,A_1\supset A_2,A_1\Longrightarrow A_2}
  \supset L
}
{A_1\supset A_2 \Longrightarrow A_1\supset A_2}
\supset R
$$
- Case: $A=A_1\vee A_2$. By i.h. on $A_1$ and weakening, we have $A_1\vee A_2,A_1\Longrightarrow A_1$. By i.h. on $A_2$ and weakening, we have $A_1\vee A_2,A_2\Longrightarrow A_2$. Then 
$$
\dfrac{
  \dfrac{A_1\vee A_2,A_1 \Longrightarrow A_1}
  {A_1\vee A_2,A_1 \Longrightarrow A_1\vee A_2}
  \vee R_L
  \quad
  \dfrac{A_1\vee A_2,A_2 \Longrightarrow A_2}
  {A_1\vee A_2,A_2 \Longrightarrow A_1\vee A_2}
  \vee R_L 
}
{A_1\vee A_2 \Longrightarrow A_1\vee A_2}
\vee L
$$

**Cut theorem**: If $\Gamma\Longrightarrow A~right$ and $\Gamma,A~left\Longrightarrow C$ then $\Gamma\Longrightarrow C$. This can be explained as:

- If we have a proof of $A~right$, we are licensed to assume $A~left$. 
- the left rules are not too strong

**Proof:** By induction on the structure of $A$, the derivation $\mathcal{D}$ of $\Gamma\Longrightarrow A$ and $\mathcal{E}$ of $\Gamma,A\Longrightarrow C$.

$$
\begin{array}{c}\mathcal{D}\\\Gamma\Longrightarrow A\end{array}\quad\text{and}\quad\begin{array}{c}\mathcal{E}\\\Gamma,A\Longrightarrow C\end{array}\quad\text{of}\quad\begin{array}{c}\mathcal{F}\\\Gamma\Longrightarrow C\end{array}
$$

- Case 1: $\mathcal{D}$ is init rule. Then $\Gamma=\Gamma',A$. So we have $\Gamma',A\Longrightarrow A$ and $\Gamma',A,A\Longrightarrow C$. By contraction theorem, we have $\Gamma',A\Longrightarrow C$.
- Case 2: $\mathcal{E}$ is the init rule using cut formula. 
- Case 3: $\mathcal{E}$ is the init rule not using cut formula. Then 
  - $\mathcal{E}=\dfrac{}{\Gamma',P,A\Longrightarrow P}init$
  - $\Gamma=\Gamma',P$
  - $C=P$
  By rule init and weaking, we have $\Gamma',P\Longrightarrow P$, so $\Gamma\Longrightarrow C$
- Case 4: $A$ is the principle formula of the last inference in both $\mathcal{D}$ and $\mathcal{E}$.
  - Case 4.1 $A = A_1\wedge A_2$
  $$
  \mathcal{D}=
  \dfrac{
    \begin{array}{c}
      \mathcal{D_1} \\
      \Gamma\Longrightarrow A_1
    \end{array}
    \quad
    \begin{array}{c}
      \mathcal{D_2} \\
      \Gamma\Longrightarrow A_2
    \end{array}
  }
  {\Gamma\Longrightarrow A_1\wedge A_2}
  \wedge R
  $$
  $$
  \mathcal{E}=
  \dfrac{
    \begin{array}{c}
      \mathcal{E_1} \\
      \Gamma,A_1\wedge A_2,A_1\Longrightarrow C
    \end{array}
  }
  {\Gamma,A_1\wedge A_2\Longrightarrow C}
  \wedge L_1
  $$
  By weakening on $\mathcal{D}$ (adding $A_1$ to the context) and induction on $\mathcal{D}$ and $\mathcal{E_1}$, $\Gamma,A_1\Longrightarrow C$. By induction on $\Gamma,A_1\Longrightarrow C$ and $\mathcal{D_1}$, we have $\Gamma\Longrightarrow C$.
  - Case 4.2 ...
- Case 5: $A$ is not the principle formula of the last inference in $\mathcal{D}$. In this case $\mathcal{D}$ must end in a left rule, for which we can analyze case by case.
  - Case 5.1 $\wedge L_1$
  $$
  \mathcal{D}=
  \dfrac{
    \begin{array}{c}
      \mathcal{D_1} \\
      \Gamma',A_1\wedge A_2,A_1\Longrightarrow A
    \end{array}
  }
  {\Gamma',A_1\wedge A_2\Longrightarrow A}
  \wedge L_1
  $$
  Then we have:
    - $\Gamma=\Gamma',A_1\wedge A_2$
    - $\Gamma',A_1\wedge A_2,A\Longrightarrow C$
    - By weakening, $\Gamma',A_1\wedge A_2,A_1,A\Longrightarrow C$
    - By induction on $\mathcal{D_1}$, $\mathcal{E}$ and the above line, $\Gamma',A_1\wedge A_2,A_1\Longrightarrow C$
    - By rule $\wedge L_1$, we have $\Gamma',A_1\wedge A_2\Longrightarrow C$, thus $\Gamma\Longrightarrow C$
  - Case 5.2 ...
- Case 6: $A$ is not the principle formula of the last inference in $\mathcal{E}$.
  - Case 6.1 $\wedge R$
  $$
  \mathcal{E}=
  \dfrac{
    \begin{array}{c}
      \mathcal{E_1} \\
      \Gamma,A\Longrightarrow C_1
    \end{array}
    \quad
    \begin{array}{c}
      \mathcal{E_2} \\
      \Gamma,A\Longrightarrow C_2
    \end{array}
  }
  {\Gamma,A\Longrightarrow C_1\wedge C_2}
  \wedge R
  $$
    - By induction on $\mathcal{D}$ and $\mathcal{E_1}$, By induction on $\mathcal{D}$ and $\mathcal{E_1}$, we have $\Gamma\Longrightarrow C_1$
    - By induction on $\mathcal{D}$ and $\mathcal{E_2}$, By induction on $\mathcal{D}$ and $\mathcal{E_1}$, we have $\Gamma\Longrightarrow C_2$
    - By rule $\wedge R$ on above two, we have $\Gamma\Longrightarrow C_1\wedge C_2$, thus $\Gamma\Longrightarrow C$
  - Case 6.2 ...

## Reference

- [Human-Centered Automated Proof Search](http://gauss.cs.iit.edu/~fderakhshan/files/JAR.pdf)
