# Lab Assignment 3: Syntax Analysis/Parsing

## Overview

This assignment covers key aspects of syntax analysis in compiler design, focusing on removing left-recursion, left-factoring, and implementing a recursive descent parser. Syntax analysis checks whether a given input string conforms to the rules of a formal grammar.

## Question 1: Removing Left-Recursion

**Theory:** Left-recursion occurs when a non-terminal refers to itself as the first symbol in its production rules. This causes problems in top-down parsers due to infinite recursion.

**Algorithm:** For a grammar rule \( A \rightarrow A\alpha \ | \ \beta \), transform it to:
A → βA'
A' → αA' | ε
Where \( A' \) is a new non-terminal.

**Example:**
- **Input:** `A → Aα | β`
- **Output:** 
A → βA'
A' → αA' | ε

## Question 2: Left-Factoring a Grammar

**Theory:** Left-factoring removes common prefixes from production rules to prepare the grammar for predictive parsing, making it deterministic.

**Steps:**
1. Identify the common prefix among alternatives.
2. Factor out the prefix.
3. Introduce a new non-terminal for the remaining alternatives.

**Example:**
- **Input:** `A → aAB | aBc | aAc`
- **Output:**
A → aA'
A' → AB | Bc | Ac


## Question 3: Recursive Descent Parsing

**Theory:** Recursive descent parsing is a top-down technique where each non-terminal in the grammar is implemented as a recursive function. The parser matches the input string against production rules, allowing backtracking if needed.

**Grammar:**
E → T E'
E' → + T E' | ε
T → F T'
T' → * F T' | ε
F → ( E ) | i


**Implementation:**
1. Start with the start symbol \( E \).
2. Apply rules recursively.
3. Backtrack if a rule fails.
4. Accept if the input matches the grammar.
