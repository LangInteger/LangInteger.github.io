---
title: Proof of Type Soundness Using Logical Relation
date: 2024-06-05 20:22:15
tags: 
  - Programming Language
  - Type Theory
  - Logical Relation
---

This blog compares proving type soundness using traditional progress/preservation methods and logical relations[^1]. Credits go to the original author of these ideas.

<!--more-->

## 1 The Language

### 1.1 Basic

$$
\begin{align*}
  & \tau::=bool\,|\,\tau_1\rightarrow\tau_2 \\
  & V::=true\,|\,false\,|\,\lambda x:\tau.e \\
  & e::=x\,|\,true\,|\,false\,|\,\lambda x:\tau.e\,|\,e_1\,e_2\,|\,\text{if }e\text{ then }e\text{ else }e\\
  & E::=[\cdot]\,|\,E\,e\,|\,\mathcal{V}\,E\,|\,\text{if }E\text{ then }e_1\text{ else }e_2\\
\end{align*}
$$

### 1.2 Operational Semantics

The operational semantics here are simplified by evaluation context.

$$
\begin{align*}
    \dfrac{}
    {\text{if true then }e_1\text{ else }e_2\mapsto\,e_1}
    \text{S-IF}_1
  \quad
    \dfrac{}
    {\text{if false then }e_1\text{ else }e_2\mapsto\,e_2}
    \text{S-IF}_2
\end{align*}
$$
$$
\begin{align*}
    \dfrac{}
    {(\lambda x:\tau.e)\,v\mapsto e[v/x]}
    \text{S-APP}
  \quad
    \dfrac{e\mapsto e'}
    {E[e]\mapsto E[e']}
    \text{S-STEP}
\end{align*}
$$

If there is no evaluation context, there will be rules like:

$$
\begin{align*}
  \dfrac{e\mapsto e'}
  {
    \text{if }e\text{ then }e_1\text{ else }e_2\mapsto\,
    \text{if }e'\text{ then }e_1\text{ else }e_2
  }
  \text{S-IF}
\end{align*}
$$
$$
\begin{align*}
  \dfrac{e_1\mapsto e_1'}
  {e_1\,e_2\mapsto e_1'\,e_2}
  \text{S-APP}_1
  \quad
  \dfrac{e_1\,val\quad e_2\mapsto e_2'}
  {e_1\,e_2\mapsto e_1\,e_2'}
  \text{S-APP}_2
\end{align*}
$$

Instead, we have rules to fill the "hole" with evaluation context:

$$
\begin{align*}
  [\cdot][e'] &= e' \\
  (E\,e)[e'] &= E[e']\,e \\
  (\mathcal{V}\,E)[e'] &= \mathcal{V}\,E[e'] \\
  (\text{if }E\text{ then }e_1\text{ else }e_2)[e'] &= \text{if }E(e')\text{ then }e_1\text{ else }e_2
\end{align*}
$$

### 1.3 Typing Rules

$$
\begin{align*}
\dfrac{\Gamma(x)=A}
{\Gamma\vdash x:A}
\text{Var}
\end{align*}
$$
$$
\begin{align*}
    \dfrac{\Gamma,x:A\vdash e:B}
    {\Gamma\vdash \lambda x:A.e:A\rightarrow B}
    \rightarrow\text{I}
  \quad
    \dfrac{\Gamma\vdash e_1:A\rightarrow B\quad\Gamma\vdash e_2:A}
    {\Gamma\vdash e_1\,e_2:B}
    \rightarrow\text{E}
\end{align*}
$$
$$
\begin{align*}
    \dfrac{}
    {\Gamma\vdash true:bool}
    \text{bool I}_1
  \quad
    \dfrac{}
    {\Gamma\vdash false:bool}
    \text{bool I}_2
\end{align*}
$$
$$
\begin{align*}
  \dfrac{\Gamma\vdash e_1:bool\quad\Gamma\vdash e_2:A\quad\Gamma\vdash e_3:A}
  {
    \Gamma\vdash\text{if }e_1\text{ then }e_2\text{ else }e_3:A
  }
  \text{bool E}
\end{align*}
$$

For evaluation contexts, there are additional typing rules:

$$
\dfrac{}
{[\cdot]:A\leadsto A}
\text{ECT-1}
\quad
\dfrac{
  E:A\leadsto bool\quad
  e_1:B \quad e_2:B
}
{\text{if }E\text{ then }e_1\text{ else }e_2:A\leadsto B}
\text{ECT-4}
$$
$$
\dfrac{E:A\leadsto B\rightarrow C\quad e:B}
{E\,e:A\leadsto B}
\text{ECT-2}
\quad
\dfrac{\mathcal{V}:B\rightarrow C\quad E:A\leadsto B}
{\mathcal{V}\,E:A\leadsto C}
\text{ECT-3}
$$

### 1.4 Logical Relations

$$
\begin{align*}
  \mathcal{V}\lbrack\lbrack\text{bool}\rbrack\rbrack
  & \triangleq 
  & \{\text{true, false}\} \\
  \mathcal{V}\lbrack\lbrack\tau_1\rightarrow\tau_2\rbrack\rbrack
  & \triangleq 
  & \{\lambda x:\tau_1:e\,|\,\forall v\in
        \mathcal{V}_1\lbrack\lbrack\tau\rbrack\rbrack. e[v/x]
        \in\mathcal{E}\lbrack\lbrack\tau_2\rbrack\rbrack \} \\
  \mathcal{E}\lbrack\lbrack\tau\rbrack\rbrack
  & \triangleq 
  & \{
      e\,|\,
      \forall e'.e\mapsto^*e'\wedge\text{irred}(e')
          \Rightarrow e'\in\mathcal{V}\lbrack\lbrack\tau\rbrack\rbrack
    \} \\
\end{align*}
$$

where

$$
\begin{align*}
  \text{irred}(e)\triangleq \nexists e'.e\mapsto e'
\end{align*}
$$
## 2 Type Safety
### 2.1 Definition
A well-typed, closed term $e$ never gets stuck, aka safe, which can be formalize as:

$$
\text{safe}(e)\triangleq\forall e'.e\rightarrow^*e'\Rightarrow val(e')\vee(\exists e''.e'\rightarrow e'')
$$
### 2.2 Proof
<div style="position:relative;">
<div style="overflow:auto;">
<table style="position: sticky;width:1600px;overflow: auto;display:block;">
    <colgroup>
       <col span="1" style="width: 100px;">
       <col span="1" style="width: 500px;">
       <col span="1" style="width: 500px;">
    </colgroup>
<tr>
<th>  </th>
<th> Progress + Preservation </th>
<th> Semantical Type Soundness </th>
</tr>

<tr>
<td>
Helper Lemmas
</td>
<td>
  <ul>
    <li>Canonical Forms</li>
    <li>Inversion Lemma</li>
    <li>Evaluation Context Lemma 1: if $E:A\leadsto B$ and $\cdot\vdash e:B$, then $\cdot\vdash E(e):B$</li>
    <li>Evaluation Context Lemma 2: if $\cdot\vdash E(e):B$, then there exists $A$ such that $\cdot\vdash e:A$ and $E:A\leadsto B$</li>
  </ul>
</td>
<td>
  <ul>
    <li>Canonical Forms</li>
  </ul>
</td>
</tr>

<tr>
<td>
Main Lemmas
</td>
<td>
<b>Progress Lemma</b>: If $\cdot\vdash e:A$ then either $e\,val$ or $\exists e'.e\mapsto e'$.
Prove by induction on the given derivation $\mathcal{D}$ of $\cdot\vdash e:A$. We analyze cases by the last typing rule that is applied to $\mathcal{D}$
<ul>
  <li>Rule Var. The bottom inference cannot be this rule since there is no $\Gamma$ contains $x$ that is equal to $\cdot$</li>
  <li>Rule $\text{bool I}_1$. $e=true$, then $e\,val$ as $true\in V$ </li>
  <li>Rule $\text{bool I}_2$. $e=false$, then $e\,val$ as $false\in V$</li>
  <li>Rule bool E. By i.h. on $e_1$, we have either $e_1\,val$ or $\exists e_1'.e_1\mapsto e_1'$</li>
    <ul>
      <li>$e_1\,val$. By cononical forms, $e_1$ is either true or false. Then by rule $\text{S-IF}_1$ or $\text{S-IF}_2$, $e$ can take a step </li>
      <li>$\exists e_1'.e_1\mapsto e_1'$. Then by rule S-STEP, $e$ can take a step </li>
    </ul>
  <li>Rule $\rightarrow$I. $e=\lambda x:A.e_1$, as $\lambda x:A.e_1\in C$, so $e\,val$</li>
  <li>Rule $\rightarrow$E. $e=e_1\,e_2$. By i.h. on $e_1$, we have either $e_1\,val$ or $\exists e_1'.e_1\mapsto e_1'$</li>
    <ul>
      <li>$e_1\,val$. By cononical forms, $e_1$ is in the form $\lambda x:A.e_3$. Then by rule S-APP, $e$ can take a step </li>
      <li>$\exists e_1'.e_1\mapsto e_1'$. Then by rule S-STEP, $e$ can take a step </li>
    </ul>
  <li>Rule ECT-1. $e=[\cdot]\,e'$, then $e\mapsto e'$</li>
  <li>Rule ECT-2. $e=(E\,e)\,e'$, then $e\mapsto E(e')\,e$</li>
  <li>Rule ECT-3. $e=(\mathcal{V}\,E)\,e'$, then $e\mapsto \mathcal{V}\,E(e')$</li>
  <li>Rule ECT-4. $e=(\text{if }E\text{ then }e_1\text{ else }e_2)\,e'$, then $e\mapsto \text{if }E(e')\text{ then }e_1\text{ else }e_2$</li>
</ul>
<b>Preservation Lemma</b>: If $\Gamma\vdash e:A$ and $e\mapsto e'$, then $\Gamma\vdash e':A$. Prove by induction on the derivation of $e\mapsto e'$.
  <ul>
    <li>
      Case $\dfrac{}{\text{if true then }e_1\text{ else }e_2\mapsto\,e_1}\text{S-IF}_1$. N.T.S $\Gamma\vdash e_1:A$. As $\Gamma\vdash\text{if true then }e_1\text{ else }e_2:A$, by inversion, $\Gamma\vdash e_1:A$, $\Gamma\vdash e_2:A$.
    </li>
    <li>
      Case $\dfrac{}{\text{if false then }e_1\text{ else }e_2\mapsto\,e_2}\text{S-IF}_2$. N.T.S $\Gamma\vdash e_2:A$. As $\Gamma\vdash\text{if true then }e_1\text{ else }e_2:A$, by inversion, $\Gamma\vdash e_1:A$, $\Gamma\vdash e_2:A$.
    </li>
    <li>
      Case $\dfrac{}{(\lambda x:\tau.e)\,v\mapsto e[v/x]}\text{S-APP}$. N.T.S $\Gamma\vdash e[v/x]:A$. As $\Gamma\vdash(\lambda x:\tau.e) v:A$, by inversion, $\Gamma\vdash (\lambda x:\tau.e):\tau\rightarrow A$, $\Gamma\vdash v:\tau$. By inversion again, $\Gamma,x:\tau\vdash e:A$. By substitution lemma, $\Gamma\vdash e[v/x]:A$
    </li>
    <li>
      Case $\dfrac{e_1\mapsto e_1'}{E[e_1]\mapsto E[e_1']}\text{S-STEP}$. Suppose $E[e_1]:A$, by evaluation context lemma 2, there exists $B$ s.t. $\cdot\vdash e_1:A$ and $E:B\leadsto A$. 
      By i.h. on the premise, $\cdot\vdash e_1':A$. 
      Bt evaluation context lemma 1, $E[e_1']:A$.
    </li>
  </ul>
<b>$\text{Preservation}^*$ Lemma.</b> If $\Gamma\vdash e:A$ and $e\rightarrow^*e'$, then $\Gamma\vdash e':A$. Prove by induction on the multi-step reduction sequence. (TBD)
</td>
<td>
Prove based on the logical relations in two steps:
  <ul>
    <li>
      (A) For all terms $e$ if $\cdot\vdash e:\tau$ then $\cdot\vDash e:\tau$
    </li>
    <li>
      (B) For all terms $e$ if $\cdot\vDash e:\tau$ then safe$(e)$
    </li>
  </ul>
Define the generalized context as
$$
\mathcal{G}\lbrack\lbrack\cdot\rbrack\rbrack\triangleq\{\emptyset\} \\
\mathcal{G}\lbrack\lbrack\Gamma,x:\tau\rbrack\rbrack\triangleq\{
  \gamma[x\mapsto v]\,|\,\gamma\in\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack\wedge v\in
  \mathcal{V}\lbrack\lbrack\tau\rbrack\rbrack
\}
$$

Define the semantic well-typedness as:

$$
\Gamma\vDash e:\tau\triangleq\forall\gamma\in\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack.\gamma(e)\in\mathcal{E}\lbrack\lbrack\tau\rbrack\rbrack
$$
<b>Lemma B</b>: Prove as follows. As $\Gamma\vDash e:\tau$, we have $e\in\mathcal{E}\{\tau\}$, which means $\forall e'.e\mapsto^*e'\wedge\text{irred}(e')\Rightarrow e'\in\mathcal{V}\lbrack\lbrack\tau\rbrack\rbrack$. To prove safe$(e)$, we fix $e'$:
  <ul>
    <li>
      if irred$(e')$, then $e'\in\mathcal{V}\lbrack\lbrack\tau\rbrack\rbrack$, which satisfied safe$(e)$
    </li>
    <li>
      if not irred$(e')$, then $\exists e''.e\rightarrow e'$, which satisfies safe$(e)$
    </li>
  </ul>
<b>Lemma A Foundamental Proerpty</b>: if $\Gamma\vdash e:\tau$ then $\Gamma\vDash e:\tau$. Prove by induction on the typing judgement $\Gamma\vdash e:\tau$
  <ul>
    <li>
Case $\dfrac{\Gamma(x)=A}{\Gamma\vdash x:A}\text{Var}$. Then we have $\Gamma\vdash x:A$, n.t.s $\Gamma\vDash x:A$. $\Gamma\neq\cdot$ as $x\in\Gamma$.
      <ul>
        <li>
          $\Gamma=\Gamma',x:A$. Here $\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack=\{\gamma[x\mapsto v]\,|\,\gamma\in\mathcal{G}\lbrack\lbrack\Gamma'\rbrack\rbrack\wedge v\in\mathcal{E}\lbrack\lbrack A\rbrack\rbrack\}$, then $\forall\gamma\in\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack.\gamma(x)\in\mathcal{E}\lbrack\lbrack A\rbrack\rbrack$
        </li>
        <li>
          $\Gamma=\Gamma',y:B$. By i.h. on $\Gamma'$, $\Gamma'\vDash x:A$, which shows $\forall\gamma\in\mathcal{G}\lbrack\lbrack\Gamma'\rbrack\rbrack.\gamma(x)\in\mathcal{E}\lbrack\lbrack A\rbrack\rbrack$. And we have $\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack=\{\gamma[y\mapsto v]\,|\,\gamma\in\mathcal{G}\lbrack\lbrack\Gamma'\rbrack\rbrack\wedge v\in\mathcal{E}\lbrack\lbrack B\rbrack\rbrack\}$. Then $\forall\gamma\in\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack.\gamma(x)\in\mathcal{E}\lbrack\lbrack A\rbrack\rbrack$
        </li>
      </ul>
    </li>
    <li>
  Case $\dfrac{\Gamma,x:A\vdash e:B}{\Gamma\vdash \lambda x:A.e:A\rightarrow B}\rightarrow\text{I}$. N.T.S $\Gamma\vDash \lambda x:A.e:A\rightarrow B$, which is $\forall\gamma\in\mathcal{G}[[\Gamma]].\gamma(\lambda x:A.e)\in\mathcal{E}[[A\rightarrow B]]$. We push the sunstitution $\gamma$ under the $\lambda$, it suffies to show that $\forall\gamma\in\mathcal{G}[[\Gamma]].\lambda x:A.\gamma(e)\in\mathcal{E}[[A\rightarrow B]]$
  By unfolding the definition of $\mathcal{E}[[A\rightarrow B]]$, we need to show that $\forall\gamma\in\mathcal{G}[[\Gamma]].\forall e'.(\lambda x:A.\gamma(e))\mapsto^*e'\wedge irred(e')\Rightarrow e'\in\mathcal{V}[[A\rightarrow B]]$. We notice that the operational semantic actually takes no step, which means $e'=\lambda x:A.\gamma(e)$. So we need to show that $\forall\gamma\in\mathcal{G}[[\Gamma]].(\lambda x:A.\gamma(e))\in\mathcal{V}[[A\rightarrow B]]$, which is the same as $\forall\gamma\in\mathcal{G}[[\Gamma]].\forall v\in\mathcal{V}[[A]].\gamma(e)[v/x]\in\mathcal{E}[[B]]$.
  By i.h. on the premise, we have $\Gamma,x:A\vdash e:B$, which shows $\forall\gamma'\in\mathcal{G}[[\Gamma,x:A]].\gamma'(e)\in\mathcal{E}[[B]]$. Instante $\gamma'$ with arbitrary $\gamma'$, we have $\gamma'\in\mathcal{G}[[\Gamma,x:A]].\gamma'(e)\in\mathcal{E}[[B]]$. With arbitrary $\gamma\in\mathcal{G}[[\Gamma]]$ and $v\in\mathcal{V}[[A]]$, we have $\gamma'=\gamma[x\mapsto v]$, which means $\gamma[x\mapsto v]\in\mathcal{G}[[\Gamma]].\gamma[x\mapsto v](e)\in\mathcal{E}[[B]]$, which is exactly what we want.
    </li>
    <li>
Case $\dfrac{\Gamma\vdash e_1:A\rightarrow B\quad\Gamma\vdash e_2:A}{\Gamma\vdash e_1\,e_2:B}\rightarrow\text{E}$. N.T.S $\Gamma\vDash e_1\,e_2:B$. Unfolding definition, it is $\forall\gamma\in\mathcal{G}[[\Gamma]].\gamma(e_1\,e_2)\in\mathcal{E}[[B]]$. By definition of $\mathcal{E}[[B]]$, it suffices to show that $\forall\gamma\in\mathcal{G}[[\Gamma]].\forall e'.(\gamma(e_1\,e_2))\mapsto^*e'\wedge irred(e')\Rightarrow e'\in\mathcal{V}[[B]]$.
Suppose $\gamma\in\mathcal{G}[[\Gamma]]$, for arbitrary $e_1'$ and $e_2'$, by i.h. on premises, we have $(\gamma(e_1))\mapsto^*e_1'\wedge irred(e_1')\Rightarrow e_1'\in\mathcal{V}[[A\rightarrow B]]$ and $(\gamma(e_2))\mapsto^*e_2'\wedge irred(e_2')\Rightarrow e_2'\in\mathcal{V}[[A]]$. By definition of $\mathcal{V}[[A\rightarrow B]]$, we have $\forall v\in\mathcal{V}[[A]].(\gamma(e_1))\mapsto^*e_1'\wedge irred(e_1')\Rightarrow e_1'=\lambda x:A.e_1'' \wedge e_1''[v/x]\in\mathcal{E}[[B]]$. Combine them with instantiating $v$ with $e_2'$, we have $(\gamma(e_2))\mapsto^*e_2'\wedge (\gamma(e_1))\mapsto^*e_1'\wedge irred(e_2')\wedge irred(e_1') $$ \Rightarrow e_1'=\lambda x:A.e_1'' \wedge e_1''[e_2'/x]\in\mathcal{E}[[B]]$, with one more step applying S-APP rule, we have $\gamma(e_1\,e_2)\mapsto^*e_2''[e_2'/x]\wedge e_2''[e_2'/x]\in\mathcal{E}[[B]]$. By definition of $\mathcal{E}[[B]]$, we get want we want.
    </li>
    <li>
      Case $\dfrac{}{\Gamma\vdash true:bool}\text{bool I}_1$. We have $\Gamma\vdash true:bool$, and n.t.s $\Gamma\vDash true:bool$, which is $\forall\gamma\in\mathcal{G}\lbrack\lbrack\Gamma\rbrack\rbrack.\gamma(true)\in\mathcal{E}\lbrack\lbrack bool\rbrack\rbrack$. By definition of $\gamma(true)$, it suffices to show $true\in\mathcal{E}\lbrack\lbrack bool\rbrack\rbrack$. Since true is already irreducible, it sufficies to show $true\in\mathcal{V}\lbrack\lbrack bool\rbrack\rbrack$, which we already have.
    </li>
    <li>
      Case $\dfrac{}{\Gamma\vdash false:bool}\text{bool I}_2$. Similar to last case. 
    </li>
    <li>
      Case $\dfrac{\Gamma\vdash e_1:bool\quad\Gamma\vdash e_2:A\quad\Gamma\vdash e_3:A}{\Gamma\vdash\text{if }e_1\text{ then }e_2\text{ else }e_3:A}\text{bool E}$. N.T.S $\Gamma\vDash\text{if }e_1\text{ then }e_2\text{ else }e_3:A$, which is for all $\gamma\in\mathcal{G}[[\Gamma]]$, we have $\text{if }\gamma(e_1)\text{ then }\gamma(e_2)\text{ else }\gamma(e_3)\in\mathcal{E}[[A]]$. By definition, it suffices to show $\forall e'.e\mapsto^*e'\wedge irred(e')\Rightarrow e'\in\mathcal{V}[[A]]$ with $e=\text{if }\gamma(e_1)\text{ then }\gamma(e_2)\text{ else }\gamma(e_3)$.
      By i.h. on the deriviation of $e_1$, $\gamma(e_1)\in\mathcal{E}[[bool]]$, which can be expanded to $\forall e_1'.\gamma(e_1)\mapsto^*e_1'\wedge irred(e_1')\Rightarrow e_1'\in\mathcal{V}[[bool]]$. By cononical forms, $e_1'$ is either true or false.
      <br/>
      Case 1. If $e_1'$ is true, then $\text{if }\gamma(e_1)\text{ then }\gamma(e_2)\text{ else }\gamma(e_3)\mapsto^* \gamma(e_2)$. By i.h. on derivation of $e_2$, $\gamma(e_2)\in\mathcal{E}[[A]]$, which can be expanded to $\forall e_2'.\gamma(e_2)\mapsto^*e_2'\wedge irred(e_2')\Rightarrow e_2'\in\mathcal{V}[[A]]$. Then by transitivity of the operational semantic, we have $\forall e_2'.\text{if }\gamma(e_1)\text{ then }\gamma(e_2)\text{ else }\gamma(e_3)\mapsto^* e_2'\wedge irred(e_2')$ $\Rightarrow e_2'\in\mathcal{V}[[A]]$, which is exactly what we want. 
      <br/>
      Case 2. If $e_1'$ is false. Similar to Case 1.
    </li>
  </ul>
</td>
</tr>

<tr>
<td>
Proof
</td>
<td>
For any $e'$ that $e\rightarrow^*e'$, there must exist a type $A$ s.t. $\Gamma\vdash e:A$. By <b>$\text{Preservation}^*$ Lemma</b>, $\Gamma\vdash e':A$. Then by <b>Progress Lemma</b>, either $e'\,val$ or $\exists e''.e'\mapsto e''$. 
<br/>
Thus we know for any $e'$ that $e\rightarrow^*e'$, either $e'\,val$ or $\exists e''.e'\mapsto e''$. 
</td>
<td>
It is already proved by the main lemmas.
</td>

</tr>
</tr>
</table>
</div>
</div>

### 2.3 Comparision

This is the first time I have gotten to know there are some trivial steps to prove type soundness from preservation and progress lemma. 

Comparing the proof, the method of progress and preservation is working on a single reduction step, which is why there are so many intermediate lemmas. For logic relation, it only uses Canonical Forms. The definition of logical relation becomes the core part.

[^1]: Ahmed, A. (2006) ‘Step-indexed syntactic logical relations for recursive and quantified types’, Programming Languages and Systems, pp. 69–83. doi:10.1007/11693024_6. 