# Projeto-Compiladores-2024q2

Projeto da Disciplina de Compiladores e Interpretadores cujo o objetivo e a criacao um compilador que devera fazer a transpilacao de uma linguagem de programacao criada pelo grupo, cuja a gramatica respeite os requisitos minimos definidos, para Linguagem C ou Java.

## Requisitos Minimos do Projeto

- [X] Possui 2 tipos de variáveis;
- [ ] Possui a estrutura `if`.. `else`;
- [ ] Possui estrutura de controle `while`/`do while`;
- [-] Operações Aritméticas executadas corretamente;
  - 09/Sep: Funcionando parcialmente. Precisa investigar o bug de quando tem multiplos operandos (mais de 2);
- [-] Atribuições realizadas corretamente;
  - 09/Sep: Funcionando parcialmente. Precisa investigar o bug de quando tem multiplos operandos (mais de 2);
- [ ] Possui operações de _Entrada_ e _Saída_;
- [X] Aceita números decimais;
- [X] Verificar se a variável já foi previamente declarada;
- [ ] Verificar se a variável foi declarada e não foi usada;
- [X] Verificar se uma variável está sendo usada sem ter valor inicial;

## Itens opicionais

- [ ] Editor Highlight (simulando uma pequena IDE);
- [ ] Avaliador de expressões aritméticas;
- [ ] Inserção de Operadores lógicos;
- [ ] Geração de várias linguagens-alvo;
- [ ] Uma API Rest para implementação do compilador;
- [ ] Um Interpretador (runtime) para a linguagem;

## Comando para atualizar ANTLR Parser

```bash
java -cp antlr-4.13.2-complete.jar org.antlr.v4.Tool PjLang.g4 -o src\io\compiler\core -package io.compiler.core
```

## Ideias

- Ideia para verificar se a variavel no for usada:
  - Adicionar um inteiro na classe `Var` que vai ser incrementado toda vez que uma variavel for usada em uma expressao;

## Bugs

- [ ] Colocando d = d funciona mesmo sem d ter sido inicializado previamente;
- [ ] Operacao do objeto _texto_ esta funcionando (nao deveria);
- [ ] Verificar porque o parentesis nao esta funcionando com a multiplicacao
  - **Obs.:** So nao esta funcionando quando esta a operacao esta do lado direito do parentesis
