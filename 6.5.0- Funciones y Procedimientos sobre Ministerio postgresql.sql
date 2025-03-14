/*
 * DBMS: postgres
 * Programmer: AMIV
 * Date: Mar 7, 2025
 * Script: Actividad 6.5 
 */

-- con subconsulta
select f_obtener_nombre_ministerio(2);

CREATE OR REPLACE FUNCTION f_obtener_nombre_ministerio (id_miembro int)
	RETURNS varchar AS $$
DECLARE
	v_nombre_ministerio ministerio.nombre%type;
BEGIN
	select m2.nombre into v_nombre_ministerio
	from ministerio m2
		where m2.codministerio = (select m.codigoministerio
									from miembro m
										where m.codmiembro = id_miembro);
	if v_nombre_ministerio is null then
			v_nombre_ministerio := 'Nombre de ministerio no disponible';
	else
		raise notice 'El miembro con el id: % pertenece al %', id_miembro, v_nombre_ministerio;
	end if;
	return v_nombre_ministerio;
END;
$$ LANGUAGE plpgsql;

-- con left join
select f_obtener_nombre_ministerio_leftjoin(3);

CREATE OR REPLACE FUNCTION f_obtener_nombre_ministerio_leftjoin (id_miembro int)
	RETURNS varchar AS $$
DECLARE
	v_nombre_ministerio ministerio.nombre%type;
BEGIN
	select m2.nombre into v_nombre_ministerio
	from ministerio m2 left join miembro m
		on m2.codministerio = m.codigoministerio
			where m.codmiembro = id_miembro;
	if v_nombre_ministerio is null then
			v_nombre_ministerio := 'Nombre de ministerio no disponible';
	else
		raise notice 'El miembro con el id: % pertenece al %', id_miembro, v_nombre_ministerio;
	end if;
	return v_nombre_ministerio;
END;
$$ LANGUAGE plpgsql;


-- creandolo en un procedimiento (aunque los procedimientos no suelen devolver valores)
CREATE OR REPLACE PROCEDURE p_obtener_nombre_ministerio(IN id_miembro int, OUT nombre_ministerio varchar)
	AS $$
DECLARE
BEGIN
	nombre_ministerio:=(select f_obtener_nombre_ministerio(id_miembro));
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE 
	v_resultado varchar;
BEGIN
	CALL p_obtener_nombre_ministerio(9, v_resultado);
	raise notice 'Nombre ministerio: %', v_resultado;
END$$


