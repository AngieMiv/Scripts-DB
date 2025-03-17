/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Mar 14, 2025
 * Script: Actividad 6.7 ext 6.6
 */

create table historico_miembro(
	id_historico serial primary key,
	cod_miembro int not null,
	nif varchar (9) not null unique,
	nombre varchar(100) not null,
	apellido1 varchar(100) not null,
	alias varchar(100) null,
	codigo_ministerio int,
	fecha_actualizacion timestamp default current_timestamp
);

CALL p_tratar_gobierno_act_6_7(2, 3);

CREATE OR REPLACE PROCEDURE p_tratar_gobierno_act_6_7 (IN opcion INT,
														IN codigo_ministerio int)
														AS $$
DECLARE
	v_cod_miembro miembro.codmiembro%TYPE;
	v_registro_miembro miembro.codmiembro%rowtype;
BEGIN
	CASE
		WHEN opcion = 1 THEN
				RAISE NOTICE '1';

				DELETE FROM ministerio
					WHERE codministerio = codigo_ministerio;

		WHEN opcion = 2 THEN
				RAISE NOTICE '2';
				-- Código miembro máximo para un ministerio
				SELECT max (codMiembro) INTO v_cod_miembro
				FROM miembro
						WHERE codigoministerio = codigo_ministerio;

				-- Antes
				-- insert into histrico_miembro(cod_miembro, nif, nombre, apellido1, alias, codigo_ministerio)
				-- select * from miembro
					-- where codmiembro = v_cod_miembro;

				DELETE FROM miembro
					where codMiembro = v_cod_miembro;

				-- Después
				if found then
					insert into historico_miembro (cod_miembro, nif, nombre, apellido, alias, codigo_ministerio)
						values (v_registro_miembro.codmiembro, v_registro_miembro.nif, v_registro_miembro.nombre, 
								v_registro_miembro.apellido, v_registro_miembro.alias, v_registro_miembro.codigoministerio);
				else
					raise notice 'No hay miembro a eliminar';
				end if;

		WHEN opcion = 3 THEN
			RAISE NOTICE '3';
			CALL p_eliminar_miembros_sobrantes();
		ELSE
			RAISE NOTICE 'otras';
	END CASE;
exception
	when sqlstate '23503' then
		raise notice 'El ministerio tiene miembros asociados; si quiere eliminar el ministerio etc etc etc';
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE p_eliminar_miembros_sobrantes() AS $$
DECLARE
	v_cursor_miembros_sobrantes cursor for
		select from membro m
			where m.codigoministerio in (select codigoministerio
										from miembro
											group by codigo ministerio
											having count (*) > 2);
	v_registro_miembro miembro%rowtype;
BEGIN 
	RAISE NOTICE 'p_eliminar_miembros_sobrantes';
	open v_cursor_miembros_sobrantes;
		loop
			fetch v_cursor_miembros_sobarntes into v_registro_miembro;
			exit when not found;
			-- comienza el tratamiento
			-- inserción en el histórico
			insert into historico_miembro (cod_miembro, nif, nombre, apellido, alias, codigo_ministerio)
				values (v_registro_miembro.codmiembro, v_registro_miembro.nif, v_registro_miembro.nombre, 
						v_registro_miembro.apellido, v_registro_miembro.alias, v_registro_miembro.codigoministerio);
			-- borrado
				DELETE FROM miembro
					where codMiembro = v_cod_miembro;
			
	DELETE
	FROM miembro
		WHERE codigoministerio IN (SELECT codigoministerio
									FROM miembro
										GROUP BY codigoministerio
										HAVING count(*) > 2);
END;
$$ LANGUAGE plpgsql;
