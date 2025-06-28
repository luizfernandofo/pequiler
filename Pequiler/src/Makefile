CC = gcc
EXE = target/goianinha

CFLAGS = -g -Wall -I$(dir $(MAIN_SRC))

LEXER_SRC = goianinha.l
PARSER_SRC = goianinha.y
MAIN_SRC = main.c
AST_SRC = ast.c

LEXER_GEN = target/lexer.c
PARSER_GEN = target/parser.c
PARSER_HEADER = target/parser.h

OBJS = target/main.o target/lexer.o target/parser.o target/ast.o

.PHONY: all clean

all: $(EXE)

$(EXE): $(OBJS)
	@mkdir -p target
	$(CC) $(CFLAGS) -o $(EXE) $(OBJS)

target/main.o: $(MAIN_SRC) ast.h
	@mkdir -p target
	$(CC) $(CFLAGS) -c -o $@ $<

target/lexer.o: $(LEXER_GEN) ast.h
	$(CC) $(CFLAGS) -c -o $@ $<

target/parser.o: $(PARSER_GEN) ast.h
	$(CC) $(CFLAGS) -c -o $@ $(PARSER_GEN:.h=.c)

target/ast.o: ast.c ast.h
	$(CC) $(CFLAGS) -c -o $@ ast.c

# Ensure Bison runs before Flex
$(LEXER_GEN): $(LEXER_SRC) $(PARSER_HEADER)
	@mkdir -p target
	flex -o $@ $<

$(PARSER_GEN) $(PARSER_HEADER): $(PARSER_SRC)
	@mkdir -p target
	bison -d -o $(PARSER_GEN:.h=.c) $<

clean:
	rm -rf target

clean-intermediates:
	rm -f target/*.o target/lexer.c target/parser.c target/parser.h