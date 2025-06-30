#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

SymbolTable *create_symbol_table() {
    SymbolTable *table = (SymbolTable *)malloc(sizeof(SymbolTable));
    if (!table) return NULL;
    ScopeEntry *global_scope = (ScopeEntry *)malloc(sizeof(ScopeEntry));
    if (!global_scope) {
        free(table);
        return NULL;
    }
    global_scope->vars = NULL;
    global_scope->funcs = NULL;
    global_scope->next = NULL;
    global_scope->previous = NULL;
    table->head = global_scope;
    table->current_scope = global_scope;
    return table;
}

TableEntry *create_table_entry(const char *name, SymbolType symbol_type, int type) {
    TableEntry *entry = (TableEntry *)malloc(sizeof(TableEntry));
    if (!entry) return NULL;
    entry->name = strdup(name);
    entry->symbol_type = symbol_type;
    entry->type = type;
    entry->next = NULL;
    entry->args = NULL;
    return entry;
}

TableEntry* check_if_var_exists_in_current_scope(SymbolTable *table, const char *name) {
    if (!table || !table->current_scope) return NULL;
    TableEntry *var = table->current_scope->vars;
    while (var) {
        if (strcmp(var->name, name) == 0) return var;
        var = var->next;
    }
    return NULL;
}

TableEntry* check_if_func_exists_in_current_scope(SymbolTable *table, const char *name) {
    if (!table || !table->current_scope) return NULL;
    TableEntry *func = table->current_scope->funcs;
    while (func) {
        if (strcmp(func->name, name) == 0) return func;
        func = func->next;
    }
    return NULL;
}

TableEntry* add_var_to_current_scope(SymbolTable *table, const char *name, int type) {
    if (!table || !table->current_scope) return NULL;
    TableEntry *entry = create_table_entry(name, ST_VAR, type);
    entry->next = table->current_scope->vars;
    table->current_scope->vars = entry;
    return entry;
}

TableEntry* add_func_to_current_scope(SymbolTable *table, const char *name, int type) {
    if (!table || !table->current_scope) return NULL;
    TableEntry *entry = create_table_entry(name, ST_FUNC, type);
    entry->next = table->current_scope->funcs;
    table->current_scope->funcs = entry;
    return entry;
}

TableEntry *get_last_func_in_current_scope(SymbolTable *table) {
    if (!table || !table->current_scope) return NULL;
    TableEntry *func = table->current_scope->funcs;
    if (!func) return NULL;
    while (func->next) {
        func = func->next;
    }
    return func;
}

TableEntry *check_if_arg_exists_in_func(TableEntry *func, const char *name) {
    if (!func || !func->args) return NULL;
    TableEntry *arg = func->args;
    while (arg) {
        if (strcmp(arg->name, name) == 0) {
            return arg;
        }
        arg = arg->next;
    }
    return NULL;
}

void add_arg_to_function(TableEntry *func, TableEntry *arg) {
    if (!func || !arg) return;
    arg->next = func->args;
    func->args = arg;
}

void free_symbol_table(SymbolTable *table) {
    if (!table) return;
    ScopeEntry *scope = table->head;
    while (scope) {
        
        TableEntry *var = scope->vars;
        while (var) {
            TableEntry *next_var = var->next;
            free(var->name);
            free(var);
            var = next_var;
        }
        
        TableEntry *func = scope->funcs;
        while (func) {
            TableEntry *next_func = func->next;
            
            TableEntry *arg = func->args;
            while (arg) {
                TableEntry *next_arg = arg->next;
                free(arg->name);
                free(arg);
                arg = next_arg;
            }
            free(func->name);
            free(func);
            func = next_func;
        }
        ScopeEntry *next_scope = scope->next;
        free(scope);
        scope = next_scope;
    }
    free(table);
}

const char* symbol_type_to_str(SymbolType type) {
    switch(type) {
        case ST_VAR: return "VAR";
        case ST_FUNC: return "FUNC";
        case ST_ARG: return "ARG";
        default: return "UNKNOWN";
    }
}

// Função auxiliar para imprimir tipo (int) como string
const char* type_to_str(int type) {
    // Adapte conforme os tipos do seu compilador/linguagem
    switch(type) {
        case 7: return "int";
        case 8: return "car";
        default: return "unknown";
    }
}

void print_args(TableEntry *args) {
    int i = 0;
    while (args) {
        printf("      Arg %d: nome='%s', tipo=%s\n", i+1, args->name, type_to_str(args->type));
        args = args->next;
        i++;
    }
}

void print_symbol_table(SymbolTable *table) {
    if (!table) return;
    ScopeEntry *scope = table->head;
    int scope_num = 0;
    while (scope) {
        if (scope_num == 0)
            printf("===== ESCOPO GLOBAL =====\n");
        else
            printf("===== ESCOPO %d =====\n", scope_num);
        // Variáveis
        printf("  Variáveis:\n");
        TableEntry *var = scope->vars;
        if (!var) printf("    (nenhuma)\n");
        while (var) {
            printf("    [%s] nome='%s', tipo=%s\n", symbol_type_to_str(var->symbol_type), var->name, type_to_str(var->type));
            var = var->next;
        }
        // Funções
        printf("  Funções:\n");
        TableEntry *func = scope->funcs;
        if (!func) printf("    (nenhuma)\n");
        while (func) {
            printf("    [%s] nome='%s', tipoRetorno=%s\n", symbol_type_to_str(func->symbol_type), func->name, type_to_str(func->type));
            if (func->args) {
                print_args(func->args);
            }
            func = func->next;
        }
        scope = scope->next;
        scope_num++;
    }
}

void create_new_scope(SymbolTable *table) {
    if (!table || !table->current_scope) return;
    ScopeEntry *new_scope = (ScopeEntry *)malloc(sizeof(ScopeEntry));
    if (!new_scope) return;
    new_scope->vars = NULL;
    new_scope->funcs = NULL;
    new_scope->next = NULL;
    new_scope->previous = table->current_scope;
    table->current_scope->next = new_scope;
    table->current_scope = new_scope;
}


