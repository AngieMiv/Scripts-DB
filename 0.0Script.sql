/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 31/03/2025
Script: Propuesta de solución del examen de 3ª Evaluación asociado al RA5 - Programación sobre Bases de Datos.
*/

-- Aparatado A: 5 puntos
-- Pruebas del procedimiento id_curso_escola=11 e id_grado=4.
call p_tratar_asignaturas_grado(4, 11);

-- Procedimiento para el tratamiento de las asignaturas según requisitos.
create or replace procedure p_tratar_asignaturas_grado(param_id_grado grado.id%type, param_id_curso curso_escolar.id%type)
	as $$

declare
	-- Cursor que recoge las asignaturas de un grado.
	v_cursor_asignaturas_grado cursor for
		select a.*
		from asignatura a join asignatura_grado ag 
			on a.id = ag.id_asignatura
		where ag.id_grado =param_id_grado;

	-- Variable "registro asignatura" parar recoger el contenido de cada una de las filas del cursor.
	v_registro_asignatura asignatura%rowtype;
begin
	-- Si alguno de los dos parámetros es nulo, salta la excepción.
	if param_id_grado is null or param_id_curso is null then
		raise exception 'Los datos de entrada grado y curso del programa están vacíos y son obligatorios; por favor, rellénelos e inténtelo de nuevo.'
		using errcode = 'P0001';
	end if;
	
	-- Apertura del cursor para comenzar a tratar las asignaturas.
	open v_cursor_asignaturas_grado;
		loop
			fetch v_cursor_asignaturas_grado into v_registro_asignatura; -- Se carga el contenido de una fila del cursor en 
			exit when not found;

			-- Se validan las características que ha de tener la asignatura para realizar el tratamiento.
			if (v_registro_asignatura.tipo = 'básica' or v_registro_asignatura.tipo = 'obligatoria') and v_registro_asignatura.id_profesor is null then
				if f_comprobar_alumnos_matriculados_cursoescolar(v_registro_asignatura.id, param_id_curso) then
					raise notice 'reg_asignatura: %', v_registro_asignatura;
					-- Si tiene alumnos matriculados, se le asigna profesor a través del procedimiento.
					call p_asignar_profesora_asignatura(v_registro_asignatura.id);
				end if;
			end if;
		end loop;
	close v_cursor_asignaturas_grado;
end;
$$ language plpgsql;


call p_asignar_profesora_asignatura(2);
-- En este procedimiento, se asigna profesor a las asignaturas.
create or replace procedure p_asignar_profesora_asignatura(param_id_asignatura asignatura.id%type)
	as $$
declare
	v_id_profesora profesor.id%type;
begin
	select id
	into v_id_profesora 	-- Se asigna el ID a esa variable, según las condiciones especificadas.
	from profesor
	where id_departamento = 1
	and sexo = 'M'
	order by fecha_nacimiento
	limit 1;

	-- Se asigna la profesora obtenida en el punto anterior
	update asignatura
	set id_profesor = v_id_profesora
	where id = param_id_asignatura;
end;
$$ language plpgsql;

select f_comprobar_alumnos_matriculados_cursoescolar(2,11);

-- Función en la que se comprueba si la asignatura tiene alumnos matriculados en un curso escolar.
create or replace function f_comprobar_alumnos_matriculados_cursoescolar(param_id_asignatura asignatura.id%type, param_id_curso curso_escolar.id%type)
	returns boolean as $$
declare
	v_hay_alumnos_matriculados boolean := false;
	v_id_alumno alumno_curso_asignatura.id_alumno%type;
begin
	-- Se almacena el ID de alumno para comprobar si es nulo o no en la asignatura/curso escolar
	select id_alumno
	into v_id_alumno
	from asignatura a join alumno_curso_asignatura aca
		on a.id =aca.id_asignatura 
	where aca.id_curso_escolar = param_id_curso
	and aca.id_asignatura= param_id_asignatura;
	
	-- Si el ID no es nulo, hay alumnos matriculados para el curso escolar.
	if v_id_alumno is not null then
		v_hay_alumnos_matriculados := true;
	end if;
	
	return v_hay_alumnos_matriculados;
end;
$$ language plpgsql;








-- Aparatado B: 5 puntos


-- Función del trigger.
create or replace function f_trigger_notificar_cambios_asignatura()
	returns trigger as $$
declare
	v_texto_notificacion notificacion.texto%type;
	v_nombre_apellidos_profesor varchar;
	v_nombre_departamento_profesor departamento.nombre%type;
	v_nombre_grado_asignatura grado.nombre%type;
begin
	if TG_OP = 'DELETE' Then  -- Caso de que desaparezca la asignatura
		if old.id_profesor is not null then
			-- Se inserta la notificación en su tabla. 
			v_nombre_apellidos_profesor:= (f_obtener_nombre_profesor(old.id_profesor));
			v_nombre_departamento_profesor:= (f_obtener_nombre_departamento(old.id_profesor));
			v_texto_notificacion:=concat('Es necesario recolocar al profesor ' ,  v_nombre_apellidos_profesor , ' del departamento ' ,  v_nombre_departamento_profesor , ' que tenía asignada la asignatura ' ,  old.nombre ,  '.');
			insert into notificacion(texto, codigo_tipo_notificacion)
				values(v_texto_notificacion,'URG');
		end if;
	elsif TG_OP = 'UPDATE' Then -- Caso de que la asignatura se quede sin profesor asignado (actualización en la tabla asignatuura de id_profesor; pasa tomar valor null)
		if new.id_profesor is null and old.id_profesor is not null then
			-- Se inserta la notificación en su tabla. 
			v_nombre_grado_asignatura:=(f_obtener_grado_asignatura(new.id));
			v_texto_notificacion:=concat('Es necesario encontrar un profesor para la asignatura ' , new.nombre , ' perteneciente al grado ' ,  v_nombre_grado_asignatura ,  '.');
			raise notice  '%', v_texto_notificacion;
			insert into notificacion(texto, codigo_tipo_notificacion)
				values(v_texto_notificacion, 'IYU');
		end if;
	end if;
	
	return null;
end;
$$ language plpgsql;

-- Trigger que se dispara tras actualización o borrado en asignatura
create or replace trigger t_notificar_cambios_asignatura
after delete or update
on asignatura
for each row
execute function f_trigger_notificar_cambios_asignatura();



select f_obtener_nombre_profesor(5);

-- Esta función extrae el nombre del profesor. Para ello, se le pasa el ID del profesor (antes del borrado).
create or replace function f_obtener_nombre_profesor(param_id_profesor profesor.id%type)
	returns text as $$
-- Se declara una variable nombre para almacenar el nombre y devolverlo.
declare
	v_nombre_profesor varchar;
-- Se concatenan nombre y apellidos (con separador) y se asignan a la variable creada.
begin
	select concat_ws(' ', nombre, apellido1, apellido2)
	into v_nombre_profesor
	from profesor
	where id = param_id_profesor;

	return v_nombre_profesor;
end;
$$ language plpgsql;


select f_obtener_nombre_departamento(5);
-- Función que permite obtener el nombre del departamento a partir del identificador del profesor.
create or replace function f_obtener_nombre_departamento(param_id_profesor profesor.id%type)
	returns departamento.nombre%type as $$
-- Se crea una variable departamento para almacenar su nombre y devolverlo.
declare
	v_departamento departamento.nombre%type;
-- Se asigna el nombre del departamento a la variable declarada.
begin
	select d.nombre
	into v_departamento
	from departamento d join profesor p
		on d.id= p.id_departamento
	where p.id = param_id_profesor;
	
	return v_departamento;
end;
$$ language plpgsql;


select f_obtener_grado_asignatura(2);

-- Esta función extrae el nombre del grado. Para ello, se le pasa el ID de la asignatura.
create or replace function f_obtener_grado_asignatura(param_id_asignatura asignatura.id%type)
	returns grado.nombre%type as $$
-- Se crea una variable grado para almacenar su nombre y devolverla.
declare
	v_nombre_grado grado.nombre%type;
-- Se le asigna a la variable declarada el valor del grado que se corresponde con la asignatura.
begin
	select nombre
	into v_nombre_grado
	from grado g join asignatura_grado ag
		on g.id= ag.id_asignatura
	where ag.id_asignatura = param_id_asignatura;

	return v_nombre_grado;
end;
$$ language plpgsql;

-- Pruebas de los triggers
delete 
from asignatura
where id =94;

update asignatura
set id_profesor = null 
where id=2;

INSERT INTO asignatura VALUES (94, 'Probabilidad y Estadística para Ciencias de la Computación', 6, 'básica', 1, 1, 21 );

