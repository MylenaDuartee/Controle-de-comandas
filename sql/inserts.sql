
--> tabela cargo
SELECT inserir('cargo',ARRAY['nome','salario'],ARRAY['Gerente','4500.00']);
SELECT inserir('cargo',ARRAY['nome','salario'],ARRAY['Garçom','1600.00']);
SELECT inserir('cargo',ARRAY['nome','salario'],ARRAY['Pizzaiolo','2800.00']);
SELECT inserir('cargo',ARRAY['nome','salario'],ARRAY['Chapeiro','2000.00']);
SELECT inserir('cargo',ARRAY['nome','salario'],ARRAY['Recepcionista','1750.00']);

SELECT * FROM CARGO;

--> tabela mesa
SELECT inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['L','4']);
SELECT inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['L','2']);
SELECT inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['O','4']);
SELECT inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['O','6']);
SELECT inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['R','4']);
SELECT inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['L','8']);

SELECT * FROM MESA;

--> tabela categoria
SELECT inserir('categoria',ARRAY['nome'],ARRAY['Pizzas']);
SELECT inserir('categoria',ARRAY['nome'],ARRAY['Bebidas']);
SELECT inserir('categoria',ARRAY['nome'],ARRAY['Hambúrgueres']);
SELECT inserir('categoria',ARRAY['nome'],ARRAY['Sobremesas']);
SELECT inserir('categoria',ARRAY['nome'],ARRAY['Petiscos']);

SELECT * FROM categoria;

--> tabela forma de pagamento
SELECT inserir('forma_pagamento',ARRAY['nome_fp','descricao'],ARRAY['Dinheiro','Pagamento em espécie']);
SELECT inserir('forma_pagamento',ARRAY['nome_fp','descricao'],ARRAY['Cartão de Crédito','Visa, Master,Elo,etc.']);
SELECT inserir('forma_pagamento',ARRAY['nome_fp','descricao'],ARRAY['Cartão de Débito','Pagamento à vista no cartão']);
SELECT inserir('forma_pagamento',ARRAY['nome_fp','descricao'],ARRAY['Pix','Transferência instantânea via QR Code']);

SELECT * FROM forma_pagamento;

--> tabela funcionario
SELECT inserir('funcionario',ARRAY['nome','dt_nasc','cod_cargo'],ARRAY['Carlos Augusto Santos', '1988-05-14', '1']);
SELECT inserir('funcionario',ARRAY['nome','dt_nasc','cod_cargo'],ARRAY['Mariana Lima Costa', '1995-09-22', '2']);
SELECT inserir('funcionario',ARRAY['nome','dt_nasc','cod_cargo'],ARRAY['João Pedro Sousa', '1992-02-10', '2']);
SELECT inserir('funcionario',ARRAY['nome','dt_nasc','cod_cargo'],ARRAY['Francisco Alves', '1985-11-30', '3']);
SELECT inserir('funcionario',ARRAY['nome','dt_nasc','cod_cargo'],ARRAY['Ana Beatriz Rocha', '2000-07-04', '5']);

SELECT * FROM funcionario;

--> tabela produto
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Pizza Calabresa Grande', '45.00', '1']);
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Pizza Quatro Queijos Grande', '52.00', '1']);
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Refrigerante Lata 350ml', '6.00', '2']);
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Suco Natural de Laranja', '8.50', '2']);
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Burger Artesanal Duplo', '28.90', '3']);
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Batata Frita com Queijo', '22.00', '5']);
SELECT inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY['Pudim de Leite Condensado', '12.00', '4']);

SELECT * FROM PRODUTO;

--> tabela comanda
SELECT inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['102.30','F','9.30','1','2']);
SELECT inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['0.00','A','0.00','3','2']);
SELECT inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['34.90','F','0.00','2','3']);
SELECT inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['0.00','A','0.00','4','3']);

SELECT * FROM COMANDA;
DROP TABLE COMANDA;

--> tabela item comanda
SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['1','1','1','45.00']);
SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['1','5','1','28.00']);
SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['1','3','3','18.00']);

SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['2','2','1','52.00']);
SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['2','4','2','17.00']);

SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['3','5','1','28.00']);
SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['3','3','1','6.00']);

SELECT inserir('item_comanda',ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY['4','6','1','22.00']);

SELECT * FROM item_comanda;

--> tabela pagamento
SELECT inserir('pagamento',ARRAY['data','valor','num_comanda','cod_fp'],ARRAY['2026-06-03', '102.30', '1', '4']);
SELECT inserir('pagamento',ARRAY['data','valor','num_comanda','cod_fp'],ARRAY['2026-06-03', '34.90', '3', '2']);

SELECT * FROM Pagamento;