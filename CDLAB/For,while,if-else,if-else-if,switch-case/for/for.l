%{
#include <stdio.h>
#include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]

%%

"for"           { return FOR; }              // Matches the keyword "for"
{digit}+        { return NUM; }              // Matches numbers
{alpha}({alpha}|{digit})* { return ID; }     // Matches identifiers (variable names)
"<="            { return LE; }                // Matches "<="
">="            { return GE; }                // Matches ">="
"=="            { return EQ; }                // Matches "=="
"!="            { return NE; }                // Matches "!="
"||"            { return OR; }                // Matches "||"
"&&"            { return AND; }               // Matches "&&"
[ \t\n]+        { /* Ignore whitespace */ }   // Ignores spaces, tabs, and newlines
.               { return yytext[0]; }         // Return any other character as itself

%%

int yywrap() {
    return 1;  // End of file or input
}
