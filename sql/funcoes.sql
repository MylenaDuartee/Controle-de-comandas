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
CREATE OR REPLACE FUNCTION fn_abrir_comanda(ac_num_mesa INT,ac_cod_func INT)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT * FROM mesa WHERE num_mesa = ac_num_mesa) THEN
        RAISE EXCEPTION 'A mesa de número "%" não existe',ac_num_mesa;
    ELSIF NOT EXISTS(SELECT * FROM funcionario WHERE cod_func = ac_cod_func) THEN
        RAISE EXCEPTION 'O funcionário de código "%" não existe',ac_cod_func;
    END IF;

    PERFORM inserir('comanda',ARRAY['valor_total','status','taxa_serv','num_mesa','cod_func'],ARRAY['0','A','10.00',ac_num_mesa::TEXT,ac_cod_func::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_adicionar_item(ai_num_comanda INT,ai_cod_prod INT, ai_qtd INT)
RETURNS VOID AS $$
 DECLARE
     st CHAR(1);
BEGIN
    SELECT status INTO st FROM comanda WHERE num_comanda = ai_num_comanda;

    IF NOT EXISTS(SELECT * FROM comanda WHERE num_comanda = ai_num_comanda) THEN
        RAISE EXCEPTION 'A comanda com número "%" não existe',ai_num_comanda;
    ELSIF st = 'F' THEN
        RAISE EXCEPTION 'A comanda informada já está com status fechado';
    ELSIF NOT EXISTS(SELECT * FROM produto WHERE cod_prod = ai_cod_prod) THEN
        RAISE EXCEPTION 'Não existe produto com código "%"',ai_cod_prod;
    END IF;

    PERFORM inserir('item_comanda', ARRAY['num_comanda','cod_prod','qtd','valor'],ARRAY[ai_num_comanda::TEXT, ai_cod_prod::TEXT, ai_qtd::TEXT, '0']);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_remover_item(ri_num_comanda INT, ri_cod_prod INT)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM comanda WHERE num_comanda = ri_num_comanda) THEN
        RAISE EXCEPTION 'A comanda com número "%" não existe', ri_num_comanda;
    END IF;

    IF NOT EXISTS(SELECT 1 FROM item_comanda WHERE num_comanda = ri_num_comanda AND cod_prod = ri_cod_prod) THEN
        RAISE EXCEPTION 'O item com código "%" não existe na comanda "%"', ri_cod_prod, ri_num_comanda;
    END IF;

    PERFORM deletar_linha('item_comanda',
        ARRAY['num_comanda','cod_prod'],
        ARRAY[ri_num_comanda::TEXT, ri_cod_prod::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_realizar_pagamento(
    rp_num_comanda INT,
    rp_cod_fp INT,
    rp_valor NUMERIC(10,2)
)
RETURNS VOID AS $$
DECLARE
    v_status CHAR(1);
BEGIN
    IF NOT EXISTS(SELECT 1 FROM comanda WHERE num_comanda = rp_num_comanda) THEN
        RAISE EXCEPTION 'A comanda com número "%" não existe', rp_num_comanda;
    END IF;

    IF NOT EXISTS(SELECT 1 FROM forma_pagamento WHERE cod_fp = rp_cod_fp) THEN
        RAISE EXCEPTION 'A forma de pagamento com código "%" não existe', rp_cod_fp;
    END IF;

    SELECT status INTO v_status FROM comanda WHERE num_comanda = rp_num_comanda;

    IF v_status = 'F' THEN
        RAISE EXCEPTION 'A comanda "%" já está fechada', rp_num_comanda;
    END IF;

    PERFORM inserir('pagamento',
        ARRAY['data','valor','num_comanda','cod_fp'],
        ARRAY[CURRENT_DATE::TEXT, rp_valor::TEXT, rp_num_comanda::TEXT, rp_cod_fp::TEXT]);

    RAISE NOTICE 'Pagamento registrado com sucesso na comanda %!', rp_num_comanda;
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_atualizar_produto(ap_cod_prod INT, ap_nome VARCHAR, ap_valor_unit NUMERIC)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM produto WHERE cod_prod = ap_cod_prod) THEN
        RAISE EXCEPTION 'Produto com código "%" não existe', ap_cod_prod;
    END IF;

    PERFORM update_tabela('produto', 'cod_prod', ap_cod_prod,
        ARRAY['nome','valor_unit'],
        ARRAY[ap_nome, ap_valor_unit::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_atualizar_cargo(ac_cod_cargo INT, ac_nome VARCHAR, ac_salario NUMERIC)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM cargo WHERE cod_cargo = ac_cod_cargo) THEN
        RAISE EXCEPTION 'Cargo com código "%" não existe', ac_cod_cargo;
    END IF;

    PERFORM update_tabela('cargo', 'cod_cargo', ac_cod_cargo,
        ARRAY['nome','salario'],
        ARRAY[ac_nome, ac_salario::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_atualizar_quantidade_item(aqi_num_comanda INT, aqi_cod_prod INT, aqi_qtd INT)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM item_comanda WHERE num_comanda = aqi_num_comanda AND cod_prod = aqi_cod_prod) THEN
        RAISE EXCEPTION 'Item com código "%" não existe na comanda "%"', aqi_cod_prod, aqi_num_comanda;
    END IF;

    UPDATE item_comanda SET qtd = aqi_qtd
    WHERE num_comanda = aqi_num_comanda AND cod_prod = aqi_cod_prod;
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_remover_produto(rp_cod_prod INT)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM produto WHERE cod_prod = rp_cod_prod) THEN
        RAISE EXCEPTION 'Produto com código "%" não existe', rp_cod_prod;
    END IF;

    PERFORM deletar_linha('produto', ARRAY['cod_prod'], ARRAY[rp_cod_prod::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_remover_cargo(rc_cod_cargo INT)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM cargo WHERE cod_cargo = rc_cod_cargo) THEN
        RAISE EXCEPTION 'Cargo com código "%" não existe', rc_cod_cargo;
    END IF;

    PERFORM deletar_linha('cargo', ARRAY['cod_cargo'], ARRAY[rc_cod_cargo::TEXT]);
END;
$$ LANGUAGE 'plpgsql';

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_remover_forma_pagamento(rfp_cod_fp INT)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM forma_pagamento WHERE cod_fp = rfp_cod_fp) THEN
        RAISE EXCEPTION 'Forma de pagamento com código "%" não existe', rfp_cod_fp;
    END IF;

    PERFORM deletar_linha('forma_pagamento', ARRAY['cod_fp'], ARRAY[rfp_cod_fp::TEXT]);
END;
$$ LANGUAGE 'plpgsql';