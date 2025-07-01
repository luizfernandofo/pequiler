# Pequiler

Este projeto implementa um compilador para a linguagem Goianinha.

## Pré-requisitos

Certifique-se de que você tem o **Flex** e o **Bison** instalados em sua máquina antes de compilar o projeto.

## Como compilar

Navegue até o diretório `src` e execute o comando abaixo para compilar o projeto:

```bash
cd Pequiler/src
make
```

O executável será gerado em `Pequiler/src/target/goianinha`.

## Como rodar

Para rodar o compilador, utilize:

```bash
./target/goianinha <arquivo_de_entrada>
```

Substitua `<arquivo_de_entrada>` pelo caminho do arquivo fonte que deseja compilar.

## Como executar os testes

Os testes estão organizados nas pastas `test/lex`, `test/parser` e `test/semantic`. Para testar o analisador léxico, sintático ou semântico, execute:

```bash
./target/goianinha <caminho_para_o_teste>
```

Por exemplo:

```bash
./target/goianinha ../test/lex/expressao1Correto.txt
```

Verifique a saída do programa para conferir se o teste passou ou falhou.

## To Do

Algumas verificações semânticas ainda não foram implementadas.