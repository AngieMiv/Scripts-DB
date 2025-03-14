/*
SGDB: Postgres
Programador: AMIV
Fecha: 05/03/2025
Script: Gestión de permisos de usuarios.
*/

-- Creación de la base de datos
DROP DATABASE IF EXISTS gestion_permisos;
CREATE DATABASE gestion_permisos;

-- Creación del ENUM definiendo los valores posibles
create type estado_enum as enum ('Activo', 'Inactivo', 'Suspendido');

-- Tabla de Usuarios. SERIAL en vez de INT AUTO_INCREMENT
CREATE TABLE T_USUARIO (
	identificador SERIAL PRIMARY KEY,
	email VARCHAR(100) NOT NULL UNIQUE,
	usuario VARCHAR(50) NOT NULL UNIQUE,
	fecha_alta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fecha_baja TIMESTAMP NULL,
	estado estado_enum NOT NULL DEFAULT 'Activo'
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

-- Carga de datos. Comillas simples para las cadenas para PostreSQL

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


