CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_criacao TIMESTAMP DEFAULT NOW()
);

CREATE TABLE log_transacoes (
    id SERIAL PRIMARY KEY,
    operacao VARCHAR(10) NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE'
    tabela VARCHAR(50) NOT NULL,   -- 'clientes'
    id_cliente INTEGER,            -- ID do cliente afetado
    dados_antigos JSONB,           -- Dados antes da operação (para UPDATE/DELETE)
    dados_novos JSONB,             -- Dados após a operação (para INSERT/UPDATE)
    transacao_id BIGINT,           -- ID da transação (txid_current())
    timestamp TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'pending' -- 'pending', 'committed', 'rolledback'
);
