#include<bits/stdc++.h>
#include "function.hpp"
using namespace std;

int main()
{
    string inputFileName = "../Input/inputgrammar.txt";
    vector<string> nonterminals;
    vector<string> terminals;
    string startSymbol;
    map<string,vector<vector<string>>> productions;

    inputGrammar(inputFileName,nonterminals,terminals,startSymbol,productions);

    string outputFileName = "../output.txt";
    outputGrammar(outputFileName,nonterminals,terminals,startSymbol,productions);

    cout<<"Done"<<endl;
}