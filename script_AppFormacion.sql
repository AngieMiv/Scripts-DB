-- Creación de la base de datos
DROP DATABASE if exists app_formacion;
CREATE DATABASE app_formacion;

-- Tabla de Usuarios
CREATE TABLE T_USUARIO (
	identificador SERIAL PRIMARY KEY,
	email VARCHAR(100) NOT NULL UNIQUE,
	usuario VARCHAR(50) NOT NULL UNIQUE,
	fecha_alta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fecha_baja TIMESTAMP NULL,
	estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
	CONSTRAINT CK_ESTADO CHECK(estado IN ('Activo', 'Inactivo', 'Suspendido'))
);

-- Tabla de Roles
CREATE TABLE T_ROL (
	identificador SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE,
	descripcion TEXT NULL
);

-- Tabla de Permisos
CREATE TABLE T_PERMISO (
	identificador SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE,
	descripcion TEXT NULL
);

-- Relación Usuario-Rol (Muchos a Muchos)
CREATE TABLE T_USUARIO_ROL (
	id_usuario INT NOT NULL,
	id_rol INT NOT NULL,
	fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id_usuario, id_rol),
	CONSTRAINT FK_USUARIOROL_USUARIO FOREIGN KEY (id_usuario) REFERENCES T_USUARIO(identificador) ON DELETE CASCADE,
	CONSTRAINT FK_USUARIOROL_ROL FOREIGN KEY (id_rol) REFERENCES T_ROL(identificador) ON DELETE CASCADE
);

-- Relación Rol-Permiso (Muchos a Muchos)
CREATE TABLE T_ROL_PERMISO (
	id_rol INT NOT NULL,
	id_permiso INT NOT NULL,
	fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id_rol, id_permiso),
	FOREIGN KEY (id_rol) REFERENCES T_ROL(identificador) ON DELETE CASCADE,
	FOREIGN KEY (id_permiso) REFERENCES T_PERMISO(identificador) ON DELETE CASCADE
);

-- Sentencias para la actividad 

-- TABLA T_PERSONAL
CREATE TABLE IF NOT EXISTS T_PERSONAL(
  dni CHAR(9) NOT NULL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) NULL
);

-- TABLA T_FORMACION
CREATE TABLE IF NOT EXISTS T_FORMACION(
  identificador serial NOT NULL PRIMARY KEY,
  nombre VARCHAR(250) NOT NULL,
  grado_universitorio BOOLean  NOT NULL DEFAULT true
);

-- TABLA T_GESTOR
CREATE TABLE IF NOT EXISTS T_GESTOR(
  dni CHAR(9) NOT NULL PRIMARY KEY,
  CONSTRAINT FK_GESTOR_PERSONAL
    FOREIGN KEY (dni) REFERENCES T_PERSONAL(dni)
);

-- TABLA T_ALUMNO
CREATE TABLE IF NOT EXISTS T_ALUMNO(
  numero_alumno serial NOT NULL PRIMARY KEY,
  fecha_nacimiento DATE NOT NULL,
  dni CHAR(9) NOT NULL UNIQUE,
  CONSTRAINT FK_ALUMNO_PERSONAL
    FOREIGN KEY (dni) REFERENCES T_PERSONAL(dni)
);

-- TABLA T_PROFESOR
CREATE TABLE IF NOT EXISTS T_PROFESOR(
  identificador serial NOT NULL PRIMARY KEY,
  dni CHAR(9) NOT NULL UNIQUE,
  CONSTRAINT FK_PROFESOR_PERSONAL
    FOREIGN KEY (dni) REFERENCES T_PERSONAL(dni)
);


-- TABLA T_FORMACION_PROFESOR
CREATE TABLE IF NOT EXISTS T_FORMACION_PROFESOR(
  id_profesor INT NOT NULL,
  id_formacion INT NOT NULL,
  PRIMARY KEY (id_profesor, id_formacion),
  CONSTRAINT FK_FORMACIONPROFESOR_PROFESOR
    FOREIGN KEY (id_profesor) REFERENCES T_PROFESOR(identificador),
  CONSTRAINT FK_FORMACIONPROFESOR_FORMACION
    FOREIGN KEY (id_formacion) REFERENCES T_FORMACION(identificador)
);

-- TABLA T_PERSONAL_USUARIO
CREATE TABLE IF NOT EXISTS T_PERSONAL_USUARIO(
  email VARCHAR(50) NOT NULL,
  dni CHAR(9) NOT NULL UNIQUE,
  PRIMARY KEY (email, dni),
  CONSTRAINT FK_PERSONALUSUARIO_PERSONAL
    FOREIGN KEY (dni) REFERENCES T_PERSONAL(dni),
  CONSTRAINT FK_PERSONALUSUARIO_USUARIO
    FOREIGN KEY (email) REFERENCES T_USUARIO(email)
);

-- Carga de datos.

INSERT INTO T_USUARIO (email, usuario, fecha_alta, fecha_baja, estado) VALUES
('juan.perez@educa.madrid.org', 'juanperez', '2023-03-15', NULL, 'Activo'),
('maria.gomez@educa.madrid.org', 'mariagomez', '2023-02-20', NULL, 'Activo'),
('carlos.lopez@educa.madrid.org', 'carloslopez', '2023-01-10', '2024-01-05', 'Inactivo'),
('ana.martin@educa.madrid.org', 'anamartin', '2023-05-25', NULL, 'Activo'),
('jose.rodriguez@educa.madrid.org', 'joserodriguez', '2023-06-30', NULL, 'Suspendido'),
('laura.fernandez@educa.madrid.org', 'laurafernandez', '2023-07-10', NULL, 'Activo'),
('pedro.sanchez@educa.madrid.org', 'pedrosanchez', '2023-08-22', NULL, 'Activo'),
('beatriz.diaz@educa.madrid.org', 'beatrizdiaz', '2023-09-11', '2024-02-01', 'Inactivo'),
('fernando.ruiz@educa.madrid.org', 'fernandoruiz', '2023-10-03', NULL, 'Suspendido'),
('patricia.moreno@educa.madrid.org', 'patriciamoreno', '2023-11-17', NULL, 'Activo'),
('ibrahim.alvarez@educa.madrid.org', 'ibrahimalvarez', '2023-12-05', NULL, 'Activo'),
('alba.navarro@educa.madrid.org', 'albanavarro', '2024-01-07', NULL, 'Suspendido'),
('ruben.torres@educa.madrid.org', 'rubentorres', '2024-02-14', NULL, 'Activo'),
('eva.ramirez@educa.madrid.org', 'evaramirez', '2023-04-09', NULL, 'Inactivo'),
('cesar.molina@educa.madrid.org', 'cesarmolina', '2023-06-15', NULL, 'Activo'),
('monica.ortega@educa.madrid.org', 'monicaortega', '2023-08-29', NULL, 'Activo'),
('alejandro.santos@educa.madrid.org', 'alejandrosantos', '2023-10-20', '2024-01-10', 'Inactivo'),
('lucia.mendez@educa.madrid.org', 'luciamendez', '2023-12-30', NULL, 'Suspendido'),
('david.hernandez@educa.madrid.org', 'davidhernandez', '2024-02-01', NULL, 'Activo'),
('isabel.iglesias@educa.madrid.org', 'isabeliglesias', '2023-03-21', NULL, 'Activo'),
('miguel.castillo@educa.madrid.org', 'miguelcastillo', '2023-05-30', NULL, 'Suspendido'),
('paula.vargas@educa.madrid.org', 'paulavargas', '2023-07-18', NULL, 'Activo'),
('adrian.leon@educa.madrid.org', 'adrianleon', '2023-09-22', NULL, 'Inactivo'),
('nataly.reyes@educa.madrid.org', 'natalyreyes', '2023-11-08', NULL, 'Activo'),
('manuel.martinez@educa.madrid.org', 'manuelmartinez', '2024-01-15', NULL, 'Activo');


INSERT INTO T_ROL (nombre, descripcion) VALUES
('Administrador', 'Tiene acceso total a la plataforma, incluyendo gestión de usuarios, cursos y permisos.'),
('Profesor', 'Puede crear y administrar cursos, evaluar estudiantes y generar contenido.'),
('Estudiante', 'Puede inscribirse en cursos, acceder al material y realizar evaluaciones.'),
('Coordinador', 'Supervisa cursos, profesores y estudiantes, pero sin control total de la plataforma.'),
('Soporte', 'Resuelve incidencias y atiende consultas de usuarios.'),
('Invitado', 'Tiene acceso limitado a ciertos cursos o materiales sin necesidad de registro.');


INSERT INTO T_PERMISO (nombre, descripcion) VALUES
('gestionar_usuarios', 'Crear, modificar y eliminar usuarios.'),
('gestionar_roles', 'Asignar y modificar roles de usuarios.'),
('gestionar_cursos', 'Crear, modificar y eliminar cursos.'),
('inscribirse_curso', 'Inscribirse en un curso disponible.'),
('ver_material', 'Acceder a materiales del curso.'),
('subir_material', 'Subir documentos y recursos a un curso.'),
('gestionar_examenes', 'Crear, modificar y calificar exámenes.'),
('realizar_examen', 'Tomar exámenes dentro de los cursos.'),
('ver_notas', 'Consultar calificaciones obtenidas.'),
('modificar_notas', 'Modificar calificaciones de estudiantes.'),
('gestionar_foro', 'Administrar foros de discusión en los cursos.'),
('publicar_mensaje', 'Escribir mensajes en foros de los cursos.'),
('responder_mensaje', 'Responder a mensajes en foros.'),
('gestionar_soporte', 'Gestionar tickets de soporte técnico.'),
('crear_ticket', 'Abrir un ticket de soporte.'),
('responder_ticket', 'Responder a consultas de soporte.'),
('eliminar_ticket', 'Cerrar o eliminar tickets de soporte.'),
('ver_informes', 'Acceder a informes y estadísticas de cursos.'),
('gestionar_pagos', 'Administrar pagos y suscripciones.'),
('acceso_demo', 'Acceder a una versión de prueba con funcionalidades limitadas.');


-- Asignamos roles a 20 usuarios.
INSERT INTO T_USUARIO_ROL (id_usuario, id_rol) VALUES
(1, 1),  -- juanperez (Administrador)
(2, 1),  -- mariagomez (Administrador)
(3, 2),  -- carloslopez (Profesor)
(4, 2),  -- anamartin (Profesor)
(5, 2),  -- joserodriguez (Profesor)
(6, 3),  -- laurafernandez (Estudiante)
(7, 3),  -- pedrosanchez (Estudiante)
(8, 3),  -- beatrizdiaz (Estudiante)
(9, 3),  -- fernandoruiz (Estudiante)
(10, 4), -- patriciamoreno (Coordinador)
(11, 4), -- ibrahimalvarez (Coordinador)
(12, 5), -- albanavarro (Soporte)
(13, 5), -- rubentorres (Soporte)
(14, 3), -- evaramirez (Estudiante)
(15, 3), -- cesarmolina (Estudiante)
(16, 4), -- monicaortega (Coordinador)
(17, 3), -- alejandrosantos (Estudiante)
(18, 3), -- luciamendez (Estudiante)
(19, 2), -- davidhernandez (Profesor)
(20, 3); -- isabeliglesias (Estudiante)

-- Asignamos permisos a los roles.

-- Administrador tiene todos los permisos.
INSERT INTO T_ROL_PERMISO (id_rol, id_permiso) VALUES
(1, 1),  -- gestionar_usuarios
(1, 2),  -- gestionar_roles
(1, 3),  -- gestionar_cursos
(1, 4),  -- inscribirse_curso
(1, 5),  -- ver_material
(1, 6),  -- subir_material
(1, 7),  -- gestionar_examenes
(1, 8),  -- realizar_examen
(1, 9),  -- ver_notas
(1, 10), -- modificar_notas
(1, 11), -- gestionar_foro
(1, 12), -- publicar_mensaje
(1, 13), -- responder_mensaje
(1, 14), -- gestionar_soporte
(1, 15), -- crear_ticket
(1, 16), -- responder_ticket
(1, 17), -- eliminar_ticket
(1, 18), -- ver_informes
(1, 19), -- gestionar_pagos
(1, 20); -- acceso_demo

-- Profesor tiene permisos relacionados con cursos y exámenes.
INSERT INTO T_ROL_PERMISO (id_rol, id_permiso) VALUES
(2, 3),  -- gestionar_cursos
(2, 4),  -- inscribirse_curso
(2, 5),  -- ver_material
(2, 6),  -- subir_material
(2, 7),  -- gestionar_examenes
(2, 8),  -- realizar_examen
(2, 9),  -- ver_notas
(2, 10), -- modificar_notas
(2, 11), -- gestionar_foro
(2, 12), -- publicar_mensaje
(2, 13); -- responder_mensaje

-- Estudiante tiene permisos limitados para ver material y realizar exámenes.
INSERT INTO T_ROL_PERMISO (id_rol, id_permiso) VALUES
(3, 4),  -- inscribirse_curso
(3, 5),  -- ver_material
(3, 8),  -- realizar_examen
(3, 9),  -- ver_notas
(3, 11), -- gestionar_foro
(3, 12), -- publicar_mensaje
(3, 13); -- responder_mensaje

-- Coordinador tiene permisos para supervisar sin gestionar usuarios.
INSERT INTO T_ROL_PERMISO (id_rol, id_permiso) VALUES
(4, 3),  -- gestionar_cursos
(4, 5),  -- ver_material
(4, 7),  -- gestionar_examenes
(4, 9),  -- ver_notas
(4, 11), -- gestionar_foro
(4, 12); -- publicar_mensaje

-- Soporte tiene permisos para gestionar tickets.
INSERT INTO T_ROL_PERMISO (id_rol, id_permiso) VALUES
(5, 14), -- gestionar_soporte
(5, 15), -- crear_ticket
(5, 16), -- responder_ticket
(5, 17); -- eliminar_ticket


-- Valores
INSERT INTO T_PERSONAL (dni, nombre, apellido1, apellido2) VALUES
('12345678A', 'Juan', 'Perez', 'Garcia'),
('23456789B', 'Maria', 'Gomez', 'Lopez'),
('34567890C', 'Carlos', 'Lopez', 'Martinez'),
('45678901D', 'Ana', 'Martin', 'Rodriguez'),
('56789012E', 'Jose', 'Rodriguez', 'Fernandez'),
('67890123F', 'Laura', 'Fernandez', 'Sanchez'),
('78901234G', 'Pedro', 'Sanchez', 'Ruiz'),
('89012345H', 'Beatriz', 'Diaz', 'Hernandez'),
('90123456I', 'Fernando', 'Ruiz', 'Moreno'),
('01234567J', 'Patricia', 'Moreno', 'Jimenez'),
('12345098K', 'Ibrahim', 'Alvarez', 'Torres'),
('23456109L', 'Alba', 'Navarro', 'Reyes'),
('34567210M', 'Ruben', 'Torres', 'Castro'),
('45678321N', 'Eva', 'Ramirez', 'Vega'),
('56789432O', 'Cesar', 'Molina', 'Ortega'),
('67890543P', 'Monica', 'Ortega', 'Blanco'),
('78901654Q', 'Alejandro', 'Santos', 'Cruz'),
('89012765R', 'Lucia', 'Mendez', 'Ramos'),
('90123876S', 'David', 'Hernandez', 'Nieto'),
('01234987T', 'Isabel', 'Iglesias', 'Pascual'),
('12345019U', 'Miguel', 'Castillo', 'Molina'),
('23456120V', 'Paula', 'Vargas', 'Aguilar'),
('34567231W', 'Adrian', 'Leon', 'Serrano'),
('45678342X', 'Nataly', 'Reyes', 'Campos'),
('56789453Y', 'Manuel', 'Martinez', 'Diaz');
 
INSERT INTO T_PERSONAL_USUARIO (email, dni) VALUES
('juan.perez@educa.madrid.org', '12345678A'),
('maria.gomez@educa.madrid.org', '23456789B'),
('carlos.lopez@educa.madrid.org', '34567890C'),
('ana.martin@educa.madrid.org', '45678901D'),
('jose.rodriguez@educa.madrid.org', '56789012E'),
('laura.fernandez@educa.madrid.org', '67890123F'),
('pedro.sanchez@educa.madrid.org', '78901234G'),
('beatriz.diaz@educa.madrid.org', '89012345H'),
('fernando.ruiz@educa.madrid.org', '90123456I'),
('patricia.moreno@educa.madrid.org', '01234567J'),
('ibrahim.alvarez@educa.madrid.org', '12345098K'),
('alba.navarro@educa.madrid.org', '23456109L'),
('ruben.torres@educa.madrid.org', '34567210M'),
('eva.ramirez@educa.madrid.org', '45678321N'),
('cesar.molina@educa.madrid.org', '56789432O'),
('monica.ortega@educa.madrid.org', '67890543P'),
('alejandro.santos@educa.madrid.org', '78901654Q'),
('lucia.mendez@educa.madrid.org', '89012765R'),
('david.hernandez@educa.madrid.org', '90123876S'),
('isabel.iglesias@educa.madrid.org', '01234987T'),
('miguel.castillo@educa.madrid.org', '12345019U'),
('paula.vargas@educa.madrid.org', '23456120V'),
('adrian.leon@educa.madrid.org', '34567231W'),
('nataly.reyes@educa.madrid.org', '45678342X'),
('manuel.martinez@educa.madrid.org', '56789453Y');

INSERT INTO T_PROFESOR (dni) VALUES
('12345678A'), -- Juan Perez Garcia
('23456789B'), -- Maria Gomez Lopez
('34567890C'), -- Carlos Lopez Martinez
('45678901D'), -- Ana Martin Rodriguez
('56789012E'), -- Jose Rodriguez Fernandez
('90123876S'); -- David Hernandez Nieto

INSERT INTO T_GESTOR (dni) VALUES
('01234567J'); -- Patricia Moreno Jimenez

INSERT INTO T_ALUMNO (fecha_nacimiento, dni) VALUES
('2000-05-15', '67890123F'), -- Laura Fernandez Sanchez
('2001-08-22', '78901234G'), -- Pedro Sanchez Ruiz
('1999-03-10', '89012345H'), -- Beatriz Diaz Hernandez
('2002-11-30', '90123456I'), -- Fernando Ruiz Moreno
('2000-07-18', '12345098K'), -- Ibrahim Alvarez Torres
('2001-02-14', '23456109L'), -- Alba Navarro Reyes
('1998-09-05', '34567210M'), -- Ruben Torres Castro
('2003-04-25', '45678321N'), -- Eva Ramirez Vega
('2000-12-01', '56789432O'), -- Cesar Molina Ortega
('1999-06-19', '67890543P'), -- Monica Ortega Blanco
('2001-10-10', '78901654Q'), -- Alejandro Santos Cruz
('2002-01-23', '89012765R'), -- Lucia Mendez Ramos
('2000-03-17', '01234987T'), -- Isabel Iglesias Pascual
('1999-08-08', '12345019U'), -- Miguel Castillo Molina
('2001-12-12', '23456120V'), -- Paula Vargas Aguilar
('2000-04-30', '34567231W'), -- Adrian Leon Serrano
('2002-07-07', '45678342X'), -- Nataly Reyes Campos
('1998-11-11', '56789453Y'); -- Manuel Martinez Diaz

  -- Inserción de 25 formaciones en la tabla T_FORMACION
INSERT INTO T_FORMACION (nombre, grado_universitorio)
VALUES
  ('Ingeniería Informática', true),
  ('Medicina', true),
  ('Derecho', true),
  ('Arquitectura', true),
  ('Biología', true),
  ('Matemáticas', true),
  ('Historia', true),
  ('Economía', true),
  ('Filosofía', true),
  ('Educación', true),
  ('Marketing', true),
  ('Física', true),
  ('Química', true),
  ('Psicología', true),
  ('Geografía', true),
  ('Administración de Empresas', false), 
  ('Comunicación Audiovisual', false), 
  ('Turismo', false), 
  ('Diseño Gráfico', false), 
  ('Marketing y Publicidad', false), 
  ('Gestión de Sistemas Informáticos', false), 
  ('Automatización y Robótica Industrial', false), 
  ('Desarrollo de Aplicaciones Multiplataforma', false), 
  ('Instalaciones Electrotécnicas', false), 
  ('Gestión de Redes de Voz y Datos', false); 
  
 INSERT INTO T_FORMACION_PROFESOR (id_profesor, id_formacion) VALUES
-- Juan Pérez García (id_profesor = 1): Especializado en tecnología
(1, 1),  -- Ingeniería Informática
(1, 21), -- Gestión de Sistemas Informáticos
(1, 23), -- Desarrollo de Aplicaciones Multiplataforma
-- María Gómez López (id_profesor = 2): Área de ciencias de la salud
(2, 2),  -- Medicina
(2, 5),  -- Biología
(2, 14), -- Psicología
-- Carlos López Martínez (id_profesor = 3): Ciencias exactas
(3, 6),  -- Matemáticas
(3, 12), -- Física
(3, 13), -- Química
-- Ana Martín Rodríguez (id_profesor = 4): Humanidades y sociales
(4, 3),  -- Derecho
(4, 9),  -- Filosofía
(4, 15), -- Geografía
-- José Rodríguez Fernández (id_profesor = 5): Educación y formación técnica
(5, 10), -- Educación
(5, 22), -- Automatización y Robótica Industrial
-- David Hernández Nieto (id_profesor = 6): Negocios y comunicación
(6, 8),  -- Economía
(6, 11), -- Marketing
(6, 17); -- Comunicación Audiovisual