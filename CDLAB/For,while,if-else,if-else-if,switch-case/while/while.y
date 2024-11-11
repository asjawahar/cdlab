%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char* s);
%}

%token ID NUM WHILE LE GE EQ NE OR AND

%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right UMINUS
%left '!'

%%

S   : ST1 { printf("Input accepted.\n"); exit(0); };
ST1 : WHILE '(' E2 ')' '{' ST '}'   // While loop structure
    ;

ST  : ST ST                          // Nested statements
    | E ';'                          // Expression followed by semicolon
    |                               // Empty rule for optional statement
    ;

E   : ID '=' E                       // Assignment statement
    | E '+' E                        // Addition
    | E '-' E                        // Subtraction
    | E '*' E                        // Multiplication
    | E '/' E                        // Division
    | E '<' E                        // Less than
    | E '>' E                        // Greater than
    | E LE E                         // Less than or equal
    | E GE E                         // Greater than or equal
    | E EQ E                         // Equal to
    | E NE E                         // Not equal to
    | E OR E                         // Logical OR
    | E AND E                        // Logical AND
    | E '+' '+'                      // Post-increment
    | E '-' '-'                      // Post-decrement
    | '(' E ')'                      // Parentheses around expression
    | ID                             // Identifier
    | NUM                            // Number
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
    printf("Enter the expression:\n");	
    yyparse();
    return 0; 
}

void yyerror(const char* s) {
    printf("Entered arithmetic expression is Invalid\n");
    exit(1);
}
