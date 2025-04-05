%{
#include <iostream>

int start_comment_line = 0;

void print_token(const char* token, int line_number) {
    std::cout << "Token: " << token << " Line: " << line_number << std::endl;
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

"/*"                        {
                                start_comment_line = lineno(); BEGIN(COMMENT);
                            }

<COMMENT>[^*\n]*
<COMMENT>[^*\n]*\n          
<COMMENT>"*"+[^*/\n]*
<COMMENT>"*"+[^*/\n]*\n     
<COMMENT>"*"+"/"            BEGIN(INITIAL);
<COMMENT><<EOF>>            {
                                std::cout << "ERROR: Comment does not end. Line: " << start_comment_line << std::endl;
                                return 0;
                            }

"programa"                  print_token(YYText(), lineno());
"car"                       print_token(YYText(), lineno());
"int"                       print_token(YYText(), lineno());
"retorne"                   print_token(YYText(), lineno());
"leia"                      print_token(YYText(), lineno());
"escreva"                   print_token(YYText(), lineno());
"novalinha"                 print_token(YYText(), lineno());
"se"                        print_token(YYText(), lineno());
"entao"                     print_token(YYText(), lineno());
"senao"                     print_token(YYText(), lineno());
"enquanto"                  print_token(YYText(), lineno());
"execute"                   print_token(YYText(), lineno());

"ou"                        print_token(YYText(), lineno());
"e"                         print_token(YYText(), lineno());
"=="                        print_token(YYText(), lineno());
"!="                        print_token(YYText(), lineno());
"<="                        print_token(YYText(), lineno());
">="                        print_token(YYText(), lineno());
"<"                         print_token(YYText(), lineno());
">"                         print_token(YYText(), lineno());
"+"                         print_token(YYText(), lineno());
"-"                         print_token(YYText(), lineno());
"*"                         print_token(YYText(), lineno());
"/"                         print_token(YYText(), lineno());
"="                         print_token(YYText(), lineno());

";"                         print_token(YYText(), lineno());
","                         print_token(YYText(), lineno());
"("                         print_token(YYText(), lineno());
")"                         print_token(YYText(), lineno());
"{"                         print_token(YYText(), lineno());
"}"                         print_token(YYText(), lineno());

{ID}                        print_token(YYText(), lineno());
{INT}                       print_token(YYText(), lineno());
\"([^\"\n])*\n              {
                                std::cout << "ERROR: String literal cannot span multiple lines at line " << lineno() << std::endl;
                                return 0;
                            }
{STRING}                    print_token(YYText(), lineno());

.                           {
                                std::cout << "ERROR: Invalid char " << YYText() << " at line " << lineno() << std::endl;
                                return 0;
                            }
