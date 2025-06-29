/*
SGDB: PostgreSQL
Alumn@: Angie M. Ibarrola Valenzuela
Fecha: 30/05/2025
Script: Programación sobre GecoVIP: Examen Ordinaria RA5
*/

CREATE OR REPLACE FUNCTION F_PROYECTO_MARZO_SEPTIEMBRE(param_fecha DATE)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXTRACT(MONTH FROM param_fecha) BETWEEN 3 AND 9;
END;
$$ LANGUAGE plpgsql;

-- Tratamiento de proyectos que empezaron entre MARZO y SEPTIEMBRE (ambos incluidos)
CREATE OR REPLACE PROCEDURE P_TRATAMIENTO_PROYECTOS(IN param_codigo_ca CHAR)
AS $$
DECLARE
	v_fecha T_PROYECTO.FECHA_INICIO%TYPE;
	v_is_marzo_sept BOOLEAN := FALSE;
	v_cursor_proyecto CURSOR FOR
		SELECT TP.* FROM T_PROYECTO TP JOIN T_PROYECTO_CURSO TCP
		ON TP.IDENTIFICADOR = TCP.ID_PROYECTO
		WHERE TCP.cod_curso = param_codigo_ca;
	v_rec_fila_proyecto RECORD;
	v_texto TEXT;
	v_id_centro_TP T_PROYECTO.id_centro%TYPE;
	v_centro_asignado_cod_curso T_PROYECTO_CURSO.cod_curso%TYPE;
	v_nombre_centro T_CENTRO.nombre%TYPE;
BEGIN

	IF param_codigo_ca IS NULL THEN
	RAISE EXCEPTION 'El campo curso académico del programa está vacío y es obligatorio, 
		por favor, rellénelo e inténtelo de nuevo'
		USING ERRCODE = 'CA001';
	END IF;

/*	INSERT tp.fecha_inicio INTO v_fecha
	FROM T_PROYECTO TP JOIN T_PROYECTO_CURSO TCP
	ON TP.IDENTIFICADOR = TCP.ID_PROYECTO 
		WHERE TCP.COD_CURSO = param_codigo_ca;*/
/*	v_is_marzo_sept := (v_fecha);*/

	OPEN v_cursor_proyecto;
	LOOP
		FETCH v_cursor_proyecto INTO v_rec_fila_proyecto;
		EXIT WHEN NOT FOUND;
		v_is_marzo_sept := F_PROYECTO_MARZO_SEPTIEMBRE(v_rec_fila_proyecto.fecha_inicio);

	IF v_is_marzo_sept = TRUE THEN

		IF v_rec_fila_proyecto.id_centro IS NULL AND v_rec_fila_proyecto.proyecto_stem THEN
			v_texto := 'El proyecto ' || v_rec_fila_proyecto.nombre || ' es de tipo STEM y de ámbito Europeo, 
				pero aún no hay un centro que lo haya implantado en el curso académico ' || param_codigo_ca;
			INSERT INTO T_NOTIFICACION(codigo_tipo_notificacion, textonotificacion)
			VALUES ('IYU', v_texto);
		END IF;

/*		IF v_rec_fila_proyecto.id_centro IS NULL AND v_fec_fila_proyecto.ambito = 'Municipal' THEN
			SELECT TC.identificador INTO v_id_centro_TP
			FROM T_CENTRO TC JOIN T_PROYECTO TP
			ON TC.identificador = TP.id_centro
				WHERE TC ------------------- ??????????
			INSERT INTO T_PROYECTO (id_centro)
			VALUES ()
		END IF;*/

		SELECT tcp.cod_curso INTO v_centro_asignado_cod_curso
		FROM T_PROYECTO_CURSO TCP JOIN T_PROYECTO TP
		ON TCP.id_proyecto = TP.identificador
			WHERE TCP.cod_curso = param_codigo_ca;
		
		SELECT TC.nombre INTO v_nombre_centro
		FROM T_CENTRO TC JOIN T_PROYECTO TP
			ON TC.identificador = TP.id_centro;

		IF v_rec_fila_proyecto.id_centro IS NOT NULL THEN-- AND t_proyecto.identificadorv_centro_asignado_cod_curso THEN 
			RAISE NOTICE 'El proyecto % asociado al centro % ha sido implantado en el curso académico %',
				v_rec_fila_proyecto.nombre, v_nombre_centro, v_centro_asignado_cod_curso;
		END IF;

	END IF;

	END LOOP;

END;
$$ LANGUAGE plpgsql;

CALL P_TRATAMIENTO_PROYECTOS('2024-2025');

CREATE OR REPLACE FUNCTION F_TRIGG_BF_UP_INGRESO()
RETURNS TRIGGER AS $$
DECLARE
	v_text text;
BEGIN
	/*IF NEW.fecha_ingreso IS NOT NULL THEN
	END IF;*/
	IF cantidad > 0 and observacion IS NULL THEN
	v_text := 'Aportacion al proyecto ' || new.id_proyecto || ' realizada por parte del patrocinador ' || new.id_patrocinador;
	NEW.observacion := v_text;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TRIGG_BF_UP_INGRESO
BEFORE INSERT
ON T_INGRESO
FOR EACH ROW
EXECUTE FUNCTION F_TRIGG_BF_UP_INGRESO();





