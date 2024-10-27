# Lab Assignment 10

## Overview
In this lab assignment, we focus on generating **3-address code** (TAC) for arithmetic expressions. We use **S-attributed grammars** with **semantic actions** to produce the code while parsing the expression based on a given context-free grammar.

### Intermediate Representations
Intermediate representations (IR) act as a bridge between high-level source code and machine code. Some common forms of IR include:
- **Abstract Syntax Trees (ASTs)**: Tree representation of the syntactic structure of source code.
- **Directed Acyclic Graphs (DAGs)**: Represent expressions where common subexpressions are identified.
- **Three-Address Code (TAC)**: Linearized code consisting of statements with at most three operands, useful for optimization and further compilation steps.

In this assignment, we focus on **TAC**, which consists of instructions where each step in the expression evaluation is represented by a simple 3-address instruction of the form:

x = y op z

Where:
- `x` is a temporary or a variable.
- `y` and `z` are variables or temporaries.
- `op` is a binary operation (e.g., `+`, `-`, `*`, `/`).

## Problem Statement
We are given a grammar that describes simple arithmetic expressions with operators such as addition (`+`), subtraction (`-`), multiplication (`*`), and division (`/`). The task is to:
1. Use **S-attributed/L-attributed grammars** with **semantic actions** to generate the corresponding 3-address code.
2. Implement a solution in C++ that takes an arithmetic expression as input and outputs the corresponding 3-address code.

---

## Grammar and Semantic Actions
The grammar that we will use for arithmetic expressions consists of the following productions:

E -> E + T | E - T | T T -> T * F | T / F | F F -> id | ( E )


### Semantic Actions
The **S-attributed grammar** associates semantic actions with each production rule to generate the 3-address code. The key concept is to create **temporary variables** to store intermediate results of subexpressions and emit the corresponding code during parsing.

#### Production Rules with Semantic Actions:
- **E -> E + T**:
  - Action: Create a new temporary variable for the result (`E.addr = new_temp()`), and generate the 3-address code for addition: `E.addr = E1.addr + T.addr`.
  
- **E -> E - T**:
  - Action: Create a new temporary variable for the result, and generate the code for subtraction: `E.addr = E1.addr - T.addr`.

- **E -> T**:
  - Action: Simply propagate the address from `T` to `E`: `E.addr = T.addr`.

- **T -> T * F**:
  - Action: Create a new temporary variable for the result, and generate the code for multiplication: `T.addr = T1.addr * F.addr`.

- **T -> T / F**:
  - Action: Create a new temporary variable for the result, and generate the code for division: `T.addr = T1.addr / F.addr`.

- **T -> F**:
  - Action: Simply propagate the address from `F` to `T`: `T.addr = F.addr`.

- **F -> id**:
  - Action: The address of an identifier `id` is its lexeme: `F.addr = id.lexeme`.

- **F -> ( E )**:
  - Action: Propagate the address from the enclosed expression `E`: `F.addr = E.addr`.

#### Temporary Variable Management:
To handle intermediate results, we use a function `new_temp()` to generate new temporary variables (`t0`, `t1`, etc.). Each time a binary operation is encountered, a new temporary is created to store the result.

### 3-Address Code Generation Process:
The parsing process generates 3-address code by:
1. Evaluating the subexpressions.
2. Storing results in temporary variables.
3. Printing the instructions in the form of three-address code.

For example, parsing the expression `a + b * c` would yield:

t0 = b * c 
t1 = a + t0


---

## Implementation in C++
We implement the grammar and semantic actions using a **recursive descent parser** in C++. Below is an explanation of the key components of the code.

### 1. Tokenizer
The `tokenize()` function breaks down the input expression into tokens, such as identifiers (`id`), operators (`+`, `-`, `*`, `/`), and parentheses (`(`, `)`). It assigns appropriate token types and stores them for further parsing.

### 2. Parser Functions
The parser consists of three main functions corresponding to the non-terminals in the grammar:
- **`E()`**: Handles expressions and addition/subtraction operations.
- **`T()`**: Handles terms and multiplication/division operations.
- **`F()`**: Handles factors (either an identifier or a parenthesized expression).

Each of these functions is responsible for generating the corresponding 3-address code by calling the `emit()` function with the appropriate arguments (temporary variables, operators, and operands).

### 3. 3-Address Code Generation
The function `emit()` is responsible for printing out the 3-address code in the form:

result = arg1 op arg2

Where `result` is the temporary variable that stores the result of the operation, `arg1` and `arg2` are the operands, and `op` is the binary operator.

### 4. Sample Input and Output
**Input Expression**:  

a + b * c

**Generated 3-Address Code**:  

t0 = b * c 
t1 = a + t0


---

## C++ Code Implementation

```cpp
#include <iostream>
#include <string>
#include <sstream>
#include <vector>

using namespace std;

int temp_count = 0; // Counter for temporary variables

// Generate new temporary variable
string new_temp() {
    return "t" + to_string(temp_count++);
}

// Emit three-address code
void emit(string result, string arg1, string op, string arg2) {
    cout << result << " = " << arg1 << " " << op << " " << arg2 << endl;
}

// Lexer: Token types
enum TokenType { ID, PLUS, MINUS, MUL, DIV, LPAREN, RPAREN, END };

// Structure to represent tokens
struct Token {
    TokenType type;
    string value;
};

// Global variables to hold tokens
vector<Token> tokens;
int current_token = 0;

// Function to get the current token
Token peek() {
    return tokens[current_token];
}

// Function to consume a token
Token next_token() {
    return tokens[current_token++];
}

// Parser Functions
void E(string& addr);
void T(string& addr);
void F(string& addr);

// Recursive Descent Parser: E -> E + T | E - T | T
void E(string& addr) {
    string T_addr;
    T(T_addr);  // Parse T
    Token token = peek();
    if (token.type == PLUS || token.type == MINUS) {
        next_token();  // Consume the operator
        string E_addr;
        E(E_addr);  // Parse the rest of E
        addr = new_temp();  // Create a new temporary
        string op = (token.type == PLUS) ? "+" : "-";
        emit(addr, E_addr, op, T_addr);  // Emit 3-address code
    } else {
        addr = T_addr;  // Propagate address from T
    }
}

// Recursive Descent Parser: T -> T * F | T / F | F
void T(string& addr) {
    string F_addr;
    F(F_addr);  // Parse F
    Token token = peek();
    if (token.type == MUL || token.type == DIV) {
        next_token();  // Consume the operator
        string T_addr;
        T(T_addr);  // Parse the rest of T
        addr = new_temp();  // Create a new temporary
        string op = (token.type == MUL) ? "*" : "/";
        emit(addr, T_addr, op, F_addr);  // Emit 3-address code
    } else {
        addr = F_addr;  // Propagate address from F
    }
}

// Recursive Descent Parser: F -> id | ( E )
void F(string& addr) {
    Token token = next_token();
    if (token.type == ID) {
        addr = token.value;  // Identifier address is just the lexeme
    } else if (token.type == LPAREN) {
        E(addr);  // Parse E inside parentheses
        if (next_token().type != RPAREN) {
            cout << "Error: Mismatched parentheses" << endl;
        }
    }
}

// Tokenize the input expression
void tokenize(string input) {
    stringstream ss(input);
    char ch;
    while (ss >> ch) {
        if (isalpha(ch)) {
            tokens.push_back({ID, string(1, ch)});
        } else if (ch == '+') {
            tokens.push_back({PLUS, "+"});
        } else if (ch == '-') {
            tokens.push_back({MINUS, "-"});
        } else if (ch == '*') {
            tokens.push_back({MUL, "*"});
        } else if (ch == '/') {
            tokens.push_back({DIV, "/"});
        } else if (ch == '(') {
            tokens.push_back({LPAREN, "("});
        } else if (ch == ')') {
            tokens.push_back({RPAREN, ")"});
        }
    }
    tokens.push_back({END, ""});
}

int main() {
    string input;
    cout << "Enter an expression: ";
    getline(cin, input);

    tokenize(input);

    string addr;
    E(addr);  // Parse the input expression

    return 0;
}
```

