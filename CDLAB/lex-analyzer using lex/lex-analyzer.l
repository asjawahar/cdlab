%{
#include <stdio.h>
#include <stdlib.h>
%}

identifier   [a-zA-Z][a-zA-Z0-9]*

%%

#.*                        { printf("\n%s is a preprocessor directive", yytext); }

int | float | char | double | while | do |
if | break | continue | void | switch | return | else |
goto                       { printf("\n%s is a keyword", yytext); }

{identifier}\(              { printf("\nfunction %s", yytext); }
\{                          { printf("\nblock begins"); }
\}                          { printf("\nblock ends"); }
\(                          { printf("\n"); ECHO; }

{identifier}(\[[0-9]*\])*  { printf("\n%s is an identifier", yytext); }
\".*\"                      { printf("\n%s is a string", yytext); }
[0-9]+                      { printf("\n%s is a number", yytext); }

\<= | \>= | \< | \> | \==   { printf("\n%s is a relational operator", yytext); }
\= | \+ | \- | \/ | \&      { printf("\n%s is an operator", yytext); }

.                           { ECHO; }

\n                          ;

%%

int main(int argc, char **argv)
{
    FILE *file;
    file = fopen("inp.c", "r");
    if (!file) {
        printf("could not open the file!!!");
        exit(0);
    }
    yyin = file;
    yylex();
    printf("\n\n");
    return 0;
}

int yywrap()
{
    return 1;
}
