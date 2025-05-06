#ifndef __SCANNER_HPP__
#define __SCANNER_HPP__ 1

#include "pq_parser.tab.hh"
#include <FlexLexer.h>
#include <istream>

namespace PQ {

    class PQ_Scanner : public yyFlexLexer {
    public:
        PQ_Scanner(std::istream* in) : yyFlexLexer(in) {
            loc = new PQ::PQ_Parser::location_type();
        }

        using FlexLexer::yylex;
        virtual int yylex(PQ::PQ_Parser::semantic_type* const lval, PQ::PQ_Parser::location_type* location);

    private:
        PQ::PQ_Parser::semantic_type* yylval = nullptr;
        PQ::PQ_Parser::location_type* loc = nullptr;
    };
}

#endif // __SCANNER_HPP__