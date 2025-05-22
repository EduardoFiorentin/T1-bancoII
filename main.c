/*
 * connect.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <libpq-fe.h> 

int main() 
{   
    PGconn *conn = PQconnectdb("password=admin user=postgres dbname=dojo");
   
    if (PQstatus(conn) == CONNECTION_BAD) {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(1);
    }

    printf("Database connected!\n");
    printf("User: %s\n", PQuser(conn));
    printf("Database name: %s\n", PQdb(conn));
    printf("Password: %s\n", PQpass(conn));

    PQfinish(conn);
    return 0;
}
