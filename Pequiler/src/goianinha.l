%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.h"
#include "ast.h"

extern int yylineno;
extern char* yytext;
extern YYSTYPE yylval;

// Variável global para armazenar a linha inicial de um comentário
int start_comment_line = 0;

// Função para mapear lexemas para tokens
int read_token(const char* lexeme) {
    if (strcmp(lexeme, "programa") == 0) return TOKEN_PROGRAMA;
    if (strcmp(lexeme, "car") == 0) return TOKEN_CAR;
    if (strcmp(lexeme, "int") == 0) return TOKEN_INT;
    if (strcmp(lexeme, "retorne") == 0) return TOKEN_RETORNE;
    if (strcmp(lexeme, "leia") == 0) return TOKEN_LEIA;
    if (strcmp(lexeme, "escreva") == 0) return TOKEN_ESCREVA;
    if (strcmp(lexeme, "novalinha") == 0) return TOKEN_NOVALINHA;
    if (strcmp(lexeme, "se") == 0) return TOKEN_SE;
    if (strcmp(lexeme, "entao") == 0) return TOKEN_ENTAO;
    if (strcmp(lexeme, "senao") == 0) return TOKEN_SENAO;
    if (strcmp(lexeme, "enquanto") == 0) return TOKEN_ENQUANTO;
    if (strcmp(lexeme, "execute") == 0) return TOKEN_EXECUTE;
    if (strcmp(lexeme, "ou") == 0) return TOKEN_OU;
    if (strcmp(lexeme, "e") == 0) return TOKEN_E;
    if (strcmp(lexeme, "==") == 0) return TOKEN_IGUAL;
    if (strcmp(lexeme, "!=") == 0) return TOKEN_DIFERENTE;
    if (strcmp(lexeme, "<=") == 0) return TOKEN_MENOR_IGUAL;
    if (strcmp(lexeme, ">=") == 0) return TOKEN_MAIOR_IGUAL;
    if (strcmp(lexeme, "<") == 0) return TOKEN_MENOR;
    if (strcmp(lexeme, ">") == 0) return TOKEN_MAIOR;
    if (strcmp(lexeme, "+") == 0) return TOKEN_SOMA;
    if (strcmp(lexeme, "-") == 0) return TOKEN_SUBTRACAO;
    if (strcmp(lexeme, "*") == 0) return TOKEN_MULTIPLICACAO;
    if (strcmp(lexeme, "/") == 0) return TOKEN_DIVISAO;
    if (strcmp(lexeme, "=") == 0) return TOKEN_ATRIBUICAO;
    if (strcmp(lexeme, ";") == 0) return TOKEN_PONTO_VIRGULA;
    if (strcmp(lexeme, ",") == 0) return TOKEN_VIRGULA;
    if (strcmp(lexeme, "(") == 0) return TOKEN_ABRE_PARENTESE;
    if (strcmp(lexeme, ")") == 0) return TOKEN_FECHA_PARENTESE;
    if (strcmp(lexeme, "{") == 0) return TOKEN_ABRE_CHAVE;
    if (strcmp(lexeme, "}") == 0) return TOKEN_FECHA_CHAVE;
    if (strcmp(lexeme, "!") == 0) return TOKEN_NEGACAO;
    return 0;
}
%}

%option noyywrap yylineno

/* Definitions Section */
%x COMMENT

DIGIT [0-9]
INT {DIGIT}+
ID [a-zA-Z_][0-9a-zA-Z_]*
STRING \"([^\"\n])*\"

WS [ \t]+

%%
    /* Rules Section */

{WS}

\n                          
\r\n                        

"/*"                        {
                                start_comment_line = yylineno; BEGIN(COMMENT);
                            }

<COMMENT>[^*\n]*            
<COMMENT>[^*\n]*\n          
<COMMENT>"*"+[^*/\n]*       
<COMMENT>"*"+[^*/\n]*\n     
<COMMENT>"*"+"/"            BEGIN(INITIAL);
<COMMENT><<EOF>>            {
                                printf("ERRO: COMENTARIO NAO TERMINA %d\n", start_comment_line);
                                exit(1);
                            }

"programa"                  {return read_token(yytext);}
"car"                       {return read_token(yytext);}
"int"                       {return read_token(yytext);}
"retorne"                   {return read_token(yytext);}
"leia"                      {return read_token(yytext);}
"escreva"                   {return read_token(yytext);}
"novalinha"                 {return read_token(yytext);}
"se"                        {return read_token(yytext);}
"entao"                     {return read_token(yytext);}
"senao"                     {return read_token(yytext);}
"enquanto"                  {return read_token(yytext);}
"execute"                   {return read_token(yytext);}

"ou"                        {return read_token(yytext);}
"e"                         {return read_token(yytext);}
"=="                        {return read_token(yytext);}
"!="                        {return read_token(yytext);}
"<="                        {return read_token(yytext);}
">="                        {return read_token(yytext);}
"<"                         {return read_token(yytext);}
">"                         {return read_token(yytext);}
"+"                         {return read_token(yytext);}
"-"                         {return read_token(yytext);}
"*"                         {return read_token(yytext);}
"/"                         {return read_token(yytext);}
"="                         {return read_token(yytext);}
"!"                         {return read_token(yytext);}

";"                         {return read_token(yytext);}
","                         {return read_token(yytext);}
"("                         {return read_token(yytext);}
")"                         {return read_token(yytext);}
"{"                         {return read_token(yytext);}
"}"                         {return read_token(yytext);}

{ID}                        {
                                yylval.str = strdup(yytext);
                                if (yylval.str == NULL) {
                                    fprintf(stderr, "ERRO: Falha de alocação de memória na linha %d\n", yylineno);
                                    exit(1);
                                }
                                return TOKEN_ID;
                            }

{INT}                       {
                                yylval.ival = atoi(yytext);
                                return TOKEN_INT_LITERAL;
                            }
                            
\"([^\"\n])*\n              {
                                printf("ERRO: CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA %d\n", yylineno-1);
                                exit(1);
                            }

{STRING}                    {
                                yylval.str = strdup(yytext);
                                if (yylval.str == NULL) {
                                    fprintf(stderr, "ERRO: Falha de alocação de memória na linha %d\n", yylineno);
                                    exit(1);
                                }
                                return TOKEN_STRING_LITERAL;
                            }

.                           {
                                printf("ERRO: CARACTERE INVALIDO %d\n", yylineno);
                                exit(1);
                            }
