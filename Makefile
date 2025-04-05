# Diretórios
SRC_DIR = Pequiler/src/Lexer
BUILD_DIR = target

# Alvo principal
build: $(BUILD_DIR)/main.o $(BUILD_DIR)/lex.yy.o
	g++ -o $(BUILD_DIR)/goianinha $(BUILD_DIR)/main.o $(BUILD_DIR)/lex.yy.o

# Compilação do arquivo lex.yy.o
$(BUILD_DIR)/lex.yy.o: $(BUILD_DIR)/lex.yy.cpp
	g++ -c $(BUILD_DIR)/lex.yy.cpp -o $(BUILD_DIR)/lex.yy.o

# Geração do arquivo lex.yy.cpp
$(BUILD_DIR)/lex.yy.cpp: $(SRC_DIR)/goianinha.l | $(BUILD_DIR)
	flex -o $(BUILD_DIR)/lex.yy.cpp $(SRC_DIR)/goianinha.l

# Compilação do arquivo main.o
$(BUILD_DIR)/main.o: $(SRC_DIR)/main.cpp | $(BUILD_DIR)
	g++ -c $(SRC_DIR)/main.cpp -o $(BUILD_DIR)/main.o

# Criação do diretório target, se não existir
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Limpeza dos arquivos gerados
clean:
	rm -rf $(BUILD_DIR)