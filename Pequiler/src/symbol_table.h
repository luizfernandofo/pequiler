#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef enum {
    ST_VAR,
    ST_FUNC,
    ST_ARG
} SymbolType;

typedef struct TableEntry {
    char *name;
    SymbolType symbol_type;
    int type; // tipo da variável ou tipo do retorno da função
    struct TableEntry *next;
    struct TableEntry *args; // lista de argumentos para funções
} TableEntry;

typedef struct ScopeEntry {
    TableEntry *vars;
    TableEntry *funcs;
    struct ScopeEntry *next;
    struct ScopeEntry *previous;
} ScopeEntry;

typedef struct SymbolTable {
    ScopeEntry *head; // Escopo global
    ScopeEntry *current_scope;
} SymbolTable;


SymbolTable *create_symbol_table();
TableEntry *create_table_entry(const char *name, SymbolType symbol_type, int type);
TableEntry *check_if_var_exists_in_current_scope(SymbolTable *table, const char *name);
TableEntry *check_if_func_exists_in_current_scope(SymbolTable *table, const char *name);
TableEntry *add_var_to_current_scope(SymbolTable *table, const char *name, int type);
TableEntry *add_func_to_current_scope(SymbolTable *table, const char *name, int type);
TableEntry *get_last_func_in_current_scope(SymbolTable *table);
TableEntry *check_if_arg_exists_in_func(TableEntry *func, const char *name);
void create_new_scope(SymbolTable *table);
void add_arg_to_function(TableEntry *func, TableEntry *arg);
void free_symbol_table(SymbolTable *table);
void print_symbol_table(SymbolTable *table);

#endif