# iph

A interpreter and parser in Haskell.

### Generating the Parser

The _Parser.y_ source code contains the definitions accepted by _Happy_ for generating the lexical and syntactic analyzer. To generate, just run the command `happy Parser.y`.

Whenever you add/change any information in the _Parser.y_ file, you need to run the above command again.

If the system displays an error message informing you that the _Happy_ command does not exist, you must install it on your system. To do this, just run the command `sudo apt install happy`.

### Running the Interpreter

To run/test the developed interpreter, we will use the `runghc` program through the `runghc Interpreter.hs` command.

When executing this command, the program waits for the user's input, who can type the expression to be interpreted. As an example, let's type the expression `2 + 4` and press _ENTER_.

For the result to be displayed, we still need to use the key combinations _CTRL + Z_ (_CTRL + D_ in Linux). These commands in sequence are shown below.

```
2 + 4 <enter>
<CTRL + Z> <enter>
```

After this procedure, the result of the interpreter processing will be displayed on the screen.

```
Just (Num 6)
```

### Later Implementations

As a college assignment, I later implemented a _Pairs_ constructor from Benjamin Pierce's book _Types and Programming Languages_.

The implementation of a parser was also carried out, using a parser generator for Haskell, in which _Happy_ was chosen for the work developed.

To reach this goal, it was done:

- Appropriation of Abstract Syntax Tree (AST)
- Adaptation of the functions that perform the semantic evaluation (step functions)
- Adaptation of type checking functions (typeof functions)
- Parser implementation and integration with the language's AST

To see the code in action, you can run the interpreter and type `tp (1, 2)` (parses and returns the first) or `ts (1, 2)` (parses and returns the second). It also accepts boolean values.

### More Information

More details about the functions can be found in comments in the _Parser.y_ and _Interpreter.hs_ files.
