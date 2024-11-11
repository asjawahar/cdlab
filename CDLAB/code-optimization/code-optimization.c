#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

struct ConstFold {
    char new_Str[50];
    char str[50];
} Opt_Data[20];

int New_Index = 0;

void ReadInput(char Buffer[], FILE *Out_file);
int Gen_token(char str[], char Tokens[][10]);

int main() {
    FILE *In_file, *Out_file;
    char Buffer[100], ch;
    int i = 0;

    // Open input file
    In_file = fopen("code.txt", "r");
    if (!In_file) {
        printf("Error opening input file 'code2.txt'. Please check the file path and permissions.\n");
        return 1;
    }

    // Open output file
    Out_file = fopen("output1.txt", "w");
    if (!Out_file) {
        printf("Error opening output file 'output1.txt'. Please check the file path and permissions.\n");
        return 1;
    }

    // Read and process each line from the input file
    while (1) {
        ch = fgetc(In_file);
        int i = 0;
        while (1) {
            if (ch == '\n') break; // End of line
            Buffer[i++] = ch;
            ch = fgetc(In_file);
            if (ch == EOF) break; // End of file
        }
        Buffer[i] = '\0'; // Null-terminate the buffer
        ReadInput(Buffer, Out_file); // Process and write to output
        if (ch == EOF) break; // End of file reached
    }

    // Close both files
    fclose(In_file);
    fclose(Out_file);

    return 0;
}

void ReadInput(char Buffer[], FILE *Out_file) {
    char temp[100], Token[10][10];
    int n, i, j, flag = 0;

    // Copy input to temp buffer
    strcpy(temp, Buffer);

    // Tokenize the input string
    n = Gen_token(temp, Token);

    // Perform constant folding and optimizations
    for (i = 0; i < n; i++) {
        if (!strcmp(Token[i], "=")) {
            if (isdigit(Token[i + 1][0]) || Token[i + 1][0] == '.') {
                flag = 1;
                if (New_Index < 20) {
                    strcpy(Opt_Data[New_Index].new_Str, Token[i - 1]);
                    strcpy(Opt_Data[New_Index++].str, Token[i + 1]);
                }
            }
        }
    }

    // Replace variables with constants
    if (!flag) {
        for (i = 0; i < New_Index; i++) {
            for (j = 0; j < n; j++) {
                if (!strcmp(Opt_Data[i].new_Str, Token[j])) {
                    strcpy(Token[j], Opt_Data[i].str);
                }
            }
        }
    }

    // Prepare the updated tokens for output
    strcpy(temp, " ");
    for (i = 0; i < n; i++) {
        strcat(temp, Token[i]);
        if (Token[i + 1][0] != ',' || Token[i + 1][0] != ',') strcat(temp, " ");
    }
    strcat(temp, "\n\0");

    // Write the processed content to the output file
    size_t len = strlen(temp);
    fwrite(temp, sizeof(char), len, Out_file);  // Write the updated code to the output file
}

// Function to tokenize input string into individual tokens
int Gen_token(char str[], char Token[][10]) {
    int i = 0, j = 0, k = 0;

    while (str[k] != '\0') {
        j = 0;
        // Skip whitespace characters
        while (str[k] == ' ' || str[k] == '\t') k++;

        // Read token until a delimiter is encountered
        while (str[k] != ' ' && str[k] != '\0' && str[k] != '=' && str[k] != '/' && str[k] != '+' && str[k] != '-' && str[k] != '*' && str[k] != ',' && str[k] != ';') {
            Token[i][j++] = str[k++];
        }
        Token[i++][j] = '\0';

        // Handle delimiters
        if (str[k] == '=' || str[k] == '/' || str[k] == '+' || str[k] == '-' || str[k] == '*' || str[k] == ',' || str[k] == ';') {
            Token[i][0] = str[k++];
            Token[i++][1] = '\0';
        }

        // End of string
        if (str[k] == '\0') break;
    }

    return i;
}
