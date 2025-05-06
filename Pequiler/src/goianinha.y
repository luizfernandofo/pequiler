%require "3.8"
%debug
%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);

extern int yylex();
%}

%token TOKEN_INT_LITERAL TOKEN_ID TOKEN_STRING_LITERAL
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
    decl_func_var decl_prog
    ;

decl_func_var:
    %empty
    | tipo TOKEN_ID decl_var TOKEN_PONTO_VIRGULA decl_func_var
    | tipo TOKEN_ID decl_func decl_func_var
    ;

decl_prog:
    TOKEN_PROGRAMA bloco
    ;

decl_var:
    %empty
    | TOKEN_VIRGULA TOKEN_ID decl_var
    ;

decl_func:
    TOKEN_ABRE_PARENTESE lista_param TOKEN_FECHA_PARENTESE bloco
    ;

lista_param:
    %empty
    | lista_param_cont
    ;

lista_param_cont:
    tipo TOKEN_ID
    | tipo TOKEN_ID TOKEN_VIRGULA lista_param_cont
    ;

bloco:
    TOKEN_ABRE_CHAVE lista_decl_var lista_comando TOKEN_FECHA_CHAVE
    ;

lista_decl_var:
    %empty
    | tipo TOKEN_ID decl_var TOKEN_PONTO_VIRGULA lista_decl_var
    ;

tipo:
    TOKEN_INT
    | TOKEN_CAR
    ;

lista_comando:
    comando
    | comando lista_comando
    ;

comando:
    TOKEN_PONTO_VIRGULA
    | expr TOKEN_PONTO_VIRGULA
    | TOKEN_RETORNE expr TOKEN_PONTO_VIRGULA
    | TOKEN_LEIA TOKEN_ID TOKEN_PONTO_VIRGULA
    | TOKEN_ESCREVA expr TOKEN_PONTO_VIRGULA
    | TOKEN_ESCREVA TOKEN_STRING_LITERAL TOKEN_PONTO_VIRGULA
    | TOKEN_NOVALINHA TOKEN_PONTO_VIRGULA
    | TOKEN_SE TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE TOKEN_ENTAO comando
    | TOKEN_SE TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE TOKEN_ENTAO comando TOKEN_SENAO comando
    | TOKEN_ENQUANTO TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE TOKEN_EXECUTE comando
    | bloco
    ;

expr:
    or_expr
    | TOKEN_ID TOKEN_ATRIBUICAO expr
    ;

or_expr:
    or_expr TOKEN_OU and_expr
    | and_expr
    ;

and_expr:
    and_expr TOKEN_E eq_expr
    | eq_expr
    ;

eq_expr:
    eq_expr TOKEN_IGUAL desig_expr
    | eq_expr TOKEN_DIFERENTE desig_expr
    | desig_expr
    ;

desig_expr:
    desig_expr TOKEN_MENOR add_expr
    | desig_expr TOKEN_MAIOR add_expr
    | desig_expr TOKEN_MAIOR_IGUAL add_expr
    | desig_expr TOKEN_MENOR_IGUAL add_expr
    | add_expr
    ;

add_expr:
    add_expr TOKEN_SOMA mul_expr
    | add_expr TOKEN_SUBTRACAO mul_expr
    | mul_expr
    ;

mul_expr:
    mul_expr TOKEN_MULTIPLICACAO un_expr
    | mul_expr TOKEN_DIVISAO un_expr
    | un_expr
    ;

un_expr:
    TOKEN_SUBTRACAO prim_expr
    | TOKEN_NEGACAO prim_expr
    | prim_expr
    ;

prim_expr:
    TOKEN_ID TOKEN_ABRE_PARENTESE lista_expr TOKEN_FECHA_PARENTESE
    | TOKEN_ID TOKEN_ABRE_PARENTESE TOKEN_FECHA_PARENTESE
    | TOKEN_ID
    | TOKEN_STRING_LITERAL
    | TOKEN_INT_LITERAL
    | TOKEN_ABRE_PARENTESE expr TOKEN_FECHA_PARENTESE
    ;

lista_expr:
    expr
    | lista_expr TOKEN_VIRGULA expr
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO: %s\n", s);
}