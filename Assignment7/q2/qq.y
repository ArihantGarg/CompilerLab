%{
#include <stdio.h>
#include <stdlib.h>

// Function prototype for the lexer
int yylex(void);
void yyerror(const char *s);

// Define YYSTYPE as a union
#define YYSTYPE_IS_DECLARED 1
typedef union {
    double val;
} YYSTYPE;

extern YYSTYPE yylval;
%}

%union {
    double val;
}

%token <val> NUMBER
%type <val> S E T F
%left '+' '-'
%left '*' '/'
%right UMINUS  // For handling unary minus

%%

/* Grammar rules and actions */

S: E { printf("Result = %lf\n", $1); }
;

E: E '+' T { $$ = $1 + $3; }
 | E '-' T { $$ = $1 - $3; }
 | T       { $$ = $1; }
;

T: T '*' F { $$ = $1 * $3; }
 | T '/' F { if ($3 == 0) {
                yyerror("Division by zero error");
                YYABORT;
            }
            $$ = $1 / $3;
          }
 | F       { $$ = $1; }
;

F: '(' E ')' { $$ = $2; }
 | '-' F %prec UMINUS { $$ = -$2; }  // Handle unary minus
 | NUMBER { $$ = $1; }
;

%%

/* Error handling function */
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

/* Main function */
int main(void) {
    printf("Enter an arithmetic expression:\n");
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    }
    return 0;
}
