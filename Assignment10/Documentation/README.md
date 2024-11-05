# Three-Address Code Generation for a C-like Language

This project implements a simple compiler in C using **Lex** and **Yacc (Bison)**. The compiler generates three-address code (TAC) for a C-like language, supporting basic constructs such as variable declarations, assignments, arithmetic and boolean expressions, and control flow statements (`if-else`, `while`).

## Overview

The Lex file (`.l` file) is responsible for tokenizing the input, identifying keywords, operators, and other language constructs. The Yacc file (`.y` file) defines the grammar rules and generates three-address code based on the input program.

## Features

### Supported Statements and Expressions

1. **Variable Declarations**: `int` and `float` types are supported.
2. **Assignment Statements**: `ID := E;` where `E` is an arithmetic or boolean expression.
3. **Arithmetic Expressions**: Operations such as `+`, `-`, `*`, `/` are supported with precedence and associativity rules.
4. **Boolean Expressions**: Logical operations such as `AND`, `OR`, and `NOT`.
5. **Relational Expressions**: `<`, `>`, `==` for comparisons.
6. **Control Flow Statements**:
   - `if-else` with conditional evaluation.
   - `while` loops with condition checks.
7. **Input/Output**:
   - `print` statements to output values.
   - `scan` statements to read values.

## File Structure

- **lex.l**: The Lex file contains token definitions and lexical rules to parse the input source code.
- **yacc.y**: The Yacc file specifies the grammar and generates the corresponding three-address code.
- **input.txt**: Sample input file where the source code to be parsed is written.
- **out.txt**: Output file where the generated three-address code is written.

## Compilation Instructions

1. **Generate Lexer and Parser**: Compile the Lex and Yacc files to generate the executable.
   ```bash
   bison -d parser.y
   flex lex.l
   gcc parser.tab.c -o parser -ll
   ```
2. **Run the Parser**: Execute the parser with `input.txt` as the input.
   ```bash
   ./parser
   ```
   This reads the input program from `input.txt` and writes the generated TAC to `output.txt`.

## Key Functions

1. **new_variable**: Generates temporary variable names for intermediate results (e.g., T0, T1, …).
2. **new_line_label**: Generates unique labels for conditional and loop control structures.
3. **yyerror**: Reports syntax errors with line numbers.

## Example Usage

For the following input in `input.txt`:
```plaintext
prog
int a;
a := 5 + 3;
if a > 4 then
    print "a is greater";
else
    print "a is smaller";
end
```

The generated TAC in `output.txt` might look like:
```plaintext
Three Address Code:

      T0 = 5 + 3
      a = T0
      T1 = a > 4
      If !(T1) goto L0
      print "a is greater"
      goto L1
 L0 : 
      print "a is smaller"
 L1 : 
      exit
```

For the following input in `input.txt`:
```plaintext
prog
    int a b;
    if d>4 then c:=d+2;
    end
end
```

The generated TAC in `output.txt` might look like:
```plaintext
Three Address Code is:

      T0 = d > 4
      T1 = T0
      If ! (T1) goto L0
      T2 = d + 2
      c = T2
 L0 : 
      exit
```

For the following input in `input.txt`:
```plaintext
prog 
    int a b;
    a := b + c;
    if d>3 or a<2 then
        print "Hello"
        if a<2 then 
            print "Hi"
        else 
            print "Complete"
        end
    end
end
```

The generated TAC in `output.txt` might look like:
```plaintext
Three Address Code is:

      T0 = b + c
      a = T0
      T1 = d > 3
      T2 = a < 2
      T3 = T1 or T2
      T4 = T3
      If ! (T4) goto L0
      print "Hello"
      T5 = a < 2
      T6 = T5
      If ! (T6) goto L1
      print "Hi"
      goto L2
 L1 : 
      print "Complete"
 L2 : 
 L0 : 
      exit

```

## Error Handling

Errors are reported with line numbers and descriptions. If there’s a syntax error, it will be displayed on the console.

