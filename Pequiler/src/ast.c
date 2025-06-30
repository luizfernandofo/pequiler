#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>


ASTNode *ast_create(ASTNodeType type, char *text, int ival, ASTNode *left, ASTNode *right, ASTNode *stmt_body, int line) {
    ASTNode *node = malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Erro: falha ao alocar memória para ASTNode\n");
        exit(1);
    }
    
    node->type = type;
    node->text = NULL;
    if (text && *text)
        node->text = text;
    node->ival = ival;
    node->line = line;
    node->left = left;
    node->right = right;
    node->stmt_body = stmt_body;
    
    return node;
}

void ast_free(ASTNode *node) {
    if (!node) return;
    
    if (node->text) free(node->text);
    if (node->left) ast_free(node->left);
    if (node->right) ast_free(node->right);
    if (node->stmt_body) ast_free(node->stmt_body);

    free(node);
}

void ast_print(ASTNode *node, int depth) {
    if (!node) return;

    for (int i = 0; i < depth; i++) printf("  ");

    const char *token_names[] = {
        "DECL_BEGIN_PROG",
        "DECL_PROGRAMA",
        "DECL_VAR",
        "DECL_FUNC",
        "DECL_FUNC_DETAILS",
        "DECL_ARG",
        "DECL_BLOCO",
        "TYPE_INT",
        "TYPE_CAR",
        "STMT_DECL",
        "STMT_RETURN",
        "STMT_READ",
        "STMT_WRITE",
        "STMT_WRITE_LITERAL",
        "STMT_NEWLINE",
        "STMT_IF_ELSE",
        "STMT_WHILE",
        "EXPR_ASSIGN",
        "EXPR_FUNC_CALL",
        "EXPR_VAR",
        "EXPR_ARG",
        "EXPR_ADD",
        "EXPR_SUB",
        "EXPR_MUL",
        "EXPR_DIV",
        "EXPR_AND",
        "EXPR_OR",
        "EXPR_EQ",
        "EXPR_NEQ",
        "EXPR_LT",
        "EXPR_GT",
        "EXPR_LE",
        "EXPR_GE",
        "EXPR_NOT",
        "EXPR_INT_LITERAL",
        "EXPR_STRING_LITERAL"
    };
    const int num_tokens = sizeof(token_names) / sizeof(token_names[0]);
    if (node->type >= 0 && node->type < num_tokens) {
        printf("%s", token_names[node->type]);
    } else {
        printf("%d", node->type);
    }
    if (node->text) printf(", %s", node->text);
    if (node->ival != 0) printf(", %d", node->ival);
    printf(", Line: %d\n", node->line);

    if (node->left) {
        ast_print(node->left, depth + 1);
    }
    if (node->right) {
        ast_print(node->right, depth + 1);
    }
    if (node->stmt_body) {
        ast_print(node->stmt_body, depth + 1);
    }
}