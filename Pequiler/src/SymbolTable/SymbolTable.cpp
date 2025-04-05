#include "SymbolTable.hpp"

SymbolTable::SymbolTable() {
    initialize();
}

SymbolTable::~SymbolTable() {
    clear();
}

void SymbolTable::initialize() {
    symbolStack.clear();
}

void SymbolTable::pushScope() {
    symbolStack.emplace_back();
}

SymbolEntry* SymbolTable::lookup(const std::string& name) {
    for (auto it = symbolStack.rbegin(); it != symbolStack.rend(); ++it) {
        auto entry = it->find(name);
        if (entry != it->end()) {
            return &entry->second;
        }
    }
    return nullptr; // Retorna nullptr se o nome não for encontrado
}

void SymbolTable::popScope() {
    if (!symbolStack.empty()) {
        symbolStack.pop_back();
    }
}

void SymbolTable::insertFunction(const std::string& name, int paramCount, DataType returnType) {
    if (!symbolStack.empty()) {
        SymbolEntry entry = {name, FUNCTION, paramCount, returnType, INT, -1, nullptr};
        symbolStack.back()[name] = entry;
    }
}

void SymbolTable::insertVariable(const std::string& name, DataType varType, int varPositionInDeclaredList) {
    if (!symbolStack.empty()) {
        SymbolEntry entry = {name, VAR, 0, INT, varType, varPositionInDeclaredList, nullptr};
        symbolStack.back()[name] = entry;
    }
}

void SymbolTable::insertParameter(const std::string& name, DataType varType, int varPositionInDeclaredList, std::shared_ptr<SymbolEntry> paramFuncOwner) {
    if (!symbolStack.empty()) {
        SymbolEntry entry = {name, PARAMETER, 0, INT, varType, varPositionInDeclaredList, paramFuncOwner};
        symbolStack.back()[name] = entry;
    }
}

void SymbolTable::clear() {
    symbolStack.clear();
}