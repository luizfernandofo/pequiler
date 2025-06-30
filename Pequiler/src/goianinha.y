%require "3.8"
%debug

%define parse.error verbose
%locations

%code requires {
#include "ast.h"
}

%{
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "ast.h"

ASTNode *ast_root = NULL;

void yyerror(const char *s);

extern int yylex();
extern int yylineno;

%}

%union {
    ASTNode *node;
    char *str;
    int ival;
}

%type <node> programa decl_func_var decl_prog decl_var decl_func lista_param lista_param_cont bloco lista_decl_var tipo lista_comando comando expr or_expr and_expr eq_expr desig_expr add_expr mul_expr un_expr prim_expr lista_expr

%token <str> TOKEN_ID TOKEN_STRING_LITERAL
%token <ival> TOKEN_INT_LITERAL
%token TOKEN_PROGRAMA TOKEN_CAR TOKEN_INT TOKEN_RETORNE TOKEN_LEIA TOKEN_ESCREVA
%token TOKEN_SE TOKEN_ENTAO TOKEN_SENAO TOKEN_ENQUANTO TOKEN_EXECUTE
%token TOKEN_SOMA TOKEN_SUBTRACAO TOKEN_MULTIPLICACAO TOKEN_DIVISAO TOKEN_ATRIBUICAO
%token TOKEN_OU TOKEN_E TOKEN_IGUAL TOKEN_DIFERENTE TOKEN_MENOR TOKEN_MAIOR TOKEN_MENOR_IGUAL TOKEN_MAIOR_IGUAL TOKEN_NEGACAO
%token TOKEN_ABRE_PARENTESE TOKEN_FECHA_PARENTESE TOKEN_ABRE_CHAVE TOKEN_FECHA_CHAVE
%token TOKEN_PONTO_VIRGULA TOKEN_VIRGULA TOKEN_NOVALINHA

%start programa

%locations

%%

programa:
    decl_func_var decl_prog { ast_root = ast_create(DECL_BEGIN_PROG, NULL, 0, $1, NULL, $2, @1.first_line); $$ = ast_root; }
    ;

decl_func_var:
    %empty { $$ = NULL; }
    | tipo TOKEN_ID decl_var TOKEN_PONTO_VIRGULA decl_func_var {
        ASTNode *var = ast_create(DECL_VAR, $2, 0, $1, $3, NULL, @2.first_line);
        $$ = ast_create(STMT_DECL, NULL, 0, var, $5, NULL, @2.first_line);
    }

    | tipo TOKEN_ID decl_func decl_func_var {
        ASTNode *func = ast_create(DECL_FUNC, $2, 0, $1, NULL, $3, @2.first_line);
        $$ = ast_create(STMT_DECL, NULL, 0, func, $4, NULL, @2.first_line);
    }
    ;

decl_prog:
    TOKEN_PROGRAMA bloco {
        $$ = ast_create(DECL_PROGRAMA, NULL, 0, NULL, NULL, $2, @1.first_line);
    }
    ;

decl_var:
    %empty { $$ = NULL; }
    | TOKEN_VIRGULA TOKEN_ID decl_var {
        $$ = ast_create(DECL_VAR, $2, 0, NULL, $3, NULL, @2.first_line);
    }
    ;

decl_func:
    TOKEN_ABRE_PARENTESE lista_param TOKEN_FECHA_PARENTESE bloco {
        $$ = ast_create(DECL_FUNC_DETAILS, NULL, 0, $2, NULL, $4, @1.first_line);
    }
    ;

lista_param:
    %empty { $$ = NULL; }
    | lista_param_cont {
        $$ = $1;
    }
    ;

lista_param_cont:
    tipo TOKEN_ID {
        $$ = ast_create(DECL_ARG, $2, 0, $1, NULL, NULL, @2.first_line);
    }
    | tipo TOKEN_ID TOKEN_VIRGULA lista_param_cont {
        $$ = ast_create(DECL_ARG, $2, 0, $1, $4, NULL, @2.first_line);
    }
    ;

bloco: // ih ih
    TOKEN_ABRE_CHAVE lista_decl_var lista_comando TOKEN_FECHA_CHAVE {
        $$ = ast_create(DECL_BLOCO, NULL, 0, $2, $3, NULL, @1.first_line);
    }
    ;

lista_decl_var:
    %empty { $$ = NULL; }
    | tipo TOKEN_ID decl_var TOKEN_PONTO_VIRGULA lista_decl_var {
        ASTNode *var = ast_create(DECL_VAR, $2, 0, $1, $3, NULL, @2.first_line);
        $$ = ast_create(STMT_DECL, NULL, 0, var, $5, NULL, @2.first_line);
    }
    ;

tipo:
    TOKEN_INT { $$ = ast_create(TYPE_INT, NULL, 0, NULL, NULL, NULL, @1.first_line); }
    | TOKEN_CAR { $$ = ast_create(TYPE_CAR, NULL, 0, NULL, NULL, NULL, @1.first_line); }
    ;

lista_comando:
    comando { $$ = $1; }
    | comando lista_comando { $1->right = $2; $$ = $1; }
    ;

comando:
    TOKEN_PONTO_VIRGULA { $$ = NULL;}
    | expr TOKEN_PONTO_VIRGULA {
        $$ = $1;
    }
    | TOKEN_RETORNE expr TOKEN_PONTO_VIRGULA {
        $$ = ast_create(STMT_RETURN, NULL, 0, $2, NULL, NULL, @1.first_line);
    }
    | TOKEN_LEIA TOKEN_ID TOKEN_PONTO_VIRGULA {
        $$ = ast_create(STMT_READ, $2, 0, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_ESCREVA expr TOKEN_PONTO_VIRGULA {
        $$ = ast_create(STMT_WRITE, NULL, 0, $2, NULL, NULL, @1.first_line);
    }
    | TOKEN_ESCREVA TOKEN_STRING_LITERAL TOKEN_PONTO_VIRGULA {
        $$ = ast_create(STMT_WRITE_LITERAL, $2, 0, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_NOVALINHA TOKEN_PONTO_VIRGULA {
        $$ = ast_create(STMT_NEWLINE, NULL, 0, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_SE TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE TOKEN_ENTAO comando {
        $$ = ast_create(STMT_IF_ELSE, NULL, 0, $6, NULL, $3, @1.first_line);
    }
    | TOKEN_SE TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE TOKEN_ENTAO comando TOKEN_SENAO comando {
        $$ = ast_create(STMT_IF_ELSE, NULL, 0, $6, $8, $3, @1.first_line);
    }
    | TOKEN_ENQUANTO TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE TOKEN_EXECUTE comando {
        $$ = ast_create(STMT_WHILE, NULL, 0, $6, NULL, $3, @1.first_line);
    }
    | bloco { $$ = $1; }
    ;

expr:
    or_expr { $$ = $1; }
    | TOKEN_ID TOKEN_ATRIBUICAO expr {
        $$ = ast_create(EXPR_ASSIGN, $1, 0, $3, NULL, NULL, @1.first_line);
    }
    ;

or_expr:
    or_expr TOKEN_OU and_expr {
        $$ = ast_create(EXPR_OR, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | and_expr { $$ = $1; }
    ;

and_expr:
    and_expr TOKEN_E eq_expr {
        $$ = ast_create(EXPR_AND, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | eq_expr { $$ = $1; }
    ;

eq_expr:
    eq_expr TOKEN_IGUAL desig_expr {
        $$ = ast_create(EXPR_EQ, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | eq_expr TOKEN_DIFERENTE desig_expr {
        $$ = ast_create(EXPR_NEQ, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | desig_expr { $$ = $1; }
    ;

desig_expr:
    desig_expr TOKEN_MENOR add_expr {
        $$ = ast_create(EXPR_LT, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | desig_expr TOKEN_MAIOR add_expr {
        $$ = ast_create(EXPR_GT, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | desig_expr TOKEN_MAIOR_IGUAL add_expr {
        $$ = ast_create(EXPR_GE, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | desig_expr TOKEN_MENOR_IGUAL add_expr {
        $$ = ast_create(EXPR_LE, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | add_expr {
        $$ = $1;
    }
    ;

add_expr:
    add_expr TOKEN_SOMA mul_expr {
        $$ = ast_create(EXPR_ADD, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | add_expr TOKEN_SUBTRACAO mul_expr {
        $$ = ast_create(EXPR_SUB, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | mul_expr { $$ = $1; }
    ;

mul_expr:
    mul_expr TOKEN_MULTIPLICACAO un_expr {
        $$ = ast_create(EXPR_MUL, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | mul_expr TOKEN_DIVISAO un_expr {
        $$ = ast_create(EXPR_DIV, NULL, 0, $1, $3, NULL, @1.first_line);
    }
    | un_expr { $$ = $1; }
    ;

un_expr:
    TOKEN_SUBTRACAO prim_expr {
        $$ = ast_create(EXPR_SUB, NULL, 1, NULL, $2, NULL, @1.first_line);
    }
    | TOKEN_NEGACAO prim_expr {
        $$ = ast_create(EXPR_NOT, NULL, 0, NULL, $2, NULL, @1.first_line);
    }
    | prim_expr { $$ = $1; }
    ;

prim_expr:
    TOKEN_ID TOKEN_ABRE_PARENTESE lista_expr TOKEN_FECHA_PARENTESE {
        $$ = ast_create(EXPR_FUNC_CALL, $1, 0, $3, NULL, NULL, @1.first_line);
    }
    | TOKEN_ID TOKEN_ABRE_PARENTESE TOKEN_FECHA_PARENTESE {
        $$ = ast_create(EXPR_FUNC_CALL, $1, 0, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_ID {
        $$ = ast_create(EXPR_VAR, $1, 0, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_STRING_LITERAL {
        $$ = ast_create(EXPR_STRING_LITERAL, $1, 0, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_INT_LITERAL {
        $$ = ast_create(EXPR_INT_LITERAL, NULL, $1, NULL, NULL, NULL, @1.first_line);
    }
    | TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE {
        $$ = $2;
    }
    ;

lista_expr:
    expr {
        $$ = $1;
    }
    | lista_expr TOKEN_VIRGULA expr {
        $$ = ast_create(EXPR_ARG, NULL, 0, $1, $3, NULL, @2.first_line);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO: %s %d\n", s, yylineno);
}