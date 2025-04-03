/*
 * PROPUESTA SOLUCIÓN AL 6.8, Excepcion Notificaciones
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 18/03/2025
Script: Script asociado a las funcionalidades descritas en la actividad 6.8.
		Versión simplificada sin Auditoría
*/

-- DDL Creación tabla que define los Tipos de Notificación.
create table if not exists T_TIPO_NOTIFICACION(
	codigo char(3) not null primary key,
	nombre varchar(50) not null
);

-- DDL Creación tabla que almacenará las Notificaciones sobre las Base de Datos de Gestión de Permisos.
create table if not exists T_NOTIFICACION_PERMISOS(
	identificador serial not null primary key,
	cod_tipo_notificacion char(3) not null,
	texto_notificacion text not null,
	fecha_alta timestamp not null default current_timestamp,
	constraint FK_NOTIFICACION_TIPONOTIFICACION 
		foreign key (cod_tipo_notificacion) references T_TIPO_NOTIFICACION (codigo)
);

-- DML para la carga inicial de datos en Tipo de Notificación.
insert into T_TIPO_NOTIFICACION(codigo, nombre) values
	('INF', 'Información'),
	('ADV', 'Advertencia'),
	('ERR', 'Error'),
	('ACT', 'Actualización'),
	('REC', 'Recordatorio');

-- call p_tratar_permisos_act_6_8(1, 'rubentorres', 'cesarmolina');
-- call p_tratar_permisos_act_6_8(1, 'mariagomez', 'cesarmolina');
-- call p_tratar_permisos_act_6_8(2, 'cesarmolina', 'cesarmolina');
-- call p_tratar_permisos_act_6_8(3, 'mariagomez', 'cesarmolina');

create or replace procedure p_tratar_permisos_act_6_8( param_opcion int , 
													param_cod_usuario_origen varchar, 
													param_cod_usuario_destino varchar)
as $$
declare
	-- Variables que se usarán a lo largo del procedimiento.
	v_usuario_tiene_rol_administador boolean;

	-- Nombres y Apellidos de usuarios
	v_nombre_apellidos_origen varchar;
	v_nombre_apellidos_destino varchar;

	-- Información para Notificaciones
	v_cod_tipo_notificacion t_tipo_notificacion.codigo%type;
	v_texto_notificacion t_notificacion_permisos.texto_notificacion%type;

	-- Información para Excepción
	v_texto_excepcion text;

begin
	-- raise notice 'param_opcion: % , param_cod_usuario_origen: % , param_cod_usuario_destino: %', param_opcion , param_cod_usuario_origen , param_cod_usuario_destino;	

	select f_es_usuario_rol_administrador(param_cod_usuario_origen) into v_usuario_tiene_rol_administador;

	if not v_usuario_tiene_rol_administador then -- Comparación 
		raise notice 'No es usuario administrador. Lanzar excepción';
		-- Lanzar Excepcion
		v_nombre_apellidos_origen:= (select f_obtener_nombre_apellidos_usuario(param_cod_usuario_origen));
		v_texto_excepcion:=v_nombre_apellidos_origen || ': No tienes rol de Administrador; rol que tiene los permisos para realizar esta acción.';
		raise exception '%', v_texto_excepcion  USING ERRCODE = 'P0001';	
	else
		raise notice 'Es usuario administrador';
		v_nombre_apellidos_origen:= (select f_obtener_nombre_apellidos_usuario(param_cod_usuario_origen));
		v_nombre_apellidos_destino:= (select f_obtener_nombre_apellidos_usuario(param_cod_usuario_destino));
		case param_opcion
			when 1 then -- Asignar rol Administrador a usuario
				v_usuario_tiene_rol_administador:=(select f_es_usuario_rol_administrador(param_cod_usuario_destino));
				-- Si el usuario NO tiene ROL Administrador
				if not v_usuario_tiene_rol_administador then 
					-- Asingar rol Administrador a usuario
					call p_asignar_usuario_rol_administrador(param_cod_usuario_destino);
				end if;
				-- Almacenar notificación
				v_cod_tipo_notificacion:='INF';
				v_texto_notificacion:='El Administrador' || v_nombre_apellidos_origen || ' asignó el rol de Administrador a ' || v_nombre_apellidos_destino;
				-- raise notice 'v_cod_tipo_notificacion: %, v_texto_notificacion: %', v_cod_tipo_notificacion, v_texto_notificacion;	
				call p_insertar_notificacion(v_cod_tipo_notificacion, v_texto_notificacion);

			when 2 then -- Quitar rol Administrador a usuario
				raise notice '2';	
				v_usuario_tiene_rol_administador:=(select f_es_usuario_rol_administrador(param_cod_usuario_destino));
				-- raise notice '1-v_usuario_rol_administador: %',v_usuario_rol_administador;	
				-- Si el usuario tiene ROL Administrador
				if v_usuario_tiene_rol_administador then 
					-- Eliminar rol Administrador a usuario
					call p_quitar_usuario_rol_administrador(param_cod_usuario_destino);
					
					-- Si el Usuario origen y destino son el mismo.					
					if param_cod_usuario_origen = param_cod_usuario_destino then
						-- Almacenar notificación
						v_cod_tipo_notificacion:='ADV';
						v_texto_notificacion:='El usuario con ' || v_nombre_apellidos_origen || ' se ha quitado así mismo el rol de Administrador.';
						-- raise notice 'v_cod_tipo_notificacion: %, v_texto_notificacion: %', v_cod_tipo_notificacion, v_texto_notificacion;	
						call p_insertar_notificacion(v_cod_tipo_notificacion, v_texto_notificacion);
					end if;					
				end if;
			else
				-- Lanzar Excepcion
				v_texto_excepcion:='El sistema no está preparado para ejecutar la opción seleccionada. Contacta con el administrador del sistema.';
				raise exception '%', v_texto_excepcion  USING ERRCODE = 'P0003';	
		end case;
	end if;
EXCEPTION 
	WHEN SQLSTATE  'P0001' THEN
		-- Almacenar notificación
		v_cod_tipo_notificacion:='ERR';
		v_texto_notificacion:='El usuario con ' || v_nombre_apellidos_origen || ' no tiene Rol de Administrador y ha intentado realizar una acción que necesita de permisos de dicho rol.';
		-- raise notice 'v_cod_tipo_notificacion: %, v_texto_notificacion: %', v_cod_tipo_notificacion, v_texto_notificacion;	
		call p_insertar_notificacion(v_cod_tipo_notificacion, v_texto_notificacion);
end;
$$ language plpgsql;


select f_es_usuario_rol_administrador('rubentorres');


create or replace function f_es_usuario_rol_administrador(param_cod_usuario t_usuario.usuario%type)
	returns boolean as $$
declare
	v_id_usuario T_USUARIO.identificador%type;
	v_resultado boolean :=false; -- Se inicializa a false
begin
	select tu.identificador into v_id_usuario
	from t_usuario tu join t_usuario_rol tur 
		on tu.identificador = tur.id_usuario
		join t_rol tr 
		on tur.id_rol = tr.identificador
	where tr.nombre ='Administrador'
	and tu.usuario = param_cod_usuario;
	
	-- Si se encuentra resultados se cambia el valor de v_resultado.
	if v_id_usuario is not null then
		v_resultado:=true;
	end if;

	return v_resultado;
end;
$$ language plpgsql;


select f_obtener_nombre_apellidos_usuario('juanperez');

create or replace function f_obtener_nombre_apellidos_usuario(param_cod_usuario t_usuario.usuario%type) 
	returns varchar as $$ 
declare
	v_email varchar;
	v_campos_nombreapellidos_email varchar;
	v_nombre_apellidos varchar:= NULL;
	v_nombre varchar:= NULL;
	v_apellidos varchar:= NULL;
begin
	select tu.email into v_email
	from t_usuario tu 
	where tu.usuario =param_cod_usuario;

	-- raise notice 'v_nombre_apellidos: %', v_nombre_apellidos;

	if v_email IS NOT NULL THEN
		-- Obtener elementos antes y después de @
		-- De entre los que hace referencia al nombre y apellidos se obtienen ambos
		v_campos_nombreapellidos_email:=split_part(v_email, '@', 1); 
		raise notice 'v_campos_nombreapellidos_email: %', v_campos_nombreapellidos_email;
		-- Información para el nombre
		v_nombre:=split_part(v_campos_nombreapellidos_email, '.', 1);
		-- Información para el apellido
		v_apellidos:=split_part(v_campos_nombreapellidos_email, '.', 2);

		v_nombre_apellidos:= initcap(v_nombre) || ' ' || initcap(v_apellidos);
	end if;

	return v_nombre_apellidos;
end;
$$ language plpgsql;

create or replace procedure p_insertar_notificacion(param_cod_tipo_notificacion t_tipo_notificacion.codigo%type, 
													param_texto_notificacion t_tipo_notificacion.nombre%type) 
	as $$
declare
begin 
	insert into T_NOTIFICACION_PERMISOS (cod_tipo_notificacion, texto_notificacion) 
		values (param_cod_tipo_notificacion, param_texto_notificacion);
end;
$$ language plpgsql;


create or replace procedure p_asignar_usuario_rol_administrador(param_cod_usuario t_usuario.usuario%type)
	as $$
declare
begin 

	insert into T_USUARIO_ROL (id_usuario, id_rol) 
		values ((select identificador from T_USUARIO where usuario=param_cod_usuario), 
				(select identificador from T_ROL where nombre='Administrador')
				);
end;
$$ language plpgsql;


create or replace procedure p_quitar_usuario_rol_administrador(param_cod_usuario t_usuario.usuario%type)
	as $$
declare
begin 
	delete from T_USUARIO_ROL 
	where id_usuario= (select identificador from T_USUARIO where usuario=param_cod_usuario)
	and id_rol=(select identificador from T_ROL where nombre='Administrador');
end;
$$ language plpgsql;