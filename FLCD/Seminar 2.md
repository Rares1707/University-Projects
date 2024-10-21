## Scanning algorithm

`input:`
+ source.txt
+ tokens.txt (reserved words, operators, separators)

`output:`
+ PIF (program internal form)
+ ST (symbol table)
+ lexical errors (if any)

### PIF:
two columns:
+ token (operators, separators, constants are noted as const, identifiers are noted as id)
+ symbol table position (-1 for anything that is not a constant or identifier)

### Symbol table:
two columns (only one entry per TOKEN (wheter it is identifier or constant)):
+ position (0-indexing)
+ symbol (identifier or constant) (strings should be between "")

Splitting a line into tokens is done by splitting it using the separators and operators (AND you need to KEEP the separators/operators as tokens).

Lexical errors are unclassified tokens (and only that). 
Examples: 
+ 0a as identifier - invalid identifier (and it's not a string because it is not between "")
+ using $ - character not in alphabet
+ 01 or +0 or -0 - invalid integer constant (because 0 can't have a sign due to how we defined it) (check for things like a=1+0, they are allowed)

> [!CAUTION]
> Quotes are part of the strings, missing a quote is a lexical error

Btw valorile din hashtable sunt salvate ca string-uri (iar diferentierea dintre string-uri si identifiere/numere se face prin '')

Din symbol table trebuie sa poti returna pozitia (indexul bin-ului si pozitia din bin pt separate chaining). Deci pozitia e pair la mine

Ne trebuie doar adaugare (care poate sa ne reutrneze si pozitia pe care a fost adaugat) si cautare (DUPA VALOARE, nu dupa index) (cautarea ne returneaza pozitia din st pe care se afla elementul)
