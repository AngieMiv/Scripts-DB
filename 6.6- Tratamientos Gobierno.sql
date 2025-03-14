/*
SGDB: Postgres
Programador: Angie M. Ibarrola Valenzuela
Fecha: Mar 13, 2025
Script: Actividad 6.6
*/

CALL p_tratar_gobierno_act_6_6(3, 6);

CREATE OR REPLACE PROCEDURE p_tratar_gobierno_act_6_6 (IN opcion INT,
														IN codigo_ministerio int)
														AS $$
DECLARE
	v_cod_miembro miembro.codmiembro%TYPE;
BEGIN
	CASE
		WHEN opcion = 1 THEN
				RAISE NOTICE '1';

				DELETE FROM ministerio
					WHERE codministerio = codigo_ministerio;
		WHEN opcion = 2 THEN
				RAISE NOTICE '2';
				SELECT max (codMiembro) INTO v_cod_miembro
				FROM miembro
						WHERE codigoministerio = codigo_ministerio;
				DELETE FROM miembro
					where codMiembro = v_cod_miembro;
		WHEN opcion = 3 THEN
			RAISE NOTICE '3';
			CALL p_eliminar_miembros_sobrantes();
		ELSE
			RAISE NOTICE 'otras';
	END CASE;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE p_eliminar_miembros_sobrantes() AS $$
DECLARE
BEGIN 
	RAISE NOTICE 'p_eliminar_miembros_sobrantes';
	DELETE
	FROM miembro
		WHERE codigoministerio IN (SELECT codigoministerio
									FROM miembro
										GROUP BY codigoministerio
										HAVING count(*) > 2);
END;
$$ LANGUAGE plpgsql;
