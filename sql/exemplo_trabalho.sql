begin;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 1', 100.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('INSERT', 1, 'Cliente 1', 100.00, :txid);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 1;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('UPDATE', 1, 'Cliente 1', 150.00, :txid);
update log set status='committed' where transacao_id=:txid;
END;

BEGIN;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 2', 200.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('INSERT', 2, 'Cliente 2', 200.00, :txid);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('UPDATE', 2, 'Cliente 2', 250.00, :txid);
update log set status='committed' where transacao_id=:txid;
END;

BEGIN;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 3', 300.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('INSERT', 3, 'Cliente 3', 300.00, :txid);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('UPDATE', 2, 'Cliente 2', 300.00, :txid);
update log set status='committed' where transacao_id=:txid;
END;

BEGIN;
SELECT txid_current() AS txid \gset
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 4', 400.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('INSERT', 4, 'Cliente 4', 400.00, :txid);
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 3;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) VALUES ('UPDATE', 3, 'Cliente 3', 350.00, :txid);
-- SELECT * FROM clientes_em_memoria;
update log set status='committed' where transacao_id=:txid;
END;


-- Todas as transações commitaram - 

--  id |   nome    | saldo  
-- ----+-----------+--------
--   1 | Cliente 1 | 150.00
--   2 | Cliente 2 | 300.00
--   4 | Cliente 4 | 400.00
--   3 | Cliente 3 | 350.00
