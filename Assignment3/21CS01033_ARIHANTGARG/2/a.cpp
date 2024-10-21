#include <bits/stdc++.h>
using namespace std;

set<char> nonTerminals;
vector<pair<string, vector<vector<string>>>> grammar;

string generateNonTerminal() { // Generates new nonTerminal
    string s = {*nonTerminals.begin()};
    s += "'";
    nonTerminals.erase(nonTerminals.begin());
    return s;
}

void parseProduction(string s) {
    vector<vector<string>> rules;
    vector<string> temp;

    for(int i = 3; i < s.size(); i++) {
        if(s[i] == '|') {
            rules.push_back(temp);
            temp.clear();
        } else {
            temp.push_back({s[i]});
        }
    }
    if(!temp.empty())
        rules.push_back(temp);
    
    grammar.push_back({{s[0]}, rules});
}

void printGrammar() {
    cout<<"\n";
    for(auto i : grammar) {
        cout << i.first << " -> ";
        for(int j = 0; j < i.second.size(); j++) {
            for(auto k : i.second[j]) {
                cout << k;
            }
            if(j != i.second.size() - 1)
                cout << " | ";
        }
        cout << endl;
    }
    cout<<"\n";
}

void leftFactorGrammar() {
    for(int z = 0; z < grammar.size(); z++) {
        vector<vector<string>> rhs = grammar[z].second;
        sort(rhs.begin(), rhs.end());

        vector<vector<string>> modifiedRules;
        vector<vector<int>> groups;

        int start = 0, size = 1, prefixLength = 1;
        for(int j = 1; j < rhs.size(); j++) {
            if(rhs[j][0] == rhs[j-1][0]) {
                size++;
            } else {
                groups.push_back({start, size, prefixLength});
                start = j;
                size = 1;
            }
        }
        groups.push_back({start, size, prefixLength});

        for(int j = 0; j < groups.size(); j++) {

            int s = groups[j][0];
            int size = groups[j][1];
            int prefixLength = groups[j][2];

            vector<string> prefixString = {rhs[s][0]};

            if(size == 1) {
                modifiedRules.push_back(rhs[s]);
            } else {
                while(1) {
                    bool match = true;
                    for(int k = s + 1; k <= s + size - 1; k++) {
                        if(prefixLength >= rhs[k].size() || prefixLength >= rhs[k-1].size()) {
                            match = false;
                            break;
                        }
                        if(rhs[k][prefixLength] != rhs[k-1][prefixLength]) {
                            match = false;
                            break;
                        }
                    }
                    if(!match)
                        break;
                    
                    prefixString.push_back(rhs[s][prefixLength]);
                    prefixLength++;
                }

                groups[j][2] = prefixLength;
                string newNonTerminal = generateNonTerminal();
                prefixString.push_back(newNonTerminal);
                modifiedRules.push_back(prefixString);
                
                vector<vector<string>> newRules;
                for(int k = s; k <= s + size - 1; k++) {
                    vector<string> tmp;
                    for(int l = prefixLength; l < rhs[k].size(); l++) {
                        tmp.push_back(rhs[k][l]);
                    }
                    newRules.push_back(tmp);
                }
                grammar.push_back({newNonTerminal, newRules});     
            }
        }   
        grammar[z].second = modifiedRules;
    }
}

int main() {
    for(char ch = 'A'; ch <= 'Z'; ch++) {
        nonTerminals.insert(ch);
    }
    ifstream inFile("input.txt");
    string num;
    getline(inFile, num);
    int n = stoi(num);
    fflush(stdin);
    string s;
    while(n--) {
        getline(inFile, s);
        parseProduction(s);
    }  
    cout << "Input CFG - " << endl;
    printGrammar();
    leftFactorGrammar();
    cout << "Left Factored Grammar -  " << endl;
    printGrammar();
}


/*

Different Input Testcases

1
A->aAB|aBc|aAc

3
Z->Y
A->bAB|bBc|bAc|aCV|cDF|cEF
B->bcD|bcG


3
A->aabc|aCbb|aabz|aCbz
B->bba|efg|bbf
C->cdf|cgi|def

*/
