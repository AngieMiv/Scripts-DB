/*
SGDB: MySQL
Programador: XXX YYY ZZZ
Fecha: 31/01/2025
Script: Sentencias de ACTUALIZACIÓN sobre Universidad: Examen práctico RA4
*/

-- (1) Matricula un alumno nuevo (nacido el 31 de enero de 2004 y que vive en Madrid) en una
-- nueva asignatura (con la condición de que no tenga profesor asignado)
-- en un nuevo curso académico (curso 2024/2025)

INSERT INTO curso_escolar
	VALUES
	(11, 2024, 2025);

INSERT INTO asignatura
	VALUES
	(93, 'Astronomia', 6, 'básica', 4, 2, NULL);

INSERT INTO alumno (id, nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo)
	VALUES
	(39, '50562024X', 'Beatriz', 'Romero', 'López', 'Madrid', 'Fleming 1', '912345999', '2004-01-31', 'H');

INSERT INTO alumno_curso_asignatura
	VALUES
	(39, 93, 11);

-- (2) Actualiza la información del alumno anterior para que su residencia sea Palencia.
UPDATE alumno SET alumno.ciudad = 'Palencia' WHERE alumno.id = 39;


-- (3) Sin cambiar la estructura de la base de datos consigue
-- eliminar la asignatura que creaste en el punto 1.
/*ALTER TABLE asignatura 
	DROP PRIMARY KEY WHERE asignatura.id = 93;*/
DELETE FROM alumno_curso_asignatura
	WHERE id_alumno = 39;

DELETE FROM asignatura
	WHERE id = 93;


-- (4) Asigna un profesor a las asignaturas cuyo nombre termina por Datos, teniendo en cuenta que
-- éste ha de aparecer como hombre y pertenecer al departamento de Departamento de Ingeniería de Software
/*SELECT p.nombre, p.id 
	FROM profesor p
	WHERE sexo = 'H'
		AND p.id_departamento = (SELECT d.id FROM departamento d
									WHERE d.nombre = 'Departamento de Ingeniería de Software');

	-- Profesores: (Manolo-14, Pepe-21, Juan-22)
-- INSERT INTO asignatura 
UPDATE asignatura (SELECT id_profesor FROM asignatura WHERE asignatura.nombre LIKE '%Datos')
SET id_profesor TO 21;*/
UPDATE asignatura SET id_profesor = (SELECT p.id
									FROM profesor p JOIN departamento d
									ON p.id_departamento = d.id
									WHERE d.nombre = 'Departamento de Ingenieria de Software'
										AND sexo = 'H'
										LIMIT 1)
	WHERE nombre LIKE '%Datos';

-- (5) Elimina aquellos profesores que no tienen asignaturas asignadas.

DELETE FROM profesor
	WHERE NOT EXISTS (SELECT *  
						FROM asignatura a
						WHERE a.id_profesor = profesor.id);




