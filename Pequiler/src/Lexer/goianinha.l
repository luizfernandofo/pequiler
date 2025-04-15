%{
#include <iostream>
#include "tokens.hpp"

int start_comment_line = 0;

int read_token(const char* lexeme, int return_override) {
    if (return_override != 0) return return_override;
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
    
    return 0;
}
%}

%option noyywrap yylineno c++

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
                                start_comment_line = lineno(); BEGIN(COMMENT);
                            }

<COMMENT>[^*\n]*            
<COMMENT>[^*\n]*\n          
<COMMENT>"*"+[^*/\n]*       
<COMMENT>"*"+[^*/\n]*\n     
<COMMENT>"*"+"/"            BEGIN(INITIAL);
<COMMENT><<EOF>>            {
                                std::cout << "ERRO: COMENTARIO NAO TERMINA " << start_comment_line << std::endl;
                                return 0;
                            }

"programa"                  {return read_token(YYText(), 0);}
"car"                       {return read_token(YYText(), 0);}
"int"                       {return read_token(YYText(), 0);}
"retorne"                   {return read_token(YYText(), 0);}
"leia"                      {return read_token(YYText(), 0);}
"escreva"                   {return read_token(YYText(), 0);}
"novalinha"                 {return read_token(YYText(), 0);}
"se"                        {return read_token(YYText(), 0);}
"entao"                     {return read_token(YYText(), 0);}
"senao"                     {return read_token(YYText(), 0);}
"enquanto"                  {return read_token(YYText(), 0);}
"execute"                   {return read_token(YYText(), 0);}

"ou"                        {return read_token(YYText(), 0);}
"ou"                        {return read_token(YYText(), 0);}
"e"                         {return read_token(YYText(), 0);}
"=="                        {return read_token(YYText(), 0);}
"!="                        {return read_token(YYText(), 0);}
"<="                        {return read_token(YYText(), 0);}
">="                        {return read_token(YYText(), 0);}
"<"                         {return read_token(YYText(), 0);}
">"                         {return read_token(YYText(), 0);}
"+"                         {return read_token(YYText(), 0);}
"-"                         {return read_token(YYText(), 0);}
"*"                         {return read_token(YYText(), 0);}
"/"                         {return read_token(YYText(), 0);}
"="                         {return read_token(YYText(), 0);}

";"                         {return read_token(YYText(), 0);}
","                         {return read_token(YYText(), 0);}
"("                         {return read_token(YYText(), 0);}
")"                         {return read_token(YYText(), 0);}
"{"                         {return read_token(YYText(), 0);}
"}"                         {return read_token(YYText(), 0);}

{ID}                        {return read_token(YYText(), TOKEN_ID);}
{INT}                       {return read_token(YYText(), TOKEN_INT_LITERAL);}
\"([^\"\n])*\n              {
                                std::cout << "ERRO: CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA " << lineno() << std::endl;
                                return 0;
                            }
{STRING}                    {return read_token(YYText(), TOKEN_STRING_LITERAL);}

.                           {
                                std::cout << "ERRO: CARACTERE INVALIDO " << lineno() << std::endl;
                                return 0;
                            }
