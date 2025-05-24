#ifndef DATABASE 
#define DATABASE

#include <libpq-fe.h> 
#include <stdlib.h>

#define DATABASE_ARGUMENTS "password=admin user=postgres dbname=t1bd2"

#define OPERATION           0
#define ID_CLIENT           1
#define NAME                2
#define BALANCE             3
#define TRANSACTION_ID      4
#define STATUS              5

PGconn      *start_connection();
void        make_redo(PGconn *conn); 

#endif // DATABASE
