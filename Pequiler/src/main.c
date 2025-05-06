#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern FILE *yyin;

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 2;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    if (yyparse() != 0) {
        fclose(yyin);
        return 1;
    }

    fclose(yyin);
    return 0;
}
