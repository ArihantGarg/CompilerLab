%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SUBEXPR 100

int yylex(void);
void yyerror(const char *s);
struct DAGNode* getOrCreateNode(char op, struct DAGNode* left, struct DAGNode* right, int value);
void printDAG(struct DAGNode* root);
void clearSubexprMap(void);

struct DAGNode* subexpr_map[MAX_SUBEXPR];
int subexpr_map_size = 0;
int node_counter = 1;

struct DAGNode {
    char op;
    struct DAGNode *left, *right;
    int value;
    char name[10];
    int visited;
};

struct DAGNode* createNode(char op, struct DAGNode* left, struct DAGNode* right, int value) {
    struct DAGNode* node = (struct DAGNode*)malloc(sizeof(struct DAGNode));
    if (node == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    node->op = op;
    node->left = left;
    node->right = right;
    node->value = value;
    node->visited = 0;
    snprintf(node->name, sizeof(node->name), "N%d", node_counter++);
    return node;
}

int compareNodes(struct DAGNode* a, struct DAGNode* b) {
    if (a == NULL && b == NULL) return 1;
    if (a == NULL || b == NULL) return 0;
    if (a->op == b->op && a->value == b->value) {
        return compareNodes(a->left, b->left) && compareNodes(a->right, b->right);
    }
    return 0;
}

struct DAGNode* getOrCreateNode(char op, struct DAGNode* left, struct DAGNode* right, int value) {
    struct DAGNode temp = {op, left, right, value, "", 0};
    for (int i = 0; i < subexpr_map_size; i++) {
        if (compareNodes(subexpr_map[i], &temp)) {
            return subexpr_map[i];
        }
    }
    struct DAGNode* newNode = createNode(op, left, right, value);
    if (subexpr_map_size < MAX_SUBEXPR) {
        subexpr_map[subexpr_map_size++] = newNode;
    } else {
        fprintf(stderr, "Subexpression map is full\n");
        exit(1);
    }
    return newNode;
}

void printNode(struct DAGNode* node) {
    if (node == NULL) return;
    if (node->op == '\0') {
        printf("%s(%d)", node->name, node->value);
    } else {
        printf("%s(%c)", node->name, node->op);
    }
}

void printDAG(struct DAGNode* root) {
    if (root == NULL) return;
    printNode(root);
    printf(" -> ");
    if (root->left != NULL) {
        printNode(root->left);
    } else {
        printf("NULL");
    }
    printf(", ");
    if (root->right != NULL) {
        printNode(root->right);
    } else {
        printf("NULL");
    }
    printf("\n");
    printDAG(root->left);
    printDAG(root->right);
}

void freeDAG(struct DAGNode* root) {
    if (root == NULL || root->visited) return;
    root->visited = 1;
    freeDAG(root->left);
    freeDAG(root->right);
    free(root);
}

void clearSubexprMap() {
    for (int i = 0; i < subexpr_map_size; i++) {
        freeDAG(subexpr_map[i]);
        subexpr_map[i] = NULL;
    }
    subexpr_map_size = 0;
}
%}

%union {
    int intVal;
    struct DAGNode* node;
}

%token <intVal> NUMBER
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

%type <node> expr term factor

%%

input: 
    expr { printf("DAG generated. In-order traversal:\n"); printDAG($1); clearSubexprMap(); printf("\n"); }
    ;

expr:
    expr PLUS term { $$ = getOrCreateNode('+', $1, $3, 0); }
    | expr MINUS term { $$ = getOrCreateNode('-', $1, $3, 0); }
    | term { $$ = $1; }
    ;

term:
    term TIMES factor { $$ = getOrCreateNode('*', $1, $3, 0); }
    | term DIVIDE factor { $$ = getOrCreateNode('/', $1, $3, 0); }
    | factor { $$ = $1; }
    ;

factor:
    LPAREN expr RPAREN { $$ = $2; }
    | NUMBER { $$ = getOrCreateNode('\0', NULL, NULL, $1); }
    ;

%%

int main() {
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
