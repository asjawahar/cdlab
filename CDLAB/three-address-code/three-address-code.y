%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct Symbol_Table {
    char sym_name[10];
    char sym_type[10];
    double value;
} Sym[10];

struct Quadruple {
    char operator[5];
    char operand1[10];
    char operand2[10];
    char result[10];
} QUAD[25];

struct Stack {
    char *items[10];
    int top;
} Stk;

int sym_cnt = 0;
int Index = 0;
int temp_var = 0;

int search_symbol(char []);
void make_symtab_entry(char [], char [], double);
void display_sym_tab();
void addQuadruple(char [], char [], char [], char []);
void display_Quadruple();
void push(char *);
char *pop();

int yyerror(const char *s);
int yylex(void);

%}

%union {
    int ival;
    double dval;
    char *string;
}

%token <dval> NUMBER
%token <string> TYPE
%token <string> ID
%type <string> varlist
%type <string> expr
%token MAIN
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

program: MAIN '(' ')' '{' body '}' ;

body: varstmt stmtlist ;

varstmt: vardecl varstmt | ;

vardecl: TYPE varlist ';' ;

varlist: varlist ',' ID {
        int i = search_symbol($3);
        if(i != -1)
            printf("\n Multiple Declaration of Variable");
        else
            make_symtab_entry($3, $<string>0, 0);
    }
    | ID '=' NUMBER {
        int i = search_symbol($1);
        if(i != -1)
            printf("\n Multiple Declaration of Variable");
        else
            make_symtab_entry($1, $<string>0, $3);
    }
    | varlist ',' ID '=' NUMBER {
        int i = search_symbol($3);
        if(i != -1)
            printf("\n Multiple Declaration of Variable");
        else
            make_symtab_entry($3, $<string>0, $5);
    }
    | ID {
        int i = search_symbol($1);
        if(i != -1)
            printf("\n Multiple Declaration of Variable");
        else
            make_symtab_entry($1, $<string>0, 0);
    };

stmtlist: stmt stmtlist | ;

stmt : ID '=' NUMBER ';' {
        int i = search_symbol($1);
        if(i == -1)
            printf("\n Undefined Variable");
        else {
            char temp[10];
            if(strcmp(Sym[i].sym_type, "int") == 0)
                sprintf(temp, "%d", (int)$3);
            else
                snprintf(temp, 10, "%f", $3);
            addQuadruple("=", "", temp, $1);
        }
    }
    | ID '=' ID ';' {
        int i = search_symbol($1);
        int j = search_symbol($3);
        if(i == -1 || j == -1)
            printf("\n Undefined Variable");
        else
            addQuadruple("=", "", $3, $1);
    }
    | ID '=' expr ';' {
        addQuadruple("=", "", pop(), $1);
    };

expr : expr '+' expr {
        char str[5], str1[5] = "t";
        sprintf(str, "%d", temp_var++);
        strcat(str1, str);
        addQuadruple("+", pop(), pop(), str1);
        push(str1);
    }
    | expr '-' expr {
        char str[5], str1[5] = "t";
        sprintf(str, "%d", temp_var++);
        strcat(str1, str);
        addQuadruple("-", pop(), pop(), str1);
        push(str1);
    }
    | expr '*' expr {
        char str[5], str1[5] = "t";
        sprintf(str, "%d", temp_var++);
        strcat(str1, str);
        addQuadruple("*", pop(), pop(), str1);
        push(str1);
    }
    | expr '/' expr {
        char str[5], str1[5] = "t";
        sprintf(str, "%d", temp_var++);
        strcat(str1, str);
        addQuadruple("/", pop(), pop(), str1);
        push(str1);
    }
    | ID {
        int i = search_symbol($1);
        if(i == -1)
            printf("\n Undefined Variable");
        else
            push($1);
    }
    | NUMBER {
        char temp[10];
        snprintf(temp, 10, "%f", $1);
        push(temp);
    };

%%

int main() {
    Stk.top = -1;
    printf("Enter the expression: ");
    yyparse();
    display_sym_tab();
    printf("\n\n");
    display_Quadruple();
    printf("\n\n");
    return 0;
}

int search_symbol(char sym[10]) {
    for(int i = 0; i < sym_cnt; i++) {
        if(strcmp(Sym[i].sym_name, sym) == 0)
            return i;
    }
    return -1;
}

void make_symtab_entry(char sym[10], char dtype[10], double val) {
    strcpy(Sym[sym_cnt].sym_name, sym);
    strcpy(Sym[sym_cnt].sym_type, dtype);
    Sym[sym_cnt].value = val;
    sym_cnt++;
}

void display_sym_tab() {
    printf("\n\nThe Symbol Table\n\n");
    printf("Name    Type    Value\n");
    for(int i = 0; i < sym_cnt; i++)
        printf("%s     %s     %f\n", Sym[i].sym_name, Sym[i].sym_type, Sym[i].value);
}

void display_Quadruple() {
    printf("\n\nThe Intermediate Code\n\n");
    printf("Result    Operator    Operand1    Operand2\n");
    for(int i = 0; i < Index; i++)
        printf("%s        %s        %s        %s\n", QUAD[i].result, QUAD[i].operator, QUAD[i].operand1, QUAD[i].operand2);
}

int yyerror(const char *s) {
    printf("\nError: %s\n", s);
    return 1;
}

void push(char *str) {
    Stk.items[++Stk.top] = strdup(str);
}

char *pop() {
    if (Stk.top == -1) {
        printf("\nStack Empty!\n");
        exit(0);
    }
    return Stk.items[Stk.top--];
}

void addQuadruple(char op[10], char op2[10], char op1[10], char res[10]) {
    strcpy(QUAD[Index].operator, op);
    strcpy(QUAD[Index].operand2, op2);
    strcpy(QUAD[Index].operand1, op1);
    strcpy(QUAD[Index].result, res);
    Index++;
}
