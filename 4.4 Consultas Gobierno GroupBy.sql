/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: 16/12/2024
Script: Consultas Gobierno con GroupBy
*/


ABAJO LO DE ALBA --

-- 1. Calcula la suma del presupuesto de todos los ministerios.
SELECT SUM(presupuesto) FROM ministerio;

-- 2. Calcula la media del presupuesto de todos los ministerios.
SELECT AVG(presupuesto) FROM ministerio;

-- 3. Muestra un listado con dos columnas, una tendrá el valor mínimo del presupuesto de todos los ministerios
	-- y otra el valor máximo.
SELECT
	MIN(ministerio.presupuesto) AS 'MinPresupuesto',
	MAX(ministerio.presupuesto) AS 'MaxPresupuesto' FROM ministerio;

-- 4. Muestra el nombre del ministerio y el presupuesto que tiene asignado, el ministerio con menor presupuesto.
SELECT ministerio.nombre, ministerio.presupuesto
	FROM ministerio
		ORDER BY ministerio.presupuesto ASC
		LIMIT 1;

-- 5. Muestra el nombre del ministerio y el presupuesto que tiene asignado, el ministerio con el mayor presupuesto.
SELECT ministerio.nombre, ministerio.presupuesto
	FROM ministerio
		ORDER BY ministerio.presupuesto DESC
		LIMIT 1;

-- 6. Obtén el número total de miembros que hay en la tabla miembro.
SELECT COUNT(codMiembro) FROM miembro;

-- 7. Obtén la cantidad de miembros que no tienen NULL en su alias.
SELECT COUNT(codMiembro) FROM miembro
	WHERE miembro.alias IS NULL;

-- 8. Muestra el número de miembros que hay en cada ministerio. Tienes que devolver dos columnas, una con
	-- el nombre del ministerio y otra con el número de miembros que tiene asignados. Ordena por cantidad de miembros.
SELECT COUNT (*)miembro.codMiembro
	FROM miembro JOIN ministerio
	WHERE codigoMinisterio = codigoMinisterio ;
	GROUP BY COUNT miembro.codMiembro ministerio.nombre;
	 -- ORDER BY COUNT(codMiembro) ASC;


SGDB: MySQ
Programador: Alba Martínez González
Fecha: 013/12/2024
Script: 4.3 Hogwarts-Consulta Multi-Tabla
*/


/*4. Muestra el nombre del ministerio y el presupuesto que tiene
asignado, el ministerio con menor presupuesto.*/


/*6. Obtén el número total de miembros que hay en la tabla
miembro.*/

SELECT COUNT(*), m.codMiembro 
FROM miembro m 
GROUP BY m.codMiembro;

/*7. Obtén la cantidad de miembros que no tienen NULL en su
alias.*/

SELECT * FROM miembro m 
WHERE m.alias IS NOT NULL;

/*8. Muestra el número de miembros que hay en cada ministerio.
Tienes que devolver dos columnas, una con el nombre del 
ministerio y otra con el número de miembros que tiene
asignados. Ordena por cantidad de miembros*/

SELECT m2.nombre, COUNT(m.codMiembro) 
FROM miembro m JOIN ministerio m2 ON m.codigoMinisterio = m2.codMinisterio
GROUP BY m2.nombre, m.codMiembro
ORDER BY COUNT(m.codMiembro);

/*9. Muestra el nombre de los ministerios que tienen 2 o más
miembros. El resultado debe tener dos columnas, una con el
nombre del ministerio y otra con el número de miembros que
tiene asignados.*/

SELECT m2.nombre ,COUNT(m.codMiembro) 
FROM miembro m JOIN ministerio m2 ON m.codigoMinisterio =m2.codMinisterio 
GROUP BY m2.nombre , m.codMiembro 
HAVING COUNT(m.codMiembro)>1;




-- 9. Muestra el nombre de los ministerios que tienen 2 o más miembros. El resultado debe tener dos columnas,
	-- una con el nombre del ministerio y otra con el número de miembros que tiene asignados.


-- 10. Obtén el número de miembros que pertenecen a cada uno de los ministerios que tienen un
	-- presupuesto mayor a 200000 euros.
