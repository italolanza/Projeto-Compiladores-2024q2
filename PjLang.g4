grammar PjLang;

@header {
    import java.util.ArrayList;
    import java.util.Stack;
    import java.util.HashMap;
    import io.compiler.types.*;
    import io.compiler.exceptions.*;
    import io.compiler.runtime.*;
    import io.compiler.core.*;
}

@members {
    private Program program = new Program();
    private HashMap<String, Var> symbolTable = new HashMap<String, Var>(); //stores variables names and type
    private ArrayList<Var> currentDecl = new ArrayList<Var>();
    private Types currentType;
    private Types leftSide = null;
    private String leftSideID = null;
    private Types rightSide = null;
    private AbstractExpression expStackTop = null;

    private Stack<ArrayList<AbstractCommand>> commandStackList = new Stack<ArrayList<AbstractCommand>>();
    private Stack<AbstractExpression> expressionStack = new Stack<AbstractExpression>();

    public void updateType() {
        for (Var v: currentDecl) {
                v.setType(currentType);
                symbolTable.put(v.getId(), v);
        }
    }

    public void printDeclaredVariables() {
        for (String id: symbolTable.keySet()) {
                System.out.println(symbolTable.get(id));
        }
    }

    public Program getProgram() {
        return this.program;        
    }

    public boolean isDeclared(String id) {
        return symbolTable.get(id) != null;
    }

    public double generateValue() {
        if (expStackTop == null) {
            expStackTop = expressionStack.pop();
        }
        return expStackTop.evaluate();
    }

    public String gerenateExpressionTreeJSON() {
        if (expStackTop == null) {
            expStackTop = expressionStack.pop();
        }
        return expStackTop.toJson();
    }
}


program 
        : 
        'programa' ID 
        { 
            program.setName(_input.LT(-1).getText());
            commandStackList.push(new ArrayList<AbstractCommand>());
        }
        variableDeclaration+
        'inicio'
        command*
        'fim'
        'fimprog'
        {
            program.setSymbolTable(symbolTable);
            program.setCommandList(commandStackList.pop());
        }
        ;

variableDeclaration 
        :   
        'variavel' { currentDecl.clear(); }
        ID { currentDecl.add(new Var(_input.LT(-1).getText())); }
        (
        VIRG ID { currentDecl.add(new Var(_input.LT(-1).getText())); }
        )* // opcionalmente podemos declarar mais de uma variavel na mesma linha
        DP
        (
        'inteiro' { currentType = Types.INTEGER; }
        |
        'real' { currentType = Types.REALNUMBER; }
        |
        'texto' { currentType = Types.TEXT; }
        )
        { updateType(); } // atualiza list de simbolos com as novas variaveis declaradas
        PV
        ;

command
    : assignment
    | conditional
    | loop
    ;

conditional
    : 'se' '(' expression ')' 'entao' (command)+ ('senao' (command)+)? 'fimse'
    {
        System.out.println("Processing 'se' block...");
        System.out.println("Condition: " + expressionStack.peek());
        System.out.println("Found 'fimse'");
        ArrayList<AbstractCommand> listaIf = commandStackList.pop();
        ArrayList<AbstractCommand> listaElse = (commandStackList.isEmpty()) ? null : commandStackList.pop();
        
        CommandIf cmd = new CommandIf(expressionStack.pop(), listaIf, listaElse);
        commandStackList.peek().add(cmd);
    }
    ;


loop
    : whileLoop
    | doWhileLoop
    ;

whileLoop
    : 'enquanto' '(' expression ')' 'faca' command* 'fimenquanto'
    {
        ArrayList<AbstractCommand> loopCommands = commandStackList.pop();
        CommandWhile cmd = new CommandWhile(expressionStack.pop(), loopCommands);
        commandStackList.peek().add(cmd);
    }
    ;

doWhileLoop
    : 'faca' command* 'enquanto' '(' expression ')' PV
    {
        ArrayList<AbstractCommand> loopCommands = commandStackList.pop();
        CommandDoWhile cmd = new CommandDoWhile(expressionStack.pop(), loopCommands);
        commandStackList.peek().add(cmd);
    }
    ;




assignment
        : 
        ID
        {
            // verifica se a variavel existe
            if (!isDeclared(_input.LT(-1).getText())) {
                throw new UndefinedExpression("Undeclared Variable: " + _input.LT(-1).getText());
            }

            // salva o ID da variavel para o caso dela nao ter sido inicilizada antes
            if (!symbolTable.get(_input.LT(-1).getText()).isInitialized()){
                leftSideID = _input.LT(-1).getText();
            }

            leftSide = symbolTable.get(_input.LT(-1).getText()).getType();
        }
        OP_ASGN
        expression
        PV
        {
            // verifica se a varaivel e o resultado da expressao possuem tipos compativeis
            if (leftSide.getValue() != rightSide.getValue()) {
                if ( leftSide == Types.REALNUMBER && rightSide == Types.INTEGER) {
                    // TODO: Candidato a Warning de perda de precisao!!
                }
                else {
                    // variaveis de tipos nao compativeis
                    throw new AssignmentException("Type Mismatching on Assignment: left side= " + leftSide + ", right side= " + rightSide);
                }
            }
                       
            if (!symbolTable.get(leftSideID).isInitialized()){
                symbolTable.get(leftSideID).setInitialized(true);
                symbolTable.get(leftSideID).setValue(expressionStack.peek().evaluate());
            }
        }
        ;


expression
        :
        term
        ((OP_SUM | OP_SUB)
        {
            BinaryExpression bin = new BinaryExpression(_input.LT(-1).getText().charAt(0));
            bin.setLeft(expressionStack.pop());
            expressionStack.push(bin);
        }
        term
        {
            AbstractExpression top = expressionStack.pop();                     // desempilha o ultimo termo adicionado
            BinaryExpression root = (BinaryExpression) expressionStack.pop();   // desempinha a operacao binaria
            root.setRight(top);                                                 // atribui o membro direito da expressao com o ultimo termo
            expressionStack.push(root);                                         // empilha a operacao binaria com os dois termos atribuidos
        }
        )*
        {
            // verifica se a expressao esta correta (operando com tipos corretos - basicamente numero com numero)
            if ( expressionStack.peek() instanceof BinaryExpression ) {
                Types leftOperatorType = ((BinaryExpression)expressionStack.peek()).getLeft().evaluateType();
                Types rightOperatorType =  ((BinaryExpression)expressionStack.peek()).getRight().evaluateType();
                
                // verifica se nenhum dos operadores e do tipo TEXT
                if (leftOperatorType == Types.TEXT || rightOperatorType == Types.TEXT) {
                    throw new ExpressionException("Operator type mismatching. Trying to operate with a text type!");
                }

                // verifica se os ambos operadores da expressao possuem o mesmo tipo
                if ( leftOperatorType != rightOperatorType ) {
                    // atribuindo um numero real a uma variavel do tipo inteira
                    if ( leftOperatorType == Types.INTEGER && rightOperatorType == Types.REALNUMBER) {
                        // TODO: Candidato a Warning de perda de precisao!!
                        // throw new ExpressionException("Operator type mismatching: left type= " + leftOperatorType + ", right type= " + rightOperatorType);    

                    }
                }
            }
        }
        ;


term : 
     factor
     ((OP_MUL | OP_DIV)
     {
        BinaryExpression bin = new BinaryExpression(_input.LT(-1).getText().charAt(0));
        char lastTolken = _input.LT(-2).getText().charAt(0);

        // o que veio antes e uma expressao unica, isto e, um operador simples/nao e uma operacao binaria - soma ou subtracao
        // desempilha e transforma ele em um membro da multiplicacao
        if ( expressionStack.peek() instanceof UnaryExpression ) {
            bin.setLeft(expressionStack.pop());
        }
        // o que veio antes e uma expressao binaria, isto e, uma operacao
        else {
            BinaryExpression father = (BinaryExpression) expressionStack.pop();

            // caso especial em que o ultimo elemento lido e um "fecha parentesis"
            // atribui o lado esquerdo como a operacao binaria
            if ( lastTolken == ')' ) {
                bin.setLeft(father);
            }
            // substitui o termo direito da operacao anterior pela nova operacao
            // e adiciona o termo direito da operacao anterior como termo esquerdo
            // da nova operacao (procedencia menor)
            else if (father.getOperation() == '+' || father.getOperation() == '-') {
                bin.setLeft(father.getRight());
                father.setRight(bin);
            }
            // operacao anterior possui mesma procedencia, entao nao precisa alterar a ordem das operacoes
            else {    
                bin.setLeft(father);
                expressionStack.push(bin);
            }
        }
     }
     factor
     {
        bin.setRight(expressionStack.pop());
        expressionStack.push(bin);
     }
     )*
    {
        // verifica se a expressao esta correta (operando com tipos corretos - basicamente numero com numero)
        if ( expressionStack.peek() instanceof BinaryExpression ) {
            Types leftOperatorType = ((BinaryExpression)expressionStack.peek()).getLeft().evaluateType();
            Types rightOperatorType =  ((BinaryExpression)expressionStack.peek()).getRight().evaluateType();
            
            // verifica se nenhum dos operadores e do tipo TEXT
            if (leftOperatorType == Types.TEXT || rightOperatorType == Types.TEXT) {
                throw new ExpressionException("Operator type mismatching. Trying to operate with a text type!");
            }
        }
        rightSide = expressionStack.peek().evaluateType();
    }
     ;


factor
        :
        '(' expression ')'
        | literal
        | ID
        {
            // verifica se a variavel existe
            if (!isDeclared(_input.LT(-1).getText())) {
                // TODO: Candidato a Warning !!
                throw new ProjectException("Undeclared Variable: " + _input.LT(-1).getText());
            }

            // verifica se a variavel foi inicializada
            if (!symbolTable.get(_input.LT(-1).getText()).isInitialized()) {
                // TODO: Candidato a Warning !!
                throw new ExpressionException("Variable " + "<" + _input.LT(-1).getText() + ">" + " was not initialized!");
            }

            
            Var v = symbolTable.get(_input.LT(-1).getText());

            // salva o tipo da variavel caso nao tenha nada salvo
            if (rightSide == null) {    
                rightSide = v.getType();
            }
            // substitui o valor do factor se o tipo de variavel possuir um valor maior
            // inteiro == 1, real == 2, texto == 3;
            else {
                if (v.getType().getValue() > rightSide.getValue()) {
                    rightSide = v.getType();
                }
            }
            
            UnaryExpression element = new UnaryExpression(v.getValue(), v.getType());
            expressionStack.push(element);
        }
        ;


literal 
        :
        NUM_INT
        {
            if (rightSide == null) {
                rightSide = Types.INTEGER;
            }
            else {
                if (rightSide.getValue() < Types.INTEGER.getValue()) {
                    rightSide = Types.INTEGER;
                }
            }
            UnaryExpression element = new UnaryExpression(Double.parseDouble(_input.LT(-1).getText()), Types.INTEGER);
            expressionStack.push(element);
            
        }
        | NUM_REAL
        { 
            if (rightSide == null) {
                rightSide = Types.REALNUMBER;
            }
            else {
                if (rightSide.getValue() < Types.REALNUMBER.getValue()) {
                    rightSide = Types.REALNUMBER;
                }
            }
            UnaryExpression element = new UnaryExpression(Double.parseDouble(_input.LT(-1).getText()), Types.REALNUMBER);
            expressionStack.push(element);
        }
        | STRING
        {
            if (rightSide == null) {
                rightSide = Types.TEXT;
            }
            else {
                if (rightSide.getValue() < Types.TEXT.getValue()) {
                    rightSide = Types.TEXT;
                }
            }
            UnaryExpression element = new UnaryExpression(_input.LT(-1).getText(), Types.TEXT);
            expressionStack.push(element);
        }
        ;


NUM_INT : ('-')?[0-9]+
        ;

NUM_REAL : ('-')?[0-9]+'.'[0-9]+
         ;

NUMBER : NUM_INT | NUM_REAL
       ;

STRING : '"' ( [a-z] | [A-Z] | [0-9] | ',' | '.' | ' ' | '-' | '+' | '*' | '/' | '!' | '?' )* '"'
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

OP_REL : ('>' | '<' | '>=' | '<= ' | '<>' | '==')
       ;

VIRG : ','
     ;

DP : ':'
   ;

PV : ';'
   ;			

WS :  ( ' ' | '\n' | '\r' | '\t' ) -> skip
   ;