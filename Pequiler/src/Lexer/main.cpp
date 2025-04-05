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
    while(lexer->yylex() != 0) {
        std::cout << "Token: " << lexer->YYText() << " line: " << lexer->lineno() << std::endl;
    }

    delete lexer;
    inputFile.close();
    std::cout << "Lexing completed successfully." << std::endl;
    return 0;
}
