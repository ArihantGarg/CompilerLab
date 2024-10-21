%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "y.tab.h"
int line_num = 1;
%}
%%

id {return id;}
\* {return mul;}
\+ {return add;}
\( {return startb;}
\) {return endb;}
[ ]* {}
\n {return yytext[0];}
%%

int yywrap(void) {return 1;}


