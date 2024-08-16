grammar PjLang;

@header {}
@members {}


program : 'program' 
           declaration* 
           command* 
           'endProg'
        ;

declaration : type ID (',' ID)*
            ;

type : 'int' 
     | 'float' 
     | 'string'
     ;

command : cmdRead 
        | cmdWrite 
        | cmdAssign 
        | cmdIf 
        | cmdWhile 
        | cmdDoWhile 
        | cmdFor
        ;

cmdRead : 'leia' '(' ID ')'
        ;

cmdWrite : 'escreva' '(' (TEXT | ID) ')'
         ;

cmdAssign : ID ':=' expression
          ;

cmdIf : 'se' '(' expression ')' 
        'entao' 
        '{' 
            command* 
        '}' 
        (
        'senao' 
        '{' 
            command* 
        '}')?
      ;

cmdWhile : 'enquanto' '(' expression ')' 
           'faca' 
           '{' 
                command* 
           '}'
         ;

cmdDoWhile : 'faça' 
             '{' 
                   command* 
             '}' 
             'enquanto' '(' expression ')'
           ;

cmdFor : 'para' '(' ID ':=' expression 'ate' expression ')' 
         'faca' 
         '{' 
               command* 
         '}'
       ;

expression : expression ( '+' | '-' ) term
           | term
           ;

term : term ( '*' | '/' ) factor
     | factor
     ;

factor : NUM_INT
       | NUM_FLOAT
       | ID
       | '(' expression ')'
       | '!' factor
       ;

TEXT : '"' (~["\r\n])* '"'
     ;

NUM_INT : [0-9]+
        ;

NUM_FLOAT : [0-9]+ '.' [0-9]+
          ;

ID : [a-zA-Z_] [a-zA-Z_0-9]*
   ;

WS : [\t\r\n]+ -> skip
   ;
