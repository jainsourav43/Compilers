%{
	#include<bits/stdc++.h>
	#include "y.tab.h"
	using namespace std;
	
	void yyerror(char *);
	
	char *getChars(char *str)
	{
		char *ans = new char[strlen(str)+1];
		strcpy(ans, str);
		
		return ans;
	}
%}

%%

[0-9]+							{ yylval.lstr = getChars(yytext); return NUM; }

[a-zA-z][a-zA-z0-9]*			{ yylval.lstr = getChars(yytext); cout<<"\nReturning ID\n"; return ID; }

[-=+/*();]						{ cout<<"\nReturning "<<*yytext<<endl; return *yytext; }

[ \t\n]+						{ cout<<"\nIgnoring space\n";}

.								{ cout<<"\nNonthing matched returning +\n"; return '+'; }

%%

int yywrap()
{
	return 1;
}
