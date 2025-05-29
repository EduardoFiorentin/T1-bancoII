#include "database.h"
#include <libpq-fe.h> 
#include <string.h>

PGconn *start_connection() {
    PGconn *conn = PQconnectdb(DATABASE_ARGUMENTS);
   
    if (PQstatus(conn) == CONNECTION_BAD) {
        fprintf(stderr, "Connection to database failed: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(1);
    }
    
    return conn;
}

void make_redo(PGconn *conn) {
    // Executa a consulta ao log

    // Verifica quais transações sofrem redo
    PGresult *redo = PQexec(conn, "select distinct transacao_id as tid from log order by tid");
    // Verifica se a consulta foi bem-sucedida
    if (PQresultStatus(redo) != PGRES_TUPLES_OK) {
        printf("Error on log reading -- %s\n", PQerrorMessage(conn));
        PQclear(redo);
        exit(1);
    }
    
    
    printf("Transações que sofrem REDO:\n");
    for (int i = 0; i < PQntuples(redo); i++) {
        printf("\t-- %s\n", PQgetvalue(redo, i, 0));
    }


    PGresult *res = PQexec(conn, "SELECT * FROM log order by transacao_id");

    // Verifica se a consulta foi bem-sucedida
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf( "Error on log reading: %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(1);
    }

    // Processa os resultados
    int i, j, nfields, nrows;
    char query[300]; 
    PGresult *resQuery;

    nfields = PQnfields(res);
    nrows = PQntuples(res);

    
    for (i = 0; i < nrows; i++) {

        if (strcmp(PQgetvalue(res, i, STATUS), "committed") == 0) {
            
            if (strcmp(PQgetvalue(res, i, OPERATION), "INSERT") == 0) {
                sprintf(query, "INSERT INTO clientes_em_memoria (id, nome, saldo) VALUES ('%s', '%s', '%s');", PQgetvalue(res, i, ID_CLIENT), PQgetvalue(res, i, NAME), PQgetvalue(res, i, BALANCE));
                // printf("%s\t\t", query);
                resQuery = PQexec(conn, query);
                printf("INSERT: %s\n", PQresStatus(PQresultStatus(resQuery)));
            }
            else if (strcmp(PQgetvalue(res, i, OPERATION), "UPDATE") == 0) {
                sprintf(query, "UPDATE clientes_em_memoria SET id='%s', nome='%s', saldo='%s' where id='%s';", PQgetvalue(res, i, ID_CLIENT), PQgetvalue(res, i, NAME), PQgetvalue(res, i, BALANCE), PQgetvalue(res, i, ID_CLIENT));
                // printf("%s\t\t", query);
                resQuery = PQexec(conn, query);
                printf("UPDATE: %s\n", PQresStatus(PQresultStatus(resQuery)));

            }
            else if (strcmp(PQgetvalue(res, i, OPERATION), "DELETE") == 0) {
                sprintf(query, "DELETE FROM clientes_em_memoria WHERE id='%s';", PQgetvalue(res, i, ID_CLIENT));
                // printf("%s\t\t", query);
                resQuery = PQexec(conn, query);
                printf("DELETE: %s\n", PQresStatus(PQresultStatus(resQuery)));

            }
        }
    }

    PQclear(res);
    PQclear(redo);

}