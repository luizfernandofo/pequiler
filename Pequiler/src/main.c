#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "symbol_table.h"

extern int yyparse();
extern FILE *yyin;
extern ASTNode *ast_root;
extern SymbolTable *symbol_table;

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

    if (ast_root) {
        //ast_print(ast_root, 0);
        ast_free(ast_root);
    }

    if (symbol_table) {
        print_symbol_table(symbol_table);
        free_symbol_table(symbol_table);
    }

    fclose(yyin);
    return 0;
}
