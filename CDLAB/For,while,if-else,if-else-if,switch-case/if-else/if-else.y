%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int yylex();                // Declare yylex to avoid implicit declaration warnings
void yyerror(const char *); // Declare yyerror to avoid implicit declaration warnings
%}

%token ID NUM IF THEN LE GE EQ NE OR AND ELSE
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right UMINUS
%left '!'

%%
S   : ST { printf("Input accepted.\n"); exit(0); }
    ;

ST  : IF '(' E2 ')' THEN ST1 ';' ELSE ST1 ';'
    | IF '(' E2 ')' THEN ST1 ';'
    ;

ST1 : ST
    | E
    ;

E   : ID '=' E
    | E '+' E
    | E '-' E
    | E '*' E
    | E '/' E
    | E '<' E
    | E '>' E
    | E LE E
    | E GE E
    | E EQ E
    | E NE E
    | E OR E
    | E AND E
    | ID
    | NUM
    ;

E2  : E '<' E
    | E '>' E
    | E LE E
    | E GE E
    | E EQ E
    | E NE E
    | E OR E
    | E AND E
    | ID
    | NUM
    ;
%%

int main() {
    printf("Enter the expression: ");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    printf("\nEntered arithmetic expression is invalid.\n\n");
}
