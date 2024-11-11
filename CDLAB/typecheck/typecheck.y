%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 10

// Symbol Table Definition
struct SymbolTable {
    char name[15];
    char type;  // 'i' for int, 'f' for float
};

struct SymbolTable symbolTable[MAX_VARS];
int varCount = 0;

// Function prototypes
int yylex(void);  // Declare yylex()
void add_symbol(char *name, char type);
int get_symbol_type(char *name);
int yyerror(const char *s);

%}

%union {
    int num;
    char *str;
    char type;
}

%token <str> ID
%token <num> NUM
%token ASSIGN INT FLOAT

%type <type> type
%type <num> expr
%type <str> statement

%%

program:
    declarations statements
;

declarations:
    declarations declaration
    | /* empty */
;

declaration:
    type ID { add_symbol($2, $1); }
;

type:
    INT { $$ = 'i'; }
    | FLOAT { $$ = 'f'; }
;

statements:
    statements statement
    | /* empty */
;

statement:
    ID ASSIGN expr { 
        int varType = get_symbol_type($1);
        if (varType == -1) {
            printf("Error: Undefined variable %s\n", $1);
            exit(1);
        }
        if (varType != $3) {
            printf("Error: Type mismatch in assignment to variable %s\n", $1);
            exit(1);
        }
        printf("Assignment to %s is valid.\n", $1);
    }
    | ID ASSIGN NUM { 
        int varType = get_symbol_type($1);
        if (varType == -1) {
            printf("Error: Undefined variable %s\n", $1);
            exit(1);
        }
        printf("Assignment to %s is valid.\n", $1);
    }
;

expr:
    NUM { $$ = 'i'; }
    | ID { 
        $$ = get_symbol_type($1);
        if ($$ == -1) {
            printf("Error: Undefined variable %s\n", $1);
            exit(1);
        }
    }
;

%%

void add_symbol(char *name, char type) {
    if (varCount < MAX_VARS) {
        strcpy(symbolTable[varCount].name, name);
        symbolTable[varCount].type = type;
        varCount++;
    } else {
        printf("Error: Symbol table is full\n");
        exit(1);
    }
}

int get_symbol_type(char *name) {
    for (int i = 0; i < varCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return symbolTable[i].type;
        }
    }
    return -1;  // Not found
}

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}

int main() {
    printf("Enter the program:\n");
    yyparse();
    return 0;
}
