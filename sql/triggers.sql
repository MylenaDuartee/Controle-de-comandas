--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_atualizar_status_mesa()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        PERFORM update_tabela('mesa','num_mesa',NEW.num_mesa,ARRAY['status'],ARRAY['O']);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        PERFORM update_tabela('mesa','num_mesa',OLD.num_mesa,ARRAY['status'],ARRAY['L']);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_atualizar_status_mesa
AFTER INSERT OR DELETE ON comanda
FOR EACH ROW
EXECUTE PROCEDURE fn_atualizar_status_mesa();
    
-- DROP TRIGGER tg_atualizar_status_mesa ON comanda;

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_validar_comanda_pagamento()
RETURNS TRIGGER AS $$
DECLARE 
    st CHAR(1);
BEGIN

    SELECT status INTO st FROM comanda WHERE num_comanda = NEW.num_comanda;

    IF st = 'F' THEN
        RAISE EXCEPTION 'Não é possivel realizar o pagamento em uma comanda que já está fechada';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_validar_comanda_pagamento
BEFORE INSERT ON pagamento
FOR EACH ROW
EXECUTE PROCEDURE fn_validar_comanda_pagamento();

-- DROP TRIGGER tg_validar_comanda_pagamento ON pagamento;
-- DROP FUNCTION fn_validar_comanda_pagamento()

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_verificar_mesa_disponivel()
RETURNS TRIGGER AS $$
DECLARE 
    st CHAR(1);
BEGIN
    SELECT status INTO st FROM mesa WHERE num_mesa = NEW.num_mesa;

    IF st = 'O' OR st = 'R' THEN
        RAISE EXCEPTION 'A mesa está indisponível';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_verificar_mesa_disponivel
BEFORE INSERT ON comanda
FOR EACH ROW
EXECUTE PROCEDURE fn_verificar_mesa_disponivel();

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_atualizar_total_comanda()
RETURNS TRIGGER AS $$
DECLARE
    v_valor_unitario NUMERIC(10,2);
    v_diferenca NUMERIC(10,2);
    v_novo_total NUMERIC(10,2);
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT valor_unit INTO v_valor_unitario FROM produto WHERE cod_prod = NEW.cod_prod;
        NEW.valor:= NEW.qtd * v_valor_unitario;

        SELECT COALESCE(valor_total,0) + NEW.valor INTO v_novo_total FROM comanda WHERE num_comanda = NEW.num_comanda;

        PERFORM update_tabela('comanda','num_comanda',NEW.num_comanda,ARRAY['valor_total'],ARRAY[v_novo_total::TEXT]);
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        SELECT valor_unit INTO v_valor_unitario FROM produto WHERE cod_prod = NEW.cod_prod;
        NEW.valor:= NEW.qtd * v_valor_unitario;
        v_diferenca := NEW.valor - OLD.valor;

        SELECT COALESCE(valor_total,0) + v_diferenca INTO v_novo_total FROM COMANDA WHERE num_comanda = NEW.num_comanda;

        PERFORM update_tabela('comanda','num_comanda',NEW.num_comanda,ARRAY['valor_total'],ARRAY[v_novo_total::TEXT]);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        SELECT valor_total - OLD.valor INTO v_novo_total FROM comanda WHERE num_comanda = OLD.num_comanda;
        PERFORM update_tabela('comanda','num_comanda',OLD.num_comanda,ARRAY['valor_total'],ARRAY[v_novo_total::TEXT]);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_atualizar_total_comanda
BEFORE INSERT OR UPDATE OR DELETE ON item_comanda
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_total_comanda();

--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_fechar_comanda()
RETURNS TRIGGER AS $$
DECLARE
    v_total_pago NUMERIC(10,2);
    v_valor_total NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(valor), 0) INTO v_total_pago
    FROM pagamento WHERE num_comanda = NEW.num_comanda;

    SELECT valor_total INTO v_valor_total
    FROM comanda WHERE num_comanda = NEW.num_comanda;

    IF v_total_pago > v_valor_total THEN
        RAISE EXCEPTION 'Valor pago (%) ultrapassa o total da comanda (%)', v_total_pago, v_valor_total;
    END IF;

    IF v_total_pago = v_valor_total THEN
        PERFORM update_tabela('comanda', 'num_comanda', NEW.num_comanda,
            ARRAY['status'],
            ARRAY['F']);
        RAISE NOTICE 'Comanda % fechada automaticamente!', NEW.num_comanda;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_fechar_comanda
AFTER INSERT ON pagamento
FOR EACH ROW
EXECUTE FUNCTION fn_fechar_comanda();