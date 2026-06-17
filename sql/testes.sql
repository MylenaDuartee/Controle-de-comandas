-- Conectar como 'user_garcom'
-- Abre a comanda na Mesa 1
SELECT fn_abrir_comanda(1); 

-- Consulta se a mesa mudou para Ocupada ('O') e se a comanda foi criada
SELECT * FROM vw_comandas_abertas;

-- Adiciona itens à comanda 1
SELECT fn_adicionar_item(1, 3, 2); -- 2 Hambúrgueres (2x 25 = 50)
SELECT fn_adicionar_item(1, 1, 3); -- 3 Refrigerantes (3x 6 = 18)

-- Consulta os itens e o valor atualizado na view (Total em itens: 68 + 10% = 74.80)
SELECT * FROM vw_itens_comanda WHERE num_comanda = 1;
SELECT * FROM vw_comandas_abertas WHERE num_comanda = 1;

-- Realiza o pagamento total (74.80) via Pix (ID 3).
SELECT fn_realizar_pagamento(1, 3, 74.80);

-- A comanda deve sumir de ABERTAS
SELECT * FROM vw_comandas_abertas WHERE num_comanda = 1;

-- View ticket médio (Deve aparecer a mesa 1)
SELECT * FROM vw_ticket_medio_mesa;


-- Tentar abrir comanda em mesa que já está ocupada (Mesa 1 ainda estará ocupada se não rodar o trigger de pagamento)
SELECT fn_abrir_comanda(1); 
-- Erro: "A mesa está indisponível"

-- Tentar adicionar item em uma comanda fechada/inexistente
SELECT fn_adicionar_item(999, 1, 1);
-- Erro: "A comanda com número "999" não existe"

-- Tentar pagar um valor maior do que o total da comanda
-- Vamos abrir a comanda 2 na Mesa 2
SELECT fn_abrir_comanda(2);
SELECT fn_adicionar_item(2, 2, 1); -- 1 Cerveja (10 + 10% = 11.00)

SELECT fn_realizar_pagamento(2, 1, 50.00);
-- Erro: "Valor pago (50.00) ultrapassa o total da comanda (11.00)"