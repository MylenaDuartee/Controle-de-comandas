CREATE DATABASE COMANDAS;
DROP DATABASE COMANDAS;

CREATE TABLE cargo (
    cod_cargo SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    salario NUMERIC(10,2) NOT NULL
);

CREATE TABLE funcionario (
    cod_func SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    dt_nasc DATE NOT NULL,
    usuario VARCHAR(50),
    cod_cargo INT NOT NULL REFERENCES cargo(cod_cargo)
);

CREATE TABLE mesa (
    num_mesa SERIAL PRIMARY KEY,
    status CHAR(1) CHECK(status  IN ('O', 'L', 'R')) NOT NULL,
    qtd_cadeira INT NOT NULL
);

CREATE TABLE categoria (
    cod_cat SERIAL PRIMARY KEY,
    nome VARCHAR(20) NOT NULL
);

CREATE TABLE produto (
    cod_prod SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    valor_unit NUMERIC(10,2) NOT NULL,
    cod_cat INT NOT NULL REFERENCES categoria(cod_cat)
);

CREATE TABLE forma_pagamento (
    cod_fp SERIAL PRIMARY KEY,
    nome_fp VARCHAR(20) NOT NULL,
    descricao VARCHAR(60) NOT NULL
);

CREATE TABLE comanda (
    num_comanda SERIAL PRIMARY KEY,
    valor_total NUMERIC(10,2) NOT NULL,
    status CHAR(1) CHECK(status IN ('A', 'F')) NOT NULL, 
    taxa_serv NUMERIC(5,2) NOT NULL,
    num_mesa INT NOT NULL REFERENCES mesa(num_mesa),
    cod_func INT NOT NULL REFERENCES funcionario(cod_func)
);

CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    num_comanda INT NOT NULL REFERENCES comanda(num_comanda),
    cod_fp INT NOT NULL REFERENCES forma_pagamento(cod_fp)
);

CREATE TABLE item_comanda (
    num_comanda INT NOT NULL REFERENCES comanda(num_comanda),
    cod_prod INT NOT NULL REFERENCES produto(cod_prod),
    qtd INT NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (num_comanda, cod_prod) 
);

-- CADASTRAR CARGOS
SELECT fn_cadastrar_cargo('Gerente', 4500.00);
SELECT fn_cadastrar_cargo('Garçom', 2100.00);

-- CADASTRAR FUNCIONÁRIOS
SELECT fn_cadastrar_funcionario('Funcionario Gerente', '1995-05-19', 1, 'user_gerente');
SELECT fn_cadastrar_funcionario('Funcionario Garçom', '1998-08-10', 2, 'user_garcom');

-- CADASTRAR MESAS
SELECT fn_cadastrar_mesa(4); -- Mesa 1
SELECT fn_cadastrar_mesa(2); -- Mesa 2
SELECT fn_cadastrar_mesa(6); -- Mesa 3
SELECT fn_cadastrar_mesa(4); -- Mesa 4

-- CADASTRAR CATEGORIAS
SELECT fn_cadastrar_categoria('Bebidas');
SELECT fn_cadastrar_categoria('Comidas');

-- CADASTRAR PRODUTOS
SELECT fn_cadastrar_produto('Refrigerante', 6.00, 1);
SELECT fn_cadastrar_produto('Cerveja', 10.00, 1);
SELECT fn_cadastrar_produto('Hambúrguer', 25.00, 2);
SELECT fn_cadastrar_produto('Batata Frita', 18.00, 2);

-- CADASTRAR FORMAS DE PAGAMENTO
SELECT fn_cadastrar_forma_pagamento('Dinheiro', 'Pagamento em espécie');
SELECT fn_cadastrar_forma_pagamento('Cartão de Crédito', 'Visa, Mastercard, Elo');
SELECT fn_cadastrar_forma_pagamento('Pix', 'Transferência instantânea');