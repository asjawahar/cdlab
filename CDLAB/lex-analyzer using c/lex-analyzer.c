#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define SIZE 128
#define NONE -1
#define EOS '\0'
#define NUM 256
#define KEYWORD 257
#define PAREN 258
#define ID 259
#define ASSIGN 260
#define REL_OP 261
#define DONE 262
#define MAX 999

char lexemes[MAX];
char buffer[SIZE];
int lastchar = -1;
int lastentry = 0;
int tokenval = NONE;
int lineno = 1;

struct entry {
    char *lexptr;
    int token;
} symtable[100];

struct entry keywords[] = {
    {"if", KEYWORD},
    {"else", KEYWORD},
    {"for", KEYWORD},
    {"int", KEYWORD},
    {"float", KEYWORD},
    {"double", KEYWORD},
    {"char", KEYWORD},
    {"struct", KEYWORD},
    {"return", KEYWORD},
    {0, 0}
};

void Error_Message(char *m) {
    fprintf(stderr, "line %d: %s\n", lineno, m);
    exit(1);
}

int look_up(char s[]) {
    int k;
    for (k = lastentry; k > 0; k--) {
        if (strcmp(symtable[k].lexptr, s) == 0) return k;
    }
    return 0;
}

int insert(char s[], int tok) {
    int len = strlen(s);
    if (lastentry + 1 >= MAX) Error_Message("Symbol Table is Full");
    if (lastchar + len + 1 >= MAX) Error_Message("Lexemes Array is Full");

    lastentry++;
    symtable[lastentry].token = tok;
    symtable[lastentry].lexptr = &lexemes[lastchar + 1];
    lastchar = lastchar + len + 1;
    strcpy(symtable[lastentry].lexptr, s);

    return lastentry;
}

void Initialize() {
    struct entry *ptr;
    for (ptr = keywords; ptr->token; ptr++) insert(ptr->lexptr, ptr->token);
}

int lexer() {
    int t;
    int i = 0;

    while (1) {
        t = getchar();

        if (t == ' ' || t == '\t') {
            continue;
        } else if (t == '\n') {
            lineno++;
        } else if (t == '(' || t == ')') {
            return PAREN;
        } else if (t == '<' || t == '>' || t == '!' || t == '=') {
            int next = getchar();
            if (next == '=' || (t == '!' && next == '=')) {
                return REL_OP;
            } else {
                ungetc(next, stdin);
                if (t == '=') return ASSIGN;
            }
        } else if (isdigit(t)) {
            ungetc(t, stdin);
            scanf("%d", &tokenval);
            return NUM;
        } else if (isalpha(t)) {
            while (isalnum(t)) {
                buffer[i++] = t;
                t = getchar();
                if (i >= SIZE) Error_Message("Buffer Overflow");
            }
            buffer[i] = EOS;
            if (t != EOF) ungetc(t, stdin);

            int val = look_up(buffer);
            if (val == 0) val = insert(buffer, ID);
            tokenval = val;
            return symtable[val].token;
        } else if (t == EOF) {
            return DONE;
        } else {
            tokenval = NONE;
            return t;
        }
    }
}

int main() {
    int lookahead;
    Initialize();

    printf("Program for Lexical Analysis\n");
    printf("Enter the expression and put ; at the end\n");
    printf("Press Ctrl + D (or Ctrl + Z in Windows) to terminate...\n");

    lookahead = lexer();
    while (lookahead != DONE) {
        switch (lookahead) {
            case NUM:
                printf("Number: %d\n", tokenval);
                break;
            case '+': case '-': case '*': case '/':
                printf("Operator: %c\n", lookahead);
                break;
            case PAREN:
                printf("Parenthesis\n");
                break;
            case ID:
                printf("Identifier: %s\n", symtable[tokenval].lexptr);
                break;
            case KEYWORD:
                printf("Keyword\n");
                break;
            case ASSIGN:
                printf("Assignment Operator\n");
                break;
            case REL_OP:
                printf("Relational Operator\n");
                break;
            default:
                printf("Unknown symbol: %c\n", lookahead);
                break;
        }
        lookahead = lexer();
    }

    return 0;
}
