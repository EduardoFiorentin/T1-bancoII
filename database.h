#ifndef DATABASE 
#define DATABASE

#include <libpq-fe.h> 
#include <stdlib.h>

#define DATABASE_ARGUMENTS "password=admin user=postgres dbname=dojo"

PGconn      *start_connection();
void        make_redo(PGconn *conn); 

#endif // DATABASE
