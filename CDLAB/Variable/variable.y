%{
#include<stdio.h> 
#include<stdlib.h>
int yylex();
void yyerror(const char *s);
%}
%token ALPHA NUMBER ENTER ER
%%
var : v ENTER { printf(" Valid Variable\n"); exit(0);} 
;

v:ALPHA exp1 
;
exp1:ALPHA exp1
 
|NUMBER exp1
|
;
%%
void yyerror(const char *s)
{
    printf("Invalid Variable\n");
    exit(1);
}

int main() { printf("Enter the Expression : "); yyparse(); return 0; }
