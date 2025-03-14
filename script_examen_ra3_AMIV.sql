/*
SGDB: MySQL
Programador: ANGIE M. IBARROLA VALENZUELA
Fecha: 31/01/2025
Script: Sentencias de CONSULTA sobre Universidad: Examen práctico RA3
*/

/*(1) Muestra un listado con la información de los alumnos que viven en Almería
o Palencia, que tienen un número de telefono y que han nacido el dia 20 de cualquier mes y año
y se ordenará por fecha de nacimiento (más jovenes primero)*/
 SELECT *
 FROM alumno a
 	WHERE a.telefono IS NOT NULL AND (a.ciudad = 'Almería' OR a.ciudad = 'Palencia')
	AND (a.fecha_nacimiento LIKE '%20')
	ORDER BY fecha_nacimiento DESC;

/*(2) Selecciona un listado de los profesores que son mujeres, que viven en una dirección que,
a partir de su 6º carácter, empieca por Mayor (el filtro contendrá únicamente 2 cláusulas)*/
SELECT *
FROM profesor p 
WHERE p.direccion LIKE '______Mayor%' AND p.sexo = 'M';

/*(3) Obtener un listado de los profesores, que son mujeres, nacidas entre 1970 y 1990,
o bien en mayo, junto con las asignaturas que imparte. El listado se ordenará alfabéticamente,
por nombre del profesor y nombre de las asignaturas*/

SELECT p.nombre AS profesora, a.nombre, p.fecha_nacimiento 
	FROM profesor p JOIN asignatura a 
		ON p.id = a.id_profesor
		WHERE p.sexo= 'M'
	-- WHERE (p.fecha_nacimiento BETWEEN '01/01/1970' AND '31/12/1990')
		-- OR (p.fecha_nacimiento LIKE '___05_____')
	ORDER BY p.nombre ASC;

/*(4) Obtener una lista de las asignaturas de "tipo básico" cuyo nombre NO empieza por A,
termina por 'ca', por 'ón' o por 'al' y se dan en primer curso.
En caso de no conocerse el nombre del profesor, se mostrará el texto "Sin profesor asignado".
Se ordenarán alfabéticamente por nombre de asignatura*/

SELECT a.curso AS 'Número de curso', a.nombre AS 'Asignatura', p.nombre AS 'Profesor', a.tipo AS 'Tipo asignatura'
FROM asignatura a JOIN profesor p ON a.id_profesor = p.id
	WHERE (a.tipo = 'básica')
	AND (a.nombre NOT LIKE 'A%' AND (a.nombre LIKE '%ca' OR a.nombre LIKE '%ón' OR a.nombre LIKE '%al')
	AND (a.curso = 1))
	-- AND a.id_profesor = IFNULL(a.id_profesor = p.nombre, 'Sin profesor asignado')
	ORDER BY a.nombre ASC;

/*(5) Obtener el número de asignaturas que sean de tipo 'Optativa' o 'Básica'
y que no tienen profesor asignado, de aquellas facultades cuyo nombre no tiene una 
longitud mayor de 40 caracteres*/

SELECT f.nombre AS 'Nombre de Facultad', COUNT(*) AS 'Nº asignaturas' 
FROM facultad f, asignatura a
WHERE CHAR_LENGTH(f.nombre) > 40
AND (a.tipo = 'básica' OR a.tipo = 'optativa'); -- AND NOT EXISTS id_profesor

/*(6) Obtener la lista de asignaturas que tengan alumnos matriculados, cuyo profesor que pertenece a facultades
cuyo nombre termina en 'Físicas' (para esta parte se usará la cláusula EXISTS/NOT EXISTS).
El resultado se ordenará alfabéticamente*/

SELECT *
FROM asignatura a 
WHERE EXISTS (SELECT id_asignatura FROM alumno_curso_asignatura)
	AND EXISTS(SELECT p.id FROM profesor p
				WHERE p.id_departamento IN (SELECT d.id FROM departamento d JOIN facultad f 
										ON d.id_facultad = f.id
										WHERE f.nombre LIKE '%Físicas'))
	ORDER BY a.nombre ASC;

/*(7) Obtener un listado con las facultades y grados que tienen menos de 2 asignaturas sin profesor asignado.
El resultado se ordenará por número de asignatura de manera descendente y,
alfabéticamente por nombre de facultad y nombre de grado.*/



/*(8) Generar una vista que obtenga el listado de los alumnos matriculados en el curso escolar 2018/2019
en asignaturas del segundo cuatrimestre.*/
CREATE OR REPLACE VIEW V_alumnos_curso_2018_2019 AS
(SELECT a.*
FROM alumno a, alumno_curso_asignatura aca, curso_escolar ce
WHERE (a.id = aca.id_alumno) AND (aca.id_curso_escolar = ce.id)
AND ce.anyo_inicio = 2018 AND ce.anyo_fin = 2029
);

/*A partir de esa vista, se obtendrá un listado de los alumnos nacidos entre 1996 y 2000. Se ordenará
alfabéticamente, por nombre de alumno y nombre de asignatura.*/

SELECT VIEW v_alumnos_curso_2018_2019
-- WHERE YEAR(fecha_nacimiento) BETWEEN 1996 AND 2000
ORDER BY nombre ASC;


/*(9) Obtener los departamentos sin profesores que pertenecen a facultades
que ofrezcan más de 2 asignaturas*/
SELECT *
FROM departamento d 
WHERE EXISTS (SELECT * FROM facultad f JOIN grado g join ON f.id = g.id_facultad
				WHERE (SELECT * FROM grado g JOIN ));

/*(10) Obtener los profesores que imparten docencia en asignaturas de grados que NO pertenecen a su facultad.
se mostrará la información ordenada, alfabéticamente, por el NIF del profesor.*/