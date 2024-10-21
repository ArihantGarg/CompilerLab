#include<bits/stdc++.h>
using namespace std;

// 21CS01033
// ARIHANT GARG

enum Type{
    Operator,
    Variable,
    Const,
    Bracket,
    Empty,
};

unordered_set<char> emptySet = {' ','\n'};
unordered_set<char> bracketSet = {'(',')'};
unordered_set<char> constSet;
unordered_set<char> operatorSet = {'+','-','=','/','*','|','&','^','!','%','<','>'};
unordered_set<char> variableSet;

void fillConstSet()
{
    for(char a='0';a<='9';a++)
        constSet.insert(a);

    constSet.insert('\'');
    constSet.insert('\"');
}

void fillVariableSet()
{
    for(char a='a';a<='z';a++)
        variableSet.insert(a);
    
    for(char a='A';a<='Z';a++)
        variableSet.insert(a);

    variableSet.insert('_');
}

vector<string> tokens;

Type getType(char c)
{
    if(variableSet.find(c)!=variableSet.end())
        return Variable;

    if(emptySet.find(c)!=emptySet.end())
        return Empty;

    if(operatorSet.find(c)!=operatorSet.end())
        return Operator;

    if(constSet.find(c)!=constSet.end())
        return Const;

    if(bracketSet.find(c)!=bracketSet.end())
        return Bracket;

    cout<<"Error : Invalid Type : "<<c<<endl;
    return Empty;
}

string getTypeAsString(char c)
{
    switch(getType(c))
    {
        case Empty:
        return "";
        break;

        case Operator:
        return "opr";
        break;

        case Variable:
        return "id";
        break;

        case Const:
        return "const";
        break;

        case Bracket:
        return "brac";
        break;

        default:
        return "error";
        break;
    }
}

void parseInput(string &input)
{
    int curIndex = 0; // For iteration over input string
    Type prevType = Empty; // Current type at input[curIndex-1]

    string curTokenString;

    for(int i=0;i<input.size();i++)
    {
        Type curType = getType(input[i]);

        if(curType==prevType)
        {
            if(curType==Empty || curType == Variable || curType == Const)
            {
                // Nothing
            }
            else
            {
                tokens.push_back(curTokenString);
                curTokenString.clear();
            }
        }
        else
        {
            if(prevType==Empty)
            {
                // Nothing
            }
            if(prevType == Const && curType == Variable) // It is Const then , example "a"
            {
                curType = Const;
            }
            else if(prevType == Variable && curType == Const) // It is variable then , example a1
            {
                curType = Variable;
            }
            else if(prevType!=Empty)
            {
                tokens.push_back(curTokenString);
                curTokenString.clear();
            }
        }

        //

        if(curType!=Empty)
            curTokenString.push_back(input[i]);
        prevType = curType;
    }
}

int main()
{
    fillConstSet();
    fillVariableSet();

    string input;
    cout<<"Enter string : ";
    getline(cin,input);
    input.push_back('\n'); // To signify EOF

    parseInput(input);
    
    cout<<"Number of tokens : "<<tokens.size()<<"\n";
    for(auto curToken:tokens)
    {
        cout<<"("<<curToken<<" , "<<getTypeAsString(curToken[0])<<")\n";
    }

    return 0;
}