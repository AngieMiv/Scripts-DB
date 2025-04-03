/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 18/02/2025
Script: Declaración de la estructura base de un Trigger.
*/

-- Los Trigger sirven para procesar información como respuesta a eventos que ocurren sobre registros de una tabla.
-- Se ejecutan de manera automática (sin intervención del programador)
-- Se almacenan como objetos de la base de datos.
-- En PostgreSQL Está formada por dos partes:
-- 		- El Trigger 
--		- La "función del Trigger" (función que se ejecuta cuando se dispara el Trigger)

CREATE OR REPLACE FUNCTION f_trigger_borrar_miembro() -- Nombre de la "Función del Trigger"
  RETURNS TRIGGER AS $$
 DECLARE
 BEGIN
	-- Tratamiento a realizar en "la función del Trigger"
	RAISE NOTICE 'Valor de la variable NEW: %', NEW; 		-- Variable NEW: Representa el contenido que tendrá el registro tras disparase el trigger
	RAISE NOTICE 'Valor de la variable OLD: %', OLD;		-- Variable OLD: Representa el contenido que tenía el registro antes dispararse el trigger.
	RAISE NOTICE 'Valor de la variable TG_OP: %', TG_OP;	-- Variable TG_OP:Representa la operación realizada. Valores: INSERT, UPDATE, DELETE, TRUNCATE.
	
	RETURN NULL;
 END;
$$ language plpgsql;

-- Nombre del Trigger 
CREATE OR REPLACE TRIGGER t_borrar_miembro		-- Nombre con el que se almacena el Trigger en la BBDD
BEFORE 											-- El trigger se disparará ANTES de...   Valores: AFTER (antes) o BEFORE (Después)
INSERT OR UPDATE OR DELETE 						-- El trigger se disparará cuando ocurra una Inserción, o una Actualización o un Borrado.  Valores: INSERT, UPDATE, DELETE, TRUNCATE.
ON miembro 										-- El trigger se disparará cuando haya un cambio en registros de la tabla 'miembro'
FOR EACH ROW 									-- la "función del Trigger" se dispara para cada fila
EXECUTE FUNCTION f_trigger_borrar_miembro(); 	-- Nombre de la función que se va a ejecutar cuando se dispare el Trigger

-- PROBANDO UN TRIGGER

-- Probando el trigger en Inserción
insert into miembro (nif, nombre, apellido1, alias, codigoministerio)
	values ('14584486H', 'Gregorio', 'Jiménez', 'Goyo', 2);

-- Probando el trigger en Borrado
delete from miembro 
where codmiembro=2;

-- Probanado el trigger en Actualización
update miembro
set alias =null
where codmiembro=3;