/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Apr 3, 2025
 * Script: 6.5 Funciones y Procedimientos sobre Ministerio
 */

CREATE OR REPLACE FUNCTION f_obtener_nombre_ministerio2(id_miembro miembro.codigoministerio%TYPE)
RETURNS ministerio.nombre%TYPE AS $$
DECLARE
	v_nombre_ministerio ministerio.nombre%TYPE;
BEGIN
	SELECT ministerio.nombre INTO v_nombre_ministerio
	FROM miembro JOIN ministerio ON miembro.codigoministerio = ministerio.codministerio
	WHERE miembro.codmiembro = id_miembro;
	
	IF v_nombre_ministerio IS NULL THEN
		RAISE NOTICE 'Nombre de ministerio no disponible';
	ELSE 
		RAISE NOTICE 'El nombre de ministerio del miembro con id % es %', id_miembro, v_nombre_ministerio;
	END IF;
	RETURN v_nombre_ministerio;
END;
$$ LANGUAGE plpgsql;

SELECT F_OBTENER_NOMBRE_MINISTERIO2(4);

CREATE OR REPLACE PROCEDURE p_obtener_nombre_ministerio2(
	IN id_miembro miembro.codigoministerio%TYPE,
	OUT nombre_ministerio ministerio.nombre%TYPE) AS $$
DECLARE
BEGIN
	nombre_ministerio := (SELECT F_OBTENER_NOMBRE_MINISTERIO2(id_miembro));
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
	v_param_nombre ministerio.nombre%TYPE;
BEGIN
	CALL P_OBTENER_NOMBRE_MINISTERIO2(4, v_param_nombre);
END $$;



