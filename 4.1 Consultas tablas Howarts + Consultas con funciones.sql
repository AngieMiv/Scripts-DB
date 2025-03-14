/*
SGDB: MySQL
Programador: Angie Ibarrola Valenzuela
Fecha: 06/12/2024
Script: Consultas sobre Howarts & Consultas con funciones.
*/

-- 1 
SELECT * FROM alumno
	WHERE es_repetidor = 'si';
-- 2
SELECT * FROM alumno
	WHERE (fechaNacimiento BETWEEN '1980/02/01' AND '1980/08/03');
-- 3 
SELECT DISTINCT apellido1 FROM alumno
	WHERE apellido1 LIKE '%y';
-- 4
SELECT * FROM alumno
	WHERE CHAR_LENGTH(nombre) = 4;
-- 5
SELECT * FROM alumno
	WHERE (CHAR_LENGTH(nombre) = 4 AND nombre LIKE '%a');
-- 6
SELECT DISTINCT * FROM alumno
	WHERE nombre LIKE '%\_%';
-- 7
SELECT * FROM alumno
	WHERE YEAR (fechaNacimiento) IN (1925, 1981);
-- 8
SELECT nombre, apellido1 FROM alumno
	WHERE apellido2 IS NULL;
-- 9
SELECT nombre, apellido1 FROM alumno
	WHERE (apellido2 IS NULL OR telefono IS NULL);

/*Solo funciones de las vistas*/

-- 10 
SELECT STR_TO_DATE('01/10/1997', '%d/%m/%Y');
-- 11
SELECT DATE_ADD('1997-10-01', INTERVAL 32 MONTH);
-- 12
SELECT ADDDATE('1997-10-01', INTERVAL 1000 DAY);
-- 13
SELECT DATE_SUB(CURDATE() , INTERVAL 2 YEAR);
-- 14
SELECT ROUND(DATEDIFF (CURDATE(), '1997-10-01')/365, 2);
-- 15
SELECT TRUNCATE(DATEDIFF (CURDATE(), '1997-10-01')/365, 0);
-- 16
SELECT CONCAT_WS('|', 'Angie', 'Ibarrola', 'Valenzuela');
-- 17
SELECT CHAR_LENGTH(REPLACE("Feliz Año 2025. Te deseo que sea un año pleno", ' ', ''));
-- 18
SELECT LENGTH(REPLACE("Feliz Año 2025. Te deseo que sea un año pleno", ' ', ''));

