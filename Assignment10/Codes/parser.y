%{ 
    /* Assignment 10 */

    #include <stdio.h> 
    #include <stdlib.h>
    #include <string.h>
    #include "lex.yy.c"
    int errorFlag = 0; 
    
    void yyerror(char *str);
    void generate_new_variable();
    int create_new_line_label();
    
    int tempVariableCount = 0;  // Count of temporary variables
    int labelCount = 0;         // Count of line labels
    
    char tempVariable[10];      // Holds the name of the current temporary variable
    int elseConditionLabel = 0;   
    int ifTrueConditionLabel = 10;  
    int whileConditionLabel = 0;
    int whileFalseConditionLabel = 0;
    FILE *outputFile; 
    
%} 

/* Token definitions */

%token AND ASSIGN DO ELSE END EQ FLOAT IF INT LPAREN RPAREN LBRACE RBRACE
%token LT GT MINUS MULT DIV NOT OR PLUS PRINT PROG SCAN SEMICOLON THEN WHILE

%left OR
%left AND
%right NOT
%left PLUS MINUS
%left MULT DIV
%left LPAREN RPAREN
%nonassoc IF
%nonassoc ELSE

%start P

%union
{ 	
	char val[100];
}
   
%type <val> E T F BE AE NE RE PE
%token <val> ID IC FC STR


/* Rule Section */
%% 
P       : PROG DL SL END 
      { 
          fprintf(outputFile, "      exit\n"); 
      }
      ;

DL      : D DL 
      | /* empty */
      ;

D       : TY VL SEMICOLON
      ;

TY      : INT 
      | FLOAT
      ;

VL      : ID VL 
      | ID
      ;

SL      : S SL 
      | /* empty */
      ;

S       : ES 
      | IS 
      | WS 
      | IOS
      ;

ES      : ID ASSIGN E SEMICOLON 
      { 
          fprintf(outputFile, "      %s = %s\n", $1, $3); 
      }
      ;

IS      : IF BE {
        generate_new_variable();
        elseConditionLabel = create_new_line_label();
        fprintf(outputFile, "      %s = %s\n", tempVariable, $2);
        fprintf(outputFile, "      If ! (%s) goto L%d\n", tempVariable, elseConditionLabel);
      } 
      THEN SL elsePart END; 

elsePart: ELSE {
        ifTrueConditionLabel = create_new_line_label();
        fprintf(outputFile, "      goto L%d\n", ifTrueConditionLabel);
        fprintf(outputFile, " L%d : \n", elseConditionLabel);
        elseConditionLabel--;
      }
      SL { 
          fprintf(outputFile, " L%d : \n", ifTrueConditionLabel); 
      }
      | { 
          fprintf(outputFile, " L%d : \n", elseConditionLabel); 
          elseConditionLabel--;
      }
      ;

WS      : WHILE {
        whileConditionLabel = create_new_line_label();
        fprintf(outputFile, " L%d : \n", whileConditionLabel);   
      }
      BE {
        whileFalseConditionLabel = create_new_line_label();
        fprintf(outputFile, "      If ! (%s) goto L%d\n", $3, whileFalseConditionLabel); 
      }
      DO SL {
        fprintf(outputFile, "      goto L%d\n", whileConditionLabel); 
        fprintf(outputFile, " L%d : \n", whileFalseConditionLabel);
        whileFalseConditionLabel-=1;
        whileConditionLabel-=1;
      }
      END
      ;

IOS     : PRINT PE
      {
          fprintf(outputFile, "      print %s\n", $2);
      }
      | SCAN ID
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = scan()\n", $2);
      }
      ;

PE      : E
      { 
          strcpy($$, $1);
      }
      | STR
      { 
          strcpy($$, $1);
      }
      ;

BE      : BE OR AE
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s or %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | AE
      {
          strcpy($$, $1);
      }
      ;

AE      : AE AND NE
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s and %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | NE
      {
          strcpy($$, $1);
      }
      ;

NE      : NOT NE
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = not %s\n", tempVariable, $2);
          strcpy($$, tempVariable);
      }
      | LBRACE BE RBRACE
      {
          strcpy($$, $2);
      }
      | RE
      {
          strcpy($$, $1);
      }
      ;

RE      : E EQ E
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s == %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | E LT E
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s < %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | E GT E
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s > %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      ;

E       : E PLUS T
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s + %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | E MINUS T
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s - %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | T
      {
          strcpy($$, $1);
      }
      ;

T       : T MULT F
      {
          generate_new_variable();
          fprintf(outputFile, "      %s = %s * %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | T DIV F
      {
          generate_new_variable();
          fprintf(outputFile, "       %s = %s / %s\n", tempVariable, $1, $3);
          strcpy($$, tempVariable);
      }
      | F
      {
          strcpy($$, $1);
      }
      ;

F       : LPAREN E RPAREN
      {
          strcpy($$, $2);
      }
      | ID
      {
          strcpy($$, $1);
      }
      | IC
      {
          strcpy($$, $1);
      }
      | FC
      {
          strcpy($$, $1);
      }
      ;

%%


int main()
{
    extern FILE *yyin;                              // Input and output files
    yyin = fopen("Input/input.txt", "r");
    outputFile = fopen("Output/output.txt", "w");
    fprintf(outputFile,"This is the final resulting Three Address Code from the given input:\n");
    fprintf(outputFile,"TAC Code:\n\n");

    yyparse();                                     // Parsing input file

    if (errorFlag == 0)
    {
      printf("Parsing Complete. Please check output file.\n");  // Successfully parsed
    }
    else
    {
        printf("Error\n");                              // Error
    }
}

void yyerror(char *str)
{
    printf("\nError at Line: %d -- %s\n", yylineno, str);
    errorFlag = 1;
}

void generate_new_variable()
{
    char result[10];
    sprintf(result, "T%d", tempVariableCount++);
    strcpy(tempVariable, result);
}

int create_new_line_label()
{
    int result = labelCount++;
    return result;
}
