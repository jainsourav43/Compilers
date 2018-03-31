%{
#include<bits/stdc++.h>
#include "first.tab.h"
using namespace std;
%}

%%



"if" 				 {return IF;}

"else"				 {return ELSE;}

"{"					 {return yytext[0];}

"}"					 {return yytext[0];}

"int "				 {/*cout<<"Returning INT\n";*/return INT;}

"uint "				 {/*cout<<"Returning UINT\n";*/ return UINT;}

"bool "				 {/*cout<<"Returning BOOL\n";*/ return BOOL;}


"true"   			 {yylval.str = (char*)malloc(yyleng);sprintf(yylval.str,"%s",yytext); /*cout<<"Returning True\n";*/ return TR;}

"false"   			 {yylval.str = (char*)malloc(yyleng);sprintf(yylval.str,"%s",yytext);/*cout<<"Returning False\n";*/ return FL;}

[0-9]+  			 {yylval.str = (char*)malloc(yyleng);sprintf(yylval.str,"%s",yytext); /*cout<<"Returning Num\n";*/ return NUM;}

[a-zA-Z][a-zA-Z0-9]* {yylval.str = (char*)malloc(yyleng);sprintf(yylval.str,"%s",yytext); /*cout<<"Returning ID\n";*/return ID;}

[-=+/*();]			 {/*cout<<"Returning Operator "<<*yytext<<"\n";*/ return yytext[0];}

[|&~^]				 {/*cout<<"Returning Bitwise Operator "<<*yytext<<"\n";*/ return yytext[0];}

"+=" 				 {/*cout<<"Returning += \n";*/ return PLEQ;}

"-=" 				 {/*cout<<"Returning -= \n";*/ return SBEQ;}

"*=" 				 {/*cout<<"Returning *= \n";*/ return MLEQ;}

"/=" 				 {/*cout<<"Returning /= \n";*/ return DVEQ;}

"||" 				 {/*cout<<"Returning || \n";*/ return LOR;}

"&&" 				 {/*cout<<"Returning && \n";*/ return LAND;}

"!" 				 {/*cout<<"Returning ! \n";*/ return LNOT;}

">=" 				 {/*cout<<"Returning >= \n";*/ return GREQ;}

"<=" 				 {/*cout<<"Returning <=\n";*/ return LSEQ;}

"<" 				 {/*cout<<"Returning < \n";*/ return LSTH;}

">" 				 {/*cout<<"Returning > \n"; */return GRTH;}

"==" 				 {/*cout<<"Returning == \n";*/ return EQEQ;}

"!=" 				 {/*cout<<"Returning != \n";*/ return NOTEQ;}

 
[\n]				 {/*cout<<"Returning EOL\n";*/ return EOL;}


              

[ \t] 			 {/*cout<<"Ignoring Spaces and Newline\n";*/ }

. 					 {/*cout<<"Nothing Matched Returnig # \n";*/ return '#';}

%%

int yywrap()
{
	return 0;
}
