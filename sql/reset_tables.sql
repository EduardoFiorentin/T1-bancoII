

delete from log;
delete from clientes_em_memoria;
drop table clientes_em_memoria;
drop table log;

CREATE UNLOGGED TABLE clientes_em_memoria (
  id SERIAL PRIMARY KEY,
  nome TEXT,
  saldo NUMERIC
);
CREATE TABLE log (operacao TEXT, id_cliente INT, nome TEXT, saldo NUMERIC);
