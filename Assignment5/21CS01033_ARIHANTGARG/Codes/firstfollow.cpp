#include <bits/stdc++.h>
#include "function.hpp"
using namespace std;

string inputFileName = "../Input/inputgrammar.txt";
vector<string> nonterminals;
vector<string> terminals;
string startSymbol;
map<string,vector<vector<string>>> productions;

set<string> nonterminalsSet;
set<string> terminalsSet;

// Function to add the elements of one set to another
void addToSet(set<string> &dest, const set<string> &src) {
    dest.insert(src.begin(), src.end());
}

// Function to compute the FIRST set for a given symbol
void computeFIRST(string symbol, map<string, vector<vector<string>>> &productions, map<string, set<string>> &FIRST) {
    for(vector<string> production: productions[symbol])
    {
        int curIndex = 0;
        bool epsilonFlag = true;

        while(curIndex<production.size())
        {
            if(nonterminalsSet.find(production[curIndex])!=nonterminalsSet.end())
            {
                set<string> temp = FIRST[production[curIndex]];
                if(temp.find("e")!=temp.end())
                {
                    temp.erase("e");
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
            FIRST[symbol].insert("e");
        }
    }
}

void computeFOLLOW(string symbol, map<string, vector<vector<string>>> &productions, map<string, set<string>> &FIRST, map<string, set<string>> &FOLLOW)
{
    for(vector<string> production: productions[symbol])
    {
        int curIndex = 0;
        set<string> currentNonTerminals;

        while(curIndex<production.size())
        {
            if(nonterminalsSet.find(production[curIndex])!=nonterminalsSet.end())
            {
                set<string> temp = FIRST[production[curIndex]];
                if(temp.find("e")!=temp.end())
                {
                    temp.erase("e");
                    for(auto c:currentNonTerminals)
                    {
                        addToSet(FOLLOW[c], temp);
                    }
                }
                else
                {
                    for(auto c:currentNonTerminals)
                    {
                        addToSet(FOLLOW[c], temp);
                    }

                    currentNonTerminals.clear();
                }

                currentNonTerminals.insert(production[curIndex]);
            }
            else if(production[curIndex]!="e")
            {
                for(auto c:currentNonTerminals)
                {
                    FOLLOW[c].insert(production[curIndex]);
                }

                currentNonTerminals.clear();
            }

            curIndex++;
        }

        for(auto c:currentNonTerminals)
        {
            addToSet(FOLLOW[c], FOLLOW[symbol]);
        }
    }
}

int main() {
    
    inputGrammar(inputFileName,nonterminals,terminals,startSymbol,productions);

    terminals.push_back("$");
    terminals.push_back("e");

    for(auto nonterminal:nonterminals)
    {
        nonterminalsSet.insert(nonterminal);
    }

    for(auto terminal:terminals)
    {
        terminalsSet.insert(terminal);
    }

    map<string, set<string>> FIRST;
    for(auto x:nonterminals)
    {
        FIRST[x]={};
    }

    // Compute FIRST sets for all non-terminals
    for(int i=0;i<productions.size();i++)
    {
        for (auto &entry : productions) {
            computeFIRST(entry.first, productions, FIRST);
        }
    }

    // Display the FIRST sets
    outputSet("../Input/inputfirst.txt",FIRST);

    // FOLLOW SET CALCULATION

    map<string, set<string>> FOLLOW;
    for(auto x:nonterminals)
    {
        FOLLOW[x]={};
    }

    // First pushing '$' to the start symbol

    FOLLOW[startSymbol].insert("$");

    // Now we will iterate over all the productions and calculate the follow set for each non-terminal

    for(int i=0;i<productions.size();i++)
    {
        
        for(auto &entry: productions)
        {
            computeFOLLOW(entry.first, productions, FIRST , FOLLOW);
        }
    }

    // Display the FOLLOW sets
    outputSet("../Input/inputfollow.txt",FOLLOW);

    return 0;
}
