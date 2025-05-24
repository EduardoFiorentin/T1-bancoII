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
    // Executa a consulta
    PGresult *res = PQexec(conn, "SELECT * FROM log");

    // Verifica se a consulta foi bem-sucedida
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Erro ao executar a consulta: %s\n", PQerrorMessage(conn));
        PQclear(res);
        PQfinish(conn);
        return;
    }

    // Processa os resultados (exemplo: imprime os dados)
    int i, j, nfields, nrows;
    char query[300]; 
    PGresult *resQuery;

    nfields = PQnfields(res);
    nrows = PQntuples(res);

    printf("Número de campos: %d\n", nfields);
    printf("Número de linhas: %d\n", nrows);

    for (i = 0; i < nrows; i++) {

        if (strcmp(PQgetvalue(res, i, STATUS), "committed") == 0) {
            
            if (strcmp(PQgetvalue(res, i, OPERATION), "INSERT") == 0) {
                sprintf(query, "INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('%s', '%s');", PQgetvalue(res, i, NAME), PQgetvalue(res, i, BALANCE));
                printf("%s\t", query);
                resQuery = PQexec(conn, query);
                printf("Query Status: %s\n", PQresStatus(PQresultStatus(resQuery)));
            }
            else if (strcmp(PQgetvalue(res, i, OPERATION), "UPDATE") == 0) {
                sprintf(query, "UPDATE clientes_em_memoria SET saldo=%s where id=%s;", PQgetvalue(res, i, BALANCE), PQgetvalue(res, i, ID_CLIENT));
                printf("%s\t", query);
                resQuery = PQexec(conn, query);
                printf("Query Status: %s\n", PQresStatus(PQresultStatus(resQuery)));

            }
            else if (strcmp(PQgetvalue(res, i, OPERATION), "DELETE") == 0) {
                sprintf(query, "DELETE FROM clientes_em_memoria where id=%s);", PQgetvalue(res, i, ID_CLIENT));
                printf("%s\t", query);
                resQuery = PQexec(conn, query);
                printf("Query Status: %s\n", PQresStatus(PQresultStatus(resQuery)));

            }
        }
    }

    PQclear(res);

}