# Diretórios
SRC_DIR = .
BUILD_DIR = ./target

# Alvo principal
build: $(BUILD_DIR)/main.o $(BUILD_DIR)/lex.yy.o
	mkdir -p $(BUILD_DIR)
	g++ -o $(BUILD_DIR)/goianinha $(BUILD_DIR)/main.o $(BUILD_DIR)/lex.yy.o
	$(MAKE) clean_intermediates

# Compilação do arquivo lex.yy.o
$(BUILD_DIR)/lex.yy.o: $(BUILD_DIR)/lex.yy.cpp
	mkdir -p $(BUILD_DIR)
	g++ -c $(BUILD_DIR)/lex.yy.cpp -I $(SRC_DIR)/ -o $(BUILD_DIR)/lex.yy.o

# Geração do arquivo lex.yy.cpp
$(BUILD_DIR)/lex.yy.cpp: $(SRC_DIR)/goianinha.l
	mkdir -p $(BUILD_DIR)
	flex -o $(BUILD_DIR)/lex.yy.cpp $(SRC_DIR)/goianinha.l

# Compilação do arquivo main.o
$(BUILD_DIR)/main.o: $(SRC_DIR)/main.cpp
	mkdir -p $(BUILD_DIR)
	g++ -c $(SRC_DIR)/main.cpp -o $(BUILD_DIR)/main.o

# Limpeza dos arquivos intermediários, exceto o executável
clean_intermediates:
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/lex.yy.cpp

# Limpeza completa (inclui o executável)
clean:
	rm -rf $(BUILD_DIR)