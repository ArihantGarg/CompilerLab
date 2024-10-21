runcpp:
	echo "\nExecuting Via C++ File\n"
	g++ s_grammar.cpp
	./a.out < expr_in.txt > cpp_out.txt

runlex:
	echo "\nExecuting Via Lex File\n"
	lex a.l 
	yacc -d a.y
	gcc lex.yy.c y.tab.c -ll -w
	./a.out < expr_in.txt > lex_out.txt