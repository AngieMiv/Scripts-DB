/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 17/02/2025
Script: Declaración e impresión de valores de distintos tipos de datos.
*/

-- Declaración de un tipo complejo en PostgreSQL.
create type tipo_nombre_completo as (
	nif varchar(9),
	nombre varchar(100),
	apellido1 varchar(100)
);

-- Bloque anónimo.
DO $$
DECLARE
	-- Tipo simple 
	v_codmiembro int :=0;

	-- Tipo registro de tabla
	v_reg_fila_miembro miembro%rowtype;

	-- Tipo record
	v_reg_miembro RECORD;

	-- Tipo compuesto
	v_nombre_completo tipo_nombre_completo;
	
	-- Tipo Cursor
	v_cursor_miembros CURSOR FOR
	    SELECT nombre, apellido1, nif, codigoministerio
	    FROM miembro
	    WHERE alias is not NULL;

BEGIN
	-- Asignacion variable simple
    v_codmiembro:=1;
	raise notice '1 .Valor de v_codmiembro: %', v_codmiembro;
	RAISE NOTICE '---------------------------------------' ;

	-- Asignacion variable simple
	select * from miembro into v_reg_fila_miembro
	where codmiembro=v_codmiembro;
	raise notice '2. Valor de v_reg_fila_miembro: %', v_reg_fila_miembro;
	RAISE NOTICE '---------------------------------------' ;

    OPEN v_cursor_miembros;
    
    
    LOOP
    
        FETCH v_cursor_miembros INTO v_reg_miembro;
        
        EXIT WHEN NOT FOUND;
        
		RAISE NOTICE '---------------------------------------' ;
        RAISE NOTICE '3. Valor de v_reg_miembro: %', v_reg_miembro;

        v_nombre_completo.nif:= v_reg_miembro.nif;
        v_nombre_completo.nombre:= v_reg_miembro.nombre;
        v_nombre_completo.apellido1:= v_reg_miembro.apellido1;
        RAISE NOTICE '	4. Valor variable tipo compuesta - v_nombre_completo: %', v_nombre_completo;
		RAISE NOTICE '##############################################' ;
    END LOOP;
    
    CLOSE v_cursor_miembros;
END $$;