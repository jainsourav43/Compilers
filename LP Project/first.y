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

map<string, pair <string,pair <string,string > > >switchmap;  
stack< map<string, pair <string,pair <string,string > > > >mapswitch;
stack<string> afterswitch;

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
void yyerror(const char *str)
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
string switchlabel;

int getFreeIndex()
{
	table[firstIndex].place="";
	table[firstIndex].code="";
	table[firstIndex].begin="";
	table[firstIndex].after="";
	return firstIndex++;
}
int mainTableIndex=-1;

int lastTableIndex=-1;

%}

%union
{
int number;
char* str;
}
%token<str> NUM ID
%token EOL
%token INT UINT BOOL SWITCH CASE DEFAULT BREAK DEC INC
%token<str> TR FL 
%token IF WHILE
%nonassoc IFX
%nonassoc ELSE 
%type<number> exp
%type<number> assignment_stmt 
%type<number> declare_stmt switch_stmt cases
%type<number> program statements if_stmt while_stmt setlabelafter
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

program:					{
								$$=getFreeIndex();		
							}
 |program statements        {
 								$$=getFreeIndex();
								table[$$].code=table[$1].code+"\n"+table[$2].code+"\n";
 								mainTableIndex = $$;
 							}
 ;
statements:					

declare_stmt 				{
								$$ = $1;
							}

|assignment_stmt 			{$$ = $1;
							}
							
|if_stmt					{$$ = $1;
                            }
                            
|while_stmt					{$$ = $1;
                            }
|switch_stmt                {
								$$=$1;
							}

|'{' program '}'			{
								$$=$2;
								mainTableIndex=$$;							
							}
					
							
;
switch_stmt:
setlabelafter SWITCH '(' exp ')'  	'{' cases  '}'		{
														$$=getFreeIndex();
														map<string, pair <string,pair <string,string > > > :: iterator it=mapswitch.top().begin();
														string gen=table[$4].code;
														while(it!=mapswitch.top().end())
														{
															gen=gen+it->second.second.second+"if "+table[$4].place+" == "+it->first+ " goto "+ 
																it->second.second.first +"\n";
																if(it->second.first!=symbolTable[table[$4].place])
																{
																	cout<<"Incompatible Type error  \n";
																	exit(0);
																}
																it++;
														} 
														gen = gen+ "\n"+table[$7].code;
														table[$$].code = gen +"\n" +afterswitch.top()+":" ;
														mainTableIndex=$$; 
														mapswitch.pop();
														afterswitch.pop();
														
												
											            } 
											
											
;	

setlabelafter:											{
															switchlabel=getLabel();
															afterswitch.push(switchlabel);
															map<string, pair <string,pair <string,string > > > tempomap;
															mapswitch.push(tempomap);
															
															
															
														}
;									
cases: 											{
														$$=getFreeIndex();
												}

| CASE exp ':' statements BREAK ';' cases 		{

												string tempafter=afterswitch.top();
												$$=getFreeIndex();
												string newlabel =getLabel();
												table[$$].code = newlabel+":"+"\n"+table[$4].code+ " goto  " + tempafter +"\n"+ table[$7].code ;
												
												map<string, pair <string,pair <string,string > > > tempmap= mapswitch.top();mapswitch.pop();
												tempmap[table[$2].place]=make_pair(symbolTable[table[$2].place],make_pair(newlabel,table[$2].code));
												mapswitch.push(tempmap);
												
					
											} 
											
| DEFAULT ':' statements					{
												$$=getFreeIndex();
												string tempafter=afterswitch.top();
												string newlabel =getLabel();
												table[$$].place = newtemp();
												table[$$].code = "deafult : "+table[$3].code+" goto " + tempafter;
												
												
											}
											
											
;
if_stmt: IF '(' exp ')'  statements %prec IFX {
  									if(symbolTable[table[$3].place]!="BOOL")
									{
										cout<<table[$3].place<<"is  Not boolean type"<<endl;
										exit(0);
									}
									$$=getFreeIndex();
									table[$$].after=getLabel();
									string gen="";
									gen="if "+table[$3].place+"== "+'0'+" goto "+table[$$].after+'\n';
									table[$$].code=table[$3].code+gen+table[$5].code+table[$$].after+":"+'\n';
									mainTableIndex==$$;		
  								 }
  | IF '(' exp ')' statements ELSE statements {
  									if(symbolTable[table[$3].place]!="BOOL")
									{
										cout<<table[$3].place <<"is  Not boolean type"<<endl;
										exit(0);
									}
									$$=getFreeIndex();
									table[$$].begin=getLabel();
									table[$$].after=getLabel();
									string gen="";
									gen=" if "+table[$3].place+" == "+'0'+" goto "+table[$$].begin+'\n';
									table[$$].code=table[$3].code+gen+table[$5].code+"\n"+ " goto " + table[$$].after+"\n"+
									table[$$].begin+":\n"+table[$7].code+'\n'+table[$$].after+":\n";
									mainTableIndex==$$;
  								}
;


while_stmt:
WHILE '(' exp ')' statements {
									if(symbolTable[table[$3].place]!="BOOL")
									{
										cout<<table[$3].place <<"is  Not boolean type"<<endl;
										exit(0);
									}
									$$=getFreeIndex();
									table[$$].begin=getLabel();
									table[$$].after=getLabel();
									string gen="";
									
									gen=table[$$].begin+":\n"+"if "+table[$3].place+"=="+'0'+" goto "+table[$$].after+'\n';
									table[$$].code=table[$3].code+gen+table[$5].code+'\n'+"goto " +table[$$].begin+"\n"+table[$$].after+":";
									mainTableIndex==$$;

							}
;
declare_stmt:
INT ID ';'          {
							if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
								exit(0);
							}
							symbolTable[string($2)] = "INT";
							$$ =getFreeIndex();
							table[$$].code ="Allocating 4 bytes for "+string($2);
							mainTableIndex=$$;
     		            }
     		           
|INT ID '=' exp ';' {
    
    						if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
								exit(0);
							}
    						symbolTable[string($2)] = "INT";
    						$$ =getFreeIndex();
							string mycode  = "Allocating 4 bytes initialising "+string($2)+ '=' + table[$4].place + '\n';
							table[$$].code=table[$4].code+"\n"+mycode;
							mainTableIndex=$$;
    				    }
    				   
    |UINT ID ';'        {
    						if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "UINT";
	 						$$ =getFreeIndex();
							table[$$].code ="Allocating 4 bytes for "+string($2);
							mainTableIndex=$$;
     		            }
     		           
    |UINT ID '=' exp ';'{
    						if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
								exit(0);
							}
        					symbolTable[string($2)] = "UINT";
    						$$ =getFreeIndex();
							string mycode  ="Allocating 4 bytes and initialising "+ string($2)+ '=' + table[$4].place + '\n';
							table[$$].code=table[$4].code+"\n"+mycode;
							mainTableIndex=$$;
    				    }
    				    
    |BOOL ID  ';'       {
                            if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "BOOL";
	 						$$ =getFreeIndex();
							table[$$].code ="Allocating 1 bytes for "+string($2);
							mainTableIndex=$$;
   						}
   						
   	 |BOOL ID '=' TR ';' {
                            if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
								exit(0);
							}
	 						symbolTable[string($2)] = "BOOL";
	 						$$ =getFreeIndex();
							string mycode  = "Allocating 1 bytes and initialising "+string($2)+ '=' + "true" + '\n';
							table[$$].code =mycode;
							mainTableIndex=$$;
   						   }
   						   
   	|BOOL ID '=' FL ';' {
                            if(symbolTable.find(string($2))!=symbolTable.end())
							{
								cout<<"Redeclaration of  "<< $2 <<" Compilation Error\n";
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
						cout<<"Undeclared " <<$1<<" Compilation Error\n";
						exit(0);
					}
					if(!checkTypeCompatibility(symbolTable[$1],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					$$ =getFreeIndex();
					string mycode  = string($1)+ '=' + table[$3].place + '\n';
				//	cout<<"Testing = "<<table[mainTableIndex].code<<endl;
					table[$$].code=table[$3].code+mycode;
					mainTableIndex=$$;
					}
			 
	|ID PLEQ exp ';'{
	
					if(symbolTable.find($1)==symbolTable.end())
					{
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
						exit(0);
					}
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					
					if(!checkTypeCompatibility(symbolTable[$1],symbolTable[table[$3].place]))
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
	
					if(symbolTable.find($1)==symbolTable.end())
					{
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
						exit(0);
					}
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					
					if(!checkTypeCompatibility(symbolTable[$1],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '-' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;

			      }
			      
	| ID MLEQ exp ';'{
	
					if(symbolTable.find($1)==symbolTable.end())
					{
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
						exit(0);
					}
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[$1],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '*' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;
			      }
			      
			      
	| ID DVEQ exp';'{
	
					if(symbolTable.find($1)==symbolTable.end())
					{
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
						exit(0);
					}
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(!checkTypeCompatibility(symbolTable[$1],symbolTable[table[$3].place]))
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$3].code +table[$$].place + '=' +string($1)+ '/' + table[$3].place+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;
			      }	
			      
			 
			 
			 
| ID DEC	';'	{

					if(symbolTable.find($1)==symbolTable.end())
					{
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
						exit(0);
					}
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[$1]=="BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$$].place + '=' +string($1)+ '-' + "1"+"\n" + string($1) + '=' + table[$$].place;
					mainTableIndex=$$;	
				}






| ID INC	';'	{

					if(symbolTable.find($1)==symbolTable.end())
					{
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
						exit(0);
					}
					$$ =getFreeIndex();
					table[$$].place =newtemp();
					if(symbolTable[$1]=="BOOL")
					{
						cout<<"Type Incompatible \n";
						exit(0);
					}
					symbolTable[table[$$].place] ="INT";
					table[$$].code = table[$$].place + '=' +string($1)+ '+' + "1"+"\n" + string($1) + '=' + table[$$].place;
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
					table[$$].code = table[$1].code+table[$3].code +table[$$].place + '=' +
					table[$1].place + '+' + table[$3].place+"\n";
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
						cout<<"Incompatible Type Compilation Error\n";
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
						cout<<"Undeclared " <<$1<<"  Compilation Error\n";
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
	cout<<"Welcome to the Sub C Three Address Code Generator.\n";
	cout<<"Please follow the Following Rules to make the most out of the Three address generator.\n";
	cout<<"1. While ,If will only accept boolean Type Expression.\n";
	cout<<"2. Relational Operation will only work if both Operator are int or uint.\n";
	cout<<"3. For Loop is not a part of this Assignment.\n";
	cout<<"4. +,-,*, / ,% Operation are not Allowed for Boolean type.\n";
	cout<<"5. All Assignment of Type +=,-=,*=,/= will for int and uint type only.\n";
	cout<<"6. As of now Declaration of multi variable is not Allowed in a Single Statement.\n";
	cout<<"Start Entering Input\n\n\n";
	
	yyparse();
	cout<<"\n\nGenerated 3-address code : \n\n";
	
	cout<<table[mainTableIndex].code<<endl;
	
	cout<<"\n\n\nThank You\n";

	return 0;
}
