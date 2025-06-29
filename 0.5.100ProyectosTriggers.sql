/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: May 26, 2025
 * Script: 99.10 - RA5 - Triggers
 */

-- 1. Antes de insertar un nuevo centro, convierta el valor del 
-- campo nombre a mayúsculas (para mantener la homogeneidad en los registros).
CREATE OR REPLACE FUNCTION f_trigg_insertar_centro_mayus()
RETURNS TRIGGER AS $$
DECLARE
BEGIN
	NEW.nombre := UPPER(NEW.nombre);
	
	RAISE NOTICE 'Valor de la variable NEW: %', NEW;
	RAISE NOTICE 'Valor de la variable OLD: %', OLD;
	RAISE NOTICE 'Valor de la variable TG_OP: %', TG_OP;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_insertar_centro_mayus
BEFORE INSERT 									-- AFTER, BEFORE -- INSERT, UPDATE, DELETE, TRUNCATE.
ON T_CENTRO										-- En qué tabla
FOR EACH ROW 									-- la "función del Trigger" se dispara para cada fila
EXECUTE FUNCTION f_trigg_insertar_centro_mayus();	-- Nombre de la función que se va a ejecutar cuando se dispare el TRIGGER

--INSERT INTO t_centro (identificador, nombre, tipo, area_territorial, titularidad, titular, CODIGO_CENTRO, direccion, TELEFONO )
--VALUES (999, 'Centro de prueba', 'Primaria', 'Madrid-Capital', 'Privado', 'Mi comunidad', 88888888, 'Calle Imaginaria 42', '666666666');

--SELECT nombre FROM t_centro WHERE identificador = 999;

-- 2. Crear un programa que valide, automáticamente antes de
-- borrar un nuevo centro, si éste tiene algún proyecto asociado.
-- Si tiene algún proyecto asociado se cancelará la operación.

CREATE OR REPLACE FUNCTION f_trigg_validar_borrado_centro()
RETURNS TRIGGER AS $$
DECLARE
BEGIN
	IF EXISTS (
		SELECT 1 FROM t_proyecto
		WHERE id_centro = OLD.identificador
	) THEN 
	RAISE EXCEPTION 'No se puede borrar el centro % porque tiene proyectos asociados', OLD.nombre;
	END IF;

	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_validar_borrado_centro
BEFORE DELETE
ON t_centro
FOR EACH ROW
EXECUTE FUNCTION f_trigg_validar_borrado_centro();

-- DELETE FROM t_centro WHERE identificador = 4;


-- 3. Crear un programa en la base de datos que registre automáticamente
-- en una tabla de cambios históricos, después de actualizar los datos de un centro
-- si hay cambios en el nombre y en la dirección del centro.
CREATE OR REPLACE FUNCTION f_trigg_registrar_actualizacion_centro()
RETURNS TRIGGER AS $$
DECLARE
BEGIN
	IF NEW.nombre IS DISTINCT FROM OLD.nombre OR
	NEW.direccion IS DISTINCT FROM OLD.direccion THEN
		INSERT INTO t_historico_centro(id_centro, nombre_anterior, nombre_nuevo, direccion_anterior, direccion_nueva)
		VALUES (OLD.identificador, OLD.nombre, NEW.nombre, OLD.direccion, NEW.direccion);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_registrar_actualizacion_centro
AFTER UPDATE
ON t_centro
FOR EACH ROW
EXECUTE FUNCTION f_trigg_registrar_actualizacion_centro();

/*UPDATE T_CENTRO
SET nombre = 'IES Ejemplo Modificado',
    direccion = 'Calle Tal 123'
WHERE identificador = 1;   -- funciona, cambiar los datos para otra prueba */

-- 4. Crear un programa en la base de datos que permita comprobar, automáticamente,
-- que la fecha en la que se realizó un gasto esté comprendida
-- entre la fecha de inicio y de fin del curso académico al que está asociado el gasto. El
-- programa tendrá que realizarlo antes de insertar o actualizar el gasto.
-- Si la fecha no está comprendida en el rango de fechas, se debe cancelar la operación.
CREATE OR REPLACE FUNCTION f_trigg_comprobacion_fecha_gastos()
RETURNS TRIGGER AS $$
DECLARE
	v_fecha_inicio date;
	v_fecha_fin date;
BEGIN
	SELECT fecha_inicio, fecha_fin INTO v_fecha_inicio, v_fecha_fin FROM T_CURSO_ACADEMICO CA
		WHERE CA.codigo = NEW.cod_curso;

	IF NEW.fecha_gasto IS NOT NULL AND NEW.fecha_gasto < v_fecha_inicio OR NEW.fecha_gasto > v_fecha_fin THEN
		RAISE EXCEPTION 'La fecha % del gasto no es del curso académico comprendido entre % - %', NEW.fecha_gasto, v_fecha_inicio, v_fecha_fin;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_comprobacion_fecha_gastos
BEFORE INSERT OR UPDATE
ON t_gasto
FOR EACH ROW
EXECUTE FUNCTION F_TRIGG_COMPROBACION_FECHA_GASTOS();

-- 5. Crear un programa con el que, después de insertar un nuevo gasto,
-- registre automáticamente en una tabla de auditoría los datos insertados
-- junto con la fecha y usuario del sistema.
CREATE OR REPLACE FUNCTION f_trigg_insert_auditoria_gasto()
RETURNS TRIGGER AS $$
DECLARE
BEGIN
	INSERT INTO t_auditoria_gasto(id_gasto, id_concepto, id_proyecto, cod_curso, fecha_gasto, precio_unidad, num_unidades, observacion, fecha_creacion, usuario)
	VALUES (NEW.identificador, NEW.id_concepto, NEW.id_proyecto, NEW.cod_curso, NEW.fecha_gasto, NEW.precio_unidad, NEW.num_unidades, NEW.observacion, NEW.fecha_creacion, CURRENT_USER);

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_insert_auditoria_gasto
AFTER INSERT
ON t_gasto
FOR EACH ROW
EXECUTE FUNCTION f_trigg_insert_auditoria_gasto();

/*INSERT INTO T_GASTO (id_concepto, id_proyecto, cod_curso, fecha_gasto, precio_unidad, num_unidades, observacion)
VALUES (1, 2, '2024-2025', '2025-05-20', 15.00, 1, 'Compra de libros');

SELECT * FROM T_AUDITORIA_GASTO; -- funciona, cambiar datos para otra prueba*/

-- 6. Crear un programa que, antes de insertar un nuevo ingreso,  modifique automáticamente el campo observación
-- (siempre y cuando este no tenga un valor) teniendo en cuenta los siguientes requerimientos:
	-- a. Si el ingreso es menor de cero se cancelará la operación.
	-- b. Si el ingreso es < 1000 el campo observación tomará el siguiente valor:
		-- “Ingreso realizado por el patrocinador {nombre del patrocinador}”.
	-- c. Si el ingreso está entre 1000 y 2000 el campo observación tomará el siguiente valor:
		-- “Ingreso realizado por el patrocinador {nombre del patrocinador} para el proyecto {nombre del proyecto}”.
	-- d. En cualquier otro caso el valor del campo observación tomará el siguiente valor:
		-- “Ingreso realizado por el patrocinador {nombre del
		-- patrocinador} para el centro {nombre del centro con código (*)}”

CREATE OR REPLACE FUNCTION f_trigg_observac_ingreso()
RETURNS TRIGGER AS $$
DECLARE
	v_observacion t_ingreso.observacion%TYPE;
	v_patrocinador t_patrocinador.nombre%TYPE;
	v_proyecto t_proyecto.nombre%TYPE;
	v_idCentro t_centro.identificador%TYPE;
BEGIN

	IF NEW.cantidad < 0 THEN
		RAISE EXCEPTION 'Operación cancelada, el ingreso no puede ser menor a 0';
	END IF;


	IF NEW.observacion IS NULL THEN

		SELECT nombre INTO v_patrocinador FROM T_PATROCINADOR
			WHERE identificador = NEW.id_patrocinador;

		SELECT nombre, id_centro INTO v_proyecto, v_idCentro FROM T_PROYECTO 
			WHERE identificador = NEW.id_proyecto;

		IF new.cantidad < 1000 THEN
			v_observacion := 'Ingreso realizado por el patrocinador ' || v_patrocinador;
			NEW.observacion := v_observacion;

		ELSIF new.cantidad BETWEEN 1000 AND 2000 THEN
			v_observacion := 'Ingreso realizado por el patrocinador ' || v_patrocinador || ' para el proyecto ' || v_proyecto;
			NEW.observacion := v_observacion;

		ELSE
			v_observacion := 'Ingreso realizado por el patrocinador ' || v_patrocinador || ' para el proyecto' || v_proyecto ||
				'para el centro ' || F_NOMBRE_CENTRO_DESDE_ID(v_idCentro);
			NEW.observacion := v_observacion;

		END  IF;

	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_observac_ingreso
BEFORE INSERT
ON t_ingreso
FOR EACH ROW
EXECUTE FUNCTION f_trigg_observac_ingreso();

INSERT INTO T_INGRESO (id_patrocinador, id_proyecto, cod_curso, fecha_ingreso, cantidad)
	VALUES (1, 1, '2022-2023', '2024-09-15', 2800.00);

select identificador, cantidad, observacion from t_ingreso where identificador = (select max(identificador) from t_ingreso);


