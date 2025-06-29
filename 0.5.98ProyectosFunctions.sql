/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: May 21, 2025
 * Script: 99.8 - RA5 Programación en BBDD
 */

CREATE TABLE T_TIPO_NOTIFICACION(
	cod_tipo_notificacion CHAR(3) PRIMARY KEY,
	nombre_tipo VARCHAR(50)
);

CREATE TABLE T_NOTIFICACION_PERMISOS(
	identificador SERIAL PRIMARY KEY,
	textoNotificacion TEXT,
	cod_tipo_notificacion CHAR(3),
	fecha_creacion TIMESTAMP,
	CONSTRAINT fk_notif_perm_cod_tipo_notif FOREIGN KEY(cod_tipo_notificacion) REFERENCES T_TIPO_NOTIFICACION(cod_tipo_notificacion)
);

ALTER TABLE T_NOTIFICACION_PERMISOS
ALTER COLUMN fecha_creacion SET DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE T_NOTIFICACION_PERMISOS
ALTER COLUMN fecha_creacion SET NOT NULL;

INSERT INTO T_TIPO_NOTIFICACION (COD_TIPO_NOTIFICACION, NOMBRE_TIPO)
VALUES
	('INF', 'Información'),
	('ADV', 'Advertencia'),
	('ERR', 'Error'),
	('ACT', 'Actualización'),
	('REC', 'Recordatorio');

-- EJERCICIO 1
CREATE OR REPLACE FUNCTION F_NUM_PROYECTOS_CENTRO(IN param_idCentro T_CENTRO.IDENTIFICADOR%TYPE DEFAULT NULL)
RETURNS INT AS $$
DECLARE
	num_proyectos int;
BEGIN
	-- a)
	IF param_idCentro IS NULL THEN
	RAISE EXCEPTION 'Se ha introducido un centro vacío; por favor introduzca un identificador de centro'
		USING ERRCODE = 'EX001';
	END IF;
	
	-- b)
	SELECT count(*) into num_proyectos FROM T_PROYECTO
		WHERE id_centro = param_idCentro;

	RETURN num_proyectos;
	
END;
$$ LANGUAGE plpgsql;

-- SELECT F_NUM_PROYECTOS_CENTRO(4);
-- SELECT F_NUM_PROYECTOS_CENTRO();

-- EJERCICIO 2
CREATE OR REPLACE FUNCTION F_NOMBRE_CENTRO_DESDE_ID(IN param_idCentro T_CENTRO.IDENTIFICADOR%TYPE DEFAULT NULL)
RETURNS text AS $$
DECLARE
	v_nombreCentro t_centro.NOMBRE%TYPE;
	v_codigoCentro t_centro.CODIGO_CENTRO%TYPE;
	resultado text;
BEGIN
	-- a)
	IF param_idCentro IS NULL THEN
	RAISE EXCEPTION 'Se ha introducido un centro vacío; por favor introduzca un identificador de centro'
		USING ERRCODE = 'EX001';
	END IF;

	-- b)
	SELECT NOMBRE, CODIGO_CENTRO
		FROM T_CENTRO
		INTO v_nombreCentro, v_codigoCentro
			WHERE IDENTIFICADOR = param_idCentro;

    resultado := param_idCentro || ': ' || v_nombreCentro || '(' || v_codigoCentro || ')';

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- SELECT F_NOMBRE_CENTRO_DESDE_ID();
-- SELECT F_NOMBRE_CENTRO_DESDE_ID(4);

-- EJERCICIO 3
CREATE OR REPLACE FUNCTION f_ingresos_proyecto_curso(
IN param_idProyecto t_proyecto_curso.ID_PROYECTO%TYPE DEFAULT NULL,
IN param_proyectoCurso t_proyecto_curso.COD_CURSO%TYPE DEFAULT NULL)
RETURNS int AS $$
DECLARE
	v_ingresos int := 0;
	v_reg_fila_proyecto RECORD;
	v_reg_fila_curso RECORD;
BEGIN
	-- a)
	IF param_idProyecto IS NULL THEN
		RAISE EXCEPTION 'Se ha introducido un proyecto vacío, por favor, introduzca un identificador de proyecto.'
		USING ERRCODE = 'EX001';
	-- b)
	ELSIF param_proyectoCurso IS NULL THEN
		RAISE EXCEPTION 'Se ha introducido un curso académico vacío, por favor, introducza un identficador de proyecto.'
		USING ERRCODE = 'EX002';
	END IF;

	-- c)
	SELECT * INTO v_reg_fila_proyecto FROM T_PROYECTO TP
		WHERE tp.IDENTIFICADOR = param_idProyecto;
	RAISE NOTICE 'Proyecto: %', v_reg_fila_proyecto;
	
	SELECT * INTO v_reg_fila_curso FROM T_CURSO_ACADEMICO CA
		WHERE ca.CODIGO = param_proyectoCurso;
	RAISE NOTICE 'Curso Académico: %', v_reg_fila_curso;
	
	RAISE NOTICE 'ID del proyecto: %, curso académico: %', param_idProyecto, param_proyectoCurso;
	
	-- d)
	SELECT COALESCE(SUM(CANTIDAD), 0) FROM T_INGRESO INTO v_ingresos
	WHERE ID_PROYECTO = param_idProyecto AND COD_CURSO = param_proyectoCurso;

	
	RETURN v_ingresos;
END;
$$ LANGUAGE plpgsql;

-- SELECT F_INGRESOS_PROYECTO_CURSO(1, '2022-2023');
-- SELECT F_INGRESOS_PROYECTO_CURSO(6, '2022-2023');

-- EJERCICIO 4
CREATE OR REPLACE FUNCTION f_ingresos_proyecto_curso(
IN param_idProyecto t_proyecto_curso.ID_PROYECTO%TYPE DEFAULT NULL,
IN param_proyectoCurso t_proyecto_curso.COD_CURSO%TYPE DEFAULT NULL)
RETURNS int AS $$
DECLARE
	v_ingresos int := 0;
	v_reg_fila_proyecto RECORD;
	v_reg_fila_curso RECORD;
BEGIN
	-- a)
	IF param_idProyecto IS NULL THEN
		RAISE EXCEPTION 'Se ha introducido un proyecto vacío, por favor, introduzca un identificador de proyecto.'
		USING ERRCODE = 'EX001';
	END IF;

	-- b)
	SELECT * INTO v_reg_fila_proyecto FROM T_PROYECTO TP
		WHERE tp.IDENTIFICADOR = param_idProyecto;
	RAISE NOTICE 'Proyecto: %', v_reg_fila_proyecto;
	
	SELECT * INTO v_reg_fila_curso FROM T_CURSO_ACADEMICO CA
		WHERE ca.CODIGO = param_proyectoCurso;
	RAISE NOTICE 'Curso Académico: %', v_reg_fila_curso;

	RAISE NOTICE 'ID del proyecto: %, curso académico: %', param_idProyecto, param_proyectoCurso;
	
	-- c)
	IF param_proyectoCurso IS NULL THEN
		SELECT SUM(CANTIDAD) INTO v_ingresos FROM T_INGRESO 
		WHERE ID_PROYECTO = param_idProyecto;

	-- d)
	ELSE
		SELECT COALESCE(SUM(CANTIDAD), 0) FROM T_INGRESO INTO v_ingresos
		WHERE ID_PROYECTO = param_idProyecto AND COD_CURSO = param_proyectoCurso;
	END IF;
	
	RETURN v_ingresos;
END;
$$ LANGUAGE plpgsql;

-- SELECT f_ingresos_proyecto_curso(1, '2022-2023');
-- SELECT f_ingresos_proyecto_curso(1, NULL);
-- SELECT f_ingresos_proyecto_curso(NULL, '2022-2023');
-- SELECT F_INGRESOS_PROYECTO_CURSO(6, '2022-2023');

-- EJERCICIO 5
CREATE OR REPLACE FUNCTION f_gastos_asociados_proyecto_curso_academico(
IN param_idProyecto t_proyecto_curso.ID_PROYECTO%TYPE DEFAULT NULL,
IN param_proyectoCurso t_proyecto_curso.COD_CURSO%TYPE DEFAULT NULL)
RETURNS INT AS $$
DECLARE
	v_ingresos INT := 0;
	v_reg_fila_proyecto RECORD;
	v_reg_fila_curso RECORD;

	v_nombre_centro t_centro.nombre%type;
	v_identificador_centro t_centro.identificador%type;

	v_nombre_proyecto t_proyecto.nombre%TYPE;
	
	v_texto_notif_inf TEXT;
BEGIN
	-- a)
	IF param_idProyecto IS NULL THEN
		RAISE EXCEPTION 'Se ha introducido un proyecto vacío; porfavor introduzca un identificador de proyecto'
		USING ERRCODE = 'EX001';
	END IF;
	
	-- b)
	SELECT * INTO v_reg_fila_proyecto FROM T_PROYECTO TP
		WHERE tp.IDENTIFICADOR = param_idProyecto;
	RAISE NOTICE 'Proyecto: %', v_reg_fila_proyecto;
	
	SELECT * INTO v_reg_fila_curso FROM T_CURSO_ACADEMICO CA
		WHERE ca.CODIGO = param_proyectoCurso;
	RAISE NOTICE 'Curso Académico: %', v_reg_fila_curso;

	RAISE NOTICE 'ID del proyecto: %, curso académico %', param_idProyecto, param_proyectoCurso;
	
	-- c)
	IF param_proyectoCurso IS NULL THEN
	SELECT SUM(cantidad) INTO v_ingresos FROM T_INGRESO
		WHERE ID_PROYECTO = param_idProyecto;
			--RETURN v_ingresos;
	ELSE
	-- d)
		SELECT COALESCE(SUM(CANTIDAD), 0) FROM T_INGRESO INTO v_ingresos
		WHERE ID_PROYECTO = param_idProyecto AND COD_CURSO = param_proyectoCurso;
			--RETURN v_ingresos;
	END IF;

	-- e)
	SELECT tc.nombre INTO v_nombre_centro FROM T_CENTRO TC JOIN T_PROYECTO TP
		ON TC.identificador = TP.id_centro
		WHERE tp.identificador = param_idProyecto;

	SELECT TP.nombre INTO v_nombre_proyecto FROM T_CENTRO TC JOIN T_PROYECTO TP
		ON TC.identificador = TP.id_centro
		WHERE tp.identificador = param_idProyecto;

	SELECT tc.identificador INTO v_identificador_centro FROM T_CENTRO TC JOIN T_PROYECTO TP
		ON TC.identificador = TP.id_centro
		WHERE tp.identificador = param_idProyecto;

v_texto_notif_inf := 
    'Se ha realizado una consulta para obtener los gastos del proyecto ' || v_nombre_proyecto ||
    ' creado por el centro ' || v_nombre_centro || '(' || v_identificador_centro || ')' ||
    ' en el ' || param_proyectoCurso || 
    '. La cantidad obtenida es: ' || v_ingresos;


	INSERT INTO T_NOTIFICACION_PERMISOS (textonotificacion, cod_tipo_notificacion) VALUES (v_texto_notif_inf, 'INF');
	-- raise notice 'NOTIFICACIONNNNN';
	
	RETURN v_ingresos;

END;
$$ LANGUAGE plpgsql;

SELECT F_GASTOS_ASOCIADOS_PROYECTO_CURSO_ACADEMICO(1, '2022-2023');
