#include<bits/stdc++.h>
using namespace std;
map<string,vector<string> > rules,newrules;
string startVariable;
map<int,vector< pair<string,string> > > table; 
map<string,set<char> >first;
map<string,set<char > >follow; 
set<char> findfirst(string s);
int numbering=0,ans;
map<pair< string,string> ,int >enumeratedRules; 
map<int,pair<string,string>  >enumeratedRulesReverse; 
string afterDot(string);
struct itemset 
{
	set < pair < pair <string,string >,bool > > items;
	bool isFinal;
	bool isDone;
	int number;
	vector<pair<string,int> > gotoon;
};
set<string> terminals;
set<string> variables;
vector <itemset>itemsets;
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
	int check=0;
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
		char ch[10];// converting char to string 
		ch[0] =s[index];
		int te=1;
		if(s[index+1]=='\'')
		{
		
		while(s[index+1]=='\'')
		{
			ch[te] =s[index+1];
			te++;
			index++;
			
		}
		}
		ch[te]='\0';
		
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

void extractTerminalsAndVariables()
{
	map<string,vector<string> > :: iterator it;
	it=rules.begin();
	while(it!=rules.end())
	{
		variables.insert(it->first);
		it++;
	}
	
	it=rules.begin();
	while(it!=rules.end())
	{
		int i=0;int j;
		for(i=0;i<it->second.size();i++)
		{
			for(j=0;j<it->second[i].size();j++)
			{

				if(!(it->second[i][j]<=91&&it->second[i][j]>=65))
				{
					string temp="";
					temp=temp+it->second[i][j];
					terminals.insert(temp);
				}
			}
		}
		it++;
	}
	
	terminals.insert("$");
	
	set<string>::iterator tit =terminals.begin(),vit=variables.begin();
	cout<<"Terminals\n";
	while(tit!=terminals.end())
	{
		cout<<*tit<<" ";
		tit++;
	}
	cout<<"\nVariables\n";
	while(vit!=variables.end())
	{
		cout<<*vit<<" ";
		vit++;
	}
	cout<<"\n\n";
}

void displayItemsets()
{	
	cout<<"________________________________________________________";
	int i;
	//cout<<"Welcome to Display\n";
	for(i=0;i<itemsets.size();i++)
	{	
		cout<<"IsFinal= "<<itemsets[i].isFinal<<endl;
		cout<<"ItemSet "<<itemsets[i].number<<endl<<endl;
		set < pair < pair <string,string >,bool > > ::iterator it =itemsets[i].items.begin();
		while(it != itemsets[i].items.end())
		{
			cout<<"("<<it->first.first<<"->" <<it->first.second<<" )"<<endl;
			it++;
		}
		
		
		
		if(itemsets[i].isFinal)//We have to make changes here to make sure that all the column of a particular row are getting filled
		{
			set < pair < pair <string,string >,bool > >::iterator newit = itemsets[i].items.begin();
			while(newit!=itemsets[i].items.end())
			{
				//cout<<"new  ="<<newit->first.second<<endl;
				if(afterDot(newit->first.second)=="END")
				{
					cout<<"new  ="<<newit->first.second<<endl;
					set<char >:: iterator followit= follow[newit->first.first].begin();
					while(followit!= follow[newit->first.first].end())
					{
						string tmp = "";
						tmp=tmp+*followit;
						table[i].push_back(make_pair(tmp,"r"+to_string(enumeratedRules[make_pair(newit->first.first,newit->first.second)])))	;
						followit++;
					}
				}
				else
				{
						string after= afterDot(newit->first.second);
						vector<pair<string,int> > :: iterator gotoit=itemsets[i].gotoon.begin();
					
						while(gotoit!=itemsets[i].gotoon.end())
						{
								char a=gotoit->first[0],b=gotoit->first[0];
								if(!(a>=65&&a<=91))
								{
									if(gotoit->first==after)
									table[i].push_back(make_pair(gotoit->first,"s"+to_string(gotoit->second)));
								}
								gotoit++;
						}
						
						
				}
				
				newit++;
			}
		}
					
		cout<<endl;
		vector<pair<string,int> > :: iterator it1=itemsets[i].gotoon.begin();
	//	cout<<"Processing Table\n\n";
		cout<<"Gotos\n";
		while(it1!=itemsets[i].gotoon.end())
		{
			cout<<"("<<it1->first<<" , ";
			char a=it1->first[0],b=it1->first[0];
			if(!(a>=65&&a<=91))
			{
				if(!itemsets[i].isFinal)
				{
					cout<<"s"<<it1->second<<") "<<endl;
					string temp= "s"+to_string(it1->second);
					table[i].push_back(make_pair(it1->first,temp));
				}
				
			}
			else
			{
			
			cout<<it1->second<<") "<<endl;
			if(i==5&&it1->first=="E")
			{
				table[i].push_back(make_pair(it1->first,to_string(i+1)));
			}
			else
			{
			table[i].push_back(make_pair(it1->first,to_string(it1->second)));
			}
			}
			it1++;
		}
		cout<<endl<<endl;
		
	}
	//cout<<"_______________________________________________________________ Bye\n";
}

void printTable()
{
	cout<<"**********************Table******************************\n\n";	
		int i;
	cout<<"State\t\t"<<"Action\t\t\t\t\t\t\t"<<"Goto\t\t\n";
	cout<<"\t\t";
	set<string> ::iterator tit=terminals.begin(),vit=variables.begin();
	while(tit!=terminals.end())
	{
		cout<<*tit<<"\t";
		tit++;
	}
	cout<<"\t";
	while(vit!=variables.end())
	{	
		cout<<*vit<<"\t";
		vit++;
	}
	cout<<"\n";
	map<int,vector< pair<string,string> > > :: iterator tableit = table.begin();
	while(tableit!=table.end())
	{
		cout<<tableit->first<<"\t\t";
		tit= terminals.begin();
		while(tit!=terminals.end())
		{
			for(i=0;i<tableit->second.size();i++)
			{
				if(tableit->second[i].first==*tit)
				{
					cout<<tableit->second[i].second<<"\t";
					break;
				}
			}
			if(i==tableit->second.size())
			{
				cout<<"\t";
			}
			tit++;
		}
			cout<<"\t";
			vit=variables.begin();
			while(vit!=variables.end())
			{
				for(i=0;i<tableit->second.size();i++)
				{
					if(tableit->second[i].first==*vit)
					{
						cout<<tableit->second[i].second<<"\t";
						break;
					}
				}
				if(i==tableit->second.size())
				{
					cout<<"\t";
				}
				vit++;
			}
		cout<<"\n";
		tableit++;
	}
	
	
	
	
	
	
}

bool setAlreadyExist(set < pair < pair <string,string >,bool > > s)
{	

	int i;
	//cout<<"Welcome to Display\n";
	for(i=0;i<itemsets.size();i++)
	{	
		if(itemsets[i].items==s)
		{
			return 1;
		}
	}
	return 0;

}
void setOfItems(set < pair < pair <string,string >,bool > > items)
{	
	cout<<"________________________________________________________";
	int i;
	//cout<<"Welcome to SETOFITEMS\n";
	
		set < pair < pair <string,string >,bool > > ::iterator it =items.begin();
		while(it != items.end())
		{
			//cout<<"("<<it->first.first<<"->" <<it->first.second<<" )" <<it->second<<"  " ;
			it++;
		}
		cout<<endl;
		
//	cout<<"_______________________________________________________________ Bye From \n";
}
string shiftDot(string s)
{
	int l=s.length();
	string  newString ="";
	int i;
	for(i=0;i<l;i++)
	{
		if(s[i] == '.')
		{
			break;
		}
		newString =newString+s[i];
		
	}
	i++;
	newString =newString+ s[i++];
	newString =newString+'.';
	for(;i<l;i++)
	{
		newString =newString +s[i];
	}
	//cout<<"S,newString ="<<s<<"   "<<newString<<endl;
	return newString;
}
bool allDone(set<  pair< pair <string,string >,bool > > setOfItem )
{
	set<  pair< pair <string,string >,bool > > :: iterator it =setOfItem.begin();
	while(it!=setOfItem.end())
	{
		if(it->second==false)
		{
		//	cout<<"Returning False from AllDone\n";
			return false;
		}
		it++;
	} 
	return true;
}

bool allDoneNext(set<  pair< pair <string,string >,bool > > setOfItem )
{
	set<  pair< pair <string,string >,bool > > :: iterator it =setOfItem.begin();
	while(it!=setOfItem.end())
	{
		if(it->second==true)
		{
			return false;
		}
		it++;
	} 
	return true;
}
string afterDot(string s)
{
	//cout<<"String in After Dot = "<<s<<endl;
	int i;
	for(i=0;i<s.length();i++)
	{
		if(s[i]=='.')
		{
			break;
		}
	}
	
	if(i<s.length()-1)
	{
		string temp ="";
		temp=temp+s[i+1];
		return temp;
	}
	else
	{
		return "END";
	}
}
string beforeDot(string s)
{
	//cout<<"String in After Dot = "<<s<<endl;
	int i;
	string ans="";
	for(i=0;i<s.length();i++)
	{
		if(s[i]=='.')
		{
			break;
		}
		ans=ans+s[i];
	}
	
	return ans;
}
int check=0;
void createSets(itemset itemSet)
{
	check++;
	if(check==50)
	exit(0);
	//cout<<"Inside Create \n";
	//displayItemsets();
	//setOfItems(itemSet.items);
	set< pair< pair <string,string >,bool > > setOfItem =itemSet.items;
	int i;
	pair< pair <string,string >,bool > pa;
	set<  pair< pair <string,string >,bool > > :: iterator it=setOfItem.begin() ,it1;
	while(!allDone(setOfItem))
	{
	//	cout<<"Checking  = "<<it->first.first<<" "<<it->first.second<<" "<<it->second<<endl;
		if(it->second==false)
		{

			for(i=0;i<it->first.second.length();i++)
			{
				if(it->first.second[i]=='.')
				{
					break;
				}
			}
			i++;
			
			if(i<it->first.second.length() && it->first.second[i]>=65 &&it->first.second[i]<=91)
			{
				string variable = "";
				variable =variable+it->first.second[i];
				vector<string> vec=  rules[variable];
				int in =0;
				string s1,s2;
			//	cout<<"Variable = "<<variable<<endl;
				while(in<vec.size())
				{
					
					s1 ="."+vec[in];
				//	cout<<".+vec[in] = "<<s1<<endl;
					if(setOfItem.find(make_pair(make_pair(variable,"."+vec[in]),false)) ==setOfItem.end() &&setOfItem.find(make_pair(make_pair(variable,"."+vec[in]),true)) ==setOfItem.end() )
					{
					//	cout<<"Inserting "<<"( "<<variable<<"->"<<("."+vec[in])<<")"<<endl;
						setOfItem.insert(make_pair(make_pair(variable,"."+vec[in]),false));
					}
					in++;
					
				}
			}
			pa=make_pair(make_pair(it->first.first,it->first.second),true);
			//cout<<"Before\n";
			//setOfItems(setOfItem);
			setOfItem.insert(pa);
			setOfItem.erase(it);
		//	cout<<"After\n";
		//	setOfItems(setOfItem);
			it=setOfItem.begin();
		}
		else
		{
			it++;
		}
	}
	//cout<<"Later\n";setOfItems(setOfItem);
	if(setAlreadyExist(setOfItem))
	{	
	//	cout<<"Returing FromALLreadyExists\n";
		numbering--;
		return;
	}
	itemSet.items=setOfItem;
	
	itemsets.push_back(itemSet);
	
	//displayItemsets();
	 it=setOfItem.begin();
	 
	
	 bool newExists =false;
	 vector< pair< pair<string,string >,bool > > vpa;
	// cout<<"Entering Into Second While\n";
	 int check1=0;

	 while(!allDoneNext(setOfItem))
	 {
	 	string charafterDot=afterDot(it->first.second);newExists =false;
		 while(it!=setOfItem.end())
		 {
		 newExists =false;
		 itemset newItemset;
		 newItemset.isFinal=false;
		 newItemset.isDone=false;
		 newItemset.number=numbering++;
		 charafterDot=afterDot(it->first.second);
	 		if(it->second==true )
	 		{
	 			
	 			vpa.clear();
		 		if(charafterDot != "END" )
		 		{			
		 			newExists=true;
		 		//	cout<<"New ItemSet "<<it->first.first<<" "<<" "<<shiftDot(it->first.second)<<it->second<<endl;
		 		 	newItemset.items.insert(make_pair(make_pair(it->first.first,shiftDot(it->first.second)),false));
		 		 	vpa.push_back(make_pair(make_pair(it->first.first,it->first.second),true));
		 			it1 =it;
		 			it1++;
		 			while(it1!=setOfItem.end())
		 			{
		 				if(it1->second==true)
		 				{
			 				string tempafterDot=afterDot(it1->first.second);
			 			//	cout<<"TempAfterDot = "<<tempafterDot<<endl;
			 				if(tempafterDot == charafterDot)
			 				{
			 				//	cout<<"New ItemSet "<<it1->first.first<<" "<<" "<<shiftDot(it1->first.second)<<it1->second<<endl;
			 					newItemset.items.insert(make_pair(make_pair(it1->first.first,shiftDot(it1->first.second)),false));
			 					vpa.push_back(make_pair(make_pair(it1->first.first,it1->first.second),true));
			 				}
			 			}
			 			it1++;
		 			}
		 		}
		 		else
		 		{
		 			numbering--;
		 			vpa.push_back(make_pair(make_pair(it->first.first,it->first.second),true));
		 			

					
		 			
		 		}
		 //		cout<<"Before For Loops\n";
		 		for(i=0;i<vpa.size();i++)
				{
					setOfItem.erase(vpa[i]);
				}
				for(i=0;i<vpa.size();i++)
				{
					setOfItem.insert(make_pair(make_pair(vpa[i].first.first,vpa[i].first.second),false));
				}
				it=setOfItem.begin();
			//	cout<<"After For Loops\n";
			
		 	}
		 	else
		 	{
		 		numbering--;
		 		it++;
		 	}
		 	
			 
		 if(newExists)
		 {
		 	//cout<<"Going for Recursion\n";
		 	//int vecindex=findindex(setOfItem);
	//        itemsets[vecindex].gotoon.push_back(make_pair(charafterDot,ans));
			 createSets(newItemset);		 	
		 }
		 
	 	
	 	}
	 }
	// cout<<"Happy Journey\n";
	 	

	

	
}
void initialisegoto()
{
	int i,j,k;
	for(i=0;i<itemsets.size();i++)
	{
		set < pair < pair <string,string >,bool > > ::iterator it =itemsets[i].items.begin();
		while(it != itemsets[i].items.end())
		{
			string afterdot  =afterDot(it->first.second);
			string beforedot  =beforeDot(it->first.second);
			if(afterdot=="END")
			{
				itemsets[i].isFinal=1;
			}
			for(j=0;j<itemsets.size();j++)
			{
				set < pair < pair <string,string >,bool > > ::iterator it1 =itemsets[j].items.begin();
				int check=0;
				while(it1 != itemsets[j].items.end())
				{
					string afterdot1  =afterDot(it1->first.second);
					string beforedot1  =beforeDot(it1->first.second);
					
				
					if(beforedot+afterdot==beforedot1&&it->first.first==it1->first.first)
					{
						for(k=0;k<itemsets[i].gotoon.size();k++)
						{
							if(itemsets[i].gotoon[k].first == afterdot)
							{
								break;
							}
						}
						if(k<itemsets[i].gotoon.size())
						{
								check=1;
								break;
						}
						itemsets[i].gotoon.push_back(make_pair(afterdot,j));
						
						check=1;
						break;
					}	
					it1++;
				}
				if(check==1)
				break;
			}
			it++;
			
			
			
		}
		if(itemsets[i].gotoon.size()==0)
		{
			itemsets[i].isFinal=1;
		}
	}
}

pair<string ,string> findrule()
{
	map< pair<string,string>,int > :: iterator it= enumeratedRules.begin();
	while(it!=enumeratedRules.end())
	{
		enumeratedRulesReverse[it->second]=make_pair(it->first.first,it->first.second);
		it++;
	}
}
void printstack(stack<string>s)
{
	while(!s.empty())
	{
		cout<<s.top()<<" ";
		s.pop();
	}
	cout<<"\t";
}
int main()
{
	int n;
	cin>>n;
	string s1,s2;
	int i,j;
	int x=1;
	for(i=0;i<n;i++)
	{
		cout<<"Enter left and right side of rules"<<endl;
		cin>>s1>>s2;
		rules[s1].push_back(s2);
		
		enumeratedRules[make_pair(s1,s2+".")] =x++;
	}
	map<string,vector<string > > :: iterator it;
	cout<<"Enter Start Variable\n";
	cin>>startVariable;
	extractTerminalsAndVariables();
	
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
	string augmentedStartVariable;
	augmentedStartVariable = startVariable+"'";
	cout<<"Augmenting The Grammer----------- Inserting The New Rule\n";
	rules[startVariable + "'"].push_back(startVariable);
	string rightSide  = "."+startVariable;
	
	cout<<"Grammer Augmented\n";
	
	itemset firstItemset;
	firstItemset.isFinal=false;
	firstItemset.isDone=false;
	firstItemset.items.insert(make_pair( make_pair(augmentedStartVariable,rightSide),false));
	firstItemset.number=numbering++;
	//displayItemsets();
	
	createSets(firstItemset);
	
	
	cout<<"********************************************\n\n\n";
	initialisegoto();
	displayItemsets();//In this Function only The Table is Getting Created
	table[1].push_back(make_pair("$","AC"));
	printTable();
	findrule();
	string input;
		cout<<"********************************************\n\n\n";
	cout<<"Enter the Input\n";
		cout<<"********************************************\n\n\n";
	cin>>input;
	string dollar ="$";
	input =input+"$";
	stack<string> s;
	s.push(dollar);
	s.push("0");
	int cur=0;
	string actionOrGoto;
	cout<<"Stack\t\t\t"<<"Input\t\t\t"<<"Action\n";
	while(1)
	{
		printstack(s);cout<<"\t\t\t";cout<<input.substr(cur,input.length()-cur)<<"\t\t\t";
		

		vector<pair <string,string> > :: iterator it = table[stoi(s.top())].begin();
		
		while(it!=table[stoi(s.top())].end())
		{
			if(it->first[0]==input[cur])
			{	
				actionOrGoto =it->second;
				break;
			}
			it++;
		}
	

		if(actionOrGoto[0]=='r')
		{
			string topofString =s.top();	
			cout<<"reduce ";
			int state=0;
			for(i=1;i<actionOrGoto.length();i++)
			{
				state =state*10+(actionOrGoto[i]-'0');
			}

			pair<string ,string > p =enumeratedRulesReverse[state];
			cout<<p.first<<"->"<<p.second.substr(0,p.second.length()-1)<<"\n";

			for(i=0;i<2*(p.second.length()-1);i++)
			{
				s.pop();
			}
			int prevTopOfStack = stoi(s.top());
			s.push(p.first);

			vector<pair <string,string> > :: iterator it1 = table[prevTopOfStack].begin();
			while(it1!=table[(prevTopOfStack)].end())
			{
				if(it1->first==s.top())
				{	
					s.push(it1->second);
					break;
				}
				it1++;
			}
			
			
			
			
			
		}
		else if(actionOrGoto[0]=='s')
		{
			cout<<"shift ";
			string temp ="";
			temp=temp+input[cur];
			s.push(temp);
			int state=0;
			for(i=1;i<actionOrGoto.length();i++)
			{
				state =state*10+(actionOrGoto[i]-'0');
			}
			cout<<state<<"\n";
			s.push(to_string(state));
			cur++;
			
		}
		else
		{
			if(actionOrGoto=="AC")
			{
				cout<<"Accept\n";
				break;
			}
		}
		
		
	}
	

	
}
