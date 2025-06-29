/* Apartado A */

create or replace procedure p_realizar_tratamiento_proyectos_marzoseptiembre( in param_cod_curso t_curso_academico.codigo%type)
	as $$
declare
	v_cursor_proyectos cursor For
							select *
							from t_proyecto tp 
							where EXTRACT(month FROM tp.fecha_inicio) between 3 and 9;
	v_registro_proyecto t_proyecto%rowtype;
	v_texto_mensaje text;
	v_id_centro t_centro.identificador%type;
	v_nombre_centro t_centro.nombre%type;
begin
	-- Validación inicial
	if param_cod_curso is null then 
		raise exception 'El campo curso académico del programa está vacío y es obligatorio; por favor, rellénelo e inténtelo de nuevo.'
			USING ERRCODE  = 'CA001';
	end if;

	-- Tratamiento de proyectos
	open v_cursor_proyectos;
		loop
			fetch v_cursor_proyectos into v_registro_proyecto;
			exit when not found;

			-- Proyectos sin centro asignado de tipo STEM			
			if v_registro_proyecto.id_centro is null and v_registro_proyecto.proyecto_stem then
				v_texto_mensaje:=concat('El proyecto ', v_registro_proyecto.nombre, ' es de tipo STEM y ámbito Europeo, pero aún no hay un centro que lo haya implantado en el curso académico ', param_cod_curso, '.');
				insert into t_notificacion(textonotificacion, cod_tipo_notificacion)
					values(v_texto_mensaje, 'IYU');
			end if;
			
			-- Proyectos sin centro asignado de ámbito Municipal
			if v_registro_proyecto.id_centro is null and v_registro_proyecto.ambito='Municipal' then
				-- Obtener el centro a asociar.
				select obtener_centro_asociar_proyecto(param_cod_curso) into v_id_centro;

				-- Realizar actualización.
				update t_proyecto
				set id_centro=v_id_centro
				where identificador=v_registro_proyecto.identificador;

			end if;

			-- Proyectos con centro asignado 
			if v_registro_proyecto.id_centro is not null then

				select nombre into v_nombre_centro
				from t_centro
				where identificador=v_registro_proyecto.id_centro;

				v_texto_mensaje:=concat('El proyecto ',v_registro_proyecto.nombre, ' asociado al centro ', v_nombre_centro , ' ha sido implantado en el curso académico ', param_cod_curso , '.');
				raise notice '% ', v_texto_mensaje;
			end if;

		end loop;
	close v_cursor_proyectos;
end;
$$ language plpgsql;


create or replace function obtener_centro_asociar_proyecto( in param_cod_curso t_curso_academico.codigo%type)
	returns t_proyecto.identificador%type as $$
declare
	v_id_centro t_centro.identificador%type;
begin
	select tc.identificador into v_id_centro
	from t_proyecto tp join t_centro tc 
		on tp.id_centro = tc.identificador
		join t_proyecto_curso tpc 
		on tpc.id_proyecto = tp.identificador
	where tpc.cod_curso = param_cod_curso
	and tp.ambito ='Municipal'
	and tp.proyecto_stem = false
	order by tp.fecha_inicio desc
	limit 1;

	return v_id_centro;
end;
$$ language plpgsql;

/*
call p_realizar_tratamiento_proyectos_marzoseptiembre('2024-2025');

select obtener_centro_asociar_proyecto('2024-2025');
*/


/* Apartado B */

create or replace function f_trigger_tratar_actualizacion_ingreso()
	returns trigger as $$
declare
	v_registro_cursoacademico t_curso_academico%rowtype;
	v_texto_mensaje text;
	v_nombre_proyecto t_proyecto.nombre%type;
	v_nombre_patrocinador t_patrocinador.nombre%type;
begin
	/*
	raise notice 'NEW: %', NEW;
	raise notice 'OLD: %', OLD;
	raise notice 'TG_OP: %', TG_OP;
	*/

	-- b) Lo primera la validación que cancela la operación
	if new.cantidad <= 0 then 
		return null;
	end if;
	
	-- a) Tratamiento con fechas	
	if new.fecha_ingreso is not null then

		--  Obtener información del curso académico
		select * into v_registro_cursoacademico
		from t_curso_academico 
		where codigo = new.cod_curso;

		if new.fecha_ingreso < v_registro_cursoacademico.fecha_inicio or new.fecha_ingreso > v_registro_cursoacademico.fecha_fin then 
			v_texto_mensaje:=concat(new.fecha_ingreso,  ' es una fecha de ingreso que no se corresponde con el curso académico ', v_registro_cursoacademico.nombre, '.');
			insert into t_notificacion(textonotificacion, cod_tipo_notificacion)
				values(v_texto_mensaje, 'IMP');
		end if;
	end if;
	
	-- c) Tratamiento sobre observación
	if new.cantidad > 0 and new.observacion IS NULL then

		-- Obtener nombre proyecto
		select tp.nombre into v_nombre_proyecto
		from t_proyecto tp 
		where tp.identificador =new.id_proyecto;

		-- Obtener nombre patrocinador
		select tp.nombre into v_nombre_patrocinador
		from t_patrocinador tp
		where tp.identificador =new.id_patrocinador;
		-- Asignar valor a la campo observación
		new.observacion:=concat('Aportación al proyecto ', v_nombre_proyecto, ' realizada por parte del patrocinador ', v_nombre_patrocinador, '.');
	end if;

	return new;
end;
$$ language plpgsql;


create or replace trigger t_tratar_actualizacion_ingreso
before update
on t_ingreso
for each row
execute function f_trigger_tratar_actualizacion_ingreso();

/*
update t_ingreso
set fecha_ingreso='2025-09-12'
where identificador = 17;
*/