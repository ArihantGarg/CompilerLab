%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);

int valid = 1;
int temp_count = 0;

char *new_temp() {
    char *temp = (char *)malloc(10 * sizeof(char));
    if (!temp) {
        printf(stderr, "Memory allocation error\n");
        exit(1);
    }
    printf("t%d", temp_count++);
    return temp;
}
%}

/* Define the union for semantic values */
%union {
    int intval;
    float floatval;
    char *str;
}

/* Token Declarations with Types */
%token PROG INT FLOAT IF THEN ELSE WHILE DO END PRINT SCAN
%token ASSIGN PLUS MINUS MUL DIV EQ LT GT LBRACE RBRACE LPAREN RPAREN SEMI OR AND NOT

/* Tokens with Semantic Values */
%token <str> ID STR
%token <intval> IC
%token <floatval> FC

/* Non-terminal Type Declarations */
%type <str> E T F PE
%type <str> ES IS WS IOS BE AE NE RE

/* Optional: Define precedence and associativity to resolve ambiguities */
%left OR
%left AND
%left NOT
%left EQ LT GT
%left PLUS MINUS
%left MUL DIV

/* Grammar Rules */
%%
P: PROG DL SL END
    {      
       
         printf("Program End\n"); 
    }
;

DL: D DL
    | /* empty */
;

D: TY VL SEMI 
;

TY: INT
    | FLOAT 
;

VL: ID VL
    | ID
;

SL: S SL
    | /* empty */
;

S: ES
 | IS
 | WS
 | IOS
;

/* Assignment Statement */
ES: ID ASSIGN E SEMI
    {   
        
        printf("%s := %s\n", $1, $3); 
    }
;

/* If Statement */
IS: IF BE THEN SL END
    { /* Handle IF without ELSE */ }
  | IF BE THEN SL ELSE SL END
    { /* Handle IF with ELSE */ }
;

/* While Statement */
WS: WHILE BE DO SL END
    { /* Handle WHILE Loop */ }
;

/* Input/Output Statements */
IOS: PRINT PE
    { 
        if ($2) {
            printf("PRINT %s\n", $2);
        }
    }
   | SCAN ID
    { 
        printf("SCAN %s\n", $2); 
    }
;

/* Print Expression */
PE: E
    | STR
;

/* Boolean Expressions */
BE: BE OR AE
    { /* Handle logical OR */ }
  | AE
    { /* Handle single AE */ }
;

AE: AE AND NE
    { /* Handle logical AND */ }
  | NE
    { /* Handle single NE */ }
;

NE: NOT NE
    { /* Handle logical NOT */ }
  | LBRACE BE RBRACE
    { /* Handle parenthesized BE */ }
  | RE
    { /* Handle relational expressions */ }
;

/* Relational Expressions */
RE: E EQ E
    { /* Handle equality */ }
  | E LT E
    { /* Handle less than */ }
  | E GT E
    { /* Handle greater than */ }
;

/* Expressions */
E: E PLUS T
    { 
        char *temp = new_temp(); 
        printf("%s := %s + %s\n", temp, $1, $3); 
        $$ = temp; 
    }
 | E MINUS T
    { 
        char *temp = new_temp(); 
        printf("%s := %s - %s\n", temp, $1, $3); 
        $$ = temp; 
    }
 | T
    { $$ = $1; }
;

/* Terms */
T: T MUL F
    { 
        char *temp = new_temp(); 
        printf("%s := %s * %s\n", temp, $1, $3); 
        $$ = temp; 
    }
 | T DIV F
    { 
        char *temp = new_temp(); 
        printf("%s := %s / %s\n", temp, $1, $3); 
        $$ = temp; 
    }
 | F
    { $$ = $1; }
;

/* Factors */
F: LPAREN E RPAREN
    { $$ = $2; }
 | ID
    { 
        $$ = strdup($1); 
    }
 | IC
    { 
        char *temp = new_temp(); 
        printf("%s := %d\n", temp, $1); 
        $$ = temp; 
    }
 | FC
    { 
        char *temp = new_temp(); 
        printf("%s := %f\n", temp, $1); 
        $$ = temp; 
    }
;
%%

/* Error Handling Function */
void yyerror(const char *s) {
    valid = 0;
    printf(stderr, "Error: %s\n", s);
    //exit(1);
}

/* Main Function */
int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    }
    yyparse();
    return 0;
}
