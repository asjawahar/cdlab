%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int yylex();               // Declare yylex to avoid implicit declaration warnings
void yyerror(const char *); // Declare yyerror to avoid implicit declaration warnings
%}

%token ID NUM SWITCH CASE DEFAULT BREAK LE GE EQ NE AND OR IF THEN WHILE
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right UMINUS
%left '!'

%%
S   : ST { printf("\nInput accepted.\n"); exit(0); }
    ;

ST  : SWITCH '(' ID ')' '{' B '}'
    ;

B   : C
    | C D
    ;

C   : C C
    | CASE NUM ':' ST1 BREAK ';'
    ;

D   : DEFAULT ':' ST1 BREAK ';'
    | DEFAULT ':' ST1
    ;

ST1 : WHILE '(' E2 ')' E ';'
    | IF '(' E2 ')' THEN E ';'
    | ST1 ST1
    | E ';'
    ;

E2  : E '<' E
    | E '>' E
    | E LE E
    | E GE E
    | E EQ E
    | E NE E
    | E AND E
    | E OR E
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
    | E AND E
    | E OR E
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
