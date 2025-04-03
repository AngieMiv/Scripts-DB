/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Mar 24, 2025
 * Script: 6.10- Triggers para el Alta/Baja/Modificación de datos de USUARIO.
 */

CREATE OR REPLACE PROCEDURE p_mod_estado_usuario(IN param_accion char(1), IN param_usuario t_usuario.usuario%TYPE)
AS $$
DECLARE 

BEGIN

	-- Validación del parametro acción
	IF upper(param_accion) NOT IN ('S','B') THEN
		RAISE EXCEPTION
			'El valor del campo Acción no es correcto; asigna un valor válido b/B o s/S.'
		USING ERRCODE = 'P0001';
	
	-- Validación de la información del campo usuario
	ELSEIF param_usuario IS NULL OR param_usuario = '' THEN
		RAISE EXCEPTION
			'El campo usuario es obligatorio, rellénalo y ejecuta de nuevo la acción'
		USING ERRCODE = 'P0002';
	END IF;

	-- Acción sobre los datos del alumno: Actualización del estado a Inactivo
	IF upper(param_accion) = 'B' THEN
	RAISE NOTICE 'B: baja del usuario. Modificación del Estado: Inactivo';
		UPDATE T_USUARIO
		SET estado = 'Inactivo'
		WHERE usuario = param_usuario;
		RAISE NOTICE 'El Estado del Usuario % se actualiza a Inactivo', param_usuario;

	-- Acción sobre los datos del alumno: Actualización del estado a Suppendido 
	ELSEIF upper(param_accion) = 'S' THEN
		UPDATE T_USUARIO
		SET estado = 'Suspendido'
		WHERE usuario = param_usuario;
		RAISE NOTICE 'El Estado del Usuario % se actualiza a Suspendido', param_usuario;
	
	END IF;
	
END $$
LANGUAGE plpgsql;

-- Llamada al procedure
CALL p_mod_estado_usuario('s', 'rubentorres');


/* no es necesario especificar las tablas porque el trigger está definido sobre T_USUARIO
entonces OLD y NEW solo tienen acceso a esa tabla */
-- creación de la "fx del trigger"
CREATE OR REPLACE FUNCTION f_trigg_quitar_roles_usuario_suspendido()
RETURNS TRIGGER AS $$
DECLARE
	v_num_roles int;
BEGIN
	
	-- Operacion realizada, trigger operation:
	RAISE NOTICE 'Valor de la v TG_OP: %', TG_OP;
	-- valores de antes y después de disparar el TRIGGER. 
	RAISE NOTICE 'Valor de la v OLD de estado: % y v NEW de estado', OLD.estado, NEW.estado;
	RAISE NOTICE 'Usuario al que se le cambia el estado: %, id: %' , NEW.usuario, NEW.identificador;
	
	-- Si el estado del alumno cambia a suspendido (y solo si hay cambios en dicho valor), 
	IF OLD.estado <> NEW.estado AND NEW.estado = 'Suspendido' THEN
		-- se eliminan los roles que tenía el alumno ahora suspendido
		DELETE FROM T_USUARIO_ROL
		WHERE id_usuario = NEW.identificador;

		RAISE NOTICE 'El usuario % ha sido suspendido y se le han quitado sus roles', NEW.usuario;
	END IF;

	IF OLD.estado <> NEW.estado AND NEW.estado = 'Inactivo' THEN
		select count(*) into v_num_roles
			from t_usuario_rol
			where id_usuario = new.identficador;

		raise notice 'v_num_roles: %', v_num_roles;
		
	END IF;
	
END
$$ LANGUAGE plpgsql;

/* no es necesario especificar las tablas porque el trigger está definido sobre T_USUARIO
entonces OLD y NEW solo tienen acceso a esa tabla */
-- Creación del trigger:
CREATE OR REPLACE TRIGGER t_quitar_roles_usuario_suspendido
	AFTER UPDATE OF estado ON T_USUARIO	-- TRIGGER después del UPDATE en T_USUARIO
	FOR EACH ROW
	EXECUTE FUNCTION f_trigg_quitar_roles_usuario_suspendido();
