-- Chama operações para recriar as tabelas e inserir os registros

\i ./reset_tables.sql;
\i ./exemplo_trabalho.sql;

select * from clientes_em_memoria;
select * from log;