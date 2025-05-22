#include "database.h"

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
    
}