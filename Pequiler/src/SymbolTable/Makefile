# Compilador e flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -g

# Diretórios
SRC_DIR = .
BUILD_DIR = ./target

# Arquivos fonte e objetos
SOURCES = $(SRC_DIR)/main.cpp $(SRC_DIR)/SymbolTable.cpp
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/SymbolTable.o

# Nome do executável
TARGET = $(BUILD_DIR)/main

# Regra padrão
all: $(TARGET) clean_objects

# Regra para criar o executável
$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^

# Regra para compilar os arquivos fonte
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Criar o diretório de build, se não existir
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Limpeza dos arquivos .o após o build
clean_objects:
	rm -rf $(BUILD_DIR)/*.o

# Limpeza completa dos arquivos gerados
clean:
	rm -rf $(BUILD_DIR)

# Phony targets
.PHONY: all clean clean_objects