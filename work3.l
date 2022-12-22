%{
    #include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "work3.tab.h" 
	extern FILE *yyin;
	extern FILE *yyout;
%}

header     [ ]*[#][!][i][m][p][o][r][t][ ]+[a-zA-Z]+[.h]*
digit  [0-9]
id     [a-z]
Start   "Start()"


%%

{Start}       { return MAIN_FUNC; }
"Def"		  { return DEF ; }
"Integer"        { return INT; }
"Float"      { return FLOAT; }
{id}         { yylval.itype = *yytext - 'a'; return VARIABLE; }
"Read"       { return READ; }
"Write"      { return WRITE; }

"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return INTO; }
"/"          { return DIV; }
"%"			 { return MOD; }
"^"          { return POWER; }
"="          { return EQUAL; }
"+="         { return PE ; }
"-="         { return ME ; }
"++"         { return INC ; }
"--"         { return DEC ; }

"LT"         { return LT; }
"GT"         { return GT; }
"LE"         { return LE; }
"GE"         { return GE; }
"NE"         { return NE; }

","          { return COMA; }
";"          { return SEMI; }
":"          { return COLON; }
"("          { return FLPAR; }
")"          { return FRPAR; }
"{"          { return SLPAR; }
"}"          { return SRPAR; }

"Sqr"        { return SQR; }
"Cube"       { return CUBE; }
"Sqrt"       { return SQRT; }
"!"        	 { return GCD ; }
"!!"         { return LCM ; }
"max"        { return MAX ; }
"min"        { return MIN ; }
"sin"        { return SINE; }
"cos"        { return COSINE; }
"tan"        { return TANGENT; }
"ln"         { return LN; }
"Fact"       { return FACTORIAL; }
"Fib"        { return FIB ; }
"Prime"      { return PRIME; }
"Divisors"   { return DIVISORS; }

"Leap_year"  { return Leap_Year; }
"Summation"  { return SUMMATION; }
"EvenOdd"   { return EVEN_ODD; }

"If"         { return IF; }
"Else"       { return ELSE; }

"For"        { return FOR; }
"In"         { return IN; }
"Range"      { return RANGE; }
"While"      { return WHILE; }
"Do"         { return DO ; }
"Dwhile"	 { return DWHILE ;}

"Switch"     { return SWITCH; }
"Case"       { return CASE; }
"Default"    { return DEFAULT; }

"AND"        { return AND ; }
"OR"         { return OR ; }

[a-z]+       { return VARI;}

"-"?{digit}+ { yylval.dtype = atof(yytext); return NUMBER ; }
"-"?{digit}*[.][0-9]+ { yylval.dtype = atof(yytext); return NUMBER ; }

{header}     { fprintf(yyout,"This is a header file\n\n"); }
"@@".*       { fprintf(yyout,"Single Line Comment\n"); }

"@"[^@]+"@"  { fprintf(yyout,"Multiline Comment\n"); }
[ \t\n]

%%

int main(void)
{
	yyin = fopen("input3.txt","r");
	yyout = fopen("output3.txt","w");
	yyparse();
}
