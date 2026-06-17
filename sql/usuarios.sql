CREATE ROLE gerente;
CREATE ROLE garcom;

CREATE USER user_gerente WITH PASSWORD 'gerente123';
CREATE USER user_garcom WITH PASSWORD 'garcom123';

GRANT gerente TO user_gerente;
GRANT garcom TO user_garcom;

GRANT CONNECT ON DATABASE COMANDAS TO gerente, garcom;

GRANT USAGE ON SCHEMA public TO gerente, garcom;

REVOKE ALL ON SCHEMA public FROM PUBLIC;

GRANT EXECUTE ON FUNCTION fn_abrir_comanda(INT) TO garcom;
GRANT EXECUTE ON FUNCTION fn_adicionar_item(INT, INT, INT) TO garcom;
GRANT EXECUTE ON FUNCTION fn_remover_item(INT, INT) TO garcom;
GRANT EXECUTE ON FUNCTION fn_atualizar_quantidade_item(INT, INT, INT) TO garcom;
GRANT EXECUTE ON FUNCTION fn_realizar_pagamento(INT, INT, NUMERIC) TO garcom;

GRANT SELECT ON vw_comandas_abertas TO garcom;
GRANT SELECT ON vw_itens_comanda TO garcom;

GRANT grupo_garcom TO gerente;

GRANT EXECUTE ON FUNCTION fn_cadastrar_cargo(VARCHAR, NUMERIC) TO gerente;
GRANT EXECUTE ON FUNCTION fn_cadastrar_funcionario(VARCHAR, DATE, INT, VARCHAR) TO gerente;
GRANT EXECUTE ON FUNCTION fn_cadastrar_mesa(INT) TO gerente;
GRANT EXECUTE ON FUNCTION fn_cadastrar_categoria(VARCHAR) TO gerente;
GRANT EXECUTE ON FUNCTION fn_cadastrar_produto(VARCHAR, NUMERIC, INT) TO gerente;
GRANT EXECUTE ON FUNCTION fn_cadastrar_forma_pagamento(VARCHAR, VARCHAR) TO gerente;
GRANT EXECUTE ON FUNCTION fn_atualizar_produto(INT, VARCHAR, NUMERIC) TO gerente;
GRANT EXECUTE ON FUNCTION fn_atualizar_cargo(INT, VARCHAR, NUMERIC) TO gerente;
GRANT EXECUTE ON FUNCTION fn_cancelar_comanda(INT) TO gerente;
GRANT EXECUTE ON FUNCTION fn_transferir_comanda_mesa(INT, INT) TO gerente;

GRANT EXECUTE ON FUNCTION fn_remover_produto(INT) TO gerente;
GRANT EXECUTE ON FUNCTION fn_remover_cargo(INT) TO gerente;
GRANT EXECUTE ON FUNCTION fn_remover_forma_pagamento(INT) TO gerente;

GRANT EXECUTE ON FUNCTION inserir(VARCHAR, VARCHAR[], VARCHAR[]) TO gerente;
GRANT EXECUTE ON FUNCTION update_tabela(VARCHAR, VARCHAR, INT, VARCHAR[], VARCHAR[]) TO gerente;
GRANT EXECUTE ON FUNCTION alterar_tabela(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO gerente;
GRANT EXECUTE ON FUNCTION deletar_linha(VARCHAR, VARCHAR[], VARCHAR[]) TO gerente;

GRANT SELECT ON vw_relatorio_vendas_mensal TO gerente;
GRANT SELECT ON vw_relatorio_desempenho_garcom TO gerente;
GRANT SELECT ON vw_relatorio_produtos_mais_vendidos TO gerente;
GRANT SELECT ON vw_ticket_medio_mesa TO gerente;
