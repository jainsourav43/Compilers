#include<bits/stdc++.h>
using namespace std;
map<string,vector<string> > rules,newrules;
string startVariable;
map<int,vector< pair<string,string> > > table; 
struct itemset 
{
	set < pair < pair <string,string >,bool > > items;
	bool isFinal;
	bool isDone;
	int number;
	vector<pair<string,int> > gotoon;
};
int numbering=0,ans;
vector <itemset>itemsets;
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
		cout<<endl;
		vector<pair<string,int> > :: iterator it1=itemsets[i].gotoon.begin();
		cout<<"Gotos\n";
		while(it1!=itemsets[i].gotoon.end())
		{
			cout<<"("<<it1->first<<" , ";
			char a=it1->first[0],b=it1->first[0];
			if(!(a>=65&&b<=91))
			{
				if(itemsets[i].isFinal)//We have to make changes here to make sure that all the column of a particular row are getting filled
				{
				cout<<"r"<<it1->second<<") "<<endl;
				string temp= "r"+to_string(it1->second);
				table[i].push_back(make_pair(it1->first,temp));
				}
				else
				{
					cout<<"s"<<it1->second<<") "<<endl;
					string temp= "s"+to_string(it1->second);
					table[i].push_back(make_pair(it1->first,temp));
				}
			}
			else
			{
			cout<<it1->second<<") "<<endl;
			table[i].push_back(make_pair(it1->first,to_string(it1->second)));
			}
			it1++;
		}
		cout<<endl<<endl;
		
	}
	//cout<<"_______________________________________________________________ Bye\n";
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
int findindex(set<  pair< pair <string,string >,bool > > setOfItem )
{
	set<  pair< pair <string,string >,bool > > :: iterator it1,it2 ;
	for(int i=0;i<itemsets.size();i++)
	{
		it1 =setOfItem.begin();
		it2=itemsets[i].items.begin();
		while(it1!=setOfItem.end()&&it2!=itemsets[i].items.end())
		{
			if(!(it1->first.first==it2->first.first&&it1->first.second==it2->first.second))
			{
				break;
			}
			it1++;
			it2++;
		}
		if(it1==setOfItem.end()&&it2==itemsets[i].items.end())
		{
			ans=itemsets[i].number;
			return i;
		}
		
	}
	return 0;
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




int main()
{
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
	displayItemsets();

}
