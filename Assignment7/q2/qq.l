%{
#include "y.tab.h"  // Required to use YACC token definitions
#include <stdlib.h> // Required for atof

// Declare yylval as an external variable
extern YYSTYPE yylval;
%}

%%

[0-9]+(\.[0-9]+)?  { yylval.val = atof(yytext); return NUMBER; }  // Integer or floating-point numbers
[ \t]+           ;                   // Ignore whitespace
"+"                { return '+'; }
"-"                { return '-'; }
"*"                { return '*'; }
"/"                { return '/'; }
"("                { return '('; }
")"                { return ')'; }
"\n"                { return 0; }
.                  { printf("Unknown character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
