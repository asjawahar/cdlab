%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

// Declaration of yylex and yyerror to avoid implicit declaration warnings
int yylex();
void yyerror(const char *);
%}

alpha [A-Za-z]
digit [0-9]

%%
[ \t\n]                   ;
if                        return IF;
then                      return THEN;
else                      return ELSE;
elseif                    return ELSEIF;
{digit}+                  return NUM;
{alpha}({alpha}|{digit})* return ID;
"<="                      return LE;
">="                      return GE;
"=="                      return EQ;
"!="                      return NE;
"||"                      return OR;
"&&"                      return AND;
.                         return yytext[0];
%%

int yywrap() { return 1; }
