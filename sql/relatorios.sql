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