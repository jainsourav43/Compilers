%{
#include<bits/stdc++.h>
using namespace std;
void wordcount(char *s);
map<string ,pair<int,set<int> > > symbolTable;
int line=1;

%}
alpha [a-zA-Z]

%%

{alpha}+[\']?{alpha}+   {wordcount(yytext);}
[\n] {line++;}
. {;}
%%

int main()
{
    yyin =fopen("InputSymbol.txt","r");
    yylex(); 
    map<string ,pair<int,set<int> > > :: iterator it =symbolTable.begin();
    cout<<"Word\t\t" <<"Frequency\t" <<"Line Numbers\n";
    while(it!=symbolTable.end())
    {
        cout<<it->first<<"\t\t"<< it->second.first << "\t\t";
        set<int> :: iterator it1 = it->second.second.begin();
        while(it1!=it->second.second.end())
        {
            cout<<*it1<<" ";
            it1++;
        }
        cout<<endl;
        it++;
    }
    
      
}


void wordcount(char* s)
{
    string str = string(s);
    set<int> temp;
    if(symbolTable.find(str)==symbolTable.end())
    {
        temp.insert(line);
        symbolTable[str] = make_pair(1,temp);
    }
    else
    {
        map<string ,pair<int,set<int> > > :: iterator it = symbolTable.find(str);
        it->second.first++;
        it->second.second.insert(line);
    }
        
    
}
