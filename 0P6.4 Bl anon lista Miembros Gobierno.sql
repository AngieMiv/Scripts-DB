/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Apr 3, 2025
 * Script: cursor y excepciones
 */
DO  $$ ------------Empieza bl anon
DECLARE
	v_cursor_miembro CURSOR FOR
		SELECT * FROM miembro
		WHERE alias IS NOT NULL;
	
	v_registro_miembro miembro%ROWTYPE;
	v_nombre_ministerio ministerio.nombre%TYPE;
		
BEGIN

	OPEN v_cursor_miembro;
	LOOP
		FETCH v_cursor_miembro INTO v_registro_miembro;
		EXIT WHEN NOT FOUND;
		-- RAISE NOTICE 'lista = %', v_registro_miembro;
		IF v_registro_miembro.codigoministerio IS NOT NULL THEN
			v_nombre_ministerio := (SELECT nombre FROM ministerio
									WHERE codministerio = v_registro_miembro.codigoministerio 
									);
			RAISE NOTICE 'El miembro % % con nif % pertenece al ministerio %.',
			v_registro_miembro.nombre, v_registro_miembro.apellido1, v_registro_miembro.nif, v_nombre_ministerio;
		ELSE
			RAISE NOTICE 'El miembro % % con nif % no tiene ministerio asignado',
			v_registro_miembro.nombre, v_registro_miembro.apellido1, v_registro_miembro.nif;
		END IF;	
	END LOOP;
	CLOSE v_cursor_miembro;
	
END $$;