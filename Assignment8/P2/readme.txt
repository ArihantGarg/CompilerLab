DAG:

-> In this folder we have lex and yacc files for implementation of DAG.
-> Operations supported: addition,subtraction,division and multiplication.
-> Input is taken from terminal.

Steps: 
flex lex.l
bison -d parser.y
gcc parser.tab.c lex.yy.c -o parser -lfl
./parser

Example:
2*3+5+2*3+5+2*3
=
DAG generated. In-order traversal:
N8(+) -> N7(+), N3(*)
N7(+) -> N6(+), N4(5)
N6(+) -> N5(+), N3(*)
N5(+) -> N3(*), N4(5)
N3(*) -> N1(2), N2(3)
N1(2) -> NULL, NULL
N2(3) -> NULL, NULL
N4(5) -> NULL, NULL
N3(*) -> N1(2), N2(3)
N1(2) -> NULL, NULL
N2(3) -> NULL, NULL
N4(5) -> NULL, NULL
N3(*) -> N1(2), N2(3)
N1(2) -> NULL, NULL
N2(3) -> NULL, NULL

bison -d parser.y   # Generate the parser code and header file
flex lex.l          # Generate the lexer code
gcc lex.yy.c parser.tab.c -o parser -lfl  # Compile and link both files
