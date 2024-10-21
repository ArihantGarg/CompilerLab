#include <iostream>
#include <map>
#include <set>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

// Function to add the elements of one set to another
void addToSet(set<char> &dest, const set<char> &src) {
    dest.insert(src.begin(), src.end());
}

// Function to compute the FIRST set for a given symbol
void computeFIRST(char symbol, map<char, vector<string>> &productions, map<char, set<char>> &FIRST) {
    for(string production: productions[symbol])
    {
        int curIndex = 0;
        bool epsilonFlag = true;

        while(curIndex<production.size())
        {
            if(production[curIndex]>='A' && production[curIndex]<='Z')
            {
                set<char> temp = FIRST[production[curIndex]];
                if(temp.find('e')!=temp.end())
                {
                    temp.erase('e');
                    addToSet(FIRST[symbol], temp);
                    curIndex++;
                }
                else
                {
                    addToSet(FIRST[symbol], temp);
                    epsilonFlag=false;
                    break;
                }
            }
            else
            {
                epsilonFlag=false;
                FIRST[symbol].insert(production[curIndex]);
                break;
            }
        }

        if(epsilonFlag)
        {
            FIRST[symbol].insert('e');
        }
    }
}

int main() {
    int n;
    cout << "Enter the number of productions: ";
    cin >> n;
    cin.ignore(); // Ignore the newline character left by cin

    map<char, vector<string>> productions;
    cout << "Enter the productions (format: A -> B | C | e):" << endl;
    for (int i = 0; i < n; ++i) {
        string line;
        getline(cin, line);

        stringstream ss(line);
        char nonTerminal;
        string arrow, production;
        
        ss >> nonTerminal >> arrow; // Read the non-terminal and the '->'

        while (ss >> production) {
            if (production == "|") continue;
            productions[nonTerminal].push_back(production);
        }
    }

    map<char, set<char>> FIRST;

    // Compute FIRST sets for all non-terminals
    for(int i=0;i<productions.size();i++)
    {
        for (auto &entry : productions) {
            computeFIRST(entry.first, productions, FIRST);
        }
    }

    // Display the FIRST sets
    cout << "FIRST sets:" << endl;
    for (auto &entry : FIRST) {
        cout << "FIRST(" << entry.first << ") = { ";
        for (char ch : entry.second) {
            cout << ch << " ";
        }
        cout << "}" << endl;
    }

    return 0;
}
