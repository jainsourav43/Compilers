%{
#include<bits/stdc++.h>
using namespace std;
int tempCounter=0;
int labelCounter=0;
struct tableStructure
{
	string place;
	string code;
	string begin;
	string after;
}table[10000];


bool checkTypeCompatibility(string s1,string s2)
{
	if(s1=="BOOL"&&(s2=="UINT"||s2=="INT"))
	{
		return false;
	}
	
	if(s2=="BOOL"&&(s1=="UINT"||s1=="INT"))
	{
		return false;
	}
	return true;
}
void yyerror(char *str)
{
	cout<<"\nError : \n"<<str<<endl;
}
int yylex();
int firstIndex=0;

string newtemp()
{
	string temp="t"+to_string(tempCounter);
	tempCounter++;
	return temp;
}

map<string,string >symbolTable;

string getLabel()
{
	string temp="L"+to_string(labelCounter);
	labelCounter++;
	return temp;
}


int getFreeIndex()
{
	table[firstIndex].place="";
	table[firstIndex].code="";
	table[firstIndex].begin="";
	table[firstIndex].after="";
	return firstIndex++;
}
int mainTableIndex=-1;

%}

%union
{
int number;
char* str;
}
%token<str> NUM ID
%token EOL
%token INT UINT BOOL 
%token<str> TR FL
%token IF 
%nonassoc IFX
%nonassoc ELSE 
%type<number> exp
%type<number> assignment_stmt 
%type<number> declare_stmt
%type<number> program statements
%token PLEQ SBEQ MLEQ DVEQ
%left GREQ  
%left LSEQ
%left GRTH 
%left LSTH
%left EQEQ
%left NOTEQ
%left LOR
%left LNOT
%left LAND
%left '|' 
%left '^'
%left '&'
%left '~'
%left '='
%left '+' '-'
%left '*' '/'
%left '%'



%%
program:					{}
 |program statements  EOL       {
 								mainTableIndex = $2;
 								cout<<table[mainTableIndex].code<<endl;
 							}
 ;
statements:					{
								$$ =getFreeIndex();
							}


|declare_stmt statements	{
								$$ =getFreeIndex();
								table[$$].code =table[$1].code+"\n"+table[$2].code+"\n";
							}

|assignment_stmt statements {
								$$ =getFreeIndex();
								table[$$].code =table[$1].code+"\n"+table[$2].code+"\n";
							}
							
;



declare_stmt:
INT ID ';'          {
							if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
							symbolTable[string($2)] = "INT";
							$$ =getFreeIndex();
							table[$$].code ="Declaring "+string($2);
							mainTableIndex=$$;
     		            }
     		           
|INT ID '=' exp ';' {
    
    						if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
    						symbolTable[string($2)] = "INT";
    						$$ =getFreeIndex();
							string mycode  = string($2)+ '=' + table[$4].place + '\n';
							table[$$].code=table[$4].code+"\n"+mycode;
							mainTableIndex=$$;
    				    }
    				   
    |UINT ID ';'        {
    						if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "UINT";
	 						$$ =getFreeIndex();
							table[$$].code ="Declaring "+string($2);
							mainTableIndex=$$;
     		            }
     		           
    |UINT ID '=' exp ';'{
    						if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
        					symbolTable[string($2)] = "UINT";
    						$$ =getFreeIndex();
							string mycode  = string($2)+ '=' + table[$4].place + '\n';
							table[$$].code=table[$4].code+"\n"+mycode;
							mainTableIndex=$$;
    				    }
    				    
    |BOOL ID  ';'       {
                            if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "BOOL";
	 						$$ =getFreeIndex();
							table[$$].code ="Declaring "+string($2);
							mainTableIndex=$$;
   						}
   						
   	 |BOOL ID '=' TR ';' {
                            if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "BOOL";
	 						$$ =getFreeIndex();
							string mycode  = "Declared and Initialised  "+string($2)+ '=' + "true" + '\n';
							table[$$].code =mycode;
							mainTableIndex=$$;
   						   }
   						   
   	|BOOL ID '=' FL ';' {
                            if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclared ID Compiler Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "BOOL";
	 						$$ =getFreeIndex();
							string mycode  = "Declared and Initialised"+ string($2)+ '=' + "false" + '\n';
							table[$$].code =mycode;
							mainTableIndex=$$;
   						   }
   						
   						
   	 
;       
assignment_stmt:

	ID '=' exp ';' {
					if(symbolTable.find(string($1))==symbolTable.end())
					{
						cout<<"Undeclared ID Compiler Error\n";
						exit(0);
					}
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					$$ =getFreeIndex();
					string mycode  = string($1)+ '=' + table[$3].place + '\n';
					table[$$].code=table[$3].code+mycode;
					mainTableIndex=$$;
					}
			 
	|ID PLEQ exp ';'{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '+' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;
					//cout<<table[mainTableIndex].code<<endl;
			      }
			      
	| ID SBEQ exp ';'{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '-' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;

			      }
			      
	| ID MLEQ exp ';'{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '*' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;
					//cout<<table[mainTableIndex].code<<endl;
			      }
			      
			      
	| ID DVEQ exp';'{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '/' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;
			      }	
			      
			      
	

;


exp:  
	exp '|' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{	
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '|' + table[$3].place+"\n";
					mainTableIndex=$$;
			     }
			      
	|exp '&' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '&' + table[$3].place+"\n";
					mainTableIndex=$$;
			      }
			      
    | exp '^' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '^' + table[$3].place+"\n";
					mainTableIndex=$$;
				  }
	
	| '~' exp 	  {
	  				$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$2].place]=="BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$2].place]=="INT")
					{
						symbolTable[table[$$].place] ="INT";
					}
					else
					{
						symbolTable[table[$$].place] ="UINT";
					}
					string mygen = '~' + table[$2].place+"\n";
					table[$$].code = table[$2].code+table[$$].place + '=' + mygen;
					mainTableIndex=$$;
				  }
			      
	|exp '+' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '+' + table[$3].place+"\n";
					mainTableIndex=$$;
			      }
 
	| exp '-' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '-' + table[$3].place+"\n";
					mainTableIndex=$$;
			      }
	 
	
	
	| exp '*' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '*' + table[$3].place+"\n";
					mainTableIndex=$$;
			      }
	
	
	| exp '/' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '/' + table[$3].place+"\n";
					mainTableIndex=$$;
			      }
	
	
	| exp '%' exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[table[$3].place],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$1].place] == "BOOL" ||symbolTable[table[$3].place] == "BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					if(symbolTable[table[$3].place] =="INT"||symbolTable[table[$1].place] =="INT")
					symbolTable[table[$$].place] ="INT";
					else
					symbolTable[table[$$].place] ="UINT";
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + '%' + table[$3].place+"\n";
					mainTableIndex=$$;
			      }
			      
	| exp LOR exp {
					$$ =getFreeIndex();
					table[$$].place =newtemp(); 
					if(symbolTable[table[$1].place] !="BOOL"||symbolTable[table[$3].place] !="BOOL")
					{
						cout<<"IncompatibleType\n";
						exit(0);
					}
					
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + "||" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      }
			      
	| exp LAND exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] !="BOOL"||symbolTable[table[$3].place] !="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + "&&" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      }  
			      
	 | exp GREQ exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] =="BOOL"||symbolTable[table[$3].place] =="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + ">=" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      } 
	| exp LSEQ exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] =="BOOL"||symbolTable[table[$3].place] =="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + "<=" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      } 
			  
	| exp GRTH exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] =="BOOL"||symbolTable[table[$3].place] =="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + ">" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      } 
			      
	| exp LSTH exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] =="BOOL"||symbolTable[table[$3].place] =="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + "<" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      } 
	
	| exp EQEQ exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] =="BOOL"||symbolTable[table[$3].place] =="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + "==" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      } 
	| exp NOTEQ exp{
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$1].place] =="BOOL"||symbolTable[table[$3].place] =="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +table[$1].place + "!=" + table[$3].place+"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      } 
			  
			      
	| LNOT exp	 {
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[table[$2].place] !="BOOL")
					{
						cout<<"Incompatible Type\n";
						exit(0);
					}
					table[$$].code = table[$2].code +table[$$].place + '=' + "!" + table[$2].place +"\n";
					symbolTable[table[$$].place] ="BOOL";
					mainTableIndex=$$;
			      }  
			      
	
			        
	| '(' exp ')' {
					$$ = getFreeIndex();
					table[$$] = table[$2];
					mainTableIndex = $$;
				  }
	
	
	
				  
	| ID		  {
	                if(symbolTable.find(string($1))==symbolTable.end())
					{
						cout<<"Undeclared ID Compiler Error\n";
						exit(0);
					}
	    			$$ =getFreeIndex();
					table[$$].place =string($1);
					mainTableIndex=$$;
				  } 
				  
				  
	
	| TR		  {
	    			$$ = getFreeIndex();
					table[$$].place = newtemp();
					symbolTable[table[$$].place]="BOOL";
					table[$$].code = table[$$].place + " = " + "true" + "\n";
					mainTableIndex = $$;
				  } 
				  
	| FL		  {
	    			$$ = getFreeIndex();
					table[$$].place = newtemp();
					symbolTable[table[$$].place]="BOOL";
					table[$$].code = table[$$].place + " = " + "false" + "\n";
					mainTableIndex = $$;
				  } 
	
	|NUM		  {
	
						$$ = getFreeIndex();
						table[$$].place = newtemp();
						symbolTable[table[$$].place]="INT";
						table[$$].code = table[$$].place + " = " + string($1) + "\n";
						mainTableIndex = $$;
				  }
	
	;
 


%%



int main()
{
	yyparse();
	cout<<"\n\nGenerated 3-address code : \n\n";

	return 0;
}
