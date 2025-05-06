#ifndef SYMBOL_TABLE_HPP
#define SYMBOL_TABLE_HPP

#include <string>
#include <unordered_map>
#include <vector>
#include <memory>

enum SymbolType {
    VAR, FUNCTION, PARAMETER
};

enum DataType {
    INT, CAR
};

struct SymbolEntry {
    std::string name;
    SymbolType type;

    int funcParamCount;
    DataType funcReturnType;
    
    DataType varType;
    int varPositionInDeclaredList;
    std::shared_ptr<SymbolEntry> paramFuncOwner; // Pointer to the function entry if this is a parameter
};

class SymbolTable {
public:
    SymbolTable();
    ~SymbolTable();

    void initialize();

    void pushScope();

    SymbolEntry* lookup(const std::string& name);

    void popScope();

    void insertFunction(const std::string& name, int paramCount, DataType returnType);

    void insertVariable(const std::string& name, DataType varType, int varPositionInDeclaredList);

    void insertParameter(const std::string& name, DataType varType, int varPositionInDeclaredList, std::shared_ptr<SymbolEntry> paramFuncOwner);

    void clear();

private:
    std::vector<std::unordered_map<std::string, SymbolEntry>> symbolStack;
};

#endif