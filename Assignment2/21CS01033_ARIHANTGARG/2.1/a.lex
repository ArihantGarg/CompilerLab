%{
    #include<stdio.h>

    void printSymbol(char token[])
    {
        for(int i=0;i<strlen(token);i++)
        {
            if(token[i]>='0' && token[i]<='9')
            {
                printf("%c",token[i]);
            }
            else if(token[i]!='.' && token[i]!='-')
            {
                // Special Character
            }
            else
                printf("%c",token[i]);
        }
    }
%}

%%

(-?)([0-9]*) {printf("Integer");}
(-?)([0-9]*)(\.)([0-9]*) {printf("Float");}
(-?)([0-9])(.*) {printf("Integer with illegal symbols : ");printSymbol(yytext);}
(')(.)(') {printf("Character constant");}
(')(') {printf("Character constant");}
(\")(.*)(\") {printf("String constant");}
.* {printf("Invalid input");}

%%

int yywrap(){}

int main()
{
    yylex();

    return 0;
}
