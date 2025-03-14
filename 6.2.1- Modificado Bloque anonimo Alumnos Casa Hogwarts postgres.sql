/*
SGDB: Postgres
Programador: AMIV (comentarios y modificaciones) - INM
Fecha: 06/03/2025
Script: (modificado) Bloque anonimo que cuenta cuántos alumnos hay en una casa especificada
		y muestra un mensaje indicando si hay más de uno o no.
		Modificación:
		Imprimir por consola (RAISE NOTICE) el identificador de la casa que introdujo al principio (variable de usuario nombre_casa)
*/

DO $$ -- Inicia un bloque anónimo en PL/pgSQL
DECLARE
    nombre_casa VARCHAR(255) := 'Ravenclaw'; -- Declara e inicializa la variable con el nombre de la casa
    num_alumnos INT; -- Declara una variable para almacenar el número de alumnos
 	id_casa INT;  -- * Declara una variable para almacenar el identificador de la casa
BEGIN

    -- * Obtiene el identificador de la casa basada en el nombre
    SELECT idCasa INTO id_casa
    FROM casa
    WHERE Nombre = nombre_casa;
    
    -- * Imprime el nombre junto con el id de la casa
    RAISE NOTICE 'Nombre de la casa: %, ID de la casa: %', nombre_casa, id_casa;

    num_alumnos := 0; -- Inicializa num_alumnos en 0

    -- * Cuenta cuántos alumnos pertenecen a la casa especificada
    SELECT COUNT(*) INTO num_alumnos
    FROM alumno
    WHERE idCasa = id_casa;

	-- Evalúa si hay más de un alumno en la casa
    IF num_alumnos > 1 THEN
        RAISE NOTICE 'Hay más de 1 alumnos en la casa %', nombre_casa; -- Mensaje si hay más de un alumno
    ELSE
        RAISE NOTICE 'No hay alumnos o hay 1 alumno en la casa %', nombre_casa; -- Mensaje si hay 0 o 1 alumno
    END IF;
END $$; -- Finaliza el bloque PL/pgSQL