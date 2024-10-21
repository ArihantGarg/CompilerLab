%{
    #include "parser.tab.h" 
%}

%%

[0-9]+      { yylval.intVal = atoi(yytext); return NUMBER; }
[ \t\n]+    { /* ignore whitespace */ }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }
"("         { return LPAREN; }
")"         { return RPAREN; }

.           { return 0; }

%%

int yywrap() {
    return 1;
}
