DO $$
DECLARE
    nombre_casa VARCHAR(255) := 'Gryffindor';
    num_alumnos INT;
BEGIN
    RAISE NOTICE 'Nombre casa: %', nombre_casa;

    num_alumnos := 0;

    SELECT COUNT(*) INTO num_alumnos
    FROM alumno
    WHERE idCasa = (SELECT idCasa 
                    FROM casa 
                    WHERE Nombre = nombre_casa);

    IF num_alumnos > 1 THEN
        RAISE NOTICE 'Hay más de 1 alumnos en la casa %', nombre_casa;
    ELSE
        RAISE NOTICE 'No hay alumnos o hay 1 alumno en la casa %', nombre_casa;
    END IF;
END $$;

