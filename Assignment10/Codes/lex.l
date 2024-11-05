%{ 
  // 21CS01033 Assignment 10
  #include<stdio.h>
  #include<string.h>
  #include "parser.tab.h" 
%}

%option yylineno 

%% 

and                             { return AND; }
:=                              { return ASSIGN; }
do                              { return DO; }
else                            { return ELSE; }
end                             { return END; }
=                               { return EQ; }
float                           { return FLOAT; }
if                              { return IF; }
int                             { return INT; }
not                             { return NOT; }
or                             { return OR; }
print                           { return PRINT; }
prog                          { return PROG; }
scan                            { return SCAN; }
then                            { return THEN; }
while                           { return WHILE; }

[0-9]+                          { strcpy(yylval.val, yytext); return IC; }
[0-9]+\.[0-9]+                  { strcpy(yylval.val, yytext); return FC; }
\"[^\"]*\"                      { strcpy(yylval.val, yytext); return STR; }
[a-zA-Z][a-zA-Z0-9]*            { strcpy(yylval.val, yytext); return ID; }

\+                             { return PLUS; }
\-                             { return MINUS; }
\*                             { return MULT; }
\/                             { return DIV; }
[<]                             { return LT; }
[>]                             { return GT; }
[(]                             { return LPAREN; }
[)]                             { return RPAREN; }
[{]                             { return LBRACE; }
[}]                             { return RBRACE; }
[;]                             { return SEMICOLON; }

\/\/.*\n   { /* Ignore single-line comments */ }
[\t\n ]                     {}

%% 

int yywrap() 
{ 
    return 1; 
}