run:
	lex parser.l
	yacc -d parser.y
	gcc lex.yy.c y.tab.c -o parser -ll
	./parser < input.txt
