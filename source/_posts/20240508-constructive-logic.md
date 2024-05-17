---
title: Note for Constructive Logic
date: 2024-05-08 12:05:54
tags: 
  - Logic
  - Programming Language
---

This is a note for my learning of [Constructive Logic](https://www.cs.cmu.edu/~fp/courses/15317-f09/schedule.html) by **Frank Pfenning**. Logic is the study of the principles of valid inferences and demonstration,  which constitutes an important area in the disciplines of philosophy and mathematics.

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
    \begin{array}{c}
      \mathcal{D} \\
      A\,true
    \end{array}
    }
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
\scriptsize
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

## 6 Local Completeness/Soundness - Global Version

Same as introduction and elimination rules, connectives are properly defined only if their left and right rules are in hormony. To show this, we introduce two theorems.

**Identity Theorem**: For any proposition $A$, we have $A\Longrightarrow A$. This is the **global version** of the **local completeness** property for each individual connective. This can be explained as:

- If we assume $A~left$ we can prove $A~right$
- The left rules of the sequent calculus are strong enough so that we can reconstitute a proof of $A$ from the assumption A

**Proof:** By induction on the structure of $A$.
- Case: $A$ is an atomic proposition. $A=P$. Then
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
- Case: $A=A_1\supset A_2$. By i.h. on $A_1$ and weakening, we have $A_1\supset A_2,A_1\Longrightarrow A_1$. By i.h. on $A_2$ and weakening, we have $A_1\supset A_2,A_1,A_2\Longrightarrow A_2$. Then
$$
\dfrac{
  \dfrac{
    A_1\supset A_2,A_1\Longrightarrow A_1
    \quad 
    A_1\supset A_2,A_1,A_2\Longrightarrow A_2}
  {A_1\supset A_2,A_1\Longrightarrow A_2}
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

**Cut theorem**: If $\Gamma\Longrightarrow A~right$ and $\Gamma,A~left\Longrightarrow C$ then $\Gamma\Longrightarrow C$. This is the **global version** of **local soundness**, which can be explained as:

- If we have a proof of $A~right$, we are licensed to assume $A~left$. 
- the left rules are not too strong

**Proof:** By induction on the structure of cut formula $A$, the derivation $\mathcal{D}$ of $\Gamma\Longrightarrow A$ and $\mathcal{E}$ of $\Gamma,A\Longrightarrow C$. We show how to transform

$$
\begin{array}{c}\mathcal{D}\\\Gamma\Longrightarrow A\end{array}\quad\text{and}\quad\begin{array}{c}\mathcal{E}\\\Gamma,A\Longrightarrow C\end{array}\quad\text{to}\quad\begin{array}{c}\mathcal{F}\\\Gamma\Longrightarrow C\end{array}
$$

in this constructive proof.

We build the proof by the combination of the last inference rule that is applied in $\mathcal{D}$ and $\mathcal{E}$. To simplify the cases we need to consider, we classify the cases as follows:

- The last inference rule is initial sequent in $\mathcal{D}$ or $\mathcal{E}$
  - Case 1: the last inference rule in $\mathcal{D}$ is initial sequent
  - Case 2: the last inference rule in $\mathcal{E}$ is initial sequent using cut formula $A$
  - Case 3: the last inference rule in $\mathcal{E}$ is initial sequent not using cut formula $A$
- The last inference rule is not initial sequent in $\mathcal{D}$ and $\mathcal{E}$
  - Case 4: $A$ is the principle formula of the last inference rule (which is not initial sequent) in both $\mathcal{D}$ and $\mathcal{E}$
  - Case 5: $A$ is not the principle formula of the last inference rule (which is not initial sequent) in $\mathcal{D}$ 
  - Case 6: $A$ is not the principle formula of the last inference rule (which is not initial sequent) in $\mathcal{E}$ 

The proof for the six cases are as follows.

- Case 1: $\mathcal{D}$ is an initial sequent like
$$
\dfrac{}
{\Gamma',P\Longrightarrow P}
init
$$
  Then $\Gamma=\Gamma',P$. We have $\Gamma',P,P\Longrightarrow C$ by $\mathcal{E}$. By contraction theorem, we have $\Gamma',P\Longrightarrow C$, which shows $\Gamma\Longrightarrow C$.
- Case 2: $\mathcal{E}$ is an initial sequent using cut formula 
  $$
    \begin{array}{c}
      \mathcal{D} \\
      \Gamma\Longrightarrow P
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{}
    {\Gamma,P\Longrightarrow P}
    init
  $$
  We have $C=P$, which shows $\Gamma\Longrightarrow C$.
- Case 3: $\mathcal{E}$ is an initial sequent not using cut formula. Then 
  $$
  \mathcal{E}=\dfrac{}{\Gamma',P,A\Longrightarrow P}init
  $$
  So $\Gamma=\Gamma',P$ and $C=P$. By rule init and weaking, we have $\Gamma',P\Longrightarrow P$, so $\Gamma\Longrightarrow C$
- Case 4: $A$ is the principle formula of the last inference in both $\mathcal{D}$ and $\mathcal{E}$. There are no cases for $\top$ and $\bot$ as they only have left or right rule, not both.
    - Case 4.1 $A = A_1\wedge A_2$
    $$
    \scriptsize
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
    ,\quad
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
    By weakening on $\mathcal{D}$ (adding $A_1$ to the context), we get a structurally identical deduction $\mathcal{D'}$ as $\scriptsize
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1} \\
        \Gamma,A_1\Longrightarrow A_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{D_2} \\
        \Gamma,A_1\Longrightarrow A_2
      \end{array}
    }
    {\Gamma,A_1\Longrightarrow A_1\wedge A_2}
    \wedge R$. 
    $$
    \color{red}{\text{There are many other cases need weakening like this.}}
    \\
    \color{red}{\text{We will skip weakening in some cases and use i.h. directly.}}
    $$
    
    Consider the following induction hypothesis. 
    $$
    \begin{array}{ccc}
      i.h. & on & result \\
      1
      &
      A_1\wedge A_2,\,\mathcal{D'},\,\mathcal{E_1}
      &
      \Gamma,A_1\Longrightarrow C
      \\
      2
      &
      A_1,\,D_1~and~\Gamma,A_1\Longrightarrow C
      &
      \Gamma\Longrightarrow C
      \\
    \end{array}
    $$
    - Case 4.2 $A=A_1\supset A_2$
    $$
    \scriptsize
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1} \\
        \Gamma,A_1\Longrightarrow A_2
      \end{array}
    }
    {\Gamma\Longrightarrow A_1\supset A_2}
    \supset R
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma,A_1\supset A_2\Longrightarrow A_1
      \end{array}
      \quad
      \begin{array}{c}
      \mathcal{E_2} \\
      \Gamma,A_1\supset A_2,A_2\Longrightarrow C
      \end{array}
    }
    {\Gamma,A_1\supset A_2\Longrightarrow C}
    \supset L
    $$
    Consider the following induction hypothesis. 
    $$
    \begin{array}{ccc}
      i.h. & on & result \\
      1
      &
      A_1\supset A_2,\,\mathcal{D},\,\mathcal{E_2}
      &
      \Gamma,A_2\Longrightarrow C
      \\
      2
      &
      A_1\supset A_2,\,\mathcal{D},\mathcal{E_1}
      &
      \Gamma\Longrightarrow A_1
      \\
      3
      &
      A_1~and~\Gamma\Longrightarrow A_1~and~\mathcal{D_1}
      &
      \Gamma\Longrightarrow A_2
      \\
      4
      &
      A_2~and~\Gamma\Longrightarrow A_2~and~\Gamma,A_2\Longrightarrow C
      &
      \Gamma\Longrightarrow C
      \\
    \end{array}
    $$
    - Case 4.3 $A=A_1\vee A_2$
    $$
    \scriptsize
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1} \\
        \Gamma\Longrightarrow A_1
      \end{array}
    }
    {\Gamma\Longrightarrow A_1\vee A_2}
    \vee R_1
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma,A_1\vee A_2,A_1\Longrightarrow C
      \end{array}
      \quad
      \begin{array}{c}
      \mathcal{E_2} \\
      \Gamma,A_1\vee A_2,A_2\Longrightarrow C
      \end{array}
    }
    {\Gamma,A_1\vee A_2\Longrightarrow C}
    \vee L
    $$
    Consider the following induction hypothesis. 
    $$
    \begin{array}{ccc}
      i.h. & on & result \\
      1
      &
      A_1\vee A_2,\,\mathcal{D},\,\mathcal{E_1}
      &
      \Gamma,A_1\Longrightarrow C
      \\
      2
      &
      A_1,\mathcal{D_1}~and~\Gamma,A_1\Longrightarrow C
      &
      \Gamma\Longrightarrow C
      \\
    \end{array}
    $$
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
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\\Gamma',A_1\wedge A_2,A\Longrightarrow C
    \end{array}
    $$
    Then we have:
      - $\Gamma=\Gamma',A_1\wedge A_2$
      - By weakening on $\mathcal{E}$, $\scriptsize\begin{array}{c}\mathcal{E'}\\\Gamma',A_1\wedge A_2,A_1,A\Longrightarrow C\end{array}$
      - By i.h. on $A_1\wedge A_2$, $\mathcal{D_1}$, $\mathcal{E'}$, then we have $\Gamma',A_1\wedge A_2,A_1\Longrightarrow C$
      - By rule $\wedge L_1$, we have $\Gamma',A_1\wedge A_2\Longrightarrow C$, thus $\Gamma\Longrightarrow C$
    - Case 5.2 $\wedge L_2$, the proof is symmetric to 5.1
    - Case 5.3 $\supset L$
    $$
    \scriptsize
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1} \\
        \Gamma',A_1\supset A_2\Longrightarrow A_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{D_2} \\
        \Gamma',A_1\supset A_2,A_2\Longrightarrow A
      \end{array}
    }
    {\Gamma',A_1\supset A_2\Longrightarrow A}
    \supset L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\\Gamma',A_1\supset A_2,A\Longrightarrow C
    \end{array}
    $$
    Then we have:
      - $\Gamma=\Gamma',A_1\supset A_2$
      - By i.h. on $A_1\supset A_2$ and $\mathcal{D_2}$ and $\mathcal{E}$, we get $\Gamma',A_1\supset A_2,A_2\Longrightarrow C$
      - By $\supset L$ on $\mathcal{D_1}$ and the above result, we get $\Gamma',A_1\supset A_2\Longrightarrow C$, which shows that $\Gamma\Longrightarrow C$
    - Case 5.4 $\vee L$
    $$
    \scriptsize
    \mathcal{D}=
    \dfrac{
      \begin{array}{c}
        \mathcal{D_1} \\
        \Gamma',A_1\vee A_2,A_1\Longrightarrow A
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{D_2} \\
        \Gamma',A_1\vee A_2,A_2\Longrightarrow A
      \end{array}
    }
    {\Gamma',A_1\vee A_2\Longrightarrow A}
    \vee L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\\Gamma',A_1\vee A_2,A\Longrightarrow C
    \end{array}
    $$
    Then we have:
      - $\Gamma=\Gamma',A_1\vee A_2$
      - By i.h. on $A_1\vee A_2$, $\mathcal{D_1}$ and $\mathcal{E}$, we have $\Gamma',A_1\vee A_2,A_1\Longrightarrow C$
      - By i.h. on $A_1\vee A_2$, $\mathcal{D_2}$ and $\mathcal{E}$, we have $\Gamma',A_1\vee A_2,A_2\Longrightarrow C$
      - By $\vee L$ on the above two results, we have $\Gamma',A_1\vee A_2\Longrightarrow C$, which shows that $\Gamma\Longrightarrow C$
    - Case 5.5 $\bot L$
    $$
    \mathcal{D}=
    \dfrac{}
    {\Gamma',\bot\Longrightarrow A}
    \bot L
    ,\quad
    \begin{array}{c}
      \mathcal{E}\\
      \Gamma',\bot,A\Longrightarrow C
    \end{array}
    $$
    Then $\Gamma = \Gamma',\bot$. Apply $\bot L$, we have $\Gamma',\bot\Longrightarrow C$, which show $\Gamma\Longrightarrow C$
- Case 6: $A$ is not the principle formula of the last inference in $\mathcal{E}$. In this case, $\mathcal{E}$ must end in a left or right rule that not gets $A$ involved. We can analyse this case by case.
    - Case 6.1 $\wedge R$
    $$
    \begin{array}{c}
      \mathcal{D} \\
      \Gamma\Longrightarrow A
    \end{array}
    ,\quad
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
      - $C=C_1\wedge C_2$
      - By i.h. on $A$, $\mathcal{D}$ and $\mathcal{E_1}$, we have $\Gamma\Longrightarrow C_1$
      - By i.h. on $A$, $\mathcal{D}$ and $\mathcal{E_2}$, we have $\Gamma\Longrightarrow C_2$
      - By rule $\wedge R$ on above two, we have $\Gamma\Longrightarrow C_1\wedge C_2$, thus $\Gamma\Longrightarrow C$
    - Case 6.2 $\supset R$
    $$
    \begin{array}{c}
      \mathcal{D} \\
      \Gamma\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma,A,C_1\Longrightarrow C_2
      \end{array}
    }
    {\Gamma,A\Longrightarrow C_1\supset C_2}
    \supset R_1
    $$
      - $C=C_1\supset C_2$
      - By i.h. on $A$, $\mathcal{D}$ and $\mathcal{E_1}$, we have $\Gamma,C_1\Longrightarrow C_2$.
      - Apply $\supset R$ with the above result, we have $\Gamma\Longrightarrow C_1\supset C_2$
    - Case 6.3 $\vee R_1$
    $$
    \begin{array}{c}
      \mathcal{D} \\
      \Gamma\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma,A\Longrightarrow C_1
      \end{array}
    }
    {\Gamma,A\Longrightarrow C_1\vee C_2}
    \vee R_1
    $$
      - $C=C_1\vee C_2$
      - By i.h. on $A$, $\mathcal{D}$ and $\mathcal{E_1}$, we have $\Gamma\Longrightarrow C_1$.
      - Apply $\vee R_1$ with the above result, we have $\Gamma\Longrightarrow C_1\vee C_2$
    - Case 6.4 $\vee R_2$. The proof is symmetric to 6.3
    - Case 6.5 $\top R$
    $$
   \begin{array}{c}
      \mathcal{D}\\
      \Gamma\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{}
    {\Gamma,A\Longrightarrow \top}
    \top R
    $$
    Then $C = \top$. Apply $\top R$, we have $\Gamma\Longrightarrow \top$, which show $\Gamma\Longrightarrow C$
    - Case 6.6 $\wedge L_1$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Gamma',A_1\wedge A_2\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma',A_1\wedge A_2,A_1,A\Longrightarrow C
      \end{array}
    }
    {\Gamma',A_1\wedge A_2,A\Longrightarrow C}
    \wedge L_1
    $$
    Then we have:
      - $\Gamma=\Gamma',A_1\wedge A_2$
      - By i.h. on $A$, $\mathcal{D}$, $\mathcal{E_1}$, we have $\Gamma',A_1\wedge A_2,A_1\Longrightarrow C$
      - Apply $\wedge L_1$ with the above result, we get $\Gamma',A_1\wedge A_2\Longrightarrow C$, which shows $\Gamma\Longrightarrow C$
    - Case 6.7 $\wedge L_2$, the proof is symmetric to 6.6 
    - Case 6.8 $\supset L$
    $$
    \scriptsize
    \begin{array}{c}
      \mathcal{D} \\
      \Gamma',A_1\supset A_2\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma',A_1\supset A_2,A\Longrightarrow A_1
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{E_2} \\
        \Gamma',A_1\supset A_2,A,A_1\Longrightarrow C
      \end{array}
    }
    {\Gamma',A_1\supset A_2,A\Longrightarrow C}
    \supset L
    $$
      - $\Gamma=\Gamma',A_1\supset A_2$
      - By i.h. on $A$, $\mathcal{D}$, $\mathcal{E_1}$, we have $\Gamma',A_1\supset A_2\Longrightarrow A_1$
      - By i.h. on $A$, $\mathcal{D}$, $\mathcal{E_2}$, we have $\Gamma',A_1\supset A_2, A_1\Longrightarrow C$
      - Apply $\supset L$ with the above two results, we get $\Gamma',A_1\supset A_2\Longrightarrow C$, which shows $\Gamma\Longrightarrow C$
    - Case 6.9 $\vee L$
    $${
    \scriptsize
    \begin{array}{c}
      \mathcal{D} \\
      \Gamma',A_1\vee A_2\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{
      \begin{array}{c}
        \mathcal{E_1} \\
        \Gamma',A_1\vee A_2,A_1,A\Longrightarrow C
      \end{array}
      \quad
      \begin{array}{c}
        \mathcal{E_2} \\
        \Gamma',A_1\vee A_2,A_2,A\Longrightarrow C
      \end{array}
    }
    {\Gamma',A_1\vee A_2,A\Longrightarrow C}
    \vee L
    }$$
      - $\Gamma=\Gamma',A_1\vee A_2$
      - By i.h. on $A$, $\mathcal{D}$, $\mathcal{E_1}$, we have $\Gamma',A_1\vee A_2,A_1\Longrightarrow C$
      - By i.h. on $A$, $\mathcal{D}$, $\mathcal{E_2}$, we have $\Gamma',A_1\vee A_2, A_2\Longrightarrow C$
      - Apply $\vee L$ with the above two results, we get $\Gamma',A_1\vee A_2\Longrightarrow C$, which shows $\Gamma\Longrightarrow C$
    - Case 6.10 $\bot L$
    $$
    \begin{array}{c}
      \mathcal{D}\\
      \Gamma',\bot\Longrightarrow A
    \end{array}
    ,\quad
    \mathcal{E}=
    \dfrac{}
    {\Gamma',\bot,A\Longrightarrow C}
    \bot L
    $$
    Then $\Gamma = \Gamma',\bot$. Apply $\bot L$, we have $\Gamma',\bot\Longrightarrow C$, which show $\Gamma\Longrightarrow C$

## 7 Cut Elimination

The cut elimination is the theorem connecting **cut-free sequent calculus** and **sequent calculus with cut**. The cut elimination theorem states that if $\mathcal{D}$ is a deduction of $\Gamma\Longrightarrow C$ possibily using the cut rule, then there exists a cut-free deduction $\mathcal{D'}$ of $\Gamma\Longrightarrow C$. That is

$$
\text{if }
\begin{array}{c}
  \mathcal{D}\\
  \Gamma\Longrightarrow A
\end{array}
\text{ then }
\begin{array}{c}
  \mathcal{D'}\\
  \Gamma\Longrightarrow A
\end{array}
$$

In the following constructive proof building $\mathcal{D'}$,
$$
\color{red}{\text{we cannot use $cut$ rule as we are in the cut-free setting.}}
\\
\color{red}{\text{But we can apply cut threom that we have built above.}}
$$

**Proof:** by induction on the structure of $\mathcal{D}$.

- Case $init$
  $$
  \dfrac{}
  {\Gamma',A\Longrightarrow A}
  init
  $$
  let $\mathcal{D'} = \mathcal{D}$.
- Case $\top R$, Case $\bot L$ are same to the above case.
- Case $\wedge L_1$
  $$
  \mathcal{D}=
  \dfrac{
    \begin{array}{c}
      \mathcal{D_1}\\
      \Gamma',B_1\wedge B_2,B_1\Longrightarrow A
    \end{array}
  }
  {\Gamma',B_1\wedge B_2\Longrightarrow A}
  \wedge L_1
  $$
  By i.h. on $\mathcal{D_1}$, there is a cut-free deduction $\mathcal{D_1'}$ of $\Gamma',B_1\wedge B_2,B_1\Longrightarrow A$. Apply $\wedge L$ to the result, we build the deduction $\mathcal{D'}$ of $\Gamma\Longrightarrow A$.
- Case $\wedge R$
  $$
  \mathcal{D}=
  \dfrac{
    \begin{array}{c}
      \mathcal{D_1}\\
      \Gamma\Longrightarrow A_1
    \end{array}
    \quad
    \begin{array}{c}
      \mathcal{D_2}\\
      \Gamma\Longrightarrow A_2
    \end{array}
  }
  {\Gamma\Longrightarrow A_1\wedge A_2}
  \wedge R
  $$
  By i.h. on $\mathcal{D_1}$, there is a cut-free deduction $\mathcal{D_1'}$ of $\Gamma\Longrightarrow A_1$. 
  By i.h. on $\mathcal{D_2}$, there is a cut-free deduction $\mathcal{D_2'}$ of $\Gamma\Longrightarrow A_2$.
  Apply $\wedge R$ to the above results, we build the deduction $\mathcal{D'}$ of $\Gamma\Longrightarrow A$.
- Case $\supset L$, Case $\supset R$, Case $\vee R_1$, Case $\vee R_2$, Case $\vee L$ are similar to the above two cases
- Case $cut$
  $$
  \mathcal{D}=
  \dfrac{
    \begin{array}{c}
      \mathcal{D_1}\\
      \Gamma\Longrightarrow B
    \end{array}
    \quad
    \begin{array}{c}
      \mathcal{D_2}\\
      \Gamma,B\Longrightarrow A
    \end{array}
  }
  {\Gamma\Longrightarrow A}
  cut
  $$
  By i.h. on $\mathcal{D_1}$, there is a cut-free deduction $\mathcal{D_1'}$ of $\Gamma\Longrightarrow B$.
  By i.h. on $\mathcal{D_2}$, there is a cut-free deduction $\mathcal{D_2'}$ of $\Gamma,B\Longrightarrow A$.
  Apply $cut$ theorem with the above results, we build the deduction $\mathcal{D'}$ of $\Gamma\Longrightarrow A$

## Reference

- [Frank Pfenning - Constructive Logic](https://www.cs.cmu.edu/~fp/courses/15317-f09/schedule.html)
- [Human-Centered Automated Proof Search](http://gauss.cs.iit.edu/~fderakhshan/files/JAR.pdf)
