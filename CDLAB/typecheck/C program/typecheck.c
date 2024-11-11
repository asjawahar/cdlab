#include<stdio.h>
#include<stdlib.h>

int main()
{
    int n, i, k, flag = 0;
    char vari[15], typ[15], b[15], c;
    
    // Asking for number of variables
    printf("Enter the number of variables: ");
    scanf("%d", &n);
    
    // Reading variable names and their types
    for(i = 0; i < n; i++)
    {
        printf("Enter the variable[%d]: ", i);
        scanf(" %c", &vari[i]); // Space before %c to discard any previous newline character
        printf("Enter the variable-type[%d] (float-f, int-i): ", i);
        scanf(" %c", &typ[i]); // Space before %c to discard any previous newline character
        if(typ[i] == 'f')
            flag = 1;
    }
    
    // Reading the expression
    printf("Enter the Expression (end with $): ");
    i = 0;
    
    getchar(); // To consume the newline character left in the buffer from previous input
    while((c = getchar()) != '$') // Keep reading until the '$' is encountered
    {
        b[i] = c;
        i++;
    }
    
    k = i; // Store the length of the input expression
    
    // Check if '/' operator is present
    for(i = 0; i < k; i++)
    {
        if(b[i] == '/')
        {
            flag = 1;
            break;
        }
    }
    
    // Check for each variable's type
    for(i = 0; i < n; i++)
    {
        if(b[0] == vari[i]) // Check if the first character of the expression is a variable
        {
            if(flag == 1) // If division is present
            {
                if(typ[i] == 'f')
                {
                    printf("\nThe datatype is correctly defined!\n");
                    break;
                }
                else
                {
                    printf("Identifier %c must be a float type!\n", vari[i]);
                    break;
                }
            }
            else
            {
                printf("\nThe datatype is correctly defined!\n");
                break;
            }
        }
    }
    return 0;
}
