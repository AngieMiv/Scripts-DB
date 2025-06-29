/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: May 24, 2025
 * Script: 99.9 - RA5
 */

CREATE OR REPLACE PROCEDURE p_tratamiento_patrocinador()  AS $$
DECLARE
	v_rec_patrocinador RECORD;
	v_aportacion_total NUMERIC;
	v_texto TEXT;
BEGIN
	-- recorremos a los patrocinaodres
	FOR v_rec_patrocinador IN
		SELECT tp.identificador, tp.nombre -- solo necesitamos el id y el nombre
		FROM T_PATROCINADOR TP
	LOOP
		-- calculamos la suma aportación del patrocinador (lo va recorriendo con el loop)
		-- NO hace falta un GROUP BY bc con el SUM y el where id = id filtramos e iteramos un único patrocinador
		-- el COALESCE es para que si no hay suma (si no aparecen en TI), se le asigna un 0 a la v_aportacion_total
		SELECT COALESCE(SUM(ti.cantidad), 0) INTO v_aportacion_total
			FROM T_INGRESO TI
			WHERE ti.id_patrocinador = v_rec_patrocinador.identificador;
		
		-- a) imprimir en consola la info
		RAISE NOTICE '% ha aportado % €', v_rec_patrocinador.nombre, v_aportacion_total;

		-- b) Si el patrocinador no ha realizado aportaciones se almacenará una
		-- notificación de tipo “Advertencia”
		IF v_aportacion_total = 0 THEN
			v_texto := v_rec_patrocinador.nombre || 'no ha realizado aportaciones. Habría que contactar con ellos';
			INSERT INTO T_NOTIFICACION_PERMISOS (COD_TIPO_NOTIFICACION, TEXTONOTIFICACION)
			VALUES ('ADV', v_texto);
		
		-- c) Si las aportaciones del patrocinador están entre 1000 y 3000 € se almacenará una
		-- notificación de tipo "Recordatorio"
		ELSIF v_aportacion_total BETWEEN 1000 AND 3000 THEN
			v_texto := v_rec_patrocinador.nombre || ', muchas gracias por sus aportaciones hasta el día de hoy (' ||
				v_aportacion_total || ' €). Le animamos a continuar apoyando nuestros proyectos';
			INSERT INTO T_NOTIFICACION_PERMISOS (COD_TIPO_NOTIFICACION, TEXTONOTIFICACION)
			VALUES ('REC', v_texto);
		
		-- d) Si las aportaciones son de más de 3000€ se almacenará una 
		-- notificación de tipo “Información”
		ELSIF v_aportacion_total > 3000 THEN
			v_texto := v_rec_patrocinador.nombre || ', muchas gracias por sus aportaciones realizadas hasta el día de hoy (' ||
				v_aportacion_total || '€). En breve, recibirá una sorpresa como reconocimiento por su apoyo a nuestros proyectos. Gracias';
			INSERT INTO T_NOTIFICACION_PERMISOS (COD_TIPO_NOTIFICACION, TEXTONOTIFICACION)
			VALUES ('INF', v_texto);
		
		END IF;
			
	END LOOP;
	
END;
$$ LANGUAGE plpgsql;

-- CALL P_TRATAMIENTO_PATROCINADOR();

-- 2. Tratamiento relacionado con los T_CONCEPTO asociados a T_GASTO
CREATE OR REPLACE PROCEDURE p_tratam_concepto_gastos() AS $$
DECLARE
	v_rec_concepto RECORD;
	v_gasto_total NUMERIC;
	v_texto TEXT;
	v_es_2425 BOOLEAN;
BEGIN
	FOR v_rec_concepto IN SELECT * FROM T_CONCEPTO TC LOOP
		-- calculamos el gasto asociado
		SELECT COALESCE(SUM(TG.precio_unidad * TG.num_unidades::numeric), 0) INTO v_gasto_total FROM T_GASTO TG
		WHERE v_rec_concepto.identificador = TG.id_concepto;
		
		-- a) imprimir en consola
		RAISE NOTICE 'El concepto % ha supuesto un gasto de % €.', v_rec_concepto.nombre, v_gasto_total;
		
		-- b) Si no hay gastos asociados al concepto se almacenará una
		-- notificación de tipo “Advertencia”
		IF v_gasto_total = 0 THEN
			v_texto := 'No hay gastos para el concepto ' || v_rec_concepto.nombre || 
				' . Habría que considerar la opción de borrarlo.';
			INSERT INTO T_NOTIFICACION_PERMISOS(cod_tipo_notificacion, textonotificacion)
			VALUES ('ADV', v_texto);
		
		-- c. En caso contrario:
			-- i. Si el gasto asociado al concepto se ha realizado en el curso académico
			-- 2024/2025 se almacenará una notificación de tipo “Recordatorio”
		ELSE
			SELECT EXISTS (
				SELECT 1 FROM T_GASTO TG
				WHERE v_rec_concepto.identificador = TG.id_concepto AND TG.cod_curso = '2024-2025'
			) INTO v_es_2425;
		
			IF v_es_2425 THEN
			v_texto := 'Ha habido gastos asociado al concepto ' || v_rec_concepto.nombre || 
				' en el curso académico 2024/2025 por importe de ' || v_gasto_total || 
				'€. Hay que analizar la manera de reducir dicho gasto.';
				INSERT INTO T_NOTIFICACION_PERMISOS(COD_TIPO_NOTIFICACION, TEXTONOTIFICACION)
				VALUES ('REC', v_texto);
			ELSE
			-- ii. En cualquier otro caso, se almacenará una notificación de tipo “Informativo”
				v_texto := 'Ha habido gastos asociado al concepto ' || v_rec_concepto.nombre ||
				', pero no en el curso académico 2024/2025. Hay que analizar el motivo.';
				INSERT INTO T_NOTIFICACION_PERMISOS(COD_TIPO_NOTIFICACION, TEXTONOTIFICACION)
				VALUES ('INF', v_texto);

			END IF;
			
		END IF;		
		
	END LOOP;
	
END;
$$ LANGUAGE plpgsql;

-- CALL P_TRATAM_CONCEPTO_GASTOS();

-- 3. Tratamiento de los centros en función del área territorial al que pertenece (recogida como parámetro de entrada) 
CREATE OR REPLACE PROCEDURE p_insertar_notificacion_error(
	IN param_cod_tipo t_notificacion_permisos.COD_TIPO_NOTIFICACION%type,
	IN param_texto TEXT) AS $$
BEGIN
    INSERT INTO t_notificacion_permisos(cod_tipo_notificacion, textonotificacion)
    VALUES (param_cod_tipo, param_texto);
	raise notice 'entra en proc aux';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error insertando notificación: % - %', SQLERRM, SQLSTATE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE p_tratam_centro_area_territorial(IN param_area_territorial t_centro.AREA_TERRITORIAL%TYPE DEFAULT NULL)
AS $$
DECLARE
	v_rec_centro RECORD;
	v_texto TEXT;
	v_num_proyectos INT;
BEGIN 
-- a. Si el parámetro del programa asociado viene vacío:
	IF param_area_territorial IS NULL OR TRIM(param_area_territorial) = '' THEN

	v_texto := 'Se ha introducido un área territorial vacío, por favor introduzca un área territorial válido.';

	-- i. Se guardará una notificación de tipo “Error”
		raise notice 'antes de insertar';
		CALL p_insertar_notificacion_error('ERR', v_texto);
		raise notice 'despues de insertar';
	-- ii. Se lanzará una excepción, con código ‘EX001’, con el mismo texto que la notificación.
		RAISE EXCEPTION 'Se ha introducido un área territorial vacío, por favor introduzca un área territorial válido.'
		USING ERRCODE = 'EX001';
	END IF;

-- b. Para cada centro existente:
	FOR v_rec_centro IN SELECT * FROM T_CENTRO LOOP 
	-- i. Se imprimirá en consola el valor del nombre del centro (en el formato de la actividad 2),
		-- junto con la titularidad así como con el área territorial al que pertenece.
		-- El formato será: “El centro {nombre del centro con formato (*)} perteneciente al área territorial {área territorial} es
		-- de titularidad {titularidad del centro}.”
		RAISE NOTICE 'El centro % pertenecente al área territorial % es de titularidad %',
			F_NOMBRE_CENTRO_DESDE_ID(v_rec_centro.identificador), v_rec_centro.area_territorial, v_rec_centro.titularidad;

		-- ii. Si el centro pertenece al área territorial ‘MadridCapital’, si el centro es de titularidad pública y tiene proyectos asignados
		-- se guardará una notificación de tipo “Advertencia”:

		IF v_rec_centro.area_territorial = 'Madrid-Capital' AND v_rec_centro.titularidad = 'Público' THEN
			SELECT COALESCE(SUM(IDENTIFICADOR), 0) INTO v_num_proyectos FROM T_PROYECTO TP
				WHERE TP.identificador = v_rec_centro.identificador;
				v_texto := 'El centro ' || F_NOMBRE_CENTRO_DESDE_ID(v_rec_centro.identificador) ||
         		' perteneciente al área territorial ' || v_rec_centro.area_territorial ||
          		' es de titularidad ' || v_rec_centro.titularidad ||
          		' y tiene ' || v_num_proyectos || ' asignados.';
			INSERT INTO T_NOTIFICACION_PERMISOS (COD_TIPO_NOTIFICACION, TEXTONOTIFICACION)
			VALUES ('ADV', v_texto);
		END IF;
		
	END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL P_TRATAM_CENTRO_AREA_TERRITORIAL('Madrid-Capital');












