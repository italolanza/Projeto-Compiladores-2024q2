grammar PjLang;

@header {}
@members {}


// program : 'programa' 
//           declaration*
//           'inicio'
//            primaryExpression* 
//            'fim'
//            'fimprog' EOF
//         ;

// declaration : type ID (',' ID)*
//             ;

primaryExpression 
        : assignment
        | block
        | command
        | declaration
        ;

assignment
        : ID OP_ASGN 
        (
        | ID
        | NUMBER
        | TEXT
        | expression
        )  
        ;


expression
        : term additiveExpression
        ;


additiveExpression 
        : ((OP_SUM | OP_SUB)
          term
          )*
        ;


term : factor multiplicativeExpression
     ;

multiplicativeExpression 
        : ((OP_MUL | OP_DIV)
          factor
          )*
        ;


factor
        : ID
        | NUMBER 
        ;

block 
        :  
        ;

command : 
        ;

declaration : 
            ;

// type : 'inteiro' 
//      | 'real' 
//      | 'texto'
//      ;

// command : cmdRead 
//         | cmdWrite 
//         | cmdAssign 
//         | cmdIf 
//         | cmdWhile 
//         | cmdDoWhile 
//         | cmdFor
//         ;

// cmdRead : 'leia' '(' ID ')'
//         ;

// cmdWrite : 'escreva' '(' (TEXT | ID) ')'
        //  ;

// cmdAssign : ID OP_ASGN expression
//           ;

// cmdIf : 'se' '(' expression ')' 
//         'entao' 
//         '{' 
//             command* 
//         '}' 
//         (
//         'senao' 
//         '{' 
//             command* 
//         '}')?
//       ;

// cmdWhile : 'enquanto' '(' expression ')' 
//            'faca' 
//            '{' 
//                 command* 
//            '}'
//          ;

// cmdDoWhile : 'faça' 
//              '{' 
//                    command* 
//              '}' 
//              'enquanto' '(' expression ')'
//            ;

// cmdFor : 'para' '(' ID ':=' expression 'ate' expression ')' 
//          'faca' 
//          '{' 
//                command* 
//          '}'
//        ;


NUMBER : NUM_INT | NUM_FLOAT
       ;

NUM_INT : ('-')?[0-9]+
        ;

NUM_FLOAT : ('-')?[0-9]+('.'[0-9]+)?
          ;

TEXT : '"' ( [a-z] | [A-Z] | [0-9] | ',' | '.' | ' ' | '-' )* '"'
     ;

ID : [a-zA-Z_] [a-zA-Z_0-9]*
   ;

OP_ASGN : ':='
        ;

OP_SUM	: '+'
        ;

OP_SUB	: '-'
        ;

OP_MUL	: '*'
        ;

OP_DIV	: '/'
        ;

OP_REL : '>' | '<' | '>=' | '<= ' | '<>' | '=='
       ;

PV : ';'
   ;			

WS :  ( ' ' | '\n' | '\r' | '\t' ) -> skip
   ;