---
title: Notes for Relational Hoare Logic
date: 2024-07-23 9:04:04
tags:
  - Programming Languages
  - Logic
---

This is a note reading the thesis of Lionel Blatter[^1], which makes contribution to the relational properties verification in the Frama-C ecosystem, and it is also a good material for learning formal verification.

<!--more-->

## 1 Hoare Logic

$\Sigma=\mathbb{X}\rightharpoonup\mathbb{N}$ represents the set of memory states for natural numbers, mapping locations to naturals. $\Psi=\mathbb{Y}\rightharpoonup\mathbb{C}$ stands for the set of memory states for commands, mapping program names to commands. Metavariables $\sigma,\sigma_0,\sigma_1\dots$ are used to range over $\Sigma$, and $\psi,\psi_0,\psi_1\dots$ to range over $\Psi$.

$\xi$ denotes the function evaluates arithmetic expressions in $\mathbb{N}$, with respect to a memory state for natural numbers. Thus , for an arithmetic expression $a$ in $\mathbb{E}_a$, we have $\xi_a\llbracket a\rrbracket:\Sigma\rightharpoonup\mathbb{N}$. Similarly, we have $\xi_b\llbracket b\rrbracket:\Sigma\rightharpoonup\mathbb{B}$ that evaluates boolean expressions $b$ in $\mathbb{E}_b$. At last, $\xi_c\llbracket c\rrbracket:\Sigma\times\Psi\rightharpoonup\Sigma$ is used to evaulate commands in $\Psi$ with memory states in $\Sigma$.

The formalization of Hoare Logic in deductive verification, also known as axiomatic semantics, takes a program as a predicate transormer.

$$
\{P\}c\{Q\}
$$

The program $c$ is executed on a state satisfying a property $P$ leads to a final state verifying another property $Q$. We can express some properties like

$$
\begin{array}{l}
  \text{requires }x >= 0
  \\
  \text{ensures \\ }result == x
\end{array}
$$

for function $abs$ taking $x$ as the parameter. But we cannot express properties, thought it is meanful, like:

$$
\forall\text{ integer }x,y;max(x,y)==(x+y+abs(x-y))/2
$$

The rules for Hoare Logic are 

$$
\dfrac{}
{
  \xi\vdash
  \{b\}skip\{b\}
}
\text{Skip}
\quad
\dfrac{}
{
  \xi\vdash
  \{b[a/x]\}x:=a\{b\}
}
\text{Assign}
$$
$$
\dfrac{
  \xi\vdash
  \{b_1\}c_1\{b_2\}
  \quad
  \xi\vdash
  \{b_2\}c_2\{b_3\}
}
{
  \xi\vdash
  \{b_1\}c_1;c_2\{b_3\}
}
\text{Sequence}
$$
$$
\dfrac{
  \xi\vdash
  \{b_1\wedge b_{if}\}c_1\{b_2\}
  \quad
  \xi\vdash
  \{b_1\wedge \neg b_{if}\}c_2\{b_2\}
}
{
  \xi\vdash
  \{b_1\}\text{if }b_{if}\text{ then }c_1\text{ else } c_2\{b_2\}
}
\text{Condition}
$$

## 2 Relational Hoare Logic

Relational properties can be seen as an extension of axiomatic semantics. The most common relational property annotation is $\{P\}c_1\sim c_2\{Q\}$ by Benton04, while if you are not expressing program similarity and linking more than two program, you may find the notation by Yan07 is more reasonable. $\{P\}(\begin{array} cc_1 \\ c_2 \end{array})\{Q\}$. The thesis sticks with the first notation as there will be no more than two programs.

We define $\Phi=\mathbb{T}\rightharpoonup\Sigma$ as the relational state environment that maps tags to memory states and use metavariables $\phi,\phi_0,\phi_1,\dots$ to range over $\Phi$.

$$
\dfrac{
}{
\vdash
\{\tilde{b}\}skip\langle t_1\rangle\sim skip\langle t_2\rangle\{\tilde{b}\}
}
\text{R-Skip}
$$
$$
\dfrac{
}{
\vdash
\{\tilde{b}
    [a_1\langle t_1\rangle/x_1\langle t_1\rangle
    ,
    a_2\langle t_2\rangle/x_2\langle t_2\rangle
    ]
\}x_1:=a_1\langle t_1\rangle\sim x_2:=a_2\langle t_2\rangle\{\tilde{b}\}
}
\text{R-Assign}
$$
$$
\dfrac{
  \vdash\{\tilde{b}_1\}c_1\langle t_1\rangle\sim c_3\langle t_2\rangle\{\tilde{b}_2\}
  \quad
  \vdash\{\tilde{b}_2\}c_2\langle t_1\rangle\sim c_4\langle t_2\rangle\{\tilde{b}_3\}
}{
\vdash
\{\tilde{b}_1\}c_1;c_2\langle t_1\rangle\sim c_3;c_4\langle t_2\rangle\{\tilde{b}_3\}
}
\text{R-Seq}
$$
$$
\dfrac{
  \vdash\{\tilde{b}_1\wedge b_1\langle t_1\rangle\wedge b_2\langle t_2\rangle\}c_1\langle t_1\rangle\sim c_3\langle t_2\rangle\{\tilde{b}_2\}
  \quad
  \vdash\{\tilde{b}_1\wedge\neg b_1\langle t_1\rangle\wedge\neg b_2\langle t_2\rangle\}c_2\langle t_1\rangle\sim c_4\langle t_2\rangle\{\tilde{b}_2\}
}{ 
  \vdash\{\tilde{b}_1\wedge b_1\langle t_1\rangle\equiv b_2\langle t_2\rangle\}
  \text{if }b_1\text{ then }c_1\text{ else }c_2\langle t_1\rangle
  \sim
  \text{if }b_1\text{ then }c_3\text{ else }c_4\langle t_2\rangle
  \{\tilde{b}_2\}
}
\text{R-If}
$$
$$
\dfrac{
  \vdash\{\tilde{b}\wedge b_1\langle t_1\rangle\wedge b_2\langle t_2\rangle\}
  c_1\sim c_2
  \{\tilde{b}\wedge b_1\langle t_1\rangle\equiv b_2\langle t_2\rangle\}
}{ 
  \vdash\{\tilde{b}_1\wedge b_1\langle t_1\rangle\equiv b_2\langle t_2\rangle\}
  \text{while }b_1\text{ do }\{c_1\}\langle t_1\rangle
  \sim
  \text{while }b_2\text{ do }\{c_2\}\langle t_2\rangle
  \{\tilde{b}_2\wedge\neg(b_1\langle t_1\rangle\vee b_2\langle t_2\rangle)\}
}
\text{R-While}
$$
$$
\dfrac{
  \vdash (\tilde{b}_1\Rightarrow\tilde{b}_1')
  \quad
  \vdash
    \{\tilde{b}_1'\}
    c_1\langle t_1\rangle\sim c_2\langle t_2\rangle
    \{\tilde{b}_2'\}
  \quad
  \vdash (\tilde{b}_2'\Rightarrow\tilde{b}_2)
}{
\vdash
  \{\tilde{b}_1\}
  c_1\langle t_1\rangle\sim c_2\langle t_2\rangle
  \{\tilde{b}_2\}
}
\text{R-Conseq}
$$

As introduced in the thesis, all of the above rules are only considering programs that are executed in locksteps, which makes it hard to compare programs with different structures. Barthe[^2] gives extended rules in his paper to solve this problem. In those rules, we assume that $c_1$ and $c_2$ are separate commands which do not have variables in comman: $var(c_1)\cap var(c_2)=\emptyset$. So we do not need tags $\langle t_1\rangle$ and $\langle t_2\rangle$ anymore.

$$
\dfrac{
  \vdash\{\phi[e/x]\}\text{skip}\sim c\{\psi\}
}{
  \vdash\{\phi\}x:=e\sim c\{\psi\}
}
\text{R-Assign-L}
$$
$$
\dfrac{
  \vdash\{\phi\wedge b\}c_1\sim c\{\psi\}
  \quad
  \vdash\{\phi\wedge \neg b\}c_2\sim c\{\psi\}
}{
  \vdash
  \{\phi\}
    \text{if }b\text{ then }c_1\text{ else }c_2
    \sim
    c
  \{\psi\}
}
\text{R-If-L}
$$

[^1]: Lionel Blatter. Relational properties for specification and verification of C programs in Frama-C. Other. Université Paris Saclay (COmUE), 2019. English. NNT : 2019SACLC065 . tel-02401884
[^2]: Barthe, G., Crespo, J. M., & Kunz, C. (2016). Product programs and relational program logics. Journal of Logical and Algebraic Methods in Programming, 85(5), 847-859.
