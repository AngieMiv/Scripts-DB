/*
SGDB: PostgreSQL
Programador: AMIV
Fecha: 25/03/2025
Script: Programa/s para el examen de 3ª Evaluación asociado al RA5 - Programación sobre Bases de Datos.
*/

-- Aparatado A: 5 puntos
CALL p_tratamiento_asignaturas_grado(1, 2);

CREATE OR REPLACE PROCEDURE p_tratamiento_asignaturas_grado(IN param_id_grado int, IN param_id_curso_escolar int)
AS -- $$
DECLARE
	v_param1 int := param_id_grado;
	v_param2 int := param_id_curso_escolar;
/*	c_cursor_asignaturas CURSOR FOR
		SELECT tipo, id_profesor, id_alumno FROM asignatura JOIN alumno_curso_asignatura ON */
BEGIN
	RAISE NOTICE 'valor de param1 % y de param2 %', v_param1, v_param2;
	/*EXECUTE f_tipo_asignatura(param)*/
/*	IF param_id_grado is null and param_id_curso_escolar is null THEN
		RAISE EXCEPTION 'Excepcion: ' using errcode = 'P0001';
	END IF;
	

	EXCEPTION
		WHEN SQLSTATE 'P0001' THEN
			RAISE NOTICE 'Los datos de entrada % y % del programa están vacíos 
				y son obligatorios, por favor rellénelos e inténdelo de nuevo. Error % - %', v_param1, v_param2, SQLERRM, SQLSTATE;
		WHEN OTHERS THEN RAISE NOTICE 'Ha saltado otra excepción. Código: %', SQLSTATE;*/
	
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION f_tipo_asignatura(param_id_asignatura asignatura.id%TYPE)
RETURNS boolean AS $$
DECLARE
	v_tipo_asignatura asignatura.id%TYPE := (SELECT tipo FROM asignatura WHERE asignatura.id = param_id_asignatura);
	v_si boolean;
BEGIN
	IF v_tipo_asignatura = 'básica' OR v_tipo_asitnatura = 'obligatoria'
		THEN v_si = TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$ LANGUAGE plpgsql;


/*CREATE OR REPLACE FUNCTION f_trigg_param_vacios()
RETURNS TRIGGER AS $$
/*DECLARE
	v_param1 int := param_id_grado;
	v_param2 int := param_id_curso_escolar;
BEGIN
	IF param_id_grado is null and param_id_curso_escolar is null THEN
		RAISE EXCEPTION 'excepcion' using errcode = 'P0001';
	END IF;
	RAISE NOTICE 'valor de param1 % y de param2 %', v_param1, v_param2;

	EXCEPTION
		WHEN SQLSTATE 'P0001' THEN
			RAISE NOTICE 'error % - %', SQLERRM, SQLSTATE;
		WHEN OTHERS THEN RAISE NOTICE 'Ha saltado otra excepción. Código: %', SQLSTATE;	
END;
$$ LANGUAGE plpgsql; */

-- Aparatado B: 5 puntos


CREATE OR REPLACE TRIGGER t_notificaciones_t_asignatura
AFTER UPDATE OR DELETE
ON asignatura
FOR EACH ROW
EXECUTE FUNCTION f_trigg_notificacion();

CREATE OR REPLACE FUNCTION f_trigg_notificacion()
RETURNS TRIGGER AS $$
DECLARE
	v_idAsignatura asignatura.id%TYPE := (select id FROM asignatura);
	v_idProfesor asignatura.id_profesor%TYPE := (select id_profesor from asignatura);
	v_record_asignatura asignatura%rowtype := (SELECT * FROM asignatura WHERE id.profesor = v_idProfesor);
	--v_old := OLD;
	--v_new := NEW;
	--v_tg_op := tg_op;
	v_profe_in_asignatura RECORD := (SELECT * FROM profesor WHERE id IN (SELECT id_profesor FROM asignatura));
	v_profe_no_asignatura RECORD := (SELECT * FROM profesor WHERE id NOT IN (SELECT id_profesor FROM asignatura));
BEGIN
	IF tg_op = 'DELETE' THEN
		IF v_idAsignatura.NEW = NULL THEN
			RAISE NOTICE 'Es necesario recolocar al profesor % %', v_profe_in_asignatura.nombre, v_profe_in_asignatura.apellido1;
			INSERT INTO NOTIFICACION (CODIGO_TIPO_NOTIFICACION, TEXTO, FECHA_NOTIFICACION) VALUES
			('AVI', 'Es necesario recolocar al profesor', localtimestamp);
		END IF;
	ELSIF tg_op = 'UPDATE' THEN
		IF v_record_asignatura.id_profesor.NEW = NULL THEN 
			RAISE NOTICE 'Es necesario encontrar un profesor para la asignatura %', v_record_asignatura.nombre;
			INSERT INTO NOTIFICACION (CODIGO_TIPO_NOTIFICACION, TEXTO, FECHA_NOTIFICACION) VALUES
			('IYU', 'Es necesario encontrar un profesor', localtimestamp);
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;

--INSERT INTO asignatura VALUES (99, 'Prueba', 6, 'básica', 1, 1, 44);
--INSERT INTO profesor VALUES (44, '77194466M', 'mery', 'jane', 'doe', 'Almería', 'C/ Quinto pino', NULL, '1980/12/13', 'M', 2);


