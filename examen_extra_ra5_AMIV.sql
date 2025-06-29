/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Jun 13, 2025
 * Script: examen extraordinaria ra5 AMIV
 */

-- 1) tratamiento cuando se produzca un cambio en la info ya existente del profesor
CREATE OR REPLACE FUNCTION f_trigg_profesor()
RETURNS TRIGGER AS $$
DECLARE

	v_nombre_prof profesor.nombre%type;
    v_num_asignaturas INTEGER;
	v_nombre_departamento departamento.nombre%TYPE;
	
BEGIN 

	-- a) En caso que haya un camio en el campo activo del pofesor; si éste pasa a inactivo habrá que tener en cuenta:
	-- (campo 'activo' ahora es 'N')
	
	-- 1. Si el profe stiene asignaturas asignadas habrá que: 
    IF NEW.activo = 'N' AND OLD.activo = 'S' THEN

		-- i. quitar al profe de dichas asignaturas
        SELECT COUNT(*) INTO v_num_asignaturas
        FROM asignatura
        WHERE id_profesor = OLD.id;
        
		IF v_num_asignaturas > 0 THEN
			UPDATE asignatura
			SET id_profesor = NULL
				WHERE id_profesor = OLD.id;
			
			SELECT nombre INTO v_nombre_prof
			FROM profesor
				WHERE id = OLD.id;
			
			-- ii. imprimir por consola el mensaje: "el profesor (nombre) tenía (num asignaturas) asignadas; y se le han quitado"       
			RAISE NOTICE 'El profesor % tenía % asignadas; y se le han quitado', v_nombre_prof, v_num_asignaturas;
			
			RETURN NEW;
			
	-- b) Si no tiene asignaturas asignadas
		-- i) Se eliminará el profesor
		ELSE
			DELETE FROM profesor WHERE id = OLD.id;
	
            SELECT d.nombre INTO v_nombre_departamento
            FROM departamento d JOIN profesor p
            	ON p.id_departamento = d.id
            		WHERE p.id = OLD.id;
			
			-- ii) imprimir por consola el siguiente mensaje: "El profesor (nombre)" perteneciente al departamento (nombre depart)
			-- ha sido eliminado de la base de datos"

            RAISE NOTICE 'El profesor % perteneciente al departamento % ha sido eliminado de la base de datos.',
            v_nombre_prof, v_nombre_departamento;
		
			RETURN NULL;
			
		END IF;
	END IF;
	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER t_trigg_prof
AFTER UPDATE
ON profesor
FOR EACH ROW
EXECUTE FUNCTION f_trigg_profesor();

-- UPDATE profesor SET activo = 'S' WHERE id = 3;
-- UPDATE profesor SET activo = 'N' WHERE id = 14;


-- 2) Al programa se la pasa info relativa al usuario  (campo usuario tabla auditoría = auditoria.usuario%type)
-- tratamiento de los profes de los departamentos con código 1, 2 y 6

CREATE OR REPLACE PROCEDURE p_usuario(IN param_usuario auditoria.usuario%TYPE)
AS $$
DECLARE

	CURSOR cur_profesores FOR SELECT id, activo, fecha_baja, nombre
	FROM profesor
        WHERE id_departamento IN (1, 2, 6);

    v_prof_id profesor.id%TYPE;
    v_activo profesor.activo%TYPE;
    v_fecha_baja profesor.fecha_baja%TYPE;
    v_num_asignaturas INTEGER;
    v_texto_auditoria TEXT;
    v_nombre_prof profesor.nombre%TYPE;
    
BEGIN
	
	-- a) Validacion de que la info de usuario en el procedure esté rellena. ERRCODE = 'USU01'
	IF param_usuario IS NULL THEN
        RAISE EXCEPTION 'El campo usuario del programa está vacío' USING ERRCODE = 'USU01';
    END IF;
	
	-- b) Si el profe no está activo y no tiene fecha de baja:
    OPEN cur_profesores;
    LOOP
        FETCH cur_profesores INTO v_prof_id, v_activo, v_fecha_baja, v_nombre_prof;
        EXIT WHEN NOT FOUND;
    	
    	-- 1. Se actualiza la fecha de baja del profe con la fecha actual
        IF v_activo = 'N' AND v_fecha_baja IS NULL THEN
            UPDATE profesor
            SET fecha_baja = CURRENT_DATE
            WHERE id = v_prof_id;

	-- c) Si el profe está activo
	
		-- 1. Si tiene valor la fecha de baja:
        ELSIF v_activo = 'S' THEN

			-- i) Se quitará el avlor de la fecha de baja que tenía el profe
            IF v_fecha_baja IS NOT NULL THEN
                UPDATE profesor
                SET fecha_baja = NULL
                WHERE id = v_prof_id;

		-- 2. En caso contrario, si el profe NO tiene asignaturas asignadas hay que
			-- i) borrar la info del profe
            ELSE
                SELECT COUNT(*) INTO v_num_asignaturas
                FROM asignatura
                WHERE id_profesor = v_prof_id;

                IF v_num_asignaturas = 0 THEN
                    DELETE FROM profesor
                    WHERE id = v_prof_id;
			-- ii) grabar en la tabla de audoría, valor del campo usuario como param de entrada, con el siguiente mensaje
            -- "El profesor nombre y apelidos profe con identificador tal, NO tiene asignaturas asignadas. Ha sido borrado"
                v_texto_auditoria := 'El profesor %', v_nombre_prof;
                    INSERT INTO auditoria(nombre_tabla, usuario, texto)
                    VALUES ('profesor', param_usuario,
                            v_texto_auditoria);
                END IF;
            END IF;
        END IF;
    END LOOP;

    CLOSE cur_profesores;

END;
$$ LANGUAGE plpgsql;

    









