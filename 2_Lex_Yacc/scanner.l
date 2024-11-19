%{
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

// Helper variables
int line = 1, column = 1;
FILE* pif;
%}

%%

"VAR"           { fprintf(pif, "<VAR>\n"); }
"BEGIN"         { fprintf(pif, "<BEGIN>\n"); }
"END"           { fprintf(pif, "<END>\n"); }
"IF"            { fprintf(pif, "<IF>\n"); }
"THEN"          { fprintf(pif, "<THEN>\n"); }
"ELSE"          { fprintf(pif, "<ELSE>\n"); }
"WHILE"         { fprintf(pif, "<WHILE>\n"); }
"DO"            { fprintf(pif, "<DO>\n"); }
"READ"          { fprintf(pif, "<READ>\n"); }
"WRITE"         { fprintf(pif, "<WRITE>\n"); }

":="            { fprintf(pif, "<ASSIGN>\n"); }
"+"             { fprintf(pif, "<PLUS>\n"); }
"-"             { fprintf(pif, "<MINUS>\n"); }
"*"             { fprintf(pif, "<MULT>\n"); }
"/"             { fprintf(pif, "<DIV>\n"); }
"<"             { fprintf(pif, "<LT>\n"); }
"<="            { fprintf(pif, "<LE>\n"); }
"="             { fprintf(pif, "<EQ>\n"); }
"<> "           { fprintf(pif, "<NE>\n"); }
">="            { fprintf(pif, "<GE>\n"); }

";"             { fprintf(pif, "<SEMI>\n"); }
":"             { fprintf(pif, "<COLON>\n"); }
","             { fprintf(pif, "<COMMA>\n"); }
"("             { fprintf(pif, "<LPAREN>\n"); }
")"             { fprintf(pif, "<RPAREN>\n"); }
"."             { fprintf(pif, "<DOT>\n"); }

[0-9]+          { fprintf(pif, "<CONST_INT, %s>\n", yytext); add_to_symbol_table(yytext); }
[a-zA-Z_][a-zA-Z0-9_]* { fprintf(pif, "<ID, %s>\n", yytext); add_to_symbol_table(yytext); }
\"[^\"]*\"      { fprintf(pif, "<CONST_STRING, %s>\n", yytext); add_to_symbol_table(yytext); }
\'[a-zA-Z0-9]\' { fprintf(pif, "<CONST_CHAR, %s>\n", yytext); add_to_symbol_table(yytext); }

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

    pif = fopen("pif.txt", "w");
    if (!pif) {
        printf("Error: Could not open PIF output file.\n");
        return 1;
    }

    st.count = 0;
    yyin = source;
    yylex();
    fclose(source);
    fclose(pif);

    FILE* st_file = fopen("st.txt", "w");
    if (st_file) {
        fprintf(st_file, "Symbol Table:\n");
        for (int i = 0; i < st.count; i++) {
             fprintf(st_file, "%d %s\n", i + 1, st.name[i]);
        }
        fclose(st_file);
    } else {
        printf("Error: Could not open Symbol Table output file.\n");
    }

    return 0;
}

