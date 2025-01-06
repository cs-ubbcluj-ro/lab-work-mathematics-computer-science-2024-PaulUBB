%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYM 100

typedef struct {
    char name[MAX_SYM][50];
    int count;
} SymbolTable;

SymbolTable st;

void add_to_symbol_table(const char* token) {
    for (int i = 0; i < st.count; i++) {
        if (strcmp(st.name[i], token) == 0) return;
    }
    strcpy(st.name[st.count], token);
    st.count++;
}

int line = 1, column = 1;
%}

%%

"VAR"           { return VAR; }
"BEGIN"         { return BEGIN; }
"END"           { return END; }
"IF"            { return IF; }
"THEN"          { return THEN; }
"ELSE"          { return ELSE; }
"ENDIF"         { return ENDIF; }
"WHILE"         { return WHILE; }
"DO"            { return DO; }
"ENDWHILE"      { return ENDWHILE; }
"READ"          { return READ; }
"WRITE"         { return WRITE; }

":="            { return ASSIGN; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"<"             { return '<'; }
"<="            { return LE; }
"="             { return '='; }
"<> "           { return NE; }
">="            { return GE; }

";"             { return ';'; }
":"             { return ':'; }
","             { return ','; }
"("             { return '('; }
")"             { return ')'; }
"."             { return '.'; }

[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); add_to_symbol_table(yytext); return ID; }
\"[^\"]*\"      { yylval.str = strdup(yytext); return STRING; }
\'[a-zA-Z0-9]\' { yylval.str = strdup(yytext); return CHARCONST; }

[ \t\r]+        { column += yyleng; }
\n              { line++; column = 1; }

.               { printf("Lexical Error: Unknown character '%s' at line %d, column %d\n", yytext, line, column); column++; }

%%

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage: %s <source_file>\n", argv[0]);
        return 1;
    }

    FILE* source = fopen(argv[1], "r");
    if (!source) {
        printf("Error: Could not open file %s\n", argv[1]);
        return 1;
    }

    st.count = 0;
    yyin = source;
    yylex();
    fclose(source);

    return 0;
}
