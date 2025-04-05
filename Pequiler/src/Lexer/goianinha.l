%{
#include <iostream>

int start_comment_line = 0;
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

"programa"
"car"
"int"
"retorne"
"leia"
"escreva"
"novalinha"
"se"
"entao"
"senao"
"enquanto"
"execute"

"ou"
"e"
"=="
"!="
"<="
">="
"<"
">"
"+"
"-"
"*"
"/"
"="

";"
","
"("
")"
"{"
"}"

{ID}
{INT}
\"([^\"\n])*\n              {
                                std::cout << "ERROR: String literal cannot span multiple lines at line " << lineno() << std::endl;
                                return 0;
                            }
{STRING}

.                           {
                                std::cout << "ERROR: Invalid char " << YYText() << " at line " << lineno() << std::endl;
                                return 0;
                            }
