#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int label[20];  // Array to store labels
int no = 0;     // Number of labels

// Function to check if the label already exists
int check_label(int n) {
    int i;
    for (i = 0; i < no; i++) {
        if (n == label[i]) {
            return 1;  // Label found
        }
    }
    return 0;  // Label not found
}

int main() {
    FILE *fp1, *fp2;
    int check_label(int n);
    char fname[10], op[10], ch;
    char operand1[8], operand2[8], result[8];
    int i = 0, j = 0;

    // Ask user for input file name
    printf("\nEnter filename of the intermediate code: ");
    scanf("%s", fname);

    // Open the input and output files
    fp1 = fopen(fname, "r");
    fp2 = fopen("target.txt", "w");

    if (fp1 == NULL || fp2 == NULL) {
        printf("\nError opening the file");
        exit(0);
    }

    // Process the intermediate code
    while (!feof(fp1)) {
        fprintf(fp2, "\n");
        fscanf(fp1, "%s", op);
        i++;

        // Check if a label needs to be printed
        if (check_label(i)) {
            fprintf(fp2, "\nlabel#%d:", i);
        }

        // Handle different operations
        if (strcmp(op, "print") == 0) {
            fscanf(fp1, "%s", result);
            fprintf(fp2, "\n\t OUT %s", result);
        }

        else if (strcmp(op, "goto") == 0) {
            fscanf(fp1, "%s", operand2);
            fprintf(fp2, "\n\t JMP label#%s", operand2);
            label[no++] = atoi(operand2);
        }

        // Handle array assignment (e.g., [] = a)
        else if (strcmp(op, "[]=") == 0) {
            fscanf(fp1, "%s %s %s", operand1, operand2, result);
            fprintf(fp2, "\n\t STORE %s[%s], %s", operand1, operand2, result);
        }

        // Handle unary minus (uminus)
        else if (strcmp(op, "uminus") == 0) {
            fscanf(fp1, "%s %s", operand1, result);
            fprintf(fp2, "\n\t MOV R1, -%s", operand1);
            fprintf(fp2, "\n\t MOV %s, R1", result);
        }

        // Handle arithmetic and logical operations based on operator
        else {
            switch (op[0]) {
                case '*':
                    fscanf(fp1, "%s %s %s", operand1, operand2, result);
                    fprintf(fp2, "\n\t MOV R0, %s", operand1);
                    fprintf(fp2, "\n\t MOV R1, %s", operand2);
                    fprintf(fp2, "\n\t MUL R0, R1");
                    fprintf(fp2, "\n\t MOV %s, R0", result);
                    break;

                case '+':
                    fscanf(fp1, "%s %s %s", operand1, operand2, result);
                    fprintf(fp2, "\n\t MOV R0, %s", operand1);
                    fprintf(fp2, "\n\t MOV R1, %s", operand2);
                    fprintf(fp2, "\n\t ADD R0, R1");
                    fprintf(fp2, "\n\t MOV %s, R0", result);
                    break;

                case '-':
                    fscanf(fp1, "%s %s %s", operand1, operand2, result);
                    fprintf(fp2, "\n\t MOV R0, %s", operand1);
                    fprintf(fp2, "\n\t MOV R1, %s", operand2);
                    fprintf(fp2, "\n\t SUB R0, R1");
                    fprintf(fp2, "\n\t MOV %s, R0", result);
                    break;

                case '/':
                    fscanf(fp1, "%s %s %s", operand1, operand2, result);
                    fprintf(fp2, "\n\t MOV R0, %s", operand1);
                    fprintf(fp2, "\n\t MOV R1, %s", operand2);
                    fprintf(fp2, "\n\t DIV R0, R1");
                    fprintf(fp2, "\n\t MOV %s, R0", result);
                    break;

                case '=':
                    fscanf(fp1, "%s %s", operand1, result);
                    fprintf(fp2, "\n\t MOV %s, %s", result, operand1);
                    break;

                case '>':
                    j++;
                    fscanf(fp1, "%s %s %s", operand1, operand2, result);
                    fprintf(fp2, "\n\t JGT %s %s label#%s", operand1, operand2, result);
                    label[no++] = atoi(result);
                    break;

                case '<':
                    fscanf(fp1, "%s %s %s", operand1, operand2, result);
                    fprintf(fp2, "\n\t JLT %s %s label#%s", operand1, operand2, result);
                    label[no++] = atoi(result);
                    break;

                default:
                    printf("\nUnrecognized operation: %s", op);
                    break;
            }
        }
    }

    fclose(fp2);
    fclose(fp1);

    // Display the generated assembly code
    fp2 = fopen("target.txt", "r");
    if (fp2 == NULL) {
        printf("\nError in opening the file");
        exit(0);
    }

    // Print the contents of the target file (assembly code)
    do {
        ch = fgetc(fp2);
        printf("%c", ch);
    } while (ch != EOF);

    fclose(fp2);
    return 0;
}
