#include <iostream>
#include <cstring>
using namespace std;

#define SUCCESS 1
#define FAILED 0

void E(), Edash(), T(), Tdash(), F();

const char *cursor;
char inputString[64];
bool isSuccess;

int main() {
    cout << "Enter the string: ";
    cin >> inputString;
    cursor = inputString;
    isSuccess = true;
    cout<<"\n Input : "<<inputString<<"\n";

    cout << "Action\n";
    cout << "--------------------------------\n";

    // Call the starting non-terminal E
    E();
    if (isSuccess && *cursor == '\0') { // If parsing is successful and the cursor has reached the end
        cout << "--------------------------------\n";
        cout << "YES\n";
    } 
    else {
        cout << "--------------------------------\n";
        cout << "NO\n";
    }

    return 0;
}

// Grammar rule: E -> T E'
void E() {
    if (!isSuccess) return; // Early return if already failed
    cout << " E -> T E'\n";
    T(); // Call non-terminal T
    Edash(); // Call non-terminal E'
}

// Grammar rule: E' -> + T E' | $
void Edash() {
    if (!isSuccess) return; // Early return if already failed
    if (*cursor == '+') {
        cout << " E' -> + T E'\n";
        cursor++;
        T(); // Call non-terminal T
        Edash(); // Call non-terminal E'
    }
    else {
        cout << " E' -> $\n";
    }
}

// Grammar rule: T -> F T'
void T() {
    if (!isSuccess) return; // Early return if already failed
    cout << " T -> F T'\n";
    F(); // Call non-terminal F
    Tdash(); // Call non-terminal T'
}

// Grammar rule: T' -> * F T' | $
void Tdash() {
    if (!isSuccess) return; // Early return if already failed
    if (*cursor == '*') {
        cout << " T' -> * F T'\n";
        cursor++;
        F(); // Call non-terminal F
        Tdash(); // Call non-terminal T'
    } 
    else {
        cout << " T' -> $\n";
    }
}

// Grammar rule: F -> ( E ) | id
void F() {
    if (!isSuccess) return; // Early return if already failed
    if (*cursor == '(') {
        cout << " F -> ( E )\n";
        cursor++;
        E(); // Call non-terminal E
        if (*cursor == ')') {
            cursor++;
        } 
        else {
            isSuccess = false; // Mark as failed
        }
    } 
    else if (*cursor == 'i' && *(cursor+1) == 'd') {
        cout << " F -> id\n";
        cursor++;
        cursor++;
    } 
    else {
        isSuccess = false; // Mark as failed
    }
}
