/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 17/02/2025
Script: Formas de gestionar las excepciones (lanzar-capturar) dentro de un procedimiento.
		https://www.postgresqltutorial.com/postgresql-plpgsql/postgresql-exception/
*/

-- Bloque anónimo
DO $$
DECLARE
	v_numero int := -1;
	v_resultado int := 0;
BEGIN
	IF v_numero < 0 THEN
		-- Se lanza la excepción (se recoge en el bloque exception)
		RAISE EXCEPTION 'El número es menor que cero.' USING ERRCODE = 'P0001';
	END IF;
	
	-- Calcular el resultado de la multiplicación x 10
	v_resultado := 10 * v_numero;

	raise notice 'El resultado de multiplicar 10 x % es: %', v_numero, v_resultado;  

EXCEPTION -- Se recogen las excepciones para su tratamiento. 
	
	WHEN SQLSTATE  'P0001' THEN
		RAISE NOTICE 'Error: % - %', SQLERRM, SQLSTATE;
	
	WHEN others THEN
		-- Esta parte es donde se capturará la excepción
		RAISE NOTICE 'Ha saltado otra excepción. Código de excepción: %', SQLSTATE;
END;
$$ language plpgsql;

-- tratamiento que lanza una excepción en un procedimiento
create or replace procedure p_probar_tratamiento_excepcion_propia(param_numero int) as $$
DECLARE
BEGIN
	IF param_numero < 0 THEN
	    -- Lanzo la excepción
	    RAISE EXCEPTION 'Número negativo no esperado.' USING ERRCODE = 'P0001';
	ELSE
        RAISE NOTICE 'tratamiento esperado cuando el número es mayor o igual que cero.';
	END IF;

EXCEPTION
    WHEN SQLSTATE  'P0001' THEN
        RAISE NOTICE 'Error: % - %', SQLERRM, SQLSTATE;
    WHEN others THEN
        -- Esta parte es donde se capturará la excepción
        RAISE NOTICE 'Ha saltado otra excepción. Código de excepción: %', SQLSTATE;
END;
$$ language plpgsql;

call p_probar_tratamiento_excepcion_propia(-1);

create or replace procedure p_probar_tratamiento_una_excepcion() as $$
begin
    RAISE NOTICE 'Tratamiento antes del borrado del ministerio';   

   -- Tratamiento del borrado de un ministerio
    BEGIN
        DELETE FROM ministerio WHERE codMinisterio = 1;
    EXCEPTION
        WHEN foreign_key_violation then -- Manejar la excepción violación de clave foránea
            RAISE NOTICE 'No se puede eliminar el Ministerio debido a restricción de clave externa';
        
		WHEN others THEN -- Manejar otras excepciones que no sean foreign_key_violation
            RAISE NOTICE 'Ocurrió un error en el tratamiento';
	END;
	
    RAISE NOTICE 'Tratamiento depués del borrado del ministerio';   
END;
$$ language plpgsql;

call p_probar_tratamiento_una_excepcion();

-- Excepciones para cada tratamiento
create or replace procedure p_probar_tratamiento_varias_excepciones() as $$
BEGIN
    -- Tratamiento del borrado de un ministerio con su excepción
    BEGIN
	    RAISE NOTICE 'Tratamiento del borrado de un ministerio con su excepción';
        DELETE FROM ministerio WHERE codMinisterio = 1;
    --Tratamiento caso de excepción
    EXCEPTION
        WHEN foreign_key_violation THEN -- Manejar la excepción por violación de integridad referencial.         
            RAISE NOTICE 'No se puede eliminar el Ministerio debido a la existencia de una restricción de clave externa';
    END;

    -- Tratamiento de actualizació de un ministerio con su posible excepción
    BEGIN
	    RAISE NOTICE 'Tratamiento de actualizació de un ministerio con su posible excepción';
        UPDATE ministerio SET presupuesto = 500000 WHERE codMinisterio = 2;
    EXCEPTION
        WHEN others THEN -- Manejar cualquier excepción que ocurra dentro de la ACTUALIZACIÓN
            RAISE NOTICE 'Ocurrió un error al actualizar el presupuesto del Ministerio 2';
    END;

    -- Tratamiento de actualización de un miembro de un ministerio con su posible excepción
    BEGIN
	    RAISE NOTICE 'Tratamiento de actualización de un miembro de un ministerio con su posible excepción';
        DELETE FROM miembro WHERE codigoMinisterio = 3;
    --Tratamiento caso de excepción    
    EXCEPTION
        WHEN others THEN -- Manejar cualquier excepción que ocurra dentro del BORRADO    
            RAISE NOTICE 'Ocurrió un error al eliminar miembros del Ministerio 3';
    END;
END;
$$ language plpgsql;


call p_probar_tratamiento_varias_excepciones();

-- Todos los tratamientos se gestionan en UN MISMO BLOQUE DE MANEJO DE EXCEPCIONES
create or replace procedure p_probar_tratamiento_varias_excepciones_juntas() as $$
BEGIN
    BEGIN
	    -- Tratamiento del borrado de un ministerio con su excepción
        DELETE FROM ministerio WHERE codMinisterio = 1;

	    -- Tratamiento de actualizació de un ministerio con su posible excepción
        UPDATE ministerio SET presupuesto = 500000 WHERE codMinisterio = 2;

       -- Tratamiento de actualización de un miembro de un ministerio con su posible excepción
       DELETE FROM miembro WHERE codigoMinisterio = 3;

    --Tratamiento caso de excepción
    EXCEPTION
        WHEN foreign_key_violation THEN
            -- Manejar la excepción para la Operación 1
            RAISE NOTICE 'No se puede eliminar el Ministerio debido a la existencia de una restricción de clave externa';
        WHEN others THEN -- Manejar otras excepciones que no sean foreign_key_violation
            RAISE NOTICE 'Ocurrió un error en el tratamiento';
    END;
END;
$$ language plpgsql;

call p_probar_tratamiento_varias_excepciones_juntas();

-- tratamiento que lanza una excepción
create or replace procedure p_probar_tratamiento_lanzar_excepcion() as $$
BEGIN
    -- Aquí va el bloque con la excepción que deseas que pase
    RAISE EXCEPTION 'Lanzo una excepción que me creo' USING ERRCODE = 'P0001';

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'No se puede eliminar el Ministerio debido a la existencia de una restricción de clave externa';
    WHEN others THEN
        -- Esta parte es donde se capturará la excepción
        RAISE NOTICE 'Ocurrió un error en el tratamiento: %', SQLERRM;
END;
$$ language plpgsql;

call p_probar_tratamiento_lanzar_excepcion();