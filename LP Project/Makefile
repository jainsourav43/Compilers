first:	first.l first.y
	bison -d first.y
	flex first.l
	g++ -o $@ first.tab.c lex.yy.c -lfl -std=c++11
