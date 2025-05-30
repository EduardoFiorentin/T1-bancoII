begin;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 1', 100.00);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 1;
update log set status='committed' where transacao_id=:txid;
END;

BEGIN;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 2', 200.00);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
update log set status='committed' where transacao_id=:txid;
END;

BEGIN;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 3', 300.00);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
ROLLBACK;
-- Como o rollback eliminaria os registros do log também, deve ser inserido manualmente
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('INSERT', 3, 'Cliente 3', 300.00, :txid);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('UPDATE', 2, 'Cliente 2', 300.00, :txid);
update log set status='rollback' where transacao_id=:txid;

BEGIN;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 4', 400.00);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 3;
update log set status='committed' where transacao_id=:txid;
END;


-- Inicial 
--  id |   nome    | saldo  
-- ----+-----------+--------
--   1 | Cliente 1 | 150.00
--   2 | Cliente 2 | 250.00
--   4 | Cliente 4 | 400.00

-- Após o redo 
--  id |   nome    | saldo  
-- ----+-----------+--------
--   1 | Cliente 1 | 150.00
--   2 | Cliente 2 | 250.00
--   4 | Cliente 4 | 400.00

