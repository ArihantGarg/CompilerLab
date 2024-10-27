%{
#include "parser.tab.h"
#include <string.h>  
%}

ID      [a-zA-Z_][a-zA-Z0-9_]*
IC      [0-9]+
FC      [0-9]+\.[0-9]+
STR     \"([^\\\"]|\\.)*\"  

/* Rules Section */
%%
"prog"      { return PROG; }
"int"       { return INT; }
"float"     { return FLOAT; }
"if"        { return IF; }
"then"      { return THEN; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"do"        { return DO; }
"end"       { return END; }
"print"     { return PRINT; }
"scan"      { return SCAN; }
"or"        { return OR; }
"and"       { return AND; }
"not"       { return NOT; }

{ID}        { yylval.str = strdup(yytext); return ID; }
{IC}        { yylval.intval = atoi(yytext); return IC; }
{FC}        { yylval.floatval = atof(yytext); return FC; }
{STR}       {
                yylval.str = strdup(yytext + 1);
                yylval.str[strlen(yylval.str) - 1] = '\0';
                return STR;
            }

":="        { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"="         { return EQ; }
"<"         { return LT; }
">"         { return GT; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
";"         { return SEMI; }

[ \t\r\n]+  {  }

.           { fprintf(stderr, "Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
