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


