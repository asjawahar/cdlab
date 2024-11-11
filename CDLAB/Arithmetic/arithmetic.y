%{
#include<stdio.h>
void yyerror(const char *s);
int yylex();
%}
%token NUMBER
%token VARIABLE
%left '+' '-'
%left '*' '/' '%'
%left '(' ')'
%%
S: VARIABLE '=' E {
    printf("\nEntered arithmetic expression is Valid\n\n"); 
    return 0;
}
;
E: E '+' E
 | E '-' E
 | E '*' E
 | E '/' E
 | E '%' E
 | '(' E ')'
 | NUMBER
 | VARIABLE
;
%%
int main() {
    printf("\nEnter Any Arithmetic Expression:\n"); 
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    printf("\nEntered arithmetic expression is Invalid\n\n");
}
