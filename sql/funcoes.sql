--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cadastrar_cargo(c_nome VARCHAR,c_salario NUMERIC)
RETURNS VOID AS $$
BEGIN
    IF EXISTS(SELECT * FROM cargo WHERE LOWER(nome) = LOWER(c_nome)) THEN
        RAISE EXCEPTION 'Já existe um cargo com o nome "%"',c_nome;
    END IF;

    PERFORM inserir('cargo',ARRAY['nome','salario'],ARRAY[c_nome,c_salario::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cadastrar_funcionario(f_nome VARCHAR,f_dt_nasc DATE,f_cod_cargo INT) -- verificar caso cargo não exista
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT * FROM cargo WHERE cod_cargo = f_cod_cargo) THEN
        RAISE EXCEPTION 'Não existe cargo com o código "%"',f_cod_cargo;
    END IF;

    PERFORM inserir('funcionario',ARRAY['nome','dt_nasc','cod_cargo'],ARRAY[f_nome,f_dt_nasc::TEXT,f_cod_cargo::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cadastrar_mesa(m_qtd_cadeira INT)
RETURNS VOID AS $$
BEGIN
    PERFORM inserir('mesa',ARRAY['status','qtd_cadeira'],ARRAY['L',m_qtd_cadeira::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cadastrar_categoria(cat_nome VARCHAR)
RETURNS VOID AS $$
BEGIN
    IF EXISTS(SELECT * FROM categoria WHERE LOWER(nome) = LOWER(cat_nome)) THEN
        RAISE EXCEPTION 'Já existe categoria com o nome "%"',cat_nome;
    END IF;

    PERFORM inserir('categoria',ARRAY['nome'],ARRAY[cat_nome]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cadastrar_produto(p_nome VARCHAR,p_valor_unit NUMERIC,p_cod_cat INT)
RETURNS VOID AS $$
BEGIN 
    IF NOT EXISTS(SELECT * FROM categoria WHERE cod_cat = p_cod_cat) THEN
        RAISE EXCEPTION 'A categoria com código "%" não existe',p_cod_cat;
    END IF;

    PERFORM inserir('produto',ARRAY['nome','valor_unit','cod_cat'],ARRAY[p_nome,p_valor_unit::TEXT,p_cod_cat::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cadastrar_forma_pagamento(fp_nome VARCHAR,fp_descricao VARCHAR)
RETURNS VOID AS $$
BEGIN
    IF EXISTS(SELECT * FROM forma_pagamento WHERE LOWER(nome_fp) = LOWER(fp_nome)) THEN
        RAISE EXCEPTION 'Já existe forma de pagamento com o nome de "%"',fp_nome;
    END IF;

    PERFORM inserir('forma_pagamento',ARRAY['nome_fp','descricao'],ARRAY[fp_nome,fp_descricao]);
END;
$$ LANGUAGE 'plpgsql';
--------------------------------------------------------------------------