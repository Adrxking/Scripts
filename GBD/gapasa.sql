DELIMITER $$
DROP PROCEDURE IF EXISTS consumo$$
CREATE PROCEDURE consumo()
MODIFIES SQL DATA
BEGIN
    DECLARE flag INT DEFAULT 0;
    DECLARE cursor_id_contrato INT;
    DECLARE cursor_dni VARCHAR(9);
    DECLARE cursor_nombre VARCHAR(50);
    DECLARE cursor_direccion VARCHAR(50);
    DECLARE cursor_consumo_anual DECIMAL(8,2);
    DECLARE cursor_consumo CURSOR FOR
    SELECT Contrato,sum(Consumo_Litros) as total FROM gapasa.consumos group by Contrato;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag=1;
    OPEN cursor_consumo;
    Loop:REPEAT
	   FETCH cursor_consumo INTO cursor_id_contrato,cursor_consumo_anual;
	    IF flag=1 THEN
	        LEAVE loop;
	    END IF;
	    UPDATE gapasa.contratos SET consumo_anual = cursor_consumo_anual WHERE num_contrato = cursor_id_contrato;
        IF cursor_consumo_anual > 350000 THEN
	        SELECT dni_cliente INTO cursor_dni FROM contratos WHERE num_contrato = cursor_id_contrato;
            SELECT nombre,direccion INTO cursor_nombre,cursor_direccion FROM clientes WHERE dni = cursor_dni;
            INSERT INTO derrochadores VALUES (cursor_dni,cursor_nombre,cursor_direccion);
        END IF;
    END REPEAT Loop;
    CLOSE cursor_consumo;
    SET flag=0;