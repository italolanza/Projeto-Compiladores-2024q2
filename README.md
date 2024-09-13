# Projeto-Compiladores-2024q2

Projeto da Disciplina de Compiladores e Interpretadores cujo o objetivo e a criacao um compilador que devera fazer a transpilacao de uma linguagem de programacao criada pelo grupo, cuja a gramatica respeite os requisitos minimos definidos, para Linguagem C ou Java (Java no caso do nosso grupo).

## Integrantes do Projeto

|                     Nome                     	|      RA     	|
|:--------------------------------------------	|:----------- 	|
| Guilherme Ferreira Costa                     	| 11201921774 	|
| Italo Milhomem de Abreu Lanza                	| 11039414    	|
| Luccas Vinicius de Faveri Tortorelli Cardoso 	| 11201920991   |

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
- [ ] Inserção de Operadores lógicos;
- [ ] Geração de várias linguagens-alvo;
- [ ] Uma API Rest para implementação do compilador;
- [ ] Um Interpretador (runtime) para a linguagem;

## Como executar o projeto

- Faca o download do arquivo Antlr.jar (antlr-<x.y.z>-complete) e coloque na raiz do projeto;
- Gere a bibliotecas do antlr usando o comando: `java -cp antlr-4.13.2-complete.jar org.antlr.v4.Tool PjLang.g4 -o src\io\compiler\antlr -package io.compiler.antlr`;
- No arquivo `src\io\compiler\main\MainClass.java`, atualize a variavel **`INPUT_FILE_PATH`** com o caminho para o arquivo de teste que sera utilizado;
  - No diretorio `input\itens_obrigatorios` ha um seria de arquivos de teste para validacao dos itens obrigatorios.
- Execute o programa
  - O arquivo `.java` de saida sera gerado na raiz do projeto.
