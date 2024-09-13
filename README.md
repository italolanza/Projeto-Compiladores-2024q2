# Projeto-Compiladores-2024q2

Projeto da Disciplina de Compiladores e Interpretadores cujo o objetivo e a criacao um compilador que devera fazer a transpilacao de uma linguagem de programacao criada pelo grupo, cuja a gramatica respeite os requisitos minimos definidos, para Linguagem C ou Java.

## Requisitos Minimos do Projeto

- [X] Possui 2 tipos de variáveis;
- [X] Possui a estrutura `if`.. `else`;
- [X] Possui estrutura de controle `while`/`do while`;
- [X] Operações Aritméticas executadas corretamente;
- [X] Atribuições realizadas corretamente;
- [X] Possui operações de _Entrada_ e _Saída_;
- [X] Aceita números decimais;
- [X] Verificar se a variável já foi previamente declarada;
- [X] Verificar se a variável foi declarada e não foi usada;
- [X] Verificar se uma variável está sendo usada sem ter valor inicial;
- Warnings:
  - [X] A cada utilização de uma variável, é necessário verificar se a mesma já foi declarada.
  - [X] Variáveis que foram declaradas e não foram usadas
  - [X] Variáveis que foram usadas e não tem valor inicial (controle na tabela de símbolos)

## Itens opicionais

- [ ] Editor Highlight (simulando uma pequena IDE);
- [ ] Avaliador de expressões aritméticas;
  - **11/Sep**: Preciso so colocar no codigo para imprimir as expressoes e o resultados conforme forem sendo analisadas
- [ ] Inserção de Operadores lógicos;
- [ ] Geração de várias linguagens-alvo;
- [ ] Uma API Rest para implementação do compilador;
- [ ] Um Interpretador (runtime) para a linguagem;

## Comando para atualizar ANTLR Parser

```bash
java -cp antlr-4.13.2-complete.jar org.antlr.v4.Tool PjLang.g4 -o src\io\compiler\antlr -package io.compiler.antlr
```

## Ideias

- Ideia para verificar se a variavel no for usada:
  - Adicionar um inteiro na classe `Var` que vai ser incrementado toda vez que uma variavel for usada em uma expressao;

## Bugs

- ~~Colocando d = d funciona mesmo sem d ter sido inicializado previamente;~~
- ~~Operacao do objeto _texto_ esta funcionando (nao deveria);~~
- ~~Investigar porque quando temos um numero quebrado nao esta reclamando sobre o diferente tipo de variavel sendo atribuida;~~
  ~~- _Nota_: Provavelmente preciso colocar uma verificacao na hora da divisao para ver se o numero e divisivel sem sobra;~~
  ~~- _Nota 2_: Outra opcao e fazer a verificacao dentro do `evaluateType()` da classe `BinaryExpression`;~~
~~- Investigar bug em que variaveis do tipo `texto` recebem valore do tipo `inteiro` e do tipo `real` sem estarem entre parentesis;~~
~~- Investigar bug em que variaveis do tipo `texto` nao reconhecem operacoes entre aspas como texto;~~
~~- Comandos `se`/`senao` aninhados causam StackOverflow;~~
  ~~- Precisa investigar.~~
- O _parser_ nao consegue diferenciar o "-1" em uma expressao como "5-1" sem que haja um espaco entre o operador e o numero;
