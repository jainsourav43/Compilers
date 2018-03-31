%{
	#include<bits/stdc++.h>
	using namespace std;
	
	void yyerror(char *str)
	{
		cout<<"\nError : \n"<<str<<endl;
	}
	int yylex();
	
	string myitoa(int n)
	{
		string str = "";
		while(n > 0)
		{
			int r = n%10;
			str += (char) r+'0';
			
			n /= 10;
		}
		
		int len = str.length();
		for(int i=0;i<len/2;i++)
			swap(str[i], str[len-i-1]);
		
		return str;
	}
	
	struct CodeHolder
	{
		string place;
		string code;
		string begin;
		string after;
	}table[10005];
	
	
	int tableIndex = 0;
	int getFreeTableIndex()
	{
		table[tableIndex].place = "";
		table[tableIndex].code = "";
		table[tableIndex].begin = "";
		table[tableIndex].after = "";
		return tableIndex++;
	}
	int labelIndex = 1;
	string newLabel()
	{
		string str = "L";
		str = str + myitoa(labelIndex++);
		return str;
	}
	int freeVarIndex = 1;
	string newTemp()
	{
		string str = "t";
		str = str + myitoa(freeVarIndex++);
		return str;
	}
	
	int mainTableIndex = -1;
	
	
%}

%union{	int lnum; char *lstr; }
%token<lstr> ID NUM
%type<lnum> exp
%type<lnum> assign_stmt
%left<lnum> LOROP LANDOP
%left<lnum> BOROP BANDOP BXOROP
%left<lnum> EQOP NEQOP LTOP LTEQOP GTOP GTEQOP
%left<lnum> '+' '-'
%left<lnum> '*' '/'
%right<lnum> EXPOP
%left<lnum> LNOTOP BNOTOP

%token<lnum> SPACE

%%
//Assignment statement
assign_stmt:
	ID '=' exp ';'		{
									$$ = getFreeTableIndex();
									cout<<"\nCurrent ID = "<<$1<<endl;
									string tempCode = string($1) + " = " + table[$3].place + "\n";
									table[$$].code = table[$3].code + tempCode;
									mainTableIndex = $$;
								}
	;
//Expression
exp:
	  exp LOROP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " || " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp LANDOP exp			{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " && " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	
	| exp BOROP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " | " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp BANDOP exp			{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " & " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp BXOROP exp			{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " ^ " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	
	| exp EQOP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " == " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp NEQOP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " != " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp LTOP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " < " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp LTEQOP exp			{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " <= " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp GTOP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " > " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp GTEQOP exp			{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " >= " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	
	| exp '+' exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " + " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp '-' exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " - " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp '*' exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " * " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	| exp '/' exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " / " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	
	| exp EXPOP exp				{
	  								$$ = getFreeTableIndex();
	  								table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = " + table[$1].place + " @ " + table[$3].place + "\n";
	  								table[$$].code = table[$1].code + table[$3].code + tempCode;
	  								mainTableIndex = $$;
	  							}
	
	| LNOTOP exp				{
	  								$$ = getFreeTableIndex();
									table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = NOT " + table[$2].place + "\n";
	  								table[$$].code = table[$2].code + tempCode;
	  								mainTableIndex = $$;
								}
	| BNOTOP exp				{
	  								$$ = getFreeTableIndex();
									table[$$].place = newTemp();
	  								string tempCode = table[$$].place + " = NOT " + table[$2].place + "\n";
	  								table[$$].code = table[$2].code + tempCode;
	  								mainTableIndex = $$;
								}
	
	| '(' exp ')'				{
	  								$$ = getFreeTableIndex();
									table[$$] = table[$2];
									mainTableIndex = $$;
								}
	| ID						{
	  								$$ = getFreeTableIndex();
									table[$$].place = string($1);
									mainTableIndex = $$;
								}
	| NUM						{
									$$ = getFreeTableIndex();
									table[$$].place = newTemp();
									table[$$].code = table[$$].place + " = " + string($1) + "\n";
									mainTableIndex = $$;
								}
	;
	
%%

int main()
{
	yyparse();
	
	cout<<"\n\nGenerated 3-address code : \n\n";
	cout<<table[mainTableIndex].code<<endl;
	
	return 0;
}
