%{ 
    #include <stdio.h> 
    #include <stdlib.h>
    #include <string.h>
    #include "lex.yy.c"
    int flag=0; 
    
    void yyerror(char *str);
    void new_variable();
    int new_line_label();
    
    int variable_count = 0;
    int line_label_count = 0;
    
    char variable[10];
    int else_ref = 0;
    int if_true_ref = 10;  
    int while_ref = 0;
    int while_false_ref = 0;
    FILE *outfile ; 
%} 

/* Definitions */

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
          fprintf(outfile, "      exit\n"); 
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
          fprintf(outfile, "      %s = %s\n", $1, $3); 
      }
      ;

IS      : IF BE {

        new_variable();
        else_ref = new_line_label();
        fprintf(outfile, "      %s = %s\n", variable, $2);
        fprintf(outfile, "      If ! (%s) goto L%d\n", variable, else_ref);
        
      } 
      THEN SL elsePart END; 
elsePart: ELSE {

        if_true_ref = new_line_label();
        fprintf(outfile, "      goto L%d\n", if_true_ref);
        fprintf(outfile, " L%d : \n", else_ref);
        else_ref--;
         
      }
      SL { 

          fprintf(outfile, " L%d : \n", if_true_ref); 
      }
      | { 
          fprintf(outfile, " L%d : \n", else_ref); 
          else_ref--;
      }
      ;

WS      : WHILE {
            
        while_ref = new_line_label();
        fprintf(outfile, " L%d : \n", while_ref);   
      }
      BE {
            
        while_false_ref = new_line_label();
        fprintf(outfile, "      If ! (%s) goto L%d\n", $3, while_false_ref); 
        
      }
      DO SL {

        fprintf(outfile, "      goto L%d\n", while_ref); 
        fprintf(outfile, " L%d : \n", while_false_ref);
        while_false_ref-=1;
        while_ref-=1;
        
      }
    
      END
      ;

IOS     : PRINT PE
      {
          fprintf(outfile, "      print %s\n", $2);
      }
      | SCAN ID
      {
          new_variable();
          fprintf(outfile, "      %s = scan()\n", $2);
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
          new_variable();
          fprintf(outfile, "      %s = %s or %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | AE
      {
          strcpy($$, $1);
      }
      ;

AE      : AE AND NE
      {
          new_variable();
          fprintf(outfile, "      %s = %s and %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | NE
      {
          strcpy($$, $1);
      }
      ;

NE      : NOT NE
      {
          new_variable();
          fprintf(outfile, "      %s = not %s\n", variable, $2);
          strcpy($$, variable);
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
          new_variable();
          fprintf(outfile, "      %s = %s == %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | E LT E
      {
          new_variable();
          fprintf(outfile, "      %s = %s < %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | E GT E
      {
          new_variable();
          fprintf(outfile, "      %s = %s > %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      ;

E       : E PLUS T
      {
          new_variable();
          fprintf(outfile, "      %s = %s + %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | E MINUS T
      {
          new_variable();
          fprintf(outfile, "      %s = %s - %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | T
      {
          strcpy($$, $1);
      }
      ;

T       : T MULT F
      {
          new_variable();
          fprintf(outfile, "      %s = %s * %s\n", variable, $1, $3);
          strcpy($$, variable);
      }
      | T DIV F
      {
          new_variable();
          fprintf(outfile, "       %s = %s / %s\n", variable, $1, $3);
          strcpy($$, variable);
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
    extern FILE *yyin;
    yyin = fopen("Input/input.txt", "r");

    if (yyin == NULL)
    {
      printf("Could not open input file\n");
      return -1;
    }

    outfile = fopen("Output/output.txt", "w");
    printf("Three Address Code is:\n\n");
    yyparse();
    if (flag == 0)
    {
      printf("Program parsed Successfully\n");
    }
}

void yyerror(char *str)
{
    printf("\nError at Line: %d -- %s\n", yylineno, str);
    flag = 1;
}

void new_variable()
{
    char res[10];
    sprintf(res, "T%d", variable_count++);
    strcpy(variable, res);
}

int new_line_label()
{
    int res = line_label_count++;
    return res;
}
