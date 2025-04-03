/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Mar 14, 2025
 * Script: 6.8- Exepción y Auditoría
 */

/* -- CREACIÓN DE TABLAS 

CREATE TABLE T_NOTIFICACION_PERMISOS (
	identificador serial PRIMARY KEY,
	textoNotificacion text,
	cod_tipo_notificacion char(3),
	fecha_creacion timestamp DEFAULT current_timestamp
);

CREATE TABLE T_TIPO_NOTIFICACION (
	cod_tipo_notificacion char(3) PRIMARY KEY,
	nombre_tipo varchar(50)
);

ALTER TABLE t_notificacion_permisos
	ADD CONSTRAINT fk_id_cod_tipo_notif FOREIGN KEY (cod_tipo_notificacion)
		REFERENCES t_tipo_notificacion (cod_tipo_notificacion);

INSERT INTO t_tipo_notificacion (cod_tipo_notificacion, nombre_tipo)
VALUES
	('INF', 'Información'),
	('ADV', 'Advertencia'),
	('ERR', 'Error'),
	('ACT', 'Actualización'),
	('REC', 'Recordatorio');

-- PROGRAMACIÓN CON PROCEDIMIENTO

CREATE OR REPLACE PROCEDURE p_tratar_permisos_act_6_8(
	IN opcion int,
	IN usuario_origen T_USUARIO.usuario%TYPE, -- %TYPE para que sde corresponda el tipo de campo de "usuario" de T_USUARIO
	IN usuario_destino T_USUARIO.usuario%TYPE)
AS $$
DECLARE
		v_nombre_usuario_origen varchar(50);
		v_apellidos_usuario_origen varchar(50);
		v_nombre_usuario_destino VARCHAR(50);
   		v_apellidos_usuario_destino VARCHAR(50);

		v_id_rol_admin INT;
		v_es_admin BOOLEAN;

BEGIN

	-- Obtenemos el nombre y apellidos del param usuario_origen
	SELECT
		-- Extraer el nombre antes del primer '.'
		-- SUBSTRING(cadena FROM inicio FOR longitud)
		SUBSTRING(email FROM 1 FOR POSITION('.' IN email) - 1),
		-- Extraer los apellidos entre el '.' y el '@'
		SUBSTRING(email FROM POSITION('.' IN email) + 1 FOR POSITION('@' IN email) - POSITION('.' IN email) - 1),
	INTO v_nombre_usuario_origen, v_apellido_usuario_origen
	FROM t_usuario
		-- Busca el usuario_origen en la tabla
		WHERE usuario = usuario_origen;

	-- Obtenemos el identificador del rol de Administrador
	SELECT identificador INTO v_id_rol_admin
	FROM t_rol
		WHERE nombre = 'Administrador';

	-- Verificar si el usuario_origen tiene rol de Administrador
	

	-- Obtenemos el nombre y apellidos del param usuario_destino
	SELECT
		SUBSTRING(email FROM 1 FOR POSITION('.' IN email) - 1),
		SUBSTRING(email FROM POSITION('.' IN email) + 1 FOR POSITION('@' IN email) - POSITION('.' IN email) - 1),
	INTO v_nombre_usuario_destino, v_apellido_usuario_destino
	FROM t_usuario
		WHERE usuario = usuario_destino;


END;
$$ LANGUAGE plpgpsql;

CREATE OR REPLACE PROCEDURE p_CLASE_tratar_permisos_act_6_8(
	IN opcion int,
	IN usuario_origen T_USUARIO.usuario%TYPE, -- %TYPE para que sde corresponda el tipo de campo de "usuario" de T_USUARIO
	IN usuario_destino T_USUARIO.usuario%TYPE) AS $$

DECLARE

		v_rol_origen varchar(50);
		v_rol_destino varchar(50);

		v_usuario_origen_es_admin BOOLEAN := FALSE;
		v_usuario_destino_es_admin BOOLEAN := FALSE;

		v_nombre_apellidos_usuario_origen VARCHAR(100);
		v_nombre_apellidos_usuario_destino VARCHAR(100);

		v_texto_notificacion text;

BEGIN

	v_nombre_apellidos_usuario_origen := (f_sacar_nombre_apellidos(usuario_origen));

	IF NOT v_usuario_origen_es_admin THEN
		raise notice 'Notificación + Excepción';
		raise exception 'Usuario %, no tienes permisos de Admin'
			using errcode = 'P0001'
	ELSE
		-- Asignar rol de administrador
		IF opcion = 1 then
			raise notice '1';

		ELSIF opcion = 2 then
			raise notice '2';

		ELSE
			raise exception 'El sistema no está preparado para ejecutar la opción seleccionada.'
				using errcode = 'P0002';
		END IF;

		raise notice 'Opciones';
	END IF;


EXCEPTION
	WHEN SQLSTATE 'P001' THEN
	v_texto_notificacion := 'El usuario con ' || v_nombre_apellidos_usuario_origen || 'no tiene Rol de Admin y ha intentado una acción que necesita rol de Admin';
	
	-- insertar notificación
	INSERT INTO t_notificacion_permisos (texto_notificacion, cod_tipo_notificacion)
		VALUES (v_texto_notificacion, 'ERR');
	RAISE NOTICE 'Error: %-%', sqlerrm, sqlstate;	


END;
$$ LANGUAGE plpgpsql;

CREATE OR REPLACE FUNCTION f_sacar_nombre_apellidos(usuario t_usuario.usuario%type)
	RETURNS VARCHAR AS $$
DECLARE
	v_nombre_apellidos VARCHAR;
	v_correo t_usuario.email%type;
	v_nombre varchar;
	v_apellidos varchar;
BEGIN
	SELECT email INTO v_correo
	FROM t_usuario
		WHERE usuario = usuario_correo;
	
	v_nombre_apellidos := split_part(v_correo, '@', 1);

	v_nombre := INITCAP(split_part(v_nombre_apellidos, '.', 1));
	v_apellidos := INITCAP(split_part(v_nombre_apellidos, '.', 2));

	v_nombre_apellidos := CONCAT(v_nombre, ' ', v_apellidos);

	return v_nombre_apellidos;
	
END;
$$ LANGUAGE plpgsql;

f_ser_rol_administrador('albanavarro');

CREATE OR REPLACE FUNCTION f_ser_rol_administrador(param_usuario t_usuario.usuario%TYPE)
	RETURNS BOOLEAN AS $$

DECLARE
	v_es_admin BOOLEAN := FALSE;
	v_id_rol INT;

BEGIN
	SELECT r.identificador INTO v_id_rol
	FROM t_rol r JOIN t_usuario_rol ur
		ON ur.id_rol = r.identificador
		JOIN t_usuario u
		ON u.identificador = ur.id_usuario
			WHERE u.usuario = param_usuario
			AND r.nombre = 'Administrador';
	
	IF v_id_rol IS NOT NULL THEN
		v_es_admin := TRUE;	
	END IF;

	RETURN v_es_admin;
END;
$$ LANGUAGE plpgsql;*/




























