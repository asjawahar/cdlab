%{
#include "y.tab.h"  // Include the Bison header for token definitions
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap 

ID          [a-zA-Z][a-zA-Z0-9]*
NUM         [0-9]+
ASSIGN      "="
INT         "int"
FLOAT       "float"

%%

{INT}       { return INT; }
{FLOAT}     { return FLOAT; }
{ASSIGN}    { return ASSIGN; }
{ID}        { yylval.str = strdup(yytext); return ID; }
{NUM}       { yylval.num = atoi(yytext); return NUM; }

%%

