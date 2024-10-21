#include <iostream>
#include <string>
#include <vector>

using namespace std;

struct Node {
    string value;
    Node* left;
    Node* right;

    Node(string v) : value(v), left(nullptr), right(nullptr) {}
};

bool isOperator(char ch) {
    return ch == '+' || ch == '-' || ch == '*' || ch == '/';
}


int findLowestPrecedenceOp(const string& expr) {
    int pos = -1;
    int precedence = 3; 
    int cntBracket = 0;

    for (int i = expr.length(); i >= 0; i--) {

        if (expr[i] == ')') {
            cntBracket++;
        } else if (expr[i] == '(') {
            cntBracket--;
        }

        if (cntBracket == 0 && (expr[i] == '+' || expr[i] == '-')) {
            if (precedence >= 1) {
                precedence = 1;
                pos = i;
                break;
            }
        } else if (cntBracket == 0 && (expr[i] == '*' || expr[i] == '/')) {
            if (precedence >= 2) {
                precedence = 2;
                pos = i;
            }
        }
    }
    return pos;
}


Node* buildAST(string expr) {
    
    while (!expr.empty() && expr[0] == ' ') expr.erase(0, 1);
    while (!expr.empty() && expr[expr.length() - 1] == ' ') expr.pop_back();

    while (expr.length() > 1 && expr[0] == '(' && expr[expr.length()-1] == ')') {
        expr.erase(0, 1);
        expr.pop_back();
    }
    
    if (expr.empty() || !isOperator(expr[0]) && expr.find_first_of("+-*/") == string::npos) {
        return new Node(expr);
    }

    
    int opPos = findLowestPrecedenceOp(expr);
    if (opPos == -1) {
        return new Node(expr); 
    }

    string leftExpr = expr.substr(0, opPos);
    string rightExpr = expr.substr(opPos + 1);

    Node* root = new Node(string(1, expr[opPos]));

    root->left = buildAST(leftExpr);
    root->right = buildAST(rightExpr);

    return root;
}

void printAST(Node* root) {
    if (root == nullptr) return;
    if (root->left != nullptr) cout << "(";
    printAST(root->left);
    cout << root->value;
    printAST(root->right);
    if (root->right != nullptr) cout << ")";
}

int main() {
    string expression;
    cout << "Enter an expression: ";
    getline(cin, expression);

    Node* astRoot = buildAST(expression);
    
    cout << "The inorder traversal of AST for the expression is: ";
    printAST(astRoot);
    cout << endl;

    return 0;
}