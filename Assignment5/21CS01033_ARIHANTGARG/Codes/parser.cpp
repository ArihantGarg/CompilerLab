#include<bits/stdc++.h>
#include "function.hpp" 
using namespace std;

string inputGrammarFileName = "../Input/inputgrammar.txt";
vector<string> nonterminals;
vector<string> terminals;
string startSymbol;
map<string,vector<vector<string>>> productions;

string inputFirstFileName = "../Input/inputfirst.txt";
string inputFollowFileName = "../Input/inputfollow.txt";

map<string,set<string>> first;
map<string,set<string>> follow;

string outputFileName1 = "../Input/output1.txt";
string outputFileName2 = "../Input/output2.txt";

string inputSequenceFileName = "../Input/inputsequence.txt";
string outputSequenceFileName = "../Input/outputsequence.txt";

string outputParserTableFileName = "../Input/outputparsertable.txt";

int main()
{
    // Part 1 : Outputting Parse Table

    inputGrammar(inputGrammarFileName,nonterminals,terminals,startSymbol,productions);
    terminals.push_back("$");
    terminals.push_back("e");

    inputSet(inputFirstFileName,first);
    inputSet(inputFollowFileName,follow);

    set<string> terminalsSet(terminals.begin(),terminals.end());
    set<string> nonterminalsSet(nonterminals.begin(),nonterminals.end());

    map<pair<string,string>,vector<string>> parserTable;

    for(auto x:nonterminals)
    {
        for(auto y:terminals)
        {
            for(auto z:productions[x])
            {
                string cur=y;

                if(cur==z[0])
                {
                    if(cur=="e")
                        cur="$";

                    outputProduction(outputParserTableFileName,x,cur,z);
                    parserTable[{x,y}]=z;
                }
                else
                {
                    set<string> firstSet=first[z[0]];

                    if(firstSet.find(y)!=firstSet.end())
                    {
                        if(cur=="e")
                            cur="$";

                        outputProduction(outputParserTableFileName,x,cur,z);
                        parserTable[{x,y}]=z;
                    }
                }
            } 
        }
    }

    // Part 2 : Sequence Checking

    vector<string> sequence;
    inputSequence(inputSequenceFileName,sequence);

    vector<string> stack;
    stack.push_back("$");
    stack.push_back(startSymbol);

    int curIndex=0;

    while(stack.size()>0)
    {
        if(curIndex==sequence.size())
        {
            sequence.push_back("e");
        }

        cout<<"Stack : ";
        for(auto x:stack)
        {
            cout<<x<<" ";
        }

        cout<<endl;

        cout<<"Sequence : ";

        for(int i=curIndex;i<sequence.size();i++)
        {
            cout<<sequence[i]<<" ";
        }

        cout<<endl;

        cout<<"Current Stack Top : "<<stack.back()<<endl;
        cout<<"Current Sequence String : "<<sequence[curIndex]<<endl;

        string curSymbol=stack.back();
        stack.pop_back();

        if(stack.size()==0 && curSymbol=="$" && sequence[curIndex]=="e")
        {
            break;
        }

        if(curSymbol=="e")
            continue;
        else if(curSymbol==sequence[curIndex])
        {
            curIndex++;
        }
        else
        {
            pair<string,string> curPair={curSymbol,sequence[curIndex]};

            if(parserTable.find(curPair)==parserTable.end())
            {
                cout<<"Sequence Rejected"<<endl;
                return 0;
            }

            vector<string> curProduction=parserTable[curPair];

            for(int i=curProduction.size()-1;i>=0;i--)
            {
                if(curProduction[i]!="e")
                    stack.push_back(curProduction[i]);
            }
        }
    }

    cout<<"Sequence Accepted"<<endl;

    // outputSequence(outputSequenceFileName,sequence);
}