/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 17/02/2025
Script: Pruebas para probar los distintos tipos de cursores.
*/
	/* USO del tipo RECORD para registro */
	DO $$
	DECLARE
		-- La variable permite recoger el contenido 
		-- de una fila de una consulta.
	    info_alumno RECORD; 
	BEGIN
		SELECT a.nombre, a.apellido1, apellido2,
			 c.nombre as nombre_casa INTO info_alumno 
		FROM alumno a join casa c
			on a.idcasa=c.idcasa
		WHERE id = 1;
	    
	    -- Se imprime el campo nombre del almuno del registro
	    RAISE NOTICE 'El alumno % pertenece a la Casa %', 
	   					info_alumno.nombre, info_alumno.nombre_casa;
	END$$;

	/* USO del tipo tabla%ROWTYPE para almacenar un registro */
	DO $$
	declare
		-- La variable permite recoger el contenido 
		-- de una fila de la tabla alumno
	    info_alumno alumno%ROWTYPE; 
	BEGIN
	    SELECT * INTO info_alumno FROM alumno WHERE id = 1;
	    
	    -- Se imprime el campo nombre del almuno del registro
	    RAISE NOTICE 'Nombre del alumno: %', info_alumno.nombre;
	END$$;


	/* Uso del IF */
	DO $$
	DECLARE
		p_numero int :=2;
		resultado VARCHAR(50);
	BEGIN
	    IF p_numero < 0 THEN
		    resultado:= 'Negativo';
	    ELSIF p_numero = 0 THEN
		    resultado:= 'Cero';
	    ELSE
	    	resultado:= 'Positivo';
	    END IF;
	   
	    RAISE NOTICE 'Resultado: %', resultado;
	END;
	$$;


	/* Uso del CASE */
	DO $$
	DECLARE
		p_numero int:=2;
	    resultado VARCHAR(50);
	BEGIN
		resultado:= 
				CASE
		    		WHEN p_numero < 0 then 'Negativo'
		        	WHEN p_numero = 0 then 'Cero'
	    			ELSE 'Positivo'
	    		END;	
	    
	    RAISE NOTICE 'Resultado: %', resultado;
	END;
	$$;

	/* Iteración con LOOP */
	DO $$
	DECLARE
		 contador INT := 1;
	BEGIN
	    LOOP
	        EXIT WHEN contador > 5;
	        RAISE NOTICE 'Valor contador: %', contador;
	        contador := contador + 1;
	    END LOOP;
	END;
	$$;


	/* Iteración con WHILE */
	DO $$
	DECLARE
	    contador INT := 1;
	BEGIN
	    WHILE contador <= 5 LOOP
	        RAISE NOTICE 'Valor contador: %', contador;
	        contador := contador + 1;
	    END LOOP;
	END;



	/* Definición de CURSOR y tratamiento del contenido */
	DO $$
	DECLARE
		cursor_miembros CURSOR FOR
			SELECT nombre, apellido1, nif, codigoministerio
			FROM miembro
			WHERE alias is NULL;

		reg_miembro RECORD;
		nombre_completo VARCHAR(250);
	BEGIN
		
		OPEN cursor_miembros;
		
		
		LOOP
		
			FETCH cursor_miembros INTO reg_miembro;
			
			EXIT WHEN NOT FOUND;
			
			nombre_completo := concat(reg_miembro.nombre, ' ', 
									reg_miembro.apellido1, 
									' con NIF: ', 
									reg_miembro.nif);
			
			RAISE NOTICE 'Nombre completo del miembro: %', nombre_completo;

		END LOOP;
		
		CLOSE cursor_miembros;
	
	END $$;

	
	
	/* BLOQUE ANÓNIMO */
	DO $$
	DECLARE
		v_num1 INT :=3;
		v_resultado INT;
	BEGIN
		v_resultado:= v_num1 * v_num1;
		raise notice '% al cuadrado es: %'
						, v_num1, v_resultado;
	END $$;

	/* Creación de la FUNCIÓN */
	CREATE OR REPLACE FUNCTION f_cuadrado_numero(numero int)
		RETURNS INT AS $$
	DECLARE
		v_resultado INT;
	BEGIN
		v_resultado:= numero * numero;
		RAISE NOTICE '% al cuadrado es: %'
						, numero, v_resultado;
		RETURN v_resultado; 	
	END;
	$$ LANGUAGE plpgsql;
	
	-- Llamada a la función
	select f_cuadrado_numero(3);

	/* Creación del PROCEDIMIENTO */
	CREATE OR REPLACE PROCEDURE p_borrar_miembro(codigo_miembro int) AS $$
	-- En este ejemplo no se crea bloque DECLARE
	BEGIN
		DELETE FROM miembro 
		WHERE codmiembro= codigo_miembro;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Llamada al PROCEDIMIENTO la función
	CALL p_borrar_miembro(3);


	/* Creación de la tabla HISTÓRICO */
	create table historico_miembros (
		id_miembro int not null, 
		nif varchar(9) not null,
		fecha_borrado DATE not null,
		primary key (id_miembro, fecha_borrado),
		constraint FK_HISTORICO_MIEMBRO 
			foreign key (id_miembro) references miembro(codmiembro)
	);

	/* Creación del TRIGGER */
	CREATE OR REPLACE FUNCTION registrar_borrado_miembro() 
		RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO historico_miembros (id_miembro, nif, fecha_borrado)
			VALUES (OLD.codMiembro, OLD.nif, CURRENT_DATE);
		
		RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;

	create OR REPLACE TRIGGER borrar_miembro_trigger
		BEFORE DELETE ON miembro
		FOR EACH ROW
	EXECUTE PROCEDURE registrar_borrado_miembro();


	/* Definición de CURSOR y tratamiento del contenido */
	DO $$
	DECLARE
		cursor_miembros CURSOR FOR
			SELECT nombre, apellido1, nif, codigoministerio
			FROM miembro
			WHERE alias is NULL;

		reg_miembro RECORD;
		nombre_completo VARCHAR(250);
	BEGIN
		-- El tratamiento va entre el BEGIN y el END
	END $$;