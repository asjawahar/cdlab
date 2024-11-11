%{
#include <stdio.h>
#include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]

%%

[\t\n]           /* Ignore whitespace */;
"while"          { return WHILE; }    // Matches the 'while' keyword
{digit}+         { return NUM; }      // Matches a number
{alpha}({alpha}|{digit})* { return ID; } // Matches identifier (variables)
"<="             { return LE; }        // Less than or equal
">="             { return GE; }        // Greater than or equal
"=="             { return EQ; }        // Equal to
"!="             { return NE; }        // Not equal to
"||"             { return OR; }        // Logical OR
"&&"             { return AND; }       // Logical AND
.                { return yytext[0]; } // Return any other character

%%

int yywrap() {
    return 1;  // End of file or input
}
