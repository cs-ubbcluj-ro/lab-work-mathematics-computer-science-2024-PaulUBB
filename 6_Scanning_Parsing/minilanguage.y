%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    int num;
    char* str;
}

%token VAR BEGIN END IF THEN ELSE ENDIF WHILE DO ENDWHILE READ WRITE
%token ASSIGN LE NE GE
%token <num> NUMBER
%token <str> ID STRING CHARCONST

%%

program:
    VAR declaration_list BEGIN statement_list END
    {
        printf("Program syntactically correct\n");
    }
    ;

declaration_list:
    declaration
    | declaration_list declaration
    ;

declaration:
    ID ':' type ';'
    ;

type:
    "BOOLEAN"
    | "INTEGER"
    | "CHAR"
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    assignment_statement
    | conditional_statement
    | loop_statement
    | input_statement
    | output_statement
    ;

assignment_statement:
    ID ASSIGN expression ';'
    ;

conditional_statement:
    IF expression THEN statement_list ELSE statement_list ENDIF
    ;

loop_statement:
    WHILE expression DO statement_list ENDWHILE
    ;

input_statement:
    READ '(' ID ')' ';'
    ;

output_statement:
    WRITE '(' expression ')' ';'
    ;

expression:
    term expression_prime
    ;

expression_prime:
    '+' term expression_prime
    | '-' term expression_prime
    | /* empty */
    ;

term:
    factor term_prime
    ;

term_prime:
    '*' factor term_prime
    | '/' factor term_prime
    | /* empty */
    ;

factor:
    NUMBER
    | ID
    | '(' expression ')'
    ;

%%

int main() {
    return yyparse();
}

void yyerror(const char* s) {
    printf("Syntax Error: %s\n", s);
}
