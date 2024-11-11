#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void main()
{
    char in[50], dig[50], id[50];
    int i = 0, j = 0, k, l = 0;

    // Clear screen (Linux/Unix)
    system("clear");

    printf("Enter the Expression:\t");
    fgets(in, sizeof(in), stdin); // safer alternative to gets()

    printf("\n***************************************************************************");
    printf("\nDataType\tIdentifier\tAddress\tConstants\tOperators\tSpecialChar");
    printf("\n***************************************************************************");

    // Start processing the expression
    while (in[i] != '\0')
    {
        if (isalpha(in[i]))  // Check if the character is alphabetic
        {
            j = 0;
            // Collect identifier (or datatype keyword)
            while ((isalpha(in[i])) || (isdigit(in[i])))
            {
                id[j] = in[i];
                i++;
                j++;
            }
            id[j] = '\0';  // Null-terminate the identifier string

            // Check if the identifier is a datatype or keyword
            if (strcmp(id, "char") == 0 || strcmp(id, "int") == 0 || strcmp(id, "float") == 0 ||
                strcmp(id, "if") == 0 || strcmp(id, "long") == 0 || strcmp(id, "while") == 0 ||
                strcmp(id, "do") == 0 || strcmp(id, "for") == 0 || strcmp(id, "switch") == 0 ||
                strcmp(id, "double") == 0)
            {
                printf("\n%s\t\t\t\t", id);  // Print the datatype
            }
            else
            {
                // It's an identifier, print it
                printf("\t\t%s", id);
            }
        }
        else if (isdigit(in[i]))  // Check if the character is a digit (constant)
        {
            k = 0;
            while (isdigit(in[i]))
            {
                dig[k] = in[i];
                i++;
                k++;
            }
            dig[k] = '\0';  // Null-terminate the constant string
            printf("\t\t\t\t%s", dig);  // Print the constant
        }
        else if (in[i] == '+' || in[i] == '-' || in[i] == '*' || in[i] == '/' || in[i] == '<' ||
                 in[i] == '>' || in[i] == '=')
        {
            // Handle operators
            printf("\t\t\t\t\t\t\t%c", in[i]);
            i++;
        }
        else if (in[i] == ';' || in[i] == ':' || in[i] == '.' || in[i] == '(' || in[i] == ')' ||
                 in[i] == '{' || in[i] == '}')
        {
            // Handle special characters
            printf("\t\t\t\t\t\t\t\t%c", in[i]);
            i++;
        }
        else
        {
            i++;  // Skip unrecognized characters
        }
        printf("\n");
    }

    // Wait for user input before exiting (this replaces getch())
    printf("\nPress Enter to exit...");
    getchar();
}
