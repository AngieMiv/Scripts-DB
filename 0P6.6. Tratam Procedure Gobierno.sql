/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Apr 3, 2025
 * Script: Act 6.6 tratar gobierno con procedure
 */
CALL P_TRATAR_GOBIERNO(3, 3);

CREATE OR REPLACE PROCEDURE p_tratar_gobierno(
	IN opcion int,
	IN cod_ministerio ministerio.CODMINISTERIO%TYPE) AS $$
DECLARE
	v_miembro_codigo_desc1 miembro.CODMIEMBRO%TYPE;
BEGIN
	CASE
		WHEN opcion = 1 THEN 
			RAISE NOTICE 'Elegida opción %', opcion;
			DELETE FROM ministerio m WHERE m.codministerio = cod_ministerio;

		WHEN opcion = 2 THEN
			RAISE NOTICE 'Elegida opción %', opcion;
			v_miembro_codigo_desc1 := (	SELECT m.codmiembro 
										FROM miembro m JOIN ministerio mt
										ON mt.codministerio = cod_ministerio AND mt.codministerio = m.codigoministerio  
										ORDER BY m.codmiembro DESC LIMIT 1);
			DELETE FROM miembro m WHERE m.codmiembro = v_miembro_codigo_desc1;
			RAISE NOTICE 'Miembro con codmiembro % borrado', v_miembro_codigo_desc1;

		WHEN opcion = 3 THEN
			RAISE NOTICE 'Elegida opción %', opcion;
			CALL P_BORRAR_MIEMBROS_MINISTERIO();

		ELSE
			RAISE NOTICE 'No existe esta opción (%)', opcion;
	END CASE;
	
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE p_borrar_miembros_ministerio() AS $$
DECLARE
BEGIN
	DELETE FROM miembro WHERE codigoministerio IN (SELECT codigoministerio FROM miembro
														GROUP BY codigoministerio
														HAVING count(*) > 2);
	RAISE NOTICE 'Borrados los miembros sobrantes de ministerios con más de 2 miembros';
END
$$ LANGUAGE plpgsql;

