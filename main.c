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
    printf("Database connected! [User: %s, Database name: %s]\n", PQuser(conn), PQdb(conn));

    

    PQfinish(conn);
    return 0;
}
