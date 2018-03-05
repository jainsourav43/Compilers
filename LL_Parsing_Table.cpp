#include<iostream>
#include<bits/stdc++.h>
using namespace std;
map<string,vector<string> > rules,newrules;
string startVariable;
set<char> findfirst(string s);
map<string,set<char> >first;
map<string,set<char > >follow; 
int check=0;
map< pair<string,char > , pair<string,string> > table; 
void printstack(stack<string>s)
{
	while(!s.empty())
	{
		cout<<s.top();
		s.pop();
	}
}
void print()//printing  the first
{
	cout<<"Printing---------------------------"<<endl;
	map<string,vector<string > > :: iterator it;
	it=rules.begin();
	int i;
	while(it!=rules.end())
	{
		cout<<it->first<<"-> ";
		for(i=0;i<it->second.size()-1;i++)
		{
			cout<<it->second[i]<<"|";
		} 
		cout<<it->second[it->second.size()-1]<<endl;
		it++;
	}
	cout<<"--------------------------------------------"<<endl;
}

int search(string pat, string txt)//finding variable on the right side of productions
{

    int M = pat.length();
    int N = txt.length();
 

    for (int i = 0; i <= N - M; i++) {
        int j;
 

        for (j = 0; j < M; j++)
            if (txt[i + j] != pat[j])
                break;
 
        if (j == M) 
           return i;
    }
    return -1;
}
set<char> findfollow(string s)
{
	set<char> temp,merged;
	map<string,vector<string > > :: iterator it;
	it=rules.begin();
	int i;
	if(follow.find(s)!=follow.end()&&check!=1)// Follow Already calculated
	{
		return follow[s];
	}
	while(it!=rules.end())
	{	
		for(i=0;i<it->second.size();i++)	
		{
			int found= search(s,it->second[i]);			
			if(found==-1)
			{
				continue;
			}
			if(it->second[i][found+s.length()]=='\'')// IF E is matched then cheking whether it is E or  E' 
			{
				continue;
			}
			if(found+s.length()<=it->second[i].length()-1)
			{
				temp=findfirst(it->second[i].substr(found+s.length(),it->second[i].length()-found-s.length()));	// Finding First of right part
				set<char> ::iterator setit = temp.begin();	
				while(setit!=temp.end())//Merging the results
				{
					if(*setit!='e')
					merged.insert(*setit);
					setit++;
				}
				if(temp.find('e')!=temp.end())// If first contain Null then finding follow of left hand
				{
					temp=findfollow(it->first);
					set<char> ::iterator setit = temp.begin();	
					while(setit!=temp.end())//merging the result
					{
						merged.insert(*setit);
						setit++;
					}
				}
			}
			else if(found+s.length()==it->second[i].length())
			{
				if(it->first==s)
				{
					//checking whether follow of E is asking for follow of E then do nothing
				}
				else
				{
					temp= findfollow(it->first);//if The variable is the rightmost character then find folllow of left side
					set<char> ::iterator setit = temp.begin();	
					while(setit!=temp.end())//Merged the results
					{
						merged.insert(*setit);
						setit++;
					}
				}
			}
			
		}
		it++;//Incrementing the iterator
	}
	if(startVariable ==s)//If it is the starting variable then add dollar to the follow 
	{
		merged.insert('$');
	}
	return merged;//Returning the result
}
set<char> findfirst(string s)
{
	int index=0;
	if(first.find(s)!=first.end())// If First is Already Calculated  just return it 
	{
		return first[s];
	}
	if(s[index]>=65&&s[index]<=91)// If the first Symbol is Variable 
	{
		char ch[2];// converting char to string 
		ch[0] =s[index];
		ch[1]='\0';
		string test=ch;//test is a string containing the variable
		set<char> temp,temp3;
		if(first.find(test)==first.end())//checking whether the first for that variable is already calculated or not  if not then find it 
		{
			vector<string> vecit;
			vecit= rules[test];
			for(int i=0;i<vecit.size();i++)	// Iterating for all the productions for that variable
			{
				set<char> temp = findfirst(vecit[i]);
				set<char> :: iterator setit;
				setit=temp.begin();
				while(setit!=temp.end())//merging the results 
				{
					temp3.insert(*setit);
					setit++;	
				}
			}
			first[test]=temp3;//putting into the map
			
		}
		else
		{
			temp3=first[test];//if already calculated then just returning it 
		}
		if(temp3.find('e')!=temp3.end())// if the first of above mentioned contains null then find the first of remaining string 
		{
			set<char>temp1=findfirst(s.substr(index+1,s.length()-1));//extracting remaining substring
			set<char> merged;
			set<char> :: iterator it;
			it=temp3.begin();
			
			while(it!=temp3.end())//merging the result 
			{
				merged.insert(*it);
				it++;
			}
			it=temp1.begin();
			while(it!=temp1.end())
			{
				merged.insert(*it);
				it++;
			}
			return merged;//returning the merged result 
		}
		else
		{

			return temp3;//if the result did not contain null then return directly
		}
		
	}
	else // if first char is terminal then just return it after putting it into a set
	{
		
		set<char> temp;
		temp.insert(s[index]);
		return temp;
	}
}
void leftfactoring(int dash)
{
	map<string,vector<string > > :: iterator it;
	it =rules.begin();
	int i;
	int last=it->second.size(),end=0;
	string minprefix="",prefix,Aplha;
	int prefixlength;
	int check=0,j;
	while(1)// Untill all the productions have been left factored 
	{
		check=0;//Just to break the above loop in case all productions have been left factored 
		while(it!=rules.end())//Iterating all productions for a single variable
		{
			end=0;//End is representing the end of productions which have been checked for left factoring 
			while(end<it->second.size())//if all are done then break
			{	
				int cur=0;//denoting the length of currently matched prefix
				string minprefix ="";//Contains the prefix matched so far
				check=0;//for cheking if any prefix exists or not 
				int prev=-1;//Just to check whether the no of prod previously matched are same or not 
				while(1)
				{
					minprefix = minprefix+it->second[end][cur];//adding character to the minprefix
					for(i=end+1;i<it->second.size();i++)
					{
						if(it->second[i].length()>=minprefix.length()&&minprefix == it->second[i].substr(0,minprefix.length()))
						{
							check=1;// if atleast one production is having comm prefix
						}
						else
						{
							break;
						}
					}
					
					if(prev!=-1&&prev==i-1)// checking if prev no of matched prod are same or not 
					{
						prev=i-1;
						cur++;
					}
					else if(prev==-1 && check==1)// initialising if we are matching first time
					{
						prev=i-1;
						cur++;
					}
					else// assigning max common prefix length to another variable
					{
						prefixlength=cur;
						break;
					}
					
				}				
				vector<string>beta;
				if(check==1)
				{
					string finalprefix =it->second[end].substr(0,cur);
				
					for(j=end;j<=prev;j++)//adding all the production to beta having common prefix
					{
						beta.push_back(it->second[j]);
					}
					for(j=end;j<=prev;j++)
					{
						vector<string>:: iterator temp=  find(it->second.begin(),it->second.end(),beta[j]);//deleting all prod having comm prx
						it->second.erase(temp);
					}
					
					rules[it->first].push_back(finalprefix+it->first+"'");//adding new prod of E'
					string newvar = it->first+"'";
					rules[newvar].push_back(beta[0].substr(cur,beta[0].length()-cur));//Adding new Rule of E'
					for(j=1;j<beta.size();j++)
					{
						rules[newvar].push_back(beta[j].substr(cur,beta[j].length()-cur));//Pushing all prod for E'
					}
				
				}
				if(!check)//Cheking if no prefix matched then just increment end 
				{
					end++;
				}
				else// If some prefix matched then assign end to after the previously matched productions 
				{
					end=prev+1;
				}
			}
			it++;
		}
		if(!check)//if nothing happend throughout the iteration then just break the outer loop
		{
			break;
		}
	}
}
void leftRecursion()
{
	map<string,vector<string > > :: iterator it;
	it=rules.begin();
	while(it!=rules.end())
	{
		vector<string> alpha,beta;
		int check=0,check1=0;
		int i;
		for(i=0;i<it->second.size();i++)
		{
			if(it->first[0] == it->second[i][0])
			{
				alpha.push_back(it->second[i].substr(1,it->second[i].length()-1));//Pushing alphas 
				check1=1;
			}
			else
			{
				beta.push_back(it->second[i]);//pushing Betas
			}
		}
		if(check1==1)
		{
			for(i=0;i<beta.size();i++)
			{
			
				it->second.push_back(beta[i]+it->first +"'");//Adding Productions having E'
			
			}
		
			for(i=0;i<alpha.size();i++)
			{
		
			
				rules[it->first +"'"].push_back(alpha[i]+it->first +"'");// Adding Rules for E'
				check=1;
			}
			if(check==1)
			{
				rules[it->first +"'"].push_back("e");//If left recursion exists then push Null
			}
		}
		if(it->first.length()==2)
		{
			it++;//If Variable if of the tyoe E'  thenn just skip otherwise go for production deletion for E 
			continue;
		}
		
		check1=0;
		for(i=0;i<alpha.size();i++)
		{
			string my= it->first+alpha[i];
			vector<string>:: iterator temp=  find(it->second.begin(),it->second.end(),my);
			it->second.erase(temp);
			check1=1;
		}
		if(check1==1)
		{
			for(i=0;i<beta.size();i++)
			{
				vector<string>:: iterator temp=  find(it->second.begin(),it->second.end(),(beta[i]));
				it->second.erase(temp);
			}
		}
			it++;
	}	
}

void createTable()
{
	map<string,vector<string > > :: iterator it;
	it=rules.begin();
	set<char> first_of_right,follow_of_left;
	while(it!=rules.end())
	{
		for(int i=0;i<it->second.size();i++)
		{
			first_of_right = findfirst(it->second[i]);
			set<char> :: iterator setit = first_of_right.begin(),setit2 ;
			while(setit!=first_of_right.end())
			{
				if(*setit!='e')
				{
					table[make_pair(it->first,*setit)] = make_pair(it->first,it->second[i]);
				}
				else
				{
					follow_of_left  =findfollow(it->first);
					setit2 = follow_of_left.begin();
					while(setit2!=follow_of_left.end())
					{
						table[make_pair(it->first,*setit2)] = make_pair(it->first,it->second[i]);
						setit2++;
					}
					
				}
				setit++;
			}
		}
		it++;
	}
	map< pair<string,char> ,pair<string,string> > :: iterator tableit =table.begin();
	while(tableit!=table.end())
	{
		cout<<"M["<<tableit->first.first <<","<<tableit->first.second<<"]"<<"= ";
		cout<<tableit->second.first<<"-> "<<tableit->second.second<<endl;
		tableit++;
	}
	
	
}
int main()
{
	
	cout<<"Enter the Number of Rules";
	int n;
	cin>>n;
	string s1,s2;
	int i,j;
	for(i=0;i<n;i++)
	{
		cout<<"Enter left and right side of rules"<<endl;
		cin>>s1>>s2;
		rules[s1].push_back(s2);
	}
	map<string,vector<string > > :: iterator it;
	cout<<"Enter Start Variable\n";
	cin>>startVariable;
	
	leftRecursion();
	
	cout<<"Left Recursion Done---------------------------------------------------\n";
	it=rules.begin();
	while(it!=rules.end())
	{
		cout<<it->first<<"-> ";
		for(i=0;i<it->second.size()-1;i++)
		{
			cout<<it->second[i]<<"|";
		} 
		cout<<it->second[it->second.size()-1]<<endl;
		it++;
	}
	
	leftfactoring(0);
	
	it=rules.begin();
	cout<<"Left Factoring Done--------------------------------------------------------\n";
	while(it!=rules.end())
	{
		cout<<it->first<<"-> ";
		for(i=0;i<it->second.size()-1;i++)
		{
			cout<<it->second[i]<<"|";
		} 
		cout<<it->second[it->second.size()-1]<<endl;
		it++;
	}
	
	
	
	

	it=rules.begin();
	
	while(it!=rules.end())
	{
		
		for(i=0;i<it->second.size();i++)	
		{
			set<char> temp = findfirst(it->second[i]);
			set<char> :: iterator setit;
			setit=temp.begin();
			while(setit!=temp.end())
			{
				first[it->first].insert(*setit);
				setit++;	
			}
		}
		it++;
	}
		
	map<string,set<char> > ::iterator firstit=first.begin();
	cout<<"Variable\t"<<"First\n";
	while(firstit!=first.end())
	{
		set<char> :: iterator setit = firstit->second.begin();
		cout<<firstit->first<<"\t\t{";
		while(setit!=firstit->second.end())
		{
			cout<<*setit<<",";
			setit++;
		}
		cout<<"}";
		firstit++;
		cout<<endl;
	}
	
	
	it=rules.begin();
	while(it!=rules.end())
	{
		follow[it->first]= findfollow(it->first);
		it++;
	}
	
	map<string,set<char> > ::iterator followit=follow.begin();
	cout<<"Variable\t"<<"Follow\n";
	
	
	while(followit!=follow.end())
	{
		set<char> :: iterator setit = followit->second.begin();
		cout<<followit->first<<"\t\t{";
		while(setit!=followit->second.end())
		{
			cout<<*setit<<",";
			setit++;
		}
		cout<<"}";
		followit++;
		cout<<endl;
	}
	cout<<"LL Parsing Table \n";
	createTable();
	cout<<"Enter the Input to Parse\n";
	string input;
	cin>>input;
	input=input+'$';
	string dollar="$";
	stack<string> s;
	s.push(dollar);
	s.push(startVariable);
	int cur=0;
	vector<string> variables;
	string temp,str="",topofstack,matched="";
	i=0;
	int ch=0;
	cout<<endl<<endl;
	cout<<"Matched\t\t"<<"Stack\t\t"<<"Input\t\t"<<"Action"<<endl;
	while(!(s.top()==dollar&&input[cur]=='$'))
	{
		topofstack = s.top();
		cout<<matched<<"\t\t";
		printstack(s);cout<<"\t\t";
		cout<<input.substr(cur,input.length()-cur)<<"\t\t";
		if(topofstack[0]>=65&&topofstack[0]<=91)
		{
			cout<<"output "<<table[make_pair(s.top(),input[cur])].first<<"->"<<table[make_pair(s.top(),input[cur])].second<<endl;
			variables.clear();
			temp =table[make_pair(s.top(),input[cur])].second;
			i=0;
			while(i<temp.length())
			{
				str=temp[i];
				i++;
				while(temp[i]=='\'')
				{
					str=str+temp[i];
					i++;
				}

				if(str!="e")
				variables.push_back(str);
			}
			s.pop();
			i=variables.size()-1;
			while(i>=0)
			{
				s.push(variables[i]);
				i--;
			}		
			
		}
		else
		{
			
			if(topofstack[0]==input[cur])
			{
				cout<<"Matched "<<input[cur]<<endl;
				matched =matched+topofstack[0];
				cur++;
				s.pop();
			}
			else
			{
				cout<<"Error\n";
				return 0;
			}
			
			
		}
		
	}
		cout<<matched<<"\t\t";
		printstack(s);cout<<"\t\t";
		cout<<input.substr(cur,input.length()-cur)<<"\n";
	
	
	
	return 0;
	
}
