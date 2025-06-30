#ifndef AST_H
#define AST_H

typedef enum {
    DECL_BEGIN_PROG,
    DECL_PROGRAMA,
    DECL_VAR,
    DECL_FUNC,
    DECL_FUNC_DETAILS,
    DECL_ARG,
    DECL_BLOCO,

    TYPE_INT,
    TYPE_CAR,

    STMT_DECL,
    STMT_RETURN,
    STMT_READ,
    STMT_WRITE,
    STMT_WRITE_LITERAL,
    STMT_NEWLINE,
    STMT_IF_ELSE,
    STMT_WHILE,

    EXPR_ASSIGN,

    EXPR_ADD,
    EXPR_SUB,
    EXPR_MUL,
    EXPR_DIV,

    EXPR_AND,
    EXPR_OR,

    EXPR_EQ,
    EXPR_NEQ,
    EXPR_LT,
    EXPR_GT,
    EXPR_LE,
    EXPR_GE,

    EXPR_INT_LITERAL,
    EXPR_STRING_LITERAL,
} ASTNodeType;

typedef struct ASTNode {
    ASTNodeType type;

    char *text;
    int ival;

    int line; // Line number in the source code

    struct ASTNode *stmt_body;

    struct ASTNode *left;
    struct ASTNode *right;
} ASTNode;

ASTNode *ast_create(ASTNodeType type, 
    char *text, int ival, 
    ASTNode *left, ASTNode *right, 
    ASTNode *stmt_body,
    int line
);

void ast_free(ASTNode *node);
void ast_print(ASTNode *node, int depth);

#endif