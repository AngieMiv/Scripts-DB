/*
 * SGDB: Postgres
 * Programadora: AMIV
 * Fecha: 07/03/2025
 * Script: Bloque anónimo opciones de 1 a 11
 * */

DO $$
DECLARE
    v_opcion INT := 3;  -- Cambiar este valor entre 1 y 11 para probar diferentes casos
    v_idCasa INT;
BEGIN
    -- Opción 1: Borrar alumnos de la casa 'Ravenclaw'
    IF v_opcion = 1 THEN
        -- Obtener el ID de la casa 'Ravenclaw'
        SELECT idCasa INTO v_idCasa FROM casa WHERE Nombre = 'Ravenclaw';
        
        -- Si la casa existe, eliminar alumnos asociados
        IF FOUND THEN
            DELETE FROM alumno WHERE idCasa = v_idCasa;
            RAISE NOTICE 'Se han eliminado los alumnos de la casa Ravenclaw (ID: %)', v_idCasa;
        ELSE
            RAISE NOTICE 'No se encontró la casa Ravenclaw';
        END IF;
    
    -- Opción 2: Insertar una nueva casa 'Glovendam'
    ELSIF v_opcion = 2 THEN
        INSERT INTO casa (Nombre) VALUES ('Glovendam');
        RAISE NOTICE 'Se ha insertado la nueva casa Glovendam';
    
    -- Otras opciones: Actualizar el apellido2 del alumno con ID = v_opcion
    ELSE
        UPDATE alumno 
        SET apellido2 = 'Damgloven'
        WHERE id = v_opcion;
        
        -- Verificar si se realizó la actualización
        IF FOUND THEN
            RAISE NOTICE 'Se ha actualizado el apellido2 del alumno con ID % a Damgloven', v_opcion;
        ELSE
            RAISE NOTICE 'No se encontró un alumno con ID %', v_opcion;
        END IF;
    END IF;
END $$;
