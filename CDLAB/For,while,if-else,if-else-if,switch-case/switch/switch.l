%{
#include <stdio.h>
#include "y.tab.h"
%}

alpha [A-Za-z]
digit [0-9]

%%
[ \n\t]                 ;
if                      return IF;
then                    return THEN;
while                   return WHILE;
switch                  return SWITCH;
case                    return CASE;
default                 return DEFAULT;
break                   return BREAK;
{digit}+                return NUM;
{alpha}({alpha}|{digit})* return ID;
"<="                    return LE;
">="                    return GE;
"=="                    return EQ;
"!="                    return NE;
"&&"                    return AND;
"||"                    return OR;
.                       return yytext[0];
%%

int yywrap() { return 1; }
