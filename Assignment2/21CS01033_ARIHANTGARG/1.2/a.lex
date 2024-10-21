%{
    #include<stdio.h>
%}

%%

c[a-zA-Z0-9]*r {printf("Yes,string starts with c and ends with r");}
[a-zA-Z0-9]* {printf("No,string does not start with c and end with r");}
.* {printf("Not an alphanumeric string");}

%%

int yywrap(){}

int main()
{
    yylex();

    return 0;
}
