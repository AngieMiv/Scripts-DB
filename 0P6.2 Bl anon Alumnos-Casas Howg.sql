/*
 * Programador: Angie Miv
 * Fecha: 23 Marzo 2025
 * Script: Bloque anónimo que muestra si hay más de 1 alumno en una de las casas de Hogwarts o no
 * */

DO $$ -- empieza el bloque anon

DECLARE -- declaración de las varibles
    nombre_casa VARCHAR(25) := 'Ravenclaw'; -- la declaramos como varchar y definimos como 'Gryffindor', pero podrían ser 'Slytherin' blabla
    num_alumnos INT; -- solo decimos que es un int 

	-- modificación: sacar el identificador de la casa
	identificador_casa INT; 
BEGIN

	-- modif: meto el id
	SELECT idcasa INTO identificador_casa
		FROM casa
		WHERE Nombre = nombre_casa; -- !! acordarse del where, que si no sale siempre un 1 xd

	-- mostramos el mensaje en consola con raise notice mostrando lo que hay en nombre_casa
	-- modif: agrego el identificador de la casa
    RAISE NOTICE 'Nombre casa: %, identificador: %', nombre_casa, identificador_casa; 

    -- num_alumnos := 0; -- inicializa a 0 el num de alumnos, aunque luego metemos otro número sacado de la tabla alumno

    SELECT COUNT(*) INTO num_alumnos -- metemos en num_alumnos el count(todos) de la tabla alumno
    FROM alumno
    WHERE idCasa = (SELECT idCasa 
                    FROM casa 
                    WHERE Nombre = nombre_casa); -- especificamos que nombre_casa es el Nombre de la tabla casa

    IF num_alumnos > 1 THEN -- IF, THEN, ELSE, END IF;
        RAISE NOTICE 'Hay más de 1 alumno en la casa %', nombre_casa; 
    ELSE
        RAISE NOTICE 'No hay alumnos o hay 1 alumno en la casa %', nombre_casa;
    END IF;
END $$; -- termina el bloque anon


