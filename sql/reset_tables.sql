
drop trigger tg_insert_log on clientes_em_memoria;
drop function insert_log;
delete from log;
delete from clientes_em_memoria;
drop table clientes_em_memoria;
drop table log;

CREATE UNLOGGED TABLE clientes_em_memoria (
  id SERIAL PRIMARY KEY,
  nome TEXT,
  saldo NUMERIC
);
CREATE TABLE log (
  operacao TEXT, 
  id_cliente INT, 
  nome TEXT, 
  saldo NUMERIC,
  transacao_id BIGINT,
  status VARCHAR(20) DEFAULT 'pending'
);
 
create or replace function insert_log()
returns trigger as $$
  declare 
  begin

    IF (TG_OP = 'DELETE') THEN
      INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('DELETE', NEW.id, NEW.nome, NEW.saldo, txid_current());
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('UPDATE', NEW.id, NEW.nome, NEW.saldo, txid_current());
      RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
      INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('INSERT', NEW.id, NEW.nome, NEW.saldo, txid_current());
      RETURN NEW;
    END IF;


  end;
$$ language plpgsql;
create trigger tg_insert_log
before insert or update or delete on clientes_em_memoria
for each row execute procedure insert_log();



-- ANTES


-- DEPOIS 