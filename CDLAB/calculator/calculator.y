%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);             // Declare yylex to avoid implicit declaration warnings
void yyerror(const char *);   // Declare yyerror to avoid implicit declaration warnings
%}

%token NAME NUMBER
%left GE LE NE EQ '<' '>' '%'
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%%
statement : NAME '=' exp
          | exp { printf("=%d\n", $1); }
          ;

exp       : NUMBER              { $$ = $1; }
          | exp '+' exp         { $$ = $1 + $3; }
          | exp '-' exp         { $$ = $1 - $3; }
          | exp '*' exp         { $$ = $1 * $3; }
          | exp '/' exp         { $$ = $1 / $3; }
          | '-' exp %prec UMINUS { $$ = -$2; }
          | '(' exp ')'         { $$ = $2; }
          ;
%%

int main() {
    printf("Enter the expression: ");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    printf("\nError occurred: %s\n", s);
}
