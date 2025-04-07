%{
#include "stdio.h"
#include "stdlib.h"
#include "tables.h"
#include "string.h"
extern int yyerror(char *s);
extern int yylineno;
int yylex(void);
%}

%union{ int val; char *str;}

%type <val> expression 
%type <str> variable 
%type <val> binary_op


%token <str> IDENTIFICATEUR 
%token <val> CONSTANTE 
%token VOID INT FOR WHILE IF ELSE SWITCH CASE DEFAULT
%token BREAK RETURN PLUS MOINS MUL DIV LSHIFT RSHIFT BAND BOR LAND LOR LT GT 
%token GEQ LEQ EQ NEQ NOT EXTERN
%left PLUS MOINS
%left MUL DIV
%left LSHIFT RSHIFT
%left BOR BAND
%left LAND LOR
%nonassoc THEN
%nonassoc ELSE
%left OP
%left REL
%start programme
%%

programme	:	
		liste_declarations liste_fonctions {printf("Programme correct\n");}
;
liste_declarations	:	
		liste_declarations declaration 
	|
;
liste_fonctions	:	
		liste_fonctions fonction 
	|   fonction
;
declaration	:	
		type liste_declarateurs ';'
;
liste_declarateurs	:	
		liste_declarateurs ',' declarateur
	|	declarateur
;
declarateur	:	
		IDENTIFICATEUR {inserer($1);}
	|	declarateur '[' CONSTANTE ']'
;
fonction	:	
		type IDENTIFICATEUR '(' liste_parms ')' '{' liste_declarations liste_instructions '}'
	|	EXTERN type IDENTIFICATEUR '(' liste_parms ')' ';'
;
type	:	
		VOID 
	|	INT 
;
liste_parms	:	
		liste_parms ',' parm
	| parm
	|
;
parm	:	
		INT IDENTIFICATEUR {inserer($2);}
;
liste_instructions :	
		liste_instructions instruction
	|
;
instruction	:	
		iteration
	|	selection
	|	saut
	|	affectation ';'
	|	bloc
	|	appel
;
iteration	:	
		FOR '(' affectation ';' condition ';' affectation ')' instruction
	|	WHILE '(' condition ')' instruction
;
selection	:	
		IF '(' condition ')' instruction %prec THEN
	|	IF '(' condition ')' instruction ELSE instruction
	|	SWITCH '(' expression ')' instruction
	|	CASE CONSTANTE ':' instruction
	|	DEFAULT ':' instruction
;
saut	:	
		BREAK ';'
	|	RETURN ';'
	|	RETURN expression ';'
;
affectation	:	
		variable '=' expression {
					symbole *s = find_in_list(ts[hash($1)], $1);
					if(s== NULL){
						fprintf(stderr, "Erreur: variable non déclarée %s\n", $1);
						exit(1);
					}
					s = inserer($1);
					s->valeur = $3;
					printf("Affectation: %s = %d\n", s->nom, s->valeur);
			}
;
bloc	:	
		'{' liste_declarations liste_instructions '}'
;
appel	:	
		IDENTIFICATEUR '(' liste_expressions ')' ';'
;
variable	:	
		IDENTIFICATEUR {
			$$ = $1;
		}
	|	variable '[' expression ']' {
		$$ = $1;
	}
;
expression	:	
		'(' expression ')' {$$ = $2; }
	|	expression binary_op expression %prec OP  {

            switch($2) {
                case '+': $$ = $1 + $3; break;
                case '-': $$ = $1 - $3; break;
                case '*': $$ = $1 * $3; break;
                case '/':
                    if ($3 == 0) {
                        fprintf(stderr, "Erreur : division par 0\n");
                        exit(1);
                    }
                    $$ = $1 / $3; break;
                case 275: $$ = $1 << $3; break;
                case 276: $$ = $1 >> $3; break;
                case '&': $$ = $1 & $3; break;
                case '|': $$ = $1 | $3; break;
                default:
                    fprintf(stderr, "Erreur : opérateur binaire inconnu\n");
                    exit(1);
            }
        }
	|	MOINS expression {
		$$ = -$2;
	}
	|	CONSTANTE {$$ = $1;}
	|	variable {
		symbole *s = find_in_list(ts[hash($1)], $1);
		if(s== NULL){
			fprintf(stderr, "Erreur: variable non déclarée %s\n", $1);
			exit(1);
		}
		$$ = s->valeur;
	}
	|	IDENTIFICATEUR '(' liste_expressions ')'
		{$$ = 0; }
;
liste_expressions	:	
		liste_expressions ',' expression
	| expression
	|
;
condition	:	
		NOT '(' condition ')'
	|	condition binary_rel condition %prec REL
	|	'(' condition ')'
	|	expression binary_comp expression
;
binary_op	:	
		PLUS {$$='+';}
	|   MOINS {$$='-';}
	|	MUL  {$$='*';}
	|	DIV {$$='/';}
	|   LSHIFT {$$=275;}
	|   RSHIFT {$$=276;}
	|	BAND {$$='&';}
	|	BOR {$$='|';}
;
binary_rel	:	
		LAND
	|	LOR
;
binary_comp	:	
		LT
	|	GT
	|	GEQ
	|	LEQ
	|	EQ
	|	NEQ
;
%%
int yyerror(char *s){
	fprintf(stderr, "%s Ligne: %d\n", s, yylineno);
	exit(1);
}

int main(){
	yyparse();
	return 0;
}