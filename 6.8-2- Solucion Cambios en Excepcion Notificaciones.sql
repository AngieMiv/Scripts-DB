/*
 * SOLUCION AL 6.8-2, script solo con cambios
 * Partiendo de la solución que propusiste en la actividad 6.8, realiza los cambios necesarios para que:
 * - La información del nombre y apellidos se obtendrá de la tabla T_PERSONAL
 * - Sólo se tengan en cuenta, de cara a validar si los usuarios son Administrador o Profesor, que los usuarios estén en estado Activo.
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 18/03/2025
Script: Script asociado a las funcionalidades descritas en la actividad 6.8.
		Versión simplificada sin Auditoría
		Cambios es las funciones:
			- f_es_usuario_rol_administrador
			- f_obtener_nombre_apellidos_usuario
*/

select f_es_usuario_rol_administrador('rubentorres');

-- Se incluye en el filtro que los usuarios estén en Activo
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
	and tu.usuario = param_cod_usuario
	and tu.estado ='Activo';
	
	-- Si se encuentra resultados se cambia el valor de v_resultado.
	if v_id_usuario is not null then
		v_resultado:=true;
	end if;

	return v_resultado;
end;
$$ language plpgsql;


select f_obtener_nombre_apellidos_usuario('juanperez');


-- Se incluye la consulta sobre t_personal para obtener el nombre y apellidos
create or replace function f_obtener_nombre_apellidos_usuario(param_cod_usuario t_usuario.usuario%type) 
	returns varchar as $$ 
declare
	v_registro_personal t_personal%rowtype;
	v_nombre_apellidos varchar:= NULL;
begin
	-- Se obtiene la información del usuario
	select p.* into v_registro_personal
	from t_personal p join t_personal_usuario pu
		on p.dni =pu.dni
		join t_usuario u
		on pu.email =u.email
	where u.usuario = param_cod_usuario;

	if v_registro_personal IS NOT NULL THEN
		v_nombre_apellidos:= v_registro_personal.nombre || ' ' || v_registro_personal.apellido1; 
	end if;

	raise notice 'v_nombre_apellidos: %', v_nombre_apellidos;
	
	return v_nombre_apellidos;
end;
$$ language plpgsql;
