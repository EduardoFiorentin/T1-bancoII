
BEGIN;
SELECT txid_current() AS txid \gset

INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Ana Souza', 500.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Ana Souza', 500.00, :txid);

UPDATE clientes_em_memoria SET saldo = saldo + 150 WHERE id = 1;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 1;

COMMIT;

UPDATE log SET status = 'committed' WHERE transacao_id = :txid;

BEGIN;
SELECT txid_current() AS txid \gset

INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Carlos Pereira', 1200.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Carlos Pereira', 1200.00, :txid);

UPDATE clientes_em_memoria SET saldo = saldo + 300 WHERE id = 2;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 2;

UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
COMMIT;


BEGIN;
SELECT txid_current() AS txid \gset

INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Maria Oliveira', 800.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Maria Oliveira', 800.00, :txid);

UPDATE clientes_em_memoria SET saldo = saldo + 400 WHERE id = 3;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 3;

UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
COMMIT;


BEGIN;
SELECT txid_current() AS txid \gset

INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Lucas Silva', 250.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Lucas Silva', 250.00, :txid);

UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 2;


ROLLBACK; 

-- Inserts fora do rollback para não sofrerem rollback
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Lucas Silva', 250.00, :txid);

INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 2;


BEGIN;
SELECT txid_current() AS txid \gset

INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Fernanda Costa', 400.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Fernanda Costa', 400.00, :txid);

UPDATE clientes_em_memoria SET saldo = saldo + 500 WHERE id = 5;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 5;

UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
COMMIT;


-- DELETE 
BEGIN;
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Teste delete 1', 400.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Teste delete 1', 400.00, :txid);


INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Teste delete 2', 400.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Teste delete 2', 400.00, :txid);


DELETE FROM clientes_em_memoria WHERE nome='Teste delete 1';
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('DELETE', 6, 'Teste delete 1', 400.00, :txid);

UPDATE log set status = 'committed' where nome like '%Teste delet%';
END;

