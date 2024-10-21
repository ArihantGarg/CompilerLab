%{
    #include<stdio.h>
%}

%%

(0*1){6,}[01]* {printf("Yes,contains atleast 6 1's");}
[01]* {printf("No,does not contain 6 or more 1's");}
.* {printf("Not a binary string");}

%%

int yywrap(){}

int main()
{
    yylex();

    return 0;
}
