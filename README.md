# WAO - WebAssembly Optimizer 
WAO é um otimizador de codigo em webAssembly, desenvolvido para otimizar códigos WebAssembly em formato WAT.
A otimização se da em questão de numero de instruções necessárias para realizar um ou mais tarefas.

## Instalação

Para utilizar o otimizador WAO é necessário os seguintes passos:

1 - Clonar o repositorio.

2 - Criar uma caminho para o repositório do WAO para acesso do compilador de Lisp escolhido.

```
Exemplo: QuickLisp
ln -s $(pwd) ~/quicklisp/local-projects
```

3 - WAO utiliza o compilador de webAssembly [WABT](https://github.com/WebAssembly/wabt).

4 - Necessário a criação de uma variável de ambient para assesso ao compilador WABT.

```
export PATH=$PATH:../wabt/out/
```

5 -  Instalação do algoritmo evolutivo [Software Evolution](https://github.com/eschulte/software-evolution).


6 - O processo de avaliação faz uso de scripts em JavaScript, para execução de código em [webAssembly](https://webassembly.org/).

Instalação NodeJS

```
sudo npm cache clean -f
sudo npm install -g n
sudo n 8.0.0
```

## Execução

WAO otimiza uma código em wat, para otimizar um arquivo, abra o compilador e execute os comandos:

```
(ql:quickload "wao")
(in-package #:wao)
(evolve-code)
```

Após o termino do execução, utilize o comando abaixo, para obter o melhor resultado encontrado.

```	
(get-best)
```
