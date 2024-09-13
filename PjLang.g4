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
    private String leftSideID = null;
    private Types leftSideType = null;
    private Types rightSideType = null;
    private String strExpr = "";
    private Stack<IFCommand> ifCmdStack = new Stack<IFCommand>();
    private Stack<CommandWhile> whileCmdStack = new Stack<CommandWhile>();
    private Stack<CommandDoWhile> doWhileCmdStack = new Stack<CommandDoWhile>();
    private AssignmentCommand currentAssignmentCommand;
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

    public void checkUnusedVariables() {
        for (String id : symbolTable.keySet()) {
            Var variable = symbolTable.get(id);
            if (!variable.isUsed()) {
                // Emite um warning se a variavel foi declarada mas nunca usada
                System.out.println("[Warning]: Variável '" + id + "' foi declarada, mas nunca usada.");
            }
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

            // Chama a verificação de variáveis não usadas
            // checkUnusedVariables();
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

command : 
        assignment
        | conditional
        | loop
        | reader
        | writer
        ;

loop
    : whileLoop
    | doWhileLoop
    ;

whileLoop
    : 'enquanto'
    {
        // cria lista uma nova lista de comandos e adiciona na pilha de comandos
        commandStackList.push(new ArrayList<AbstractCommand>());
        strExpr = "";
        whileCmdStack.push(new CommandWhile());
    }
    OP 
    expression
    OP_REL
    {
        // salva o operador operacional na string de expressoes
        strExpr += _input.LT(-1).getText();
    }
    expression
    CP
    {
        // salva expressao/condicional do while
        whileCmdStack.peek().setCondition(strExpr);
    }
    'faca' 
    command+
    {
        // retira a lista de comandos da pilha e salva na lista de comandos "True"
        whileCmdStack.peek().setLoopCommands(commandStackList.pop());
    }
    'fimenquanto'
    {
        // adiciona o ultimo CommandWhile da stack de ifs
        // na stack de comandos
        commandStackList.peek().add(whileCmdStack.pop());
    }
    ;

doWhileLoop
    : 'faca'
    {
        // cria uma nova lista de comandos e adiciona na pilha de comandos
        commandStackList.push(new ArrayList<AbstractCommand>());
        strExpr = "";  // Reseta a string de expressão
        doWhileCmdStack.push(new CommandDoWhile());  // Adiciona o comando do-while à pilha
    }
    command+
    {
        // remove a lista de comandos da pilha e a salva no comando do-while
        doWhileCmdStack.peek().setLoopCommands(commandStackList.pop());
    }
    'enquanto' {strExpr = "";}
    OP 
    expression
    OP_REL
    {
        // pega o operador relacional
        strExpr += _input.LT(-1).getText();
    }
    expression
    CP PV
    {
        // armazena a condição final do 'do-while'
        doWhileCmdStack.peek().setCondition(strExpr);

        // adiciona o último CommandDoWhile à pilha de comandos
        commandStackList.peek().add(doWhileCmdStack.pop());
    }
    ;

reader :   
            'leia'
            OP
            ID
            {
                // salva valor do tolken ID
                String id = _input.LT(-1).getText();
            
                // verifica se a variavel existe
                if (!isDeclared(id)) {
                    // Emite um warning ao inves de lançar um erro
                    System.out.println("[Warning]: Variável '" + id + "' não foi declarada.");
                }

                // inicializa a variavel que vai receber o valor
                symbolTable.get(id).setInitialized(true);
                
                // cria o commando de leitura e adiciona na lista de comandos
                AbstractCommand readCommand = new ReadCommand(symbolTable.get(id));
                commandStackList.peek().add(readCommand);
            }
            CP
            PV
            {
                rightSideType = null;
            }
        ;

writer : 
            'escreva'
            {
                strExpr = "";
            }
            OP
            expression
            {
                // salva expressao lida
                String exp = strExpr;
                
                //cria novo comando de escrita
                AbstractCommand writeCommand = new WriteCommand(exp);
                commandStackList.peek().add(writeCommand);
            }
            CP
            PV
            {
                rightSideType = null;
            }
         ;

conditional :
        'se' 
        {
            // cria lista uma nova lista de comandos e adiciona na pilha de comandos
            commandStackList.push(new ArrayList<AbstractCommand>());
            strExpr = "";
            ifCmdStack.push(new IFCommand());
        }
        OP
        expression
        OP_REL
        {
            // salva o operador operacional na string de expressoes
            strExpr += _input.LT(-1).getText();
        }
        expression
        CP
        {
            // salva expressao/condicional do If
            ifCmdStack.peek().setExpression(strExpr);
        }
        'entao'
        command+
        {
            // retira a lista de comandos da pilha e salva na lista de comandos "True"
            ifCmdStack.peek().setTrueList(commandStackList.pop());
        }
        ('senao'
        {
            // cria uma nova entrada na pilha para 
            // armazenar os comandos de dentro do "False"
            commandStackList.push(new ArrayList<AbstractCommand>());
        }
        command+
        {
            // retira a lista de comandos da pilha e salva na lista de comandos "False"
            ifCmdStack.peek().setFalseList(commandStackList.pop());
        }
        )?
        'fimse'
        {
            // adiciona o ultimo Ifcommand da stack de ifs
            // na stack de comandos
            commandStackList.peek().add(ifCmdStack.pop());
        }
      ;

assignment
        : 
        ID
        {
            // salva valor do tolken ID
            String id = _input.LT(-1).getText();
            Var leftSideVar;

            // verifica se a variavel existe/foi declarada
            if (isDeclared(id)) {
                // left side type
                leftSideType = symbolTable.get(id).getType();
                leftSideVar = symbolTable.get(id);
            }
            else {
                // cria uma variavel que nao existe para colocado na expressao
                leftSideVar = new Var(id);
            }

            leftSideID = id;

            // reseta a variavel que armazena a expressao/tolkens lidos e
            // cria nova uma variavel do tipo AssignmentCommand
            strExpr = "";
            currentAssignmentCommand = new AssignmentCommand(leftSideVar);
        }
        OP_ASGN
        expression
        PV
        {
            // verifica se a variavel existe/foi declarada
            if (!isDeclared(leftSideID)) {
                // Emite um warning de Variavel Nao Declarada
                System.out.println("[Warning]: Variavel '" + leftSideID + "' esta sendo usada porem nao foi declarada!");
                
                // deixa os dois lados com o mesmo tipo para nao quebrar o restante do as checagens
                leftSideType = rightSideType;
            }
            else {
                // variavel existe/foi declarada
                // primeira vez que a variavel esta sendo inicializada
                if (!symbolTable.get(leftSideID).isInitialized()){
                    symbolTable.get(leftSideID).setInitialized(true);
                    symbolTable.get(leftSideID).setUsed(true);
                    symbolTable.get(leftSideID).setValue(expressionStack.peek().evaluate());
                }

                // verifica se a varaivel e o resultado da expressao possuem tipos compativeis
                if (leftSideType.getValue() != rightSideType.getValue()) {
                    if ( leftSideType == Types.REALNUMBER && rightSideType == Types.INTEGER) {
                        System.out.println("[Warning]: Trying to assign a type '" + rightSideType + "' to a '" + leftSideType + "' type variable. Are you sure?" );
                    }
                    else {
                        // variaveis de tipos nao compativeis
                        throw new AssignmentException("Type Mismatching on Assignment: left side= " + leftSideType + ", right side= " + rightSideType);
                    }
                }
            }

            // salva expressao lida no AssignmentCommand
            // e adiciona o novo comando na stack de comandos
            currentAssignmentCommand.setExpression(strExpr);
            commandStackList.peek().add(currentAssignmentCommand);
        }
        ;


expression
        :
        term 
        {
            strExpr += _input.LT(-1).getText();
        }
        ((OP_SUM | OP_SUB)
        {
            // salva operador da expressao
            strExpr += _input.LT(-1).getText();

            // cria uma nova expressao binaria com o operador lido
            // salva o que ja foi lido como o lado esquerdo
            // e e adicionado na pilha de expressoes
            BinaryExpression bin = new BinaryExpression(_input.LT(-1).getText().charAt(0));
            bin.setLeft(expressionStack.pop());
            expressionStack.push(bin);
        }
        term
        {
            strExpr += _input.LT(-1).getText();                                 // salva ultimo elemento da expressao
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
                        // TODO: Candidato a warning de perda de precisao!!
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
        rightSideType = expressionStack.peek().evaluateType();
    }
     ;


factor
        :
        '(' {strExpr += _input.LT(-1).getText();}
            expression 
        ')'
        | literal
        | ID
        {
            String varName  = _input.LT(-1).getText();

            // verifica se a variavel existe
            if (!isDeclared(varName)) {
                // Emite um warning ao invés de lançar um erro
                System.out.println("[Warning]: Variável '" + varName + "' não foi declarada.");
            }

            Var v = symbolTable.get(varName);

            // verifica se a variavel foi inicializada
            if (!symbolTable.get(varName).isInitialized()) {
                // Emite um warning se a variável não tiver valor inicial
                System.out.println("[Warning]: Variável '" + varName + "' esta sendo usada porem nao foi inicializada.");
            } else {
                // Marcar a variável como usada
                v.setUsed(true);
            }

            // salva o tipo da variavel caso nao tenha nada salvo
            if (rightSideType == null) {    
                rightSideType = v.getType();
            }
            // substitui o valor do factor se o tipo de variavel possuir um valor maior
            // inteiro == 1, real == 2, texto == 3;
            else {
                if (v.getType().getValue() > rightSideType.getValue()) {
                    rightSideType = v.getType();
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
            if (rightSideType == null) {
                rightSideType = Types.INTEGER;
            }
            else {
                if (rightSideType.getValue() < Types.INTEGER.getValue()) {
                    rightSideType = Types.INTEGER;
                }
            }
            UnaryExpression element = new UnaryExpression(Double.parseDouble(_input.LT(-1).getText()), Types.INTEGER);
            expressionStack.push(element);
            
        }
        | NUM_REAL
        { 
            if (rightSideType == null) {
                rightSideType = Types.REALNUMBER;
            }
            else {
                if (rightSideType.getValue() < Types.REALNUMBER.getValue()) {
                    rightSideType = Types.REALNUMBER;
                }
            }
            UnaryExpression element = new UnaryExpression(Double.parseDouble(_input.LT(-1).getText()), Types.REALNUMBER);
            expressionStack.push(element);
        }
        | STRING
        {
            if (rightSideType == null) {
                rightSideType = Types.TEXT;
            }
            else {
                if (rightSideType.getValue() < Types.TEXT.getValue()) {
                    rightSideType = Types.TEXT;
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

STRING : '"' ( [a-z] | [A-Z] | [0-9] | ',' | '.' | ' ' | '-' | '+' | '*' | '/' | '!' | '?' | ':' )* '"'
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

OP : '('
   ;

CP : ')'
   ;

WS :  ( ' ' | '\n' | '\r' | '\t' ) -> skip
   ;