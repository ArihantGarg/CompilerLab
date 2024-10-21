#include <iostream>
#include <string>
#include <sstream>
#include <vector>

using namespace std;

int temp_count = 0; // Counter for temporary variables

// Generate new temporary variable
string new_temp() {
    return "t" + to_string(temp_count++);
}

// Emit three-address code
void emit(string result, string arg1, string op, string arg2) {
    cout << result << " = " << arg1 << " " << op << " " << arg2 << endl;
}

enum TokenType { ID, PLUS, MINUS, MUL, DIV, LPAREN, RPAREN, END };

struct Token {
    TokenType type;
    string value;
};

vector<Token> tokens;
int current_token = 0;

// Function to get the current token
Token peek() {
    return tokens[current_token];
}

// Function to consume a token
Token next_token() {
    return tokens[current_token++];
}

// Parser Functions
void E(string& addr);
void T(string& addr);
void F(string& addr);

// E -> T ( + T | - T )*
void E(string& addr) {
    T(addr);
    Token token = peek();
    while (token.type == PLUS || token.type == MINUS) {
        next_token();
        string T_addr;
        T(T_addr);
        string temp = new_temp();
        string op = (token.type == PLUS) ? "+" : "-";
        emit(temp, addr, op, T_addr);
        addr = temp;
        token = peek();
    }
}

// T -> F ( * F | / F )*
void T(string& addr) {
    F(addr);
    Token token = peek();
    while (token.type == MUL || token.type == DIV) {
        next_token();
        string F_addr;
        F(F_addr);
        string temp = new_temp();
        string op = (token.type == MUL) ? "*" : "/";
        emit(temp, addr, op, F_addr);
        addr = temp;
        token = peek();
    }
}

// F -> id | ( E )
void F(string& addr) {
    Token token = next_token();
    if (token.type == ID) {
        addr = token.value;
    } else if (token.type == LPAREN) {
        E(addr);
        if (next_token().type != RPAREN) {
            cout << "Error: Mismatched parentheses" << endl;
        }
    }
}

// Tokenize the input expression
void tokenize(string input) {
    stringstream ss(input);
    char ch;
    while (ss >> ch) {
        if (isalpha(ch)) {
            tokens.push_back({ID, string(1, ch)});
        } else if (ch == '+') {
            tokens.push_back({PLUS, "+"});
        } else if (ch == '-') {
            tokens.push_back({MINUS, "-"});
        } else if (ch == '*') {
            tokens.push_back({MUL, "*"});
        } else if (ch == '/') {
            tokens.push_back({DIV, "/"});
        } else if (ch == '(') {
            tokens.push_back({LPAREN, "("});
        } else if (ch == ')') {
            tokens.push_back({RPAREN, ")"});
        }
    }
    tokens.push_back({END, ""});
}

int main() {
    string input;
    cout << "Enter expression: ";
    getline(cin, input);
    
    tokenize(input);

    string addr;
    E(addr);

    cout << "Final result stored in: " << addr << endl;

    return 0;
}
