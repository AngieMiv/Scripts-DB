/*
SGDB: Postgres
Programador: INM - AMIV (comentarios) 
Fecha: 06/03/2025
Script: Bloque anonimo que cuenta cuántos alumnos hay en una casa especificada
		y muestra un mensaje indicando si hay más de uno o no.*/

DO $$ -- Inicia un bloque anónimo en PL/pgSQL
DECLARE
    nombre_casa VARCHAR(255) := 'Ravenclaw'; -- Declara e inicializa la variable con el nombre de la casa
    num_alumnos INT; -- Declara una variable para almacenar el número de alumnos
BEGIN
    RAISE NOTICE 'Nombre casa: %', nombre_casa; -- Muestra un mensaje con el nombre de la casa

    num_alumnos := 0; -- Inicializa num_alumnos en 0

    SELECT COUNT(*) INTO num_alumnos
    FROM alumno
    WHERE idCasa = (SELECT idCasa -- Obtiene el idCasa de la casa con el nombre dado
                    FROM casa 
                    WHERE Nombre = nombre_casa);

	-- Evalúa si hay más de un alumno en la casa
    IF num_alumnos > 1 THEN
        RAISE NOTICE 'Hay más de 1 alumnos en la casa %', nombre_casa; -- Mensaje si hay más de un alumno
    ELSE
        RAISE NOTICE 'No hay alumnos o hay 1 alumno en la casa %', nombre_casa; -- Mensaje si hay 0 o 1 alumno
    END IF;
END $$; -- Finaliza el bloque PL/pgSQL
