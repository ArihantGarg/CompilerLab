run:
	bison Codes/parser.y -o Codes/parser.tab.c
	flex -o Codes/lex.yy.c Codes/lex.l
	gcc Codes/parser.tab.c -o Codes/parser  -ll
	./Codes/parser