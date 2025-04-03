/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Mar 28, 2025
 * Script: 6.12- Práctica para el Alta de Usuarios a partir de datos del personal
 */

-- Primero creamos la extensión unaccent para quitar las tíldes que haya, para poder usarlo igual que el lower()
CREATE EXTENSION IF NOT EXISTS unaccent;


-- Función para pasar todo a minúsculas y quitar las tildes
/*CREATE OR REPLACE FUNCTION f_lower_unaccent(param_texto varchar)
RETURNS varchar AS $$
BEGIN
	RETURN lower(unaccent(param_texto));
END;
$$ LANGUAGE plpgsql;*/


-- Procedimiento para asignar el rol "Invitado" a los usuarios dados de alta, o si ya existe pero no tiene ninguno, asignárselo
CREATE OR REPLACE PROCEDURE p_asignar_rol_invitado (
	IN param_usuario T_USUARIO.usuario%TYPE
) AS $$
DECLARE
	v_id_usuario T_USUARIO.identificador%TYPE;
	v_id_rol_invitado T_ROL.identificador%TYPE;
	v_tiene_rol boolean;
BEGIN
	-- obtenemos el identificador del usuario
	SELECT identificador INTO v_id_usuario
	FROM T_USUARIO
		WHERE usuario = param_usuario;

	-- obtehemos el id de rol "Invitado" (por alguna razón me salta el underline en rojo en v_id_rol_invitado si lo pongo después del select exists)
	SELECT identificador INTO v_id_rol_invitado
	FROM T_ROL
		WHERE nombre = 'Invitado';
	
	-- miramos si el usuario tiene roles asignados y lo metemos en el boolean v_tiene_rol
	SELECT EXISTS (
	    SELECT FROM t_usuario_rol
	    WHERE id_usuario = v_id_usuario
	) INTO v_tiene_rol;
	
	raise notice 'v_tiene_rol = %', v_tiene_rol;

	IF NOT v_tiene_rol THEN
		INSERT INTO T_USUARIO_ROL(id_usuario, id_rol)
		VALUES (v_id_usuario, v_id_rol_invitado);
		RAISE NOTICE '(p_asignar_rol_invitado): Se le ha asignado el rol de Invitado al usuario %', param_usuario;
	ELSE
		RAISE NOTICE '(p_asignar_rol_invitado): El usuario % ya tiene roles asignados', param_usuario;
	END IF;

END;
$$ LANGUAGE plpgsql;


-- Procedimiento para crear el usuario si no existe desde los datos de la t_personal
CREATE OR REPLACE PROCEDURE p_altaUsuario_fromPersonal (
	IN param_nombre T_PERSONAL.nombre%TYPE,
	IN param_apellido1 T_PERSONAL.apellido1%TYPE,
	IN param_dni T_PERSONAL.dni%TYPE 
)
AS $$
DECLARE
	v_usuario T_USUARIO.usuario%TYPE;
	v_email T_USUARIO.email%TYPE;
	v_usuario_existe boolean; 
BEGIN
	-- generamos el usuario y email en t_usuario desde los datos de t_personal
	
	-- usuario: sin tildes y en minus, 3 iniciales de nombre + 3 iniciales de apellido + 4 ultimos chars del DNI
	v_usuario := lower(unaccent(
		substring(param_nombre FROM 1 FOR 3) || substring(param_apellido1 FROM 1 FOR 3) || RIGHT(param_dni, 4)
	));/*::T_USUARIO.usuario%type*/ -- Casteo porque la funcion ésta me devuelve un tipo text
	
	-- email: sin tildes y en minus, nombre + '.' + apellido1 + 4 ultimos chars del dni + @educa.madrid.org
	v_email := lower(unaccent(
		param_nombre || '.' || param_apellido1 || RIGHT(param_dni, 4) ||'@educa.madrid.org'
	));/*::T_USUARIO.email%type;*/
	
	-- miramos si el usuario ya existe
	SELECT EXISTS ( -- el SELECT EXISTS devuelve TRUE o FALSE, que lo meteremos INTO v_usuario_existe que es un boolean
		SELECT usuario FROM T_USUARIO WHERE usuario = v_usuario
	) INTO v_usuario_existe;
	
	-- si el usuario no existe, le damos de alta y le asignamos el rol 'Invitado'
	IF v_usuario_existe = FALSE THEN
		INSERT INTO T_USUARIO(usuario, email, estado)
		VALUES (v_usuario, v_email, 'Activo');
		RAISE NOTICE '(p_altaUsuario_fromPersonal): Usuario % con email % creado con estado Activo', v_usuario, v_email;
		-- Le asignamos el rol de invitado al usuario creado
		CALL P_ASIGNAR_ROL_INVITADO(v_usuario);
		RAISE NOTICE '(p_altaUsuario_fromPersonal): Asignado rol de Invitado al usuario nuevo %', v_usuario;
	
	-- si ya existe pero no tiene rol, asignamos el rol de invtado con el procedure, que ya mira si tiene o no roles
	ELSE
		CALL P_ASIGNAR_ROL_INVITADO(v_usuario);
		RAISE NOTICE '(p_altaUsuario_fromPersonal): Asignado rol de Invitado al usuario %', v_usuario;	
		
	END IF;
			
END;
$$ LANGUAGE plpgsql;


-- "Función" del trigger
CREATE OR REPLACE FUNCTION f_trigg_alta_usuario()
RETURNS TRIGGER AS $$
DECLARE
BEGIN
	-- llamamos al procedimiento que da de alta al usuario
	CALL p_altaUsuario_fromPersonal(new.nombre, new.apellido1, new.dni);
	RETURN NEW;	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER t_alta_usuario
BEFORE INSERT ON T_PERSONAL
FOR EACH ROW
EXECUTE FUNCTION f_trigg_alta_usuario();


DO $$
DECLARE
	cur_t_personal CURSOR FOR
		SELECT tp.*
		FROM T_PERSONAL tp
			join T_PERSONAL_USUARIO tpu on tp.dni = tpu.dni
			join T_USUARIO tu on tpu.email = tu.email
			where tu.identificador not in (select tur.id_usuario
											from t_usuario_rol tur);

	reg_personal_no_usuario RECORD;
	v_dni T_PERSONAL.dni%TYPE;
	v_usuario T_USUARIO.usuario%TYPE;
BEGIN
	OPEN cur_t_personal;

	LOOP
		FETCH cur_t_personal into reg_personal_no_usuario;
		EXIT WHEN NOT FOUND;
		raise notice 'registro del personal no usuario %', reg_personal_no_usuario;
			
		CALL p_asignar_rol_invitado(v_usuario);
	END LOOP;

	CLOSE cur_t_personal;
END $$;


-- probamos el dar de alta de un usuario que no existe

/*spoiler: no funciona
 * SQL Error [42601]: ERROR: query has no destination for result data
  Hint: If you want to discard the results of a SELECT, use PERFORM instead.
  Where: PL/pgSQL function p_asignar_rol_invitado(character varying) line 18 at SQL statement
SQL statement "CALL P_ASIGNAR_ROL_INVITADO(v_usuario)"
PL/pgSQL function p_altausuario_frompersonal(character varying,character varying,character) line 30 at CALL
SQL statement "CALL P_ALTAUSUARIO_FROMPERSONAL(NEW.nombre, NEW.apellido1, NEW.dni)"
PL/pgSQL function f_trigg_alta_usuario() line 5 at CALL
*
* No funcionaba bc en p_asignar_rol_invitado la sentencia select exists hay que usar PERFORM,
* ya que no necesito el resultado de la consulta, solo quiero saber si existe un registro
**/

/*
 * Me seguía dando error por el tema de la funcion esta que hice que me devuelve un text
 **/

/* Bueno pues sigue sin funcionar
 * SQL Error [3F000]: ERROR: schema "t_usuario" does not exist
  Where: PL/pgSQL function p_altausuario_frompersonal(character varying,character varying,character) line 10 at assignment
SQL statement "CALL P_ALTAUSUARIO_FROMPERSONAL(NEW.nombre, NEW.apellido1, NEW.dni)"
PL/pgSQL function f_trigg_alta_usuario() line 5 at CALL
**/

INSERT INTO T_PERSONAL(DNI, NOMBRE, APELLIDO1, APELLIDO2)
VALUES ('56473829I', 'Isidoro', 'Nevares', 'Martín');

INSERT INTO T_PERSONAL(DNI, NOMBRE, APELLIDO1, APELLIDO2)
VALUES ('22222222A', 'Alba', 'Martínez', 'González');

-- probamos con otro que sí existe pero no tiene roles
INSERT INTO T_PERSONAL(DNI, NOMBRE, APELLIDO1, APELLIDO2)
VALUES ('45678342X', 'Nataly', 'Reyes', 'Campos');




