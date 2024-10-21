#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <string>
#include <algorithm>

using namespace std;

vector<string> split(const string &str, char delimiter) {
    vector<string> tokens;
    stringstream ss(str);
    string token;
    while (getline(ss, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

void removeLeftRecursion(const string &nonTerminal, vector<string> &productions, unordered_map<string, vector<string>> &newProductions) {
    vector<string> alpha, beta;
    for (const string &prod : productions) {
        if (prod[0] == nonTerminal[0]) { // Left recursion
            alpha.push_back(prod.substr(1)); // Remove the non-terminal from the left side
        } else {
            beta.push_back(prod);
        }
    }

    if (alpha.empty()) {
        newProductions[nonTerminal] = productions; // No left recursion
        return;
    }

    string newNonTerminal = nonTerminal + "'";

    for (string &b : beta) {
        newProductions[nonTerminal].push_back(b + newNonTerminal);
    }

    for (string &a : alpha) {
        newProductions[newNonTerminal].push_back(a + newNonTerminal);
    }

    newProductions[newNonTerminal].push_back("e"); // Add epsilon production
}

void leftFactor(unordered_map<string, vector<string>> &productions) {
    bool changes = true;

    while (changes) {
        changes = false;

        for (auto &prodPair : productions) {
            string nonTerminal = prodPair.first;
            vector<string> &prods = prodPair.second;

            unordered_map<string, vector<string>> prefixMap;

            for (string &prod : prods) {
                string prefix = prod.substr(0, 1);
                prefixMap[prefix].push_back(prod);
            }

            if (prefixMap.size() == 1) {
                continue;
            }

            for (auto &prefixPair : prefixMap) {
                if (prefixPair.second.size() > 1) {
                    changes = true;
                    string newNonTerminal = nonTerminal + "'";
                    vector<string> newProds;

                    for (string &prod : prefixPair.second) {
                        newProds.push_back(prod.substr(1));
                    }

                    productions[newNonTerminal] = newProds;

                    for (auto &prod : prods) {
                        if (prod.substr(0, 1) == prefixPair.first) {
                            prod = prefixPair.first + newNonTerminal;
                        }
                    }

                    break;
                }
            }
        }
    }
}

int main() {
    ifstream grammarFile("Grammar.txt");
    ofstream outputFile("grammarLL.txt");

    unordered_map<string, vector<string>> productions;
    string line;

    // Step 1: Read the grammar from the file
    while (getline(grammarFile, line)) {
        auto parts = split(line, '-');
        string nonTerminal = parts[0];
        string rightSide = split(parts[1], '>')[1];

        vector<string> prodList = split(rightSide, '|');
        for (string &prod : prodList) {
            productions[nonTerminal].push_back(prod);
        }
    }

    // Step 2: Remove left recursion
    unordered_map<string, vector<string>> newProductions;
    for (auto &prodPair : productions) {
        removeLeftRecursion(prodPair.first, prodPair.second, newProductions);
    }

    // Step 3: Left factoring
    leftFactor(newProductions);

    // Step 4: Write the LL(1) grammar to the output file
    for (auto &prodPair : newProductions) {
        outputFile << prodPair.first << " -> ";
        for (size_t i = 0; i < prodPair.second.size(); ++i) {
            if (i > 0) outputFile << " | ";
            outputFile << prodPair.second[i];
        }
        outputFile << endl;
    }

    grammarFile.close();
    outputFile.close();

    cout << "Transformed grammar has been saved to grammarLL.txt" << endl;

    return 0;
}
