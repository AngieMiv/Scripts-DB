/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 23/03/2025
Script: Script asociado a las funcionalidades descritas en la actividad 6.13.
*/

-- Definición de un tipo compuesto que contenga la información de un alumno.
create type informacion_alumno as(
	dni char(9), 
	nombre varchar(50),
	apellido1 varchar(50),
	apellido2 varchar(50),
	fecha_nacimiento date
);

-- Pruebas del procedimiento.
delete from t_alumno
where dni = '30127737Z';

delete from t_personal
where dni = '30127737Z';


do $$
declare
	v_informacion_alumno informacion_alumno;
begin
	v_informacion_alumno.dni:='30127737Z'; -- 01234567J-  89012345H - 30127737Z
	v_informacion_alumno.nombre='Margarita';
	v_informacion_alumno.apellido1:='Salas';
	v_informacion_alumno.fecha_nacimiento:='2000-05-23';

	call p_realizar_alta_alumno(v_informacion_alumno);
end;
$$ language plpgsql;

*/

create or replace procedure p_realizar_alta_alumno(param_informacion_alumno informacion_alumno) 
	as $$
declare

	
begin

	-- raise notice '%', param_informacion_alumno;
	if (param_informacion_alumno.dni is null 
		or param_informacion_alumno.nombre is null
		or param_informacion_alumno.apellido1 is null 
		or param_informacion_alumno.fecha_nacimiento is null) then
		raise exception 'Los campos dni, nombre, apellido1 y fecha de nacimiento son obligatorios; complételos y ejecute de nuevo la acción.'
			using errcode = 'P0001';
	elsif not es_dni_valido(param_informacion_alumno.dni) then 
		raise exception 'El DNI/NIF % es incorrecto, por favor introduzca un DNI con el formato correcto.', param_informacion_alumno.dni
			using errcode = 'P0002';
	elsif f_existir_alumno(param_informacion_alumno.dni) then
		raise exception 'Existe un alumno con dni % dado de alta como alumno. Inténtelo con datos de otro alumno.', param_informacion_alumno.dni
			using errcode = 'P0003';
	else
		-- Es el caso de que hay datos en t_personal pero no en t_alumno.
		if not f_existir_personal(param_informacion_alumno.dni) then
			-- raise notice 'tratamiento alta personal';
			insert into t_personal (dni,nombre,apellido1,apellido2)
				values (param_informacion_alumno.dni, param_informacion_alumno.nombre,param_informacion_alumno.apellido1, param_informacion_alumno.apellido2);
		end if;		
		-- raise notice 'tratamiento alta alumno';
		-- Se inserta la información de alumno
		insert into t_alumno (dni,fecha_nacimiento)
			values (param_informacion_alumno.dni, param_informacion_alumno.fecha_nacimiento);
	end if;

end;
$$ language plpgsql;


create or replace function es_dni_valido(param_dni char) 
	returns boolean as $$
declare 
	v_dni_correcto boolean:= false;
	v_ultimo_caracter char;
	V_LISTA_CARACTERES constant varchar := 'TRWAGMYFPDXBNJZSQVHLCKE';
begin
	-- raise notice 'param_dni: %', param_dni;
	v_ultimo_caracter:=substring(param_dni, 9, 1);
	-- raise notice 'v_ultimo_caracter: %', v_ultimo_caracter;

	if char_length(param_dni) = 9 and position(upper(v_ultimo_caracter) in V_LISTA_CARACTERES) != 0 then 
		v_dni_correcto:=true;
	end if;

	return v_dni_correcto;
end;
$$ language plpgsql;

-- Función que valida, partiendo de un DNI, si existe o no un alumno (registro en t_alumno)
create or replace function f_existir_alumno(param_dni char) 
	returns boolean as $$
declare
	v_existe_alumno boolean:= false;
	v_numero_alumno t_alumno.numero_alumno%type;
begin
	select numero_alumno into v_numero_alumno
	from t_alumno 
	where dni=param_dni;

	if v_numero_alumno is not null then
		v_existe_alumno:= true;
	end if;

	return  v_existe_alumno;

end;
$$language plpgsql;

-- Función que valida, partiendo de un DNI, si existe o no una persona (registro en t_personal)
create or replace function f_existir_personal(param_dni char) 
	returns boolean as $$
declare
	v_existe_personal boolean:= false;
	v_dni_personal t_personal.dni%type;
begin
	select dni into v_dni_personal
	from t_personal 
	where dni=param_dni;

	if v_dni_personal is not null then
		v_existe_personal:= true;
	end if;

	return  v_existe_personal;

end;
$$language plpgsql;

-- Función que valida, partiendo de un DNI, si existe o no un gestor (registro en t_gestor)
create or replace function f_existir_gestor(param_dni char) 
	returns boolean as $$
declare
	v_existe_gestor boolean:= false;
	v_dni_gestor t_gestor.dni%type;
begin
	select dni into v_dni_gestor
	from t_gestor 
	where dni=param_dni;

	if v_dni_gestor is not null then
		v_existe_gestor:= true;
	end if;

	return  v_existe_gestor;

end;
$$language plpgsql;


-- Función del Trigger BEFORE t_validar_existencia_gestor
create or replace function f_trigger_validar_existencia_gestor()
	returns trigger as $$
declare
begin
	/*
	raise notice 'f_trigger_validar_existencia_gestor - new %', new;
	raise notice 'f_trigger_validar_existencia_gestor - old %', old;
	raise notice 'f_trigger_validar_existencia_gestor - tg_op %', tg_op;
	*/
	if f_existir_gestor(new.dni) then
		raise exception 'Ya existe un gestor con DNI/NIF %; no es posible estar dado de alta en el sistema como alumno y como gestor a la vez.', new.dni
			using errcode = 'P0004';
	end if;

	return new;
end;
$$ language plpgsql;

-- Trigger BEFORE que permitirá validar que no exista un gestor con el mismo dni
-- que el alumno que se va a insertar.
create or replace trigger t_validar_existencia_gestor
	before 
	insert
	on t_alumno
	for each row
execute function f_trigger_validar_existencia_gestor();



-- Función del trigger AFTER, t_insertar_personal
create or replace function f_trigger_insertar_personal()
	returns trigger as $$
declare
begin
	/*
	raise notice 'f_trigger_insertar_persona - new %', new;
	raise notice 'f_trigger_insertar_persona - old %', old;
	raise notice 'f_trigger_insertar_persona - tg_op %', tg_op;

	raise notice 'Realizar alta usuario';
	*/
	call p_crear_nuevo_usuario(new);
	return new;
end;
$$ language plpgsql;


-- Creación de un trigger AFTER, para gestionar el tratamiento tras 
-- la inserción en la tabla T_PERSONAL
create or replace trigger t_insertar_personal
	after
	insert
	on t_personal
	for each row
execute function f_trigger_insertar_personal();