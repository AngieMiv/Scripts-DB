/*
 * DBMS: postgres
 * Programmer: Angie M. Ibarrola Valenzuela
 * Date: Mar 23, 2025
 * Script: bloque anonimo opciones 
 */

DO $$
declare
	v_opcion int := 10;
begin
		case
			-- opcion 1: borrar alumnos casa 'Ravenclaw'
			when v_opcion = 1 then
				raise notice 'opc 1';
				delete from alumno where idcasa = (select idcasa from casa
													where nombre = 'Ravenclaw');
				raise notice 'Borrados los alumnos de la casa Ravenclaw';
	
			-- opcion 2: insertar nueva casa de nombre 'Glovendam'
			when v_opcion = 2 then
				raise notice 'opc 2:';
				insert into casa (idcasa, nombre)
					values (5, 'Glovendam');
				raise notice 'Insertada casa Glovendam';

			-- cualquier otro caso:
			else
				raise notice 'cualquier otro caso';
				update alumno
					set apellido2 = 'Damgloven'
					where alumno.id = v_opcion;
				if found then
					raise notice 'se actualizó el apellido a Damgloven del 
						alumno con id %', v_opcion;
				else 
					raise notice 'no hay alumno con id %', v_opcion;
				end if;
			end case;

END $$;