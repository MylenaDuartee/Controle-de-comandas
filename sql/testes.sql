-- -- cargo (sem FK, começa por ele)
-- SELECT inserir('cargo', ARRAY['nome','salario'], ARRAY['Gerente','5000.00']);

-- -- categoria
-- SELECT inserir('categoria', ARRAY['nome'], ARRAY['Bebidas']);

-- -- mesa
-- SELECT inserir('mesa', ARRAY['status','qtd_cadeira'], ARRAY['L','4']);

-- -- forma_pagamento
-- SELECT inserir('forma_pagamento', ARRAY['nome_fp','descricao'], ARRAY['Pix','Pagamento via chave Pix']);

-- -- funcionario (depende de cargo, cod_cargo=1)
-- SELECT inserir('funcionario', ARRAY['nome','dt_nasc','cod_cargo'], ARRAY['João Silva','1990-05-10','1']);

-- -- produto (depende de categoria, cod_cat=1)
-- SELECT inserir('produto', ARRAY['nome','valor_unit','cod_cat'], ARRAY['Coca-Cola','8.00','1']);

-- -- comanda (depende de mesa e funcionario)
-- SELECT inserir('comanda', ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'], ARRAY['0.00','A','10.00','1','1']);

-- -- item_comanda (depende de comanda e produto)
-- SELECT inserir('item_comanda', ARRAY['num_comanda','cod_prod','qtd','valor'], ARRAY['1','1','2','16.00']);

-- -- pagamento (depende de comanda e forma_pagamento)
-- SELECT inserir('pagamento', ARRAY['data','valor','num_comanda','cod_fp'], ARRAY['2025-06-14','16.00','1','1']);

-- -- atualiza salário do cargo 1
-- SELECT update_tabela('cargo', 'cod_cargo', 1, ARRAY['salario'], ARRAY['6000.00']);

-- -- atualiza status da comanda 1
-- SELECT update_tabela('comanda', 'num_comanda', 1, ARRAY['status','valor_total'], ARRAY['F','16.00']);

-- -- ADD: adiciona coluna telefone em funcionario
-- SELECT alterar_tabela('funcionario', 'ADD', 'telefone', 'VARCHAR(15)');

-- -- ALTER: muda o tipo dessa coluna
-- SELECT alterar_tabela('funcionario', 'ALTER', 'telefone', 'VARCHAR(20)');

-- -- DROP: remove a coluna
-- SELECT alterar_tabela('funcionario', 'DROP', 'telefone', NULL);

-- -- deleta o pagamento antes (por causa das FKs)
-- SELECT deletar_linha('pagamento', 'id', '1');

-- -- deleta item_comanda
-- SELECT deletar_linha('item_comanda', 'num_comanda', '1');

-- -- deleta comanda
-- SELECT deletar_linha('comanda', 'num_comanda', '1');

-- -- erros
-- -- tabela vazia
-- SELECT inserir('', ARRAY['nome'], ARRAY['Gerente']);

-- -- colunas e valores com tamanhos diferentes
-- SELECT inserir('cargo', ARRAY['nome','salario'], ARRAY['Gerente']);

-- -- tabela que não existe
-- SELECT inserir('clientes', ARRAY['nome'], ARRAY['João']);

-- -- coluna que não existe


-- -- update
-- -- tabela vazia
-- SELECT update_tabela('', 'cod_cargo', 1, ARRAY['salario'], ARRAY['6000.00']);

-- -- colunas e valores com tamanhos diferentes
-- SELECT update_tabela('cargo', 'cod_cargo', 1, ARRAY['nome','salario'], ARRAY['Gerente']);

-- -- tabela que não existe
-- SELECT update_tabela('clientes', 'cod_cargo', 1, ARRAY['salario'], ARRAY['6000.00']);

-- -- coluna que não existe
-- SELECT update_tabela('cargo', 'cod_cargo', 1, ARRAY['coluna_errada'], ARRAY['6000.00']);

-- --alterar
-- -- tabela que não existe
-- SELECT alterar_tabela('clientes', 'ADD', 'telefone', 'VARCHAR(15)');

-- -- operação inválida
-- SELECT alterar_tabela('funcionario', 'RENAME', 'telefone', 'VARCHAR(15)');

-- -- DROP em coluna referenciada por FK
-- -- (cod_cargo em funcionario referencia cargo)
-- SELECT alterar_tabela('cargo', 'DROP', 'cod_cargo', NULL);

-- -- delete
-- -- tabela vazia
-- SELECT deletar_linha('', 'id', '1');

-- -- tabela que não existe
-- SELECT deletar_linha('clientes', 'id', '1');

-- -- violação de FK (tenta deletar cargo que tem funcionario vinculado)
-- SELECT deletar_linha('cargo', 'cod_cargo', '1');


-- SELECT * FROM MESA;
-- SELECT inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['0.00','A','0.00','2','2']);
-- SELECT inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['0.00','A','0.00','3','2']);
-- SELECT * FROM COMANDA;

-- SELECT inserir('pagamento', ARRAY['data','valor','num_comanda','cod_fp'], ARRAY['2025-06-14','16.00','1','1']);
-- SELECT * FROM pagamento;


-- 1. Cargo
INSERT INTO cargo (nome, salario) VALUES ('Garçom', 2000.00);

-- 2. Funcionario
INSERT INTO funcionario (nome, dt_nasc, cod_cargo) VALUES ('João', '1990-01-01', 1);

-- 3. Mesa
INSERT INTO mesa (status, qtd_cadeira) VALUES ('L', 4);

-- 4. Categoria
INSERT INTO categoria (nome) VALUES ('Bebidas');

-- 5. Produto
INSERT INTO produto (nome, valor_unit, cod_cat) VALUES ('Coca-Cola', 8.00, 1);

-- 6. Forma de pagamento
INSERT INTO forma_pagamento (nome_fp, descricao) VALUES ('Cartão', 'Cartão de crédito/débito');

-- 7. Comanda (deve ocupar a mesa automaticamente)
INSERT INTO comanda (valor_total, status, taxa_serv, num_mesa, cod_func) VALUES (0, 'A', 10.00, 1, 1);

-- 8. Item comanda (deve calcular valor e atualizar valor_total da comanda)
INSERT INTO item_comanda (num_comanda, cod_prod, qtd, valor) VALUES (1, 1, 2, 0);

INSERT INTO produto (nome, valor_unit, cod_cat) VALUES ('Suco', 6.00, 1);

INSERT INTO item_comanda (num_comanda, cod_prod, qtd, valor) VALUES (1, 2, 3, 0);

SELECT * from comanda;
SELECT * from item_comanda;

-- Nova mesa (se não tiver disponível)
INSERT INTO mesa (status, qtd_cadeira) VALUES ('L', 4);

-- Nova comanda
INSERT INTO comanda (valor_total, status, taxa_serv, num_mesa, cod_func) VALUES (0, 'A', 5.00, 8, 1);
SELECT* from mesa
SELECT * from comanda;
SELECT * from item_comanda;
-- Itens
INSERT INTO item_comanda (num_comanda, cod_prod, qtd, valor) VALUES (14, 1, 2, 0);
INSERT INTO item_comanda (num_comanda, cod_prod, qtd, valor) VALUES (14, 3, 1, 0);