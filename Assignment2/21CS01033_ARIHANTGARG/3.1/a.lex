%{
    #include<stdio.h>
%}

%%

(INT|int) {printf("IntegerDatatype ");}
(FLOAT|float) {printf("FloatDatatype ");}
(CHAR|char) {printf("CharacterDatatype ");}
(BOOL|bool) {printf("BooleanDatatype ");}

(if) {printf("If ");}
(for) {printf("For ");}
(while) {printf("While ");}
(read) {printf("Read ");}
(out) {printf("Write ");}
(main) {printf("Main ");}
(input) {printf("Input ");}

(\+) {printf("Add ");}
(-) {printf("Subtract ");}
(\*) {printf("Multiply ");}
(\/) {printf("Divide ");}
(%) {printf("Modulo ");}
(=) {printf("Assignment ");}
(<) {printf("SmallerThan ");}
(>) {printf("GreaterThan ");}
(==) {printf("EqualTo ");}
(>=) {printf("GreaterThanEqualTo ");}
(<=) {printf("SmallerThanEqualTo ");}
(!=) {printf("NotEqualTo ");}
(\+\+) {printf("Increment ");}
(--) {printf("Decrement ");}

(-?)([0-9]*) {printf("IntegerConstant ");}
(-?)([0-9]*)(\.)([0-9]*) {printf("FloatConstant ");}
(')(.)(') {printf("CharacterConstant ");}
(\")(.*)(\") {printf("StringConstant ");}

([a-zA-Z][a-zA-Z0-9_]*) {printf("Variable ");}

[\(\)] {printf("Bracket ");}
[{}] {printf("CurlyBracket ");}
[;] {printf("Semicolon ");}


%%

int yywrap(){}

int main()
{
    yylex();

    return 0;
}
