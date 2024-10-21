%{
    #include<stdio.h>
%}

%%

(.){7,} {printf("No");}
(.){1,5} {printf("No");}
([a-c]*)(a){2}([a-c]*)(b){2}([a-c]*) {printf("No");}
([a-c]*)(b){2}([a-c]*)(a){2}([a-c]*) {printf("No");}
([a-c]*)(a){2}([a-c]*) {printf("Yes");}
([a-c]*)(b){2}([a-c]*) {printf("Yes");}
.* {printf("No");}

%%

int yywrap(){}

int main()
{
    yylex();

    return 0;
}
