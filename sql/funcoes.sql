

------ Função de inserir ------
CREATE OR REPLACE FUNCTION inserir(nm_tabela VARCHAR, nm_colunas VARCHAR[], nm_valores VARCHAR[])
RETURNS VOID AS $$
DECLARE 
    tabela VARCHAR;
    text_sql TEXT;
BEGIN

    tabela :=  LOWER(TRIM(nm_tabela));

    IF tabela IS NULL OR tabela = '' THEN
        RAISE EXCEPTION 'O nome da tabela não pode estar vazio!';
    END IF;

    IF ARRAY_LENGTH(nm_colunas,1) <> ARRAY_LENGTH(nm_valores,1) THEN
        RAISE EXCEPTION 'A quantidade de colunas não bate com a de valores';
    END IF;

    IF tabela NOT IN ('cargo','funcionario','mesa','categoria','produto','fm_pagamento','comanda','pagamento','item_comanda') THEN
        RAISE EXCEPTION 'A tabela "%" não existe',tabela;
    END IF;

    text_sql:= FORMAT('INSERT INTO %I (%s) VALUES (%s)', tabela, array_to_string(nm_colunas,', '), '''' || array_to_string(nm_valores, ''', ''') || '''');

    EXECUTE text_sql;

    RAISE NOTICE 'Inserção feita com sucesso!';

EXCEPTION
    WHEN undefined_column THEN
        RAISE EXCEPTION 'A coluna "%" não existe na tabela "%"', nm_colunas,tabela;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro: %', SQLERRM;
END;
$$ LANGUAGE 'plpgsql';


------ Função de update ------
CREATE OR REPLACE FUNCTION update_tabela(nm_tabela VARCHAR,nm_pk VARCHAR, vl_pk INT, nm_colunas VARCHAR[],vl_colunas VARCHAR[])
RETURNS VOID AS $$
DECLARE
    tabela VARCHAR;
    text_sql TEXT;
    i INT;
    set_sql TEXT:= '';
    pk VARCHAR;
BEGIN
    tabela:= LOWER(TRIM(nm_tabela));
    pk:= LOWER(TRIM(nm_pk)); -- rever o bagui da chave primaria não existir nessa tabela especifica

    IF tabela IS NULL OR tabela = '' THEN
        RAISE EXCEPTION 'O nome da tabela não pode ser vazio';
    END IF;

    IF ARRAY_LENGTH(nm_colunas,1) <> ARRAY_LENGTH(vl_colunas,1) THEN
        RAISE EXCEPTION 'A quantidade de colunas não bate com a de valores';
    END IF;
    
    IF tabela NOT IN ('cargo','funcionario','mesa','categoria','produto','fm_pagamento','comanda','pagamento','item_comanda') THEN
        RAISE EXCEPTION 'A tabela "%" não existe', tabela;
    END IF;

    FOR i IN 1..ARRAY_LENGTH(nm_colunas,1) LOOP
        set_sql:= set_sql || nm_colunas[i] || ' = ''' || vl_colunas[i]|| '''';
        IF i < ARRAY_LENGTH(nm_colunas,1) THEN
            set_sql:= set_sql || ', ';
        END IF;
    END LOOP;

    text_sql:= FORMAT('UPDATE %I SET %s WHERE %I = %s',tabela,set_sql, pk, vl_pk);
    EXECUTE text_sql;

    RAISE NOTICE 'Update feito com sucesso!';

    EXCEPTION
    WHEN undefined_column THEN
        RAISE EXCEPTION 'Uma das colunas não existem na tabela "%"',tabela;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro: %', SQLERRM;
END;
$$ LANGUAGE 'plpgsql';


------ Função de Alterar ------
CREATE OR REPLACE FUNCTION alterar_tabela(nm_tabela VARCHAR, nm_operacao VARCHAR, nm_coluna VARCHAR,nm_tipo VARCHAR)
RETURNS VOID AS $$
DECLARE
    operacao VARCHAR:= UPPER(nm_operacao);
    text_sql TEXT;
BEGIN
    IF operacao = 'ADD' THEN
        text_sql:= FORMAT('ALTER TABLE %I ADD COLUMN %I %s',nm_tabela,nm_coluna,nm_tipo);
    ELSIF operacao = 'DROP' THEN
        text_sql:= FORMAT('ALTER TABLE %I DROP COLUMN %I',nm_tabela,nm_coluna);
    ELSIF operacao = 'ALTER' THEN
        text_sql:= FORMAT('ALTER TABLE %I ALTER COLUMN %I TYPE %s',nm_tabela,nm_coluna,nm_tipo);
    ELSE 
        RAISE EXCEPTION 'Operacao "%" inválida!',operacao;
    END IF; 

    EXECUTE text_sql;
    RAISE NOTICE 'Operação "%" na coluna "%" da tabela "%" realizada com sucesso!', operacao, nm_coluna, nm_tabela;

EXCEPTION
    WHEN dependent_objects_still_exist THEN
        RAISE EXCEPTION 'Não é possível remover a coluna "%" pois ela é referenciada por outra tabela!', nm_coluna;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro: %', SQLERRM;
END;
$$ LANGUAGE 'plpgsql';


------ Função deletar ------
CREATE OR REPLACE FUNCTION deletar_linha(nm_tabela VARCHAR, nm_coluna VARCHAR, vl_coluna VARCHAR)
RETURNS VOID AS $$
DECLARE
    text_sql VARCHAR;
    tabela VARCHAR:= LOWER(TRIM(nm_tabela));
BEGIN
    IF tabela IS NULL OR tabela = '' THEN
        RAISE EXCEPTION 'O nome da tabela não pode ser vazio';
    END IF;

    IF tabela NOT IN ('cargo','funcionario','mesa','categoria','produto','fm_pagamento','comanda','pagamento','item_comanda') THEN
        RAISE EXCEPTION 'A tabela "%" não existe', tabela;
    END IF;

    text_sql:= FORMAT('DELETE FROM %I WHERE %I =''%s''',tabela,nm_coluna,vl_coluna);
    EXECUTE text_sql;
    RAISE NOTICE 'Linha deletada da tabela "%" com sucesso!', tabela;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Não é possível deletar pois este registro é referenciado por outra tabela!';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro: %', SQLERRM;
END;
$$ LANGUAGE 'plpgsql';
