%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

[ \n\t]+                         ;
main                             { return MAIN; }
int|float|double|char            { yylval.string = strdup(yytext); return TYPE; }
[a-zA-Z][a-zA-Z0-9_]*            { yylval.string = strdup(yytext); return ID; }
[0-9]+                           { yylval.dval = atof(yytext); return NUMBER; }
[0-9]+\.[0-9]+                   { yylval.dval = atof(yytext); return NUMBER; }
.                                { return yytext[0]; }

%%

int yywrap() { return 1; }
