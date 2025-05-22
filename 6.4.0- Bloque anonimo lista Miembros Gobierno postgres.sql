/*
 * DBMS: postgres
 * Programmer: AMIV
 * Date: Mar 7, 2025
 * Script:  Bloque de código anónimo que trabaje con un cursor,
 * que recoja la lista de miembros cuyo alias es distinto de NULL: Por cada miembro obtenido, se imprimirá por consola un mensaje.
 */

/*UPDATE miembro
SET codigoministerio = NULL 
	WHERE codmiembro = 6; -- tmb 1

SELECT *
FROM miembro m
	WHERE alias IS NOT NULL
	ORDER BY codmiembro;*/

DO $$
DECLARE
	v_cursor_miembro CURSOR FOR
		SELECT *
		FROM miembro m
			WHERE alias IS NOT NULL;

	v_registro_miembro miembro%ROWTYPE;

	v_nombre_ministerio ministerio.nombre%type;

BEGIN 
	OPEN v_cursor_miembro;
		LOOP
			FETCH v_cursor_miembro INTO v_registro_miembro;
			EXIT WHEN NOT FOUND;

-- 			RAISE NOTICE '%', v_registro_miembro;
			IF v_registro_miembro.codigoministerio IS NULL THEN
				RAISE NOTICE 'El miembro % % con nif % no tiene ministerio asignado',
					v_registro_miembro.nombre, v_registro_miembro.apellido1, v_registro_miembro.nif;
			ELSE
				v_nombre_ministerio := (SELECT nombre
										FROM ministerio
											WHERE codministerio = v_registro_miembro.codigoministerio);
				RAISE NOTICE 'El miembro % % con nif % pertenece al ministerio %.',
					v_registro_miembro.nombre, v_registro_miembro.apellido1, v_registro_miembro.nif, v_nombre_ministerio;
			END IF;
		END LOOP;
	CLOSE v_cursor_miembro;
	
END$$
