# Instalações

```
sudo apt-get update
sudo apt-get install libpq-dev
```

# Compilação 

```
gcc -o main  *.c -I/usr/include/postgresql -lpq
```

# Rodar 
```
./main
```