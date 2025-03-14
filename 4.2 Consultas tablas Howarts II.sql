/*
SGDB: MySQL
Programador: Angie Ibarrola V
Fecha: 02/12/2024
Script: Consultas sobre tablas Howarts II.
*/

-- 1
SELECT LOWER (CONCAT_WS(' ', nombre, apellido1, apellido2)) AS Nombre_Completo
	FROM alumno;
SELECT LOWER (CONCAT(nombre,' ', apellido1,' ', apellido2)) AS Nombre_completo 
	FROM alumno;
-- 2
SELECT CONCAT_WS(' ', UPPER(nombre), apellido1, apellido2) AS Nombre_Completo
	FROM alumno;
-- 3
SELECT CONCAT_WS(' ',nombre, apellido1, IFNULL(apellido2, 'APELLIDO2_NULL'))
	AS Nombre_Completo
		FROM alumno;
-- 4
SELECT IF(apellido2 is null, UPPER (CONCAT_WS( ' ', nombre, apellido1)),
	CONCAT_WS( ' ', nombre, apellido1, apellido2))
		FROM alumno;
-- 5
SELECT CONCAT_WS( ' ', nombre, apellido1, apellido2),
	REVERSE(CONCAT_WS( ' ', nombre, apellido1, apellido2))
		FROM alumno;
-- 6
SELECT UPPER (CONCAT_WS( ' ', nombre, apellido1, apellido2)),
	LOWER (REVERSE (CONCAT_WS( ' ', nombre, apellido1, apellido2)))
		FROM alumno;
-- 7
SELECT nombre, LENGTH(nombre) AS Tamanyo_Bytes,
	CHAR_LENGTH(nombre) AS Tamanyo_Caracteres 
		FROM alumno;
-- 8
SELECT CONCAT_WS (' ', nombre, apellido1, apellido2) AS Nombre_Completo,
	LOWER (CONCAT(nombre, '.', apellido1, '@howarts.uk')) AS email
	FROM alumno;
 /*9 Listado con 3 columnas, las 2 primeras del ej 8.
	La 3ra será la contraseña que se generará con los caracteres invertidos del segundo apellido,
	seguidos de 4 caracteres del año de la fecha de nacimiento.
	Si el segundo apellido está vacío, utilizaremos el primero.*/
SELECT CONCAT_WS (' ', nombre, apellido1, apellido2) AS Nombre_Completo,
	LOWER(CONCAT(nombre, '.', apellido1, '@howarts.uk')) AS email,
	CONCAT(REVERSE(IF(apellido2 IS NULL, apellido1, apellido2)), YEAR(fechaNacimiento)) AS password
	FROM alumno; 