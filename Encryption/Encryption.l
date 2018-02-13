%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void specialwords(char *s);
void words(char *s);
void number(char *s);
%}
digits [0-9]+
%%
"lexical" {specialwords(yytext); }
"calculator" {specialwords(yytext); }
"pWWWWarser" {specialwords(yytext); }
"syntax" {specialwords(yytext); }
"encryption" {specialwords(yytext); }
"programming" {specialwords(yytext); }
"hexadecimal" {specialwords(yytext); }
"bootstrapping" {specialwords(yytext);}
[a-zA-Z]+ {words(yytext);}
{digits} {number(yytext);}


%%
int  main()
{
	yyin= fopen("inputencryption.txt","r");
	yylex();

	
}

int yywrap()
{
	return 0;
}
void swap(char *a , char *b)
{
	char temp=*a;
	*a=*b;
	*b=temp;
}
void specialwords(char *s)
{
	int len=strlen(s);
	char a,b;
	int i,in;
	int count=0;
	a=s[len-1];
	b=s[len-2];

	for(i=len-1;i>=2;i--)
	{
		s[i]=s[i-2];
	}
	s[1]=a;
	s[0]=b;
	for(i=0;i<strlen(s);i++)
	{
		if(i<strlen(s)&&s[i]=='W')
		{
			int start=i;
			while(s[i]=='W')
			{
				s[i]=' ';
				count++;
				i++;
			}
			if(count==1)
			{
				s[i-1]==' ';				
			}
			else
			{
				for(in=start+1;in<strlen(s);in++)
				{
					s[in] =s[in+count-1];
				}
				len = strlen(s);
				printf("Len = %d ",len);
				s[len] = '\0'; 
				count=0;
			}
		}
		
		
	}
	for(i=len-1;i>=0;i--)
	{
		printf("%c",s[i]);
	}
	//printf("\n");
}



void words(char* s)
{
	int k=2;
	int count=0;
	int i,in,j; 
	int len = strlen(s);
	for(i=0;i<len;i++)
	{
		if(s[i]<=122&&s[i]>=97)
		{
			s[i] =(s[i]+k);
			if(s[i]>122)
			{
				s[i]= s[i]%122+96;
			}
		}
		else
		{
			s[i] =(s[i]+k);
			if(s[i]>91)
			{
				s[i]= s[i]%91+64;
			}
		}
	}
	//printf("S = %s\n",s);
	for(i=0;i<strlen(s);i++)
	{
		if(s[i]=='W')
		{
			int start=i;
			while(s[i]=='W')
			{
				s[i]=' ';
				count++;
				i++;
			}
			if(count==1)
			{
				s[i-1]==' ';				
			}
			else
			{
				for(in=start+1;in<strlen(s);in++)
				{
					s[in] =s[in+count-1];
				}
				len = strlen(s);
				s[len] = '\0'; 
				count=0;
			}
		}
		
		
	}
	for(i=len-1;i>=0;i--)
	{
		printf("%c",s[i]);
	}
	//printf("\n");

}

void number(char* s)
{
	int	len = strlen(s),i,j;
	if(1)
	{
		j=len-1;
		for(i=len/2-1;i>=0;i--)
		{
			swap(&s[i],&s[j]);
			j--;
		}
	}
	printf("%s",s);
}






