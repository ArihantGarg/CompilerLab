#include<bits/stdc++.h>
using namespace std;

void inputGrammar(string inputFileName,vector<string> &nonterminals,vector<string> &terminals,string &startSymbol,map<string,vector<vector<string>>> &productions)
{   
    ifstream fin(inputFileName);

    int nonTerminalsSize;
    fin>>nonTerminalsSize;

    for (int i = 0; i < nonTerminalsSize; ++i) {
        string nonTerminal;
        fin>>nonTerminal;
        nonterminals.push_back(nonTerminal);
    }

    int terminalsSize;
    fin>>terminalsSize;

    for (int i = 0; i < terminalsSize; ++i) {
        string terminal;
        fin>>terminal;
        terminals.push_back(terminal);
    }

    fin>>startSymbol;

    int numRules;
    fin>>numRules;

    fin.ignore(); // Ignore the newline character

    for (int i = 0; i < numRules; ++i) {
        string line;
        getline(fin, line);

        stringstream ss(line);
        string nonTerminal;
        string arrow;
        
        vector<string> curproduction;
        string curToken;
        
        ss >> nonTerminal >> arrow; // Read the non-terminal and the '->'

        while (ss >> curToken) {
            if (curToken == "|")
            {
                productions[nonTerminal].push_back(curproduction);
                curproduction.clear();
            }
            else
            {
                curproduction.push_back(curToken);
            }
        }

        productions[nonTerminal].push_back(curproduction);
    }
}

void outputGrammar(string outputFileName,vector<string> &nonterminals,vector<string> &terminals,string &startSymbol,map<string,vector<vector<string>>> &productions)
{
    ofstream fout(outputFileName);

    fout<<nonterminals.size()<<endl;
    for(auto nonterminal:nonterminals)
    {
        fout<<nonterminal<<" ";
    }
    fout<<endl;

    fout<<terminals.size()<<endl;
    for(auto terminal:terminals)
    {
        fout<<terminal<<" ";
    }
    fout<<endl;

    fout<<startSymbol<<endl;

    fout<<productions.size()<<endl;
    for(auto production:productions)
    {
        fout<<production.first<<" -> ";
        for(auto rule:production.second)
        {
            for(auto token:rule)
            {
                fout<<token<<" ";
            }
            if(rule!=production.second.back())
            {
                fout<<"| ";
            }
        }
        fout<<endl;
    }
}

void outputSet(string outputFileName,map<string, set<string>> &set)
{
    ofstream fout(outputFileName);

    fout<<set.size()<<"\n";

    for(auto [nonterminal, tokens]:set)
    {
        fout<<nonterminal<<" "<<tokens.size()<<"\n";
        for(auto token:tokens)
        {
            fout<<token<<" ";
        }
        fout<<"\n";
    }
}

void inputSet(string inputFileName,map<string, set<string>> &set)
{
    ifstream fin(inputFileName);

    int setSize;
    fin>>setSize;

    for (int i = 0; i < setSize; ++i) {
        string nonTerminal;
        fin>>nonTerminal;

        int tokensSize;
        fin>>tokensSize;

        for (int j = 0; j < tokensSize; ++j) {
            string token;
            fin>>token;
            set[nonTerminal].insert(token);
        }
    }
}

void inputSequence(string inputFileName,vector<string> &sequence)
{
    ifstream fin(inputFileName);

    string curToken;

    while(fin>>curToken)
    {
        sequence.push_back(curToken);
    }
}

void outputSequence(string outputFileName,vector<string> &sequence)
{
    ofstream fout(outputFileName);

    for(auto token:sequence)
    {
        fout<<token<<" ";
    }   
    fout<<endl;
}

void outputProduction(string outputFileName,string x,string y,vector<string> z)
{
    ofstream fout(outputFileName,ios::app);

    fout<<x<<" "<<y<<" : "<<x<<" -> ";
    for(auto token:z)
    {
        fout<<token<<" ";
    }
    fout<<endl;
}