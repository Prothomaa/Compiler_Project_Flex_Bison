%{
    #include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#define PI 3.14159265
	extern FILE *yyin;
	extern FILE *yyout;
	int checked[26],flag=0,m_flag=0, t, s;
	float arr[1000];
	int sym[26];
%}

%union { 
  int itype;
  double dtype;  
}

%token VARI 
%token <dtype> NUMBER
%token <itype> VARIABLE 
%type <dtype> TERM
%type <dtype> FACTOR
%type <dtype> G
%type <dtype> EXPRESSION
%type <dtype> STATEMENT
%type <dtype> LOOP
%type <dtype> SWITCH_CASE
%type <dtype> multiple_case
%type <dtype> IF_ELSE
%type <dtype> stmt

%token MAIN_FUNC DEF INT FLOAT READ WRITE PLUS MINUS PE ME INTO DIV MOD POWER SQR SQRT GCD LCM MAX MIN CUBE SINE COSINE TANGENT LN EQUAL LT GT LE GE NE COMA SEMI COLON FLPAR FRPAR SLPAR SRPAR FACTORIAL FIB INC DEC Leap_Year PRIME DIVISORS EVEN_ODD SUMMATION IF ELSE FOR IN RANGE WHILE DO DWHILE SWITCH CASE DEFAULT AND OR
%nonassoc IFX
%nonassoc ELSE
%left LT GT LE GE
%left PLUS MINUS
%left INTO DIV
%left SQRT SQR CUBE
%left SINE COSINE TANGENT

%%
program:
    | MAIN_FUNC SLPAR STATEMENTS SRPAR { fprintf(yyout,"Execution Done!\n"); }
	| DEF VARI FLPAR VARIABLES FRPAR SLPAR STATEMENTS SRPAR   {fprintf(yyout,"Function Declaration!\n\n"); } program
    ; 
STATEMENTS:
    | STATEMENTS STATEMENT 
	| STATEMENTS BUILT_IN_FUNCTIONS
	| STATEMENTS LOOP
	| STATEMENTS SWITCH_CASE
    | STATEMENTS IF_ELSE    { 
	                            if($2) 
								{  
								    fprintf(yyout,"Value of Expression in Valid Condition: %.2f\n",$2); 
								}
								else
								{
								   fprintf(yyout,"Condition false\n");
								}
						    }
    | STATEMENTS DECLARATION
    ;

STATEMENT:
     EXPRESSION SEMI        { 
                                $$ = $1;	
                                fprintf(yyout,"Value of expression : %.2f\n",$1);
                            }
    | VARIABLE EQUAL EXPRESSION SEMI
                  	        {															
                                if(checked[$1] == 1)
                                {
                                    arr[$1] = $3;
									$$ = arr[$1];
                                    fprintf(yyout,"%c assigned %.2f\n",$1+97,$3);
                                }
								else
                                  fprintf(yyout,"%c not declared\n",$1+97);
						    }
	| VARIABLE PE EXPRESSION SEMI    {fprintf(yyout,"Result of += "); 
									if(checked[$1] == 1)
                                {
                                    arr[$1] = $1+$3;
									$$ = arr[$1];
                                    fprintf(yyout,"%c assigned %.2f\n",$1+97,$3);
                                }
								else
                                  fprintf(yyout,"%c not declared\n",$1+97); }

	| VARIABLE ME EXPRESSION SEMI    {fprintf(yyout,"Result of -= ");if(checked[$1] == 1)
                                {
                                    arr[$1] = $1-$3;
									$$ = arr[$1];
                                    fprintf(yyout,"%c assigned %.2f\n",$1+97,$3);
                                }
								else
                                  fprintf(yyout,"%c not declared\n",$1+97); }

    | READ VARIABLE SEMI         {
                                printf("Value taken from user for %c\n",$2+97);
                                if(checked[$2] == 1) 
                                { 
                                    fprintf(yyout,"Value taken from user for %c\n",$2+97);
                                    float a;
                                    scanf("%f",&a);
                                    arr[$2] = a;
								}
								else
                                    fprintf(yyout,"%c not declared\n",$2+97);
                            }
    | WRITE FLPAR VARIABLE FRPAR SEMI 
	                        { 
                                if(checked[$3] == 1) 
                                    fprintf(yyout,"Value of %c is %.2f\n",$3+97,arr[$3]);
								else
                                    fprintf(yyout,"%c not declared\n",$3+97);

                            }
	;
BUILT_IN_FUNCTIONS:
      Leap_Year stmt SEMI   {
	                            int n = (int)$2;
                                if(((n%4 == 0) && (n%100 != 0)) || (n%400 == 0))
                                    fprintf(yyout,"%d leap year\n",n);
                                else
                                    fprintf(yyout,"%d not leap year\n",n);
                            } 
    | PRIME stmt SEMI       {
	                            int n = (int)$2;
                                int i,cnt=0;
                                for(i=2;i<n;i++)
                                {
                                    if(n%i == 0)
                                    {
                                        cnt=cnt+1;
                                        break;
                                    }
                                }
                                if(cnt==0 && $2 != 1)
                                    fprintf(yyout,"Yes! %d prime\n",n);
                                else
                                    fprintf(yyout,"No! %d not prime\n",n);
                            } 
    | DIVISORS stmt SEMI    {
                                int j;
								int n = (int)$2;
                                fprintf(yyout,"All the divisors of %d are -> ",n);
                                for(j=1;j<=n;j++)
                                {
                                    if(n%j==0)
                                       fprintf(yyout,"%d ",j);
							    }
                                fprintf(yyout,"\n");
                            }
    | SUMMATION stmt SEMI   {
	                            int n = (int)$2;
								int sum = n*(n+1)/2;
								fprintf(yyout,"Summation of 1st %d numbers is %d\n",n,sum);
	                        }
    | EVEN_ODD stmt SEMI    {
	                            int n = (int)$2;
	                            if(n %2 == 0)
								    fprintf(yyout,"%d Even Number\n",n);
								else
								    fprintf(yyout,"%d Odd Number\n",n);
	                        }
    ;
LOOP:
      FOR VARIABLE EQUAL NUMBER IN RANGE FLPAR NUMBER COMA NUMBER FRPAR COLON stmt SEMI
	                        {
							    if(checked[$2] == 1)
                                {
								    fprintf(yyout,"For loop Found\n");
								    if($4 <= $8)
                                    {
									    for(arr[$2] = $4; arr[$2] <= $8; arr[$2] += $10)
                                            fprintf(yyout,"Value of for loop %.2f\n",$13);
									}
									else
									{
									    for(arr[$2] = $4; arr[$2] > $8; arr[$2] -= $10)
                                            fprintf(yyout,"Value of for loop: %.2f\n",$13);
									}
                                }
								else
                                  fprintf(yyout,"%c not declared\n",$2+97);	
							}
	| WHILE VARIABLE LE NUMBER COLON stmt SEMI
                            {
							    float a = arr[$2];
								float b = $4;
								$$ = $6;
								if((checked[$2] == 1) && (a <= b))
								{
								    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a <= b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a += 1;
									    if(a > b) break;
                                    }
								    arr[$2] = a;
								}
								else
								    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
	| WHILE VARIABLE GE NUMBER COLON stmt SEMI
                            {
							    float a = arr[$2];
								float b = $4;
								$$ = $6;
								if((checked[$2] == 1) && (a >= b))
								{
								    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a >= b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a -= 1;
									    if(a < b) break;
                                    }
								    arr[$2] = a;
								}
								else
								    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
	| DO COLON stmt SEMI DWHILE NUMBER GE NUMBER SEMI
							{
								int x = (int)$6;
								do
								{
									$$ = $3;
									x=x-1;
									fprintf(yyout,"Value in Do while loop: %.2f\n",$$);
								}
								while(x >= (int)$8);
								fprintf(yyout,"Do While loop found !\n");
							}
    ;
SWITCH_CASE:
     SWITCH FLPAR NUMBER {t= (int)$3; s=1;} FRPAR SLPAR multiple_case SRPAR {fprintf(yyout,"Switch done !\n"); } 
	                        
	;
multiple_case:
     CASE NUMBER COLON stmt SEMI { if(t == (int)$2) {fprintf(yyout,"CASE found %d !\n",t); s=0;} } multiple_case
    | DEFAULT COLON stmt SEMI            {if(s == 1) {fprintf(yyout,"Executed Default\n");}}
    ;
IF_ELSE:
    IF EXPRESSION SLPAR stmt SEMI SRPAR
	                        {
								if($2) 
								{
								    $$ = $4;
								}
								else
								{
								    $$ = 0;
								}
							}
    | IF EXPRESSION SLPAR stmt SEMI SRPAR ELSE SLPAR stmt SEMI SRPAR 
	                        {
								if($2)
								{
									$$ = $4;
							    }
							    else
							    {
									$$ = $9;
								}
							}
    | IF EXPRESSION SLPAR IF_ELSE SRPAR ELSE SLPAR IF_ELSE SRPAR 
                            {
                                if($2) { $$ = $4; }
                                else   { $$ = $8; }
                            }   
    ;
stmt:
    EXPRESSION  { $$ = $1; }
	;
DECLARATION:
    TYPE VARIABLES SEMI  { if(flag!=0) 
	                        fprintf(yyout,"Variable declared\n");
						}
	;
TYPE:
    FLOAT
	| INT
	;
VARIABLES:
    VARIABLES COMA VARIABLE   {
	                        if(checked[$3] == 1)
                            {
							    fprintf(yyout,"%c already declared\n",$3+97);
								flag =0;
								return 0;
							}
                            else
							{   checked[$3] = 1;
							    flag=1;
							}
                        }
    | VARIABLE	            {
                            if(checked[$1] == 1)
                            {
							    fprintf(yyout,"%c already declared\n",$1+97);
								flag = 0;
								return 0;
							}
                            else
							{
							    checked[$1] = 1;
								flag = 1;
							}
                        }								
	;
EXPRESSION:
      EXPRESSION PLUS TERM { $$ = $1 + $3; }
    | EXPRESSION MINUS TERM { $$ = $1 - $3; }
	| EXPRESSION AND TERM   { if ($1 != 0 && $3 != 0)
								{fprintf(yyout,"Logical AND is True\n");}
								else
								{
									fprintf(yyout,"Logical AND is False\n");
									}
							}
	| EXPRESSION OR TERM   { if ($1 == 0 && $3 == 0)
								{fprintf(yyout,"Logical OR is False\n");}
								else
								{fprintf(yyout,"Logical OR is True\n");}
							}
	| TERM                { $$ = $1; }
	;
TERM:
     TERM INTO FACTOR      { $$ = $1 * $3; }
    | TERM DIV FACTOR     {
                             if($3) 
                                $$ = $1 / $3;
                             else 
                             { 
                                $$ = 0; 
                                fprintf(yyout,"Division by zero\n"); 
                             }
                          }
	| TERM MOD FACTOR   { if($3)
								{fprintf(yyout,"Modulu");$$ = (int)$1 % (int)$3 ;}
								else 
								{
									$$ = 0;
									fprintf(yyout,"Result is undefined\n");
								}
						}
	
	| TERM GCD FACTOR              { int n1 = (int)$1, n2 = (int)$3,n3 ;
								  for(int i=1 ; i<=n1 && i<=n2 ; i++)
								  {
									if(n1%i ==0 && n2%i ==0)
									{
										
										n3=i;
									}
								  }
								  fprintf(yyout,"GCD value");
								  $$=n3;
								  }
	| TERM LCM FACTOR			{int n1 = (int)$1, n2 = (int)$3, g ;
								  for(int i=1 ; i<=n1 && i<=n2 ; i++)
								  {
									if(n1%i ==0 && n2%i ==0)
									{
										g=i;
									}
								  }
								  fprintf(yyout,"LCM value");
								  $$ = n1/g*n2 ;
								  }
	| MAX TERM FACTOR 			{float n1 = $2, n2=$3, max;
									if(n1>n2)
									{
										max = n1;
									}
									else
									{
										max=n2;
									}
									fprintf(yyout,"Max value");
									$$=max;
									}
	| MIN TERM FACTOR 			{float n1 = $2, n2=$3, min;
									if(n1>n2)
									{
										min = n2;
									}
									else
									{
										min=n1;
									}
									fprintf(yyout,"Min value");
									$$=min;
									}
    | FACTOR              { $$ = $1; }
	;
FACTOR:	
      G POWER FACTOR    { $$ = powl($1,$3); }
	| G LT FACTOR         { $$ = $1 < $3; }
    | G GT FACTOR         { $$ = $1 > $3; }
    | G LE FACTOR         { $$ = $1 <= $3; }
    | G GE FACTOR         { $$ = $1 >= $3; }
	| G NE FACTOR         { $$ = $1 != $3; }
	| SQR G               { fprintf(yyout,"Square ");$$ = $2*$2; }
	| CUBE G              { fprintf(yyout,"Cubic ");$$ = $2*$2*$2; }
    | SQRT G              { fprintf(yyout,"Square-root ");$$ = sqrt($2); }
	| SINE G              { 
	                         double x = $2;
	                         double val = PI / 180;
                             double res = sin(x*val);
							 fprintf(yyout,"SINE ");
							 $$ = res;
						  }
	| COSINE G            { 
	                         double x = $2;
							 double val = PI / 180;
                             double res = cos(x*val);
							 fprintf(yyout,"COSINE ");
							 $$ = res;
						  }
	| TANGENT G           { 
	                         double x = $2;
	                         double val = PI / 180;
                             double res = tan(x*val);
							 fprintf(yyout,"TANGENT ");
							 $$ = res;
						  }
	| LN G                { fprintf(yyout,"Ln ");$$ =log($2); }
	| FACTORIAL G         {
							 int n = (int) $2;
                               int i,res = 1;
							   
                               for(i=1;i<=n;i++)
                                  res *= i;
							fprintf(yyout,"Factorial ");
                               $$=res ;
                          }
	| FIB G  			 { int n = (int)$2; int fib[n+6] ; fib[0]=0; fib[1]=1;
							fprintf(yyout,"Fibonacci series is= %d %d", fib[0],fib[1]);
							for (int i = 2 ; i<n ; i++)
							{
								fib[i] = fib[i-1]+fib[i-2];
								fprintf(yyout," %d",fib[i]);
							}
							fprintf(yyout,"\n");
							}
	| INC G              { int n=(int)$2;fprintf(yyout,"Increment(++) ");$$=n+1 ;}
	| DEC G              { int n=(int)$2;fprintf(yyout,"Decrement(--) ");$$=n-1 ;}
    | G                   { $$ = $1; }
	;
G:  
    NUMBER                   { $$ = $1; }
    | VARIABLE                 { 
                               if(checked[$1] == 1) 
                                  $$ = arr[$1];
						  }
    |FLPAR EXPRESSION FRPAR { $$ = $2; }
    ;	
%%

int yywrap()
{
    return 1;
}
int yyerror(char *s) 
{
	fprintf(yyout,"%s\n",s);
	return(0);
}