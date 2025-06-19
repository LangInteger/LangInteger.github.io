---
title: The equivalence of two LBIs
date: 2025-06-19 17:37:04
tags: 
  - Bunched implication
  - BI
  - LBI
  - Sequent Calculus
  - Cut Elimination
---

The logic of bunched implication (BI), compared to linear logic (LL), adds an extra additive primitive for implication. 

<!-- more -->

Let $\mathbb{P}$ be a denumerable set of propositional letters. The set of formulas are defined by the following grammar.
$$
B::=p\in\mathbb{P}
\mid \top
\mid \bot
\mid \mathbb{1}
\mid B_1\wedge B_2
\mid B_1\wedge B_2
\mid B_1\supset B_2
\mid B_1\otimes B_2
\mid B_1\multimap B_2
$$
The context is not lists, multisets, or sets, instead bunches defined as:
$$
\Gamma ::= B
\mid \varnothing^+
\mid \varnothing^\times
\mid \Gamma\mathbb{;}\Gamma
\mid \Gamma\mathbb{,}\Gamma
$$
The sequent calculus representation of BI is called LBI. The set of rules can be found at Table 6.1 (by replacing the $\wedge R$, $\vee L$ to the corresponding additive version as shown in Lemma 6.1) in [The Semantics and Proof Theory of the Logic of Bunched Implications](http://www0.cs.ucl.ac.uk/staff/D.Pym/BI.htm)
$$
\dfrac{\,}{
	p\vdash p
}
Ax
\quad\quad
\dfrac{
	\Gamma(\varnothing^\times)\vdash B
}{
	\Gamma(\mathbb{1})\vdash B
}
\mathbb{1}L
\quad\quad
\dfrac{
	\,
}{
	\varnothing^\times\vdash \mathbb{1}
}
\mathbb{1}R
\quad\quad
\dfrac{
	\Gamma(\varnothing^+)\vdash B
}{
	\Gamma(\mathbb{\top})\vdash B
}
\top L
\quad\quad
\dfrac{
	\,
}{
	\varnothing^+\vdash \top
}
\top R
\quad\quad
\dfrac{\,}{
	\Gamma(\bot)\vdash B
}\bot L
$$
$$
\dfrac{
	\Gamma(B_1\mathbb{,}B_2)\vdash B
}{
	\Gamma(B_1\otimes B_2)\vdash B
}
\otimes L
\quad\quad
\dfrac{
	\Gamma_1\vdash B_1
	\quad
	\Gamma_2\vdash B_2
}{
	\Gamma_1\mathbb{,}\Gamma_2\vdash B_1\otimes B_2
}
\otimes R
$$
$$
\dfrac{
	\Gamma(B_1;B_2)\vdash B
}{
	\Gamma(B_1\wedge B_2)\vdash B
}
\wedge L
\quad\quad
\dfrac{
	\Gamma_1\vdash B_1
	\quad
	\Gamma_2\vdash B_2
}{
	\Gamma_1;\Gamma_2\vdash B_1\wedge B_2
}
\wedge R
$$
$$
\dfrac{
	\Gamma_1\vdash B_1
	\quad
	\Gamma(\Gamma_2,B_2)\vdash B
}{
	\Gamma(\Gamma_1,\Gamma_2,B_1\multimap B_2)\vdash B
}
\color{red}{\multimap L}
\quad\quad
\dfrac{
	\Gamma,B_1\vdash B_2
}{
	\Gamma\vdash B_1\multimap B_2
}
\multimap R
$$
$$
\dfrac{
	\Gamma_1\vdash B_1
	\quad
	\Gamma(\Gamma_2;B_2)\vdash B
}{
	\Gamma(\Gamma_1;\Gamma_2;B_1\supset B_2)\vdash B
}
\color{blue}{\supset L}
\quad\quad
\dfrac{
	\Gamma;B_1\vdash B_2
}{
	\Gamma\vdash B_1\supset B_2
}
\supset R
$$
$$
\dfrac{
	\Gamma(B_1)\vdash B
	\quad
	\Gamma(B_2)\vdash B
}{
	\Gamma(B_1\vee B_2)\vdash B
}
\vee L
\quad\quad 
\dfrac{
	\Gamma\vdash B_1
}{
	\Gamma\vdash B_1\vee B_2
}
\vee R_1
\quad\quad 
\dfrac{
	\Gamma\vdash B_2
}{
	\Gamma\vdash B_1\vee B_2
}
\vee R_2
$$
$$
\dfrac{
	\Gamma(\Gamma_1)\vdash B
}{
	\Gamma(\Gamma_1;\Gamma_2)\vdash B
}
W
\quad\quad
\dfrac{
	\Gamma(\Gamma_1;\Gamma_1)\vdash B
}{
	\Gamma(\Gamma_1)\vdash B
}
C
\quad\quad
\dfrac{
	\Gamma_1\vdash B
}{
	\Gamma_2\vdash B
}
E_{(\Gamma_1\equiv \Gamma_2)}
$$


Another paper [LBI Cut Elimination Proof with BI-Multi-Cut](https://ieeexplore.ieee.org/abstract/document/6269651) solved the mistake the previous book made in the cut elimination proof. However, the LBI given in Figure 1 (we call it as $\mathsf{multicutLBI}$) of the paper is slightly different of the previous one, which is:
$$
\dfrac{\,}{
	p\vdash p
}
Ax
\quad\quad
\dfrac{
	\Gamma(\varnothing^\times)\vdash B
}{
	\Gamma(\mathbb{1})\vdash B
}
\mathbb{1}L
\quad\quad
\dfrac{
	\,
}{
	\varnothing^\times\vdash \mathbb{1}
}
\mathbb{1}R
\quad\quad
\dfrac{
	\Gamma(\varnothing^+)\vdash B
}{
	\Gamma(\mathbb{\top})\vdash B
}
\top L
\quad\quad
\dfrac{
	\,
}{
	\varnothing^+\vdash \top
}
\top R
\quad\quad
\dfrac{\,}{
	\Gamma(\bot)\vdash B
}\bot L
$$
$$
\dfrac{
	\Gamma(B_1\mathbb{,}B_2)\vdash B
}{
	\Gamma(B_1\otimes B_2)\vdash B
}
\otimes L
\quad\quad
\dfrac{
	\Gamma_1\vdash B_1
	\quad
	\Gamma_2\vdash B_2
}{
	\Gamma_1\mathbb{,}\Gamma_2\vdash B_1\otimes B_2
}
\otimes R
$$
$$
\dfrac{
	\Gamma(B_1;B_2)\vdash B
}{
	\Gamma(B_1\wedge B_2)\vdash B
}
\wedge L
\quad\quad
\dfrac{
	\Gamma_1\vdash B_1
	\quad
	\Gamma_2\vdash B_2
}{
	\Gamma_1;\Gamma_2\vdash B_1\wedge B_2
}
\wedge R
$$
$$
{
	\dfrac{
		\Gamma_1\vdash B_1
		\quad
		\Gamma(B_2)\vdash B
	}{
		\Gamma(\Gamma_1,B_1\multimap B_2)\vdash B
	}
	\color{red}{\multimap L}
}
	\quad\quad
	\dfrac{
		\Gamma,B_1\vdash B_2
	}{
		\Gamma\vdash B_1\multimap B_2
	}
	\multimap R
$$
$$
{
	\dfrac{
		\Gamma_1\vdash B_1
		\quad
		\Gamma(\Gamma_1;B_2)\vdash B
	}{
		\Gamma(\Gamma_1;B_1\supset B_2)\vdash B
	}
	\color{blue}{\supset L}
}
\quad\quad
\dfrac{
	\Gamma;B_1\vdash B_2
}{
	\Gamma\vdash B_1\supset B_2
}
\supset R
$$
$$
\dfrac{
	\Gamma(B_1)\vdash B
	\quad
	\Gamma(B_2)\vdash B
}{
	\Gamma(B_1\vee B_2)\vdash B
}
\vee L
\quad\quad 
\dfrac{
	\Gamma\vdash B_1
}{
	\Gamma\vdash B_1\vee B_2
}
\vee R_1
\quad\quad 
\dfrac{
	\Gamma\vdash B_2
}{
	\Gamma\vdash B_1\vee B_2
}
\vee R_2
$$
$$
\dfrac{
	\Gamma(\Gamma_1)\vdash B
}{
	\Gamma(\Gamma_1;\Gamma_2)\vdash B
}
W
\quad\quad
\dfrac{
	\Gamma(\Gamma_1;\Gamma_1)\vdash B
}{
	\Gamma(\Gamma_1)\vdash B
}
C
\quad\quad
\dfrac{
	\Gamma_1\vdash B
}{
	\Gamma_2\vdash B
}
E_{(\Gamma_1\equiv \Gamma_2)}
$$

The article follows to show that the two LBIs are equivalent. The proof has two directions.
- For any sequent $\Delta\vdash B$ derivable in $\mathsf{multicutLBI}$, noted as $\Delta\vdash_{\mathsf{multicutLBI}} B$, with derivation $\mathcal{D}$, it is derivable in $\mathsf{LBI}$.
	The proof is by structural induction on $\mathcal{D}$. It starts by case analysis on the last rule applied to $\mathcal{D}$. The only interesting case is $\multimap L$ and $\supset L$. All other cases are by I.H. on the premise (if any) and then apply the rule with the same name in $\mathsf{LBI}$.
	- $\multimap L$. We have $$\Gamma(\Gamma_1,B_1\multimap B_2)\vdash_{\mathsf{multicutLBI}}B$$. NTS $$\Gamma(\Gamma_1,B_1\multimap B_2)\vdash_{\mathsf{LBI}}B$$.
	$$
	\begin{array}{llr}
		1 & \Gamma_1\vdash_{\mathsf{LBI}} B_1 & \text{By I.H. on first premise} \\
		2 & \Gamma(B_2)\vdash_{\mathsf{LBI}} B & \text{By I.H. on second premise} \\
		3 & \Gamma(\varnothing^\times,B_2)\vdash_{\mathsf{LBI}} B & \text{By E}:2 \\
		4 & \Gamma(\Gamma_1,\varnothing^\times,B_1\multimap B_2)\vdash_{\mathsf{LBI}} B & \text{By }\multimap\text{L}:1,3\\
	\end{array}
	$$
	- $\supset L$. We have $$\Gamma(\Gamma_1;B_1\supset B_2)\vdash_{\mathsf{multicutLBI}}B$$. NTS $$\Gamma(\Gamma_1;B_1\supset B_2)\vdash_{\mathsf{LBI}}B$$.
		$$
		\begin{array}{llr}
			1 & \Gamma_1\vdash_{\mathsf{LBI}} B_1 & \text{By I.H. on first premise} \\
			2 & \Gamma(\Gamma_1;B_2)\vdash_{\mathsf{LBI}} B & \text{By I.H. on second premise} \\
			3 & \Gamma(\Gamma_1;\Gamma_1;B_1\supset B_2)\vdash_{\mathsf{LBI}} B & \text{By }\supset\text{L}:1,2 \\
			4 & \Gamma(\Gamma_1;B_1\supset B_2)\vdash_{\mathsf{LBI}} B & \text{By Contraction}:3 \\
		\end{array}
		$$
-  For any sequent $\Delta\vdash B$ derivable in $\mathsf{LBI}$, noted as $\Delta\vdash_{\mathsf{LBI}} B$, with derivation $\mathcal{D}$, it is derivable in $\mathsf{multicutLBI}$.
	The proof is by structural induction on $\mathcal{D}$. It starts by case analysis on the last rule applied to $\mathcal{D}$. The only interesting case is $\multimap L$ and $\supset L$. All other cases are by I.H. on the premise (if any) and then apply the rule with same name in $\mathsf{multicutLBI}$.
	- $\multimap L$. We have $$\Gamma(\Gamma_1,\Gamma_2,B_1\multimap B_2)\vdash_{\mathsf{LBI}}B$$, NTS $$\Gamma(\Gamma_1,\Gamma_2,B_1\multimap B_2)\vdash_{\mathsf{multicutLBI}}B$$. 
	$$
	\begin{array}{llr}
		1 & \Gamma_1\vdash_{\mathsf{multicutLBI}} B_1 & \text{By I.H. on first premise} \\
		2 & \Gamma(\Gamma_2,B_2)\vdash_{\mathsf{multicutLBI}} B & \text{By I.H. on second premise} \\
		3 & \Gamma(\Gamma_2,\Gamma_1,B_1\multimap B_2)\vdash_{\mathsf{multicutLBI}} B & \text{By }\multimap\text{L}:1,2 \\
		4 & \Gamma(\Gamma_1,\Gamma_2,B_1\multimap B_2)\vdash_{\mathsf{multicutLBI}} B & \text{By E}:3 \\
	\end{array}
	$$
	- $\supset L$.We have $$\Gamma(\Gamma_1;\Gamma_2;B_1\supset B_2)\vdash_{\mathsf{LBI}}B$$. NTS $$\Gamma(\Gamma_1;\Gamma_2;B_1\supset B_2)\vdash_{\mathsf{multicutLBI}}B$$.
		$$
		\begin{array}{llr}
			1 & \Gamma_1\vdash_{\mathsf{multicutLBI}} B_1 & \text{By I.H. on first premise} \\
			2 & \Gamma(\Gamma_2;B_2)\vdash_{\mathsf{multicutLBI}} B & \text{By I.H. on second premise} \\
			3 & \Gamma_1;\Gamma_2\vdash_{\mathsf{multicutLBI}} B_1 & \text{By }W:1 \\
			4 & \Gamma(\Gamma_1;\Gamma_2;B_2)\vdash_{\mathsf{multicutLBI}} B & \text{By }W:2 \\
			5 & \Gamma(\Gamma_1;\Gamma_2;B_1\supset B_2)\vdash_{\mathsf{multicutLBI}} B & \text{By }\supset L:3,4 \\
		\end{array}
		$$