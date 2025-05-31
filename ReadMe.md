## Introdução
Esta implementação foi realizada como requisito parcial para nota 1 da disciplina de Bancos de Dados 2, e tem como objetivo simular uma recuperação de dados a partir de um registro de log utilizando o algoritmo REDO em banco de dados Postgre.

**Estudante**: Eduardo Fiorentin - 2211100002

## Explicação da implementação
O algoritmo REDO foi implementado utilizando a linguagem C. O objetivo é criar e popular uma tabela em memória (UNLOGED TABLE) 'clientes_em_memoria' e, em seguida, reinicializar o postgres e repopulá-la apenas utilizando o algoritmo REDO implementado e uma tabela de log, que por sua vez é populada durante a inserção dos registros na tabela de clientes por um trigger.

## Dependências
Para rodar o projeto, primeiramente é necessário ter instalado o gerenciador de bancos de dados Postgres e sua biblioteca para integração com linguagem C, bem como o compilador gcc.

### Instalação da biblioteca

```
sudo apt-get update
sudo apt-get install libpq-dev
```

Após a instalação, verifique no diretório `usr/include/postgresql` se o arquivo `libpq-fe.h` foi adicionado.

## Base de dados 

**Importante!**: Por padrão, a implementação utiliza o usuário **postgres**, senha **admin**. Ajuste estas configurações na macro `DATABASE_ARGUMENTS` (`database.h`) para que o programa consiga acessar a base de dados corretamente. 

Por padrão, a implementação utiliza uma base de dados denominada `t1bd2`, cujo script de criação pode ser acessado em `sql/create_database.sql`. É possível alterá-la, para isso, altere o nome da base de dados no macro `DATABASE_ARGUMENTS` (`database.h`).

O script para criação da estrutura inicial (tabela de clientes, log e trigger) está disponível em `sql/reset_tables.sql`.

O script para inserção dos registros nas tabelas de clientes e log está disponível em `sql/exemplo_trabalho.sql`.

Ambos os scrips podem ser executados separadamente ou através do script `restart.sql`.


### Setup da base de dados
1. Acesse o diretório `./sql` via terminal e abra o psql.
2. No psql, certifique-se de estar conectado à base de dados correta.
3. Execute o script de criação das tabelas, trigger e registros `\i ./restart.sql`.

 
## Compilação do script de REDO 

Para executar o algoritmo redo, primeiramente é necessário compilar o programa. Para isso, execute:

```
gcc -o redo  *.c -I/usr/include/postgresql -lpq
```

## Linha de teste 

Para a 

1. Criar a base de dados e rodar o comando que cria/reseta as tabelas e trigger (processo descrito anteriormente)

2. Derrubar o postgres e restaurá-lo 

```
// encontrar PID
ps -ef | grep postgres

// Matar PG
sudo kill -9 PID

// Restaurar PG
sudo service postgresql start
```

3. rodar o algoritmo REDO 
```
[.] ./redo
``` 

O resultado esperado é que, após a reconstrução da tabela 'clientes_em_memoria', sua estrutura final seja igual a antes da reinicialização do postgres.