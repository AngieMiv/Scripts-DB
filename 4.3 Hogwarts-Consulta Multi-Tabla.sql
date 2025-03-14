/*
 * 4.3 Hogwarts-Consulta Multi-Tabla
 * SGDB: MySQL
 * Programador: Angie Ibarrola V.
 * Fecha: 13/12/2024
 * Script: Consultas sobre Howarts & Consultas con funciones.
 */

/* 1. Obtener el nombre y los dos apellidos de todos los alumnos, en minúsculas
	y en una sola columna (Nombres y apellidos separados con un espacio). */
SELECT LOWER(CONCAT_WS(' ', nombre, apellido1, apellido2))
	AS 'Nombre_Completo' FROM alumno;

/* 2. Devuelve el listado con todos los datos de los alumnos y
	el nombre de la casa a la que pertenecen. */
SELECT * FROM alumno JOIN casa
	ON alumno.idCasa = casa.idCasa;

/* 3. Devuelve un listado con el nombre y apellidos de los alumnos 
	y el nombre de la casa a la que pertenecen.
	Ordena el resultado por el nombre de la casa y luego por nombre del alumno.*/
SELECT alumno.nombre, alumno.apellido1, alumno.apellido2, casa.Nombre
	FROM alumno, casa
		WHERE alumno.idCasa = casa.idCasa
			ORDER BY casa.Nombre, alumno.Nombre ASC;

/* 4. Devuelve el nombre, los apellidos y la fecha de nacimiento y el nombre de la casa del alumno
	más joven.*/
SELECT MIN(alumno.fechaNacimiento), alumno.nombre, apellido1, apellido2, fechaNacimiento, casa.Nombre
	FROM alumno, casa
		WHERE alumno.idCasa = casa.idCasa;

/* 5. Devuelve un listado con todos los alumnos de “Gryffindor” ordenados por nombre.*/
SELECT * FROM alumno
	ORDER BY alumno.nombre ASC;
	
/* 6. Devuelve un listado con todos los alumnos de “Gryffindor” que no hayan repetido.*/
SELECT * FROM alumno JOIN casa
	ON alumno.idCasa = casa.idCasa
		WHERE alumno.es_repetidor = 'no' AND casa.Nombre = 'Gryffindor';
	
/* 7. Devuelve un listado con todos los alumnos de los casas “Slytherin“ y ”Ravenclaw”,
	sin utilizar el operador IN.*/
SELECT * FROM alumno JOIN casa
	ON alumno.idCasa = casa.idCasa
		WHERE casa.Nombre = 'Slytherin' OR casa.Nombre = 'Ravenclaw';

/* 8. Devuelve un listado con todos los alumnos de las casas “Slytherin“ y ”Ravenclaw”
	utilizando el operador IN.*/
SELECT * FROM alumno JOIN casa
	ON alumno.idCasa = casa.idCasa
		WHERE casa.Nombre IN ('Slytherin', 'Ravenclaw');

