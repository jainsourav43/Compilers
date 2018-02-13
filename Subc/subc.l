%{
#include<bits/stdc++.h>
using namespace std;
set<string>special;
void words(char*);
void number(char*);
void initialise();
%}

digits [0-9]
alpha [a-zA-Z]
alphanum [a-zA-Z0-9]
%%
{alpha} {words(yytext);}
{alpha}{alphanum}+ {words(yytext);}
{digits}+ {number(yytext);}
[+|\-|*|/] {printf("Operator");}
%%
int main()
{
initialise();
//yyin =fopen("Input.c","r");
yylex();

}


void initialise()
{

special.insert("int");
special.insert("double");
special.insert("float");
special.insert("char");
special.insert("short");
special.insert("for");
special.insert("while");
special.insert("if");
special.insert("else");
special.insert("do");
special.insert("struct");
special.insert("class");
special.insert("return");
special.insert("using");
special.insert("namespace");
special.insert("std");
special.insert("include");
special.insert("cout");
special.insert("cin");
special.insert("void");
special.insert("printf");
}



void words(char *s)
{
	string str =string(s);
	cout<<str<<"is a\t";
	if(special.find(str)!=special.end())
	{
		cout<<"Keyword\n";
	}
	else
	{
		cout<<"identifier\n";
;	}
}

void number(char *s)
{
	int n=atoi(s);
	cout<<s<<"is a\t";
	if(n==INT_MAX||n==INT_MIN)
	{
		cout<<"INT_MIN OR INT_MAX\n";
	}
	else
	{
	cout<<"num\n";
	}
}
