#include <iostream>
#include <fstream>
#include <FlexLexer.h>

int main(int argc, char *argv[])
{
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file>" << std::endl;
        return 2;
    }

    std::ifstream inputFile(argv[1]);
    if (!inputFile) {
        std::cerr << "Error opening file: " << argv[1] << std::endl;
        return 1;
    }

    yyFlexLexer* lexer = new yyFlexLexer(&inputFile, nullptr);
    int yylex_res = lexer->yylex(); 
    while (yylex_res != 0) {
        std::cout << "Encontrado o lexema " << lexer->YYText() << " pertencente ao token de codigo " << yylex_res << " linha " << lexer->lineno() << std::endl;
        yylex_res = lexer->yylex();
    }

    delete lexer;
    inputFile.close();
    return 0;
}
