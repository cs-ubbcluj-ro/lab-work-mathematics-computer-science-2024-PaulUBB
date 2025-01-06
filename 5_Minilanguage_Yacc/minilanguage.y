%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
%}

%token VAR BEGIN END IF THEN ELSE ENDIF WHILE DO ENDWHILE READ WRITE BOOLEAN INTEGER CHAR
%token NUMBER

%left '+' '-'
%left '*' '/'

%start program

%%

program
    : VAR statement_list { printf("Program syntactic correct\n"); }
    | BEGIN statement_list END { printf("Program syntactic correct\n"); }
    ;

statement_list
    : statement { printf("Production: statement_list -> statement\n"); }
    | statement statement_list { printf("Production: statement_list -> statement statement_list\n"); }
    ;

statement
    : initial_statement { printf("Production: statement -> initial_statement\n"); }
    | assignment_statement { printf("Production: statement -> assignment_statement\n"); }
    | conditional_statement { printf("Production: statement -> conditional_statement\n"); }
    | loop_statement { printf("Production: statement -> loop_statement\n"); }
    | input_statement { printf("Production: statement -> input_statement\n"); }
    | output_statement { printf("Production: statement -> output_statement\n"); }
    ;

initial_statement
    : identifier ':' type ';' { printf("Production: initial_statement -> identifier : type ;\n"); }
    | identifier ':' type ';' initial_statement { printf("Production: initial_statement -> identifier : type ; initial_statement\n"); }
    ;

assignment_statement
    : identifier "=" expression ';' { printf("Production: assignment_statement -> identifier := expression ;\n"); }
    ;

conditional_statement
    : IF expression THEN statement_list ELSE statement_list ENDIF { printf("Production: conditional_statement -> IF expression THEN statement_list ELSE statement_list ENDIF\n"); }
    ;

loop_statement
    : WHILE expression DO statement_list ENDWHILE { printf("Production: loop_statement -> WHILE expression DO statement_list ENDWHILE\n"); }
    ;

input_statement
    : READ '(' identifier ')' ';' { printf("Production: input_statement -> READ ( identifier ) ;\n"); }
    ;

output_statement
    : WRITE '(' expression ')' ';' { printf("Production: output_statement -> WRITE ( expression ) ;\n"); }
    ;

expression
    : term expression_prime { printf("Production: expression -> term expression_prime\n"); }
    ;

expression_prime
    : '+' term expression_prime { printf("Production: expression_prime -> + term expression_prime\n"); }
    | '-' term expression_prime { printf("Production: expression_prime -> - term expression_prime\n"); }
    | /* empty */ { printf("Production: expression_prime -> ε\n"); }
    ;

term
    : factor term_prime { printf("Production: term -> factor term_prime\n"); }
    ;

term_prime
    : '*' factor term_prime { printf("Production: term_prime -> * factor term_prime\n"); }
    | '/' factor term_prime { printf("Production: term_prime -> / factor term_prime\n"); }
    | /* empty */ { printf("Production: term_prime -> ε\n"); }
    ;

factor
    : NUMBER { printf("Production: factor -> NUMBER\n"); }
    | identifier { printf("Production: factor -> identifier\n"); }
    | '(' expression ')' { printf("Production: factor -> ( expression )\n"); }
    ;

identifier
    : letter { printf("Production: identifier -> letter\n"); }
    | letter identifier { printf("Production: identifier -> letter identifier\n"); }
    ;

letter
    : 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | ... | 'z' { printf("Production: letter -> a|b|c|...|z\n"); }
    ;

type
    : BOOLEAN { printf("Production: type -> BOOLEAN\n"); }
    | INTEGER { printf("Production: type -> INTEGER\n"); }
    | CHAR { printf("Production: type -> CHAR\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    exit(1);
}

int main() {
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    }
    return 0;
}
