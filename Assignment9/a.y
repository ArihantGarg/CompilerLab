%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int temp_count = 0;

// Generate new temporary variable
char* new_temp() {
    char* temp = (char*) malloc(10 * sizeof(char));
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

// Emit three-address code
void emit(char* result, char* arg1, char* op, char* arg2) {
    printf("%s = %s %s %s\n", result, arg1, op, arg2);
}

%}

%union {
    char* string;
}

%token <string> ID
%token PLUS MINUS MUL DIV LPAREN RPAREN
%type <string> expr term factor

%%

input:
    expr { printf("Final result stored in: %s\n", $1); }
;

expr:
    term { $$ = $1; }
    | expr PLUS term {
        char* temp = new_temp();
        emit(temp, $1, "+", $3);
        $$ = temp;
    }
    | expr MINUS term {
        char* temp = new_temp();
        emit(temp, $1, "-", $3);
        $$ = temp;
    }
;

term:
    factor { $$ = $1; }
    | term MUL factor {
        char* temp = new_temp();
        emit(temp, $1, "*", $3);
        $$ = temp;
    }
    | term DIV factor {
        char* temp = new_temp();
        emit(temp, $1, "/", $3);
        $$ = temp;
    }
;

factor:
    ID {
        $$ = strdup($1); // Identifier address is just the lexeme
    }
    | LPAREN expr RPAREN {
        $$ = $2; // Expression inside parentheses
    }
;

%%

int main() {
    printf("Lex Code\n");
    printf("Enter expression: ");
    yyparse();
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
