ReadMe:

1. Abstract Syntax Tree (AST): Dump the AST using:
    gcc -fdump-tree-original-raw -dumpdir AST/ -c program.c
    nano AST/program.c.005t.original

    This will create a file program.c.005t.original containing the AST dump.
    AST: The Abstract Syntax Tree (AST) is a high-level tree structure representing the
        source code in a hierarchical manner, reflecting the program's syntax.

2. GIMPLE Representation: Dump the GIMPLE form using:
    gcc -fdump-tree-gimple-raw -dumpdir GIMPLE/ -c program.c
    nano GIMPLE/program.c.006t.gimple

    This will create a file program.c.006t.gimple with the GIMPLE dump.
    GIMPLE: This is a lower-level representation where each operation is broken down into simple 
        three-address code. This form is closer to machine instructions but still high-level.

3. Control Flow Graph (CFG): Dump the CFG using:
    gcc -fdump-tree-cfg-raw -dumpdir CFG/ -c program.c
    nano CFG/program.c.015t.cfg

    This will generate program.c.015t.cfg containing the CFG.
    CFG: The Control Flow Graph shows how different blocks of code (like loops and conditionals) 
        are structured and how control moves from one block to another during execution.

4. Register Transfer Language (RTL): Dump the RTL using:
    gcc -da -dumpdir RTL/ -c program.c
    nano RTL/program.c.245r.expand

    This will generate several files like program.c.245r.expand that contain the RTL dump.
    RTL: The Register Transfer Language is a very low-level representation that reflects actual operations 
        on machine registers and memory. It’s the final stage before generating assembly code.

