/*
 * connect.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <libpq-fe.h> 
#include "database.h"

int main() 
{   
    PGconn *conn = start_connection(); 
    printf("Conexão estabelecida! [User: %s, Database name: %s]\n", PQuser(conn), PQdb(conn));
    printf("Iniciando REDO!\n");
    make_redo(conn);
    PQfinish(conn);
    return 0;
}
