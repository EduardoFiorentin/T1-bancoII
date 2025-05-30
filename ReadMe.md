# Instalações

```
sudo apt-get update
sudo apt-get install libpq-dev
```

# Configuração da base de dados 
Especificar como alterar o nome da base de dados no arquivo de configuração

# Explicação da implementação
Breve explicação da lógica 

# Compilação 

```
gcc -o main  *.c -I/usr/include/postgresql -lpq
```

# Rodar 
```
./main
```

# Linha de teste 

1. Criar o database e rodar o comando que cria/reseta as tabelas 
```
[./sql] \i ./restart.sql
```

2. Derrubar o postgres e restaurá-lo 

```
// encontrar PID
ps -ef | grep postgres

// Matar PG
sudo kill -9 pid

// Restaurar PG
sudo service postgresql start
```

3. rodar o REDO 
```
[.] ./main
```