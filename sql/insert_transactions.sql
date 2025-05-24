
--Transação 1
BEGIN;
SELECT txid_current() AS txid \gset

-- Insere Cliente 1
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 1', 100.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Cliente 1', 100.00, :txid);

-- Atualiza saldo do Cliente 1
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 1;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 1;

-- Marca transação como committed
UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
COMMIT;


-- Transação 2
BEGIN;
SELECT txid_current() AS txid \gset

-- Insere Cliente 2
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 2', 200.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Cliente 2', 200.00, :txid);

-- Atualiza saldo do Cliente 2
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 2;

-- Marca transação como committed
UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
COMMIT;


-- Transação 3
BEGIN;
SELECT txid_current() AS txid \gset

-- Insere Cliente 3
INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 3', 300.00);
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Cliente 3', 300.00, :txid);

-- Atualiza saldo do Cliente 2 
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, saldo, :txid FROM clientes_em_memoria WHERE id = 2;

-- Marca transação como committed
UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
COMMIT;

-- -- Transação 4
BEGIN;
    SELECT txid_current() AS txid \gset

    -- Insere Cliente 3
    INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 5', 300.00);

    -- Atualiza saldo do Cliente 2
    UPDATE clientes_em_memoria SET saldo = 1500 WHERE id = 2;
    -- Marca transação como committed
-- UPDATE log SET status = 'committed' WHERE transacao_id = :txid;
ROLLBACK; 

INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id) 
VALUES ('INSERT', currval('clientes_em_memoria_id_seq'), 'Cliente 5', 300.00, :txid);


INSERT INTO log (operacao, id_cliente, nome, saldo, transacao_id)
SELECT 'UPDATE', id, nome, 1500, :txid FROM clientes_em_memoria WHERE id = 2;
