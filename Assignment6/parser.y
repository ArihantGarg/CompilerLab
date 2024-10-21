%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int yylex();
void yyerror(char *s);

%}

%token id mul add startb endb
%start E

%%

E
	:	E add T 
	| T
	;
	
T
	:	T mul F
	| F
	;

F
	:	startb E endb
	| id	
	;

%%

extern int yylex();
extern int yyparse();
extern int line_num;

void yyerror(char *s){
	printf("Error: %s\n",s);
	exit(-1);
}

int main(){
	yyparse();
	printf("Accepted\n");
	return 0;
}
