%{
#include "y.tab.h"
%}

%%

[a-zA-Z]      { yylval.string = strdup(yytext); return ID; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MUL; }
"/"           { return DIV; }
"("           { return LPAREN; }
")"           { return RPAREN; }
[ \t\n]       { /* ignore whitespaces */ }
.             { /* error */ }

%%

int yywrap() {
    return 1;
}
