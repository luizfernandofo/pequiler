#include "SymbolTable.hpp"
#include <iostream>

int main() {
    SymbolTable symbolTable;

    // Inicializar a pilha de tabelas de símbolos
    symbolTable.initialize();
    std::cout << "Symbol table initialized." << std::endl;

    // Criar um novo escopo
    symbolTable.pushScope();
    std::cout << "New scope pushed." << std::endl;

    // Inserir uma variável no escopo atual
    symbolTable.insertVariable("x", INT, 1);
    symbolTable.insertVariable("y", INT, 2);
    std::cout << "Variables 'x' and 'y' inserted." << std::endl;

    // Inserir uma função no escopo atual
    symbolTable.insertFunction("myFunction", 2, INT);
    std::cout << "Function 'myFunction' inserted." << std::endl;

    // Pesquisar por uma variável
    SymbolEntry* entry = symbolTable.lookup("x");
    if (entry) {
        std::cout << "Found variable 'x' of type: " << entry->varType << std::endl;
    } else {
        std::cout << "Variable 'x' not found." << std::endl;
    }

    // Pesquisar por uma função
    entry = symbolTable.lookup("myFunction");
    if (entry) {
        std::cout << "Found function 'myFunction' with return type: " << entry->funcReturnType << std::endl;
    } else {
        std::cout << "Function 'myFunction' not found." << std::endl;
    }

    // Criar um novo escopo
    symbolTable.pushScope();
    std::cout << "New scope pushed." << std::endl;

    // Inserir uma variável no novo escopo
    symbolTable.insertVariable("z", INT, 1);
    std::cout << "Variable 'z' inserted in new scope." << std::endl;

    // Pesquisar por uma variável no escopo atual
    entry = symbolTable.lookup("z");
    if (entry) {
        std::cout << "Found variable 'z' of type: " << entry->varType << std::endl;
    } else {
        std::cout << "Variable 'z' not found." << std::endl;
    }

    // Pesquisar por uma variável em um escopo anterior
    entry = symbolTable.lookup("x");
    if (entry) {
        std::cout << "Found variable 'x' in outer scope of type: " << entry->varType << std::endl;
    } else {
        std::cout << "Variable 'x' not found in outer scope." << std::endl;
    }

    // Remover o escopo atual
    symbolTable.popScope();
    std::cout << "Current scope popped." << std::endl;

    // Pesquisar por uma variável removida
    entry = symbolTable.lookup("z");
    if (entry) {
        std::cout << "Found variable 'z' of type: " << entry->varType << std::endl;
    } else {
        std::cout << "Variable 'z' not found (as expected)." << std::endl;
    }

    // Limpar a pilha de tabelas de símbolos
    symbolTable.clear();
    std::cout << "Symbol table cleared." << std::endl;

    return 0;
}