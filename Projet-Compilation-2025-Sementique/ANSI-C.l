%option noyywrap
%option yylineno
%{
#include <stdio.h>
#include "miniC.tab.h"
#include "symboles.h"
#define TOKEN_EOF 0
extern int yylineno;
int yylex(void);
int yyerror(char *s);

/* Ne g�re pas les commentaires. A rajouter */
/* Supprimer les lignes dont vous n'avez pas besoin. */
%}
D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*


%%
"break"                 { return BREAK; }
"case"                  { return CASE; }
"default"               { return DEFAULT; }
"else"                  { return ELSE; }
"extern"                { return EXTERN; }
"for"                   { return FOR; }
"if"                    { return IF; }
"int"                   { return INT; }
"return"                { return RETURN; }
"switch"                { return SWITCH; }
"void"                  { return VOID; }
"while"                 { return WHILE; }
"then"                  { return THEN; }

{L}({L}|{D})*           { yylval.str = strdup(yytext); return IDENTIFICATEUR; }

{D}+                    { yylval.val = atoi(yytext);  return CONSTANTE; }

"+"                     { return PLUS; }
"-"                     { return MOINS; }
"*"                     { return MUL; }
"/"                     { return DIV; }

">>"                    { return RSHIFT; }
"<<"                    { return LSHIFT; }

"&"                     { return BAND; }
"|"                     { return BOR; }

"&&"                    { return LAND; }
"||"                    { return LOR; }

"<"                     { return LT; }
">"                     { return GT; }
"<="                    { return LEQ; }
">="                    { return GEQ; }
"=="                    { return EQ; }
"!="                    { return NEQ; }
"!"                     { return NOT; }

"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
";"                     { return ';'; }
","                     { return ','; }
"="                     { return '='; }
":"                     { return ':'; }
"["                     { return '['; }
"]"                     { return ']'; }

\/\*([^*]|\*+[^*/])*\*\/ { }
[ \t\v\n\f]             {  }

.                       { fprintf(stderr, "Caractere incorrect: %c à la ligne: %d \n", yytext[0], yylineno); }
%%
