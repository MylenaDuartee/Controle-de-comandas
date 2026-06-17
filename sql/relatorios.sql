--------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_relatorio_vendas_mensal AS
SELECT 
    EXTRACT(YEAR FROM p.data) AS ano,
    EXTRACT(MONTH FROM p.data) AS mes,
    SUM(p.valor) AS faturamento_total,
    COUNT(DISTINCT p.num_comanda) AS total_comandas_pagas
FROM pagamento p
GROUP BY EXTRACT(YEAR FROM p.data), EXTRACT(MONTH FROM p.data)
ORDER BY ano DESC, mes DESC;

--------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_relatorio_desempenho_garcom AS
SELECT 
    f.cod_func,
    f.nome AS nome_garcom,
    COUNT(c.num_comanda) AS comandas_atendidas,
    COALESCE(SUM(c.valor_total - c.taxa_serv), 0) AS total_vendido_em_itens
FROM funcionario f
LEFT JOIN comanda c ON f.cod_func = c.cod_func AND c.status = 'F'
GROUP BY f.cod_func, f.nome
ORDER BY total_vendido_em_itens DESC;

--------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_relatorio_produtos_mais_vendidos AS
SELECT 
    prod.nome AS nome_produto,
    cat.nome AS categoria,
    SUM(item.qtd) AS quantidade_total_vendida,
    SUM(item.valor) AS faturamento_total
FROM item_comanda item
JOIN produto prod ON item.cod_prod = prod.cod_prod
JOIN categoria cat ON prod.cod_cat = cat.cod_cat
GROUP BY prod.nome, cat.nome
ORDER BY quantidade_total_vendida DESC;

--------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_comandas_abertas AS
SELECT 
    c.num_comanda,
    m.num_mesa,
    f.nome AS garcom,
    c.valor_total,
    c.taxa_serv
FROM comanda c
JOIN mesa m ON c.num_mesa = m.num_mesa
JOIN funcionario f ON c.cod_func = f.cod_func
WHERE c.status = 'A'
ORDER BY c.num_comanda;

--------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_itens_comanda AS
SELECT 
    ic.num_comanda,
    p.nome AS produto,
    ic.qtd,
    ic.valor
FROM item_comanda ic
JOIN produto p ON ic.cod_prod = p.cod_prod
JOIN comanda c ON ic.num_comanda = c.num_comanda
WHERE c.status = 'A'
ORDER BY ic.num_comanda;

--------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ticket_medio_mesa AS
SELECT
    m.num_mesa,
    COUNT(c.num_comanda) AS total_comandas,
    ROUND(AVG(c.valor_total), 2) AS ticket_medio
FROM comanda c
JOIN mesa m ON c.num_mesa = m.num_mesa
WHERE c.status = 'F'
GROUP BY m.num_mesa
ORDER BY ticket_medio DESC;