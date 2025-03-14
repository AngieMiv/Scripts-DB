/* PostgreSQL INSERT DATA */

INSERT INTO t_empresa (nombre, fecha_fundacion, propietario, director_actual)
	VALUES ('Capcom', '1979-05-30', 'Kenzo Tsujimoto', 'Haruhiro Tsujimoto')
	;

/* --- coordinadores --- */
INSERT INTO t_empleado (id_empleado, dni, nombre, apellido, apellido2, fecha_nacimiento, fecha_alta, salario, id_coordinador, empresa)
	VALUES
	(1, '11111111A', 'Ryozo', 'Tsujimoto', NULL, '1973-08-01', '1995-04-10', 150000.00, 1, 1), /*id_empleado 1 (coordinador id: 1 programadores) */
	(2, '22222222B', 'Miguel', 'García', 'Pérez', '1975-03-15', '2000-06-01', 140000.00, 2, 1), /*id_empleado 2 (coord.Id: 2 testers) */
	(3, '33333333C', 'Aiko', 'Tanaka', 'Yamashita', '1980-07-20', '2005-01-12', 130000.00, 3,1), /*id_empleado 3 (coord.Id: 3 ingenieros sonido) */
	(4, '44444444D', 'Carlos', 'Ramírez', 'López', '1978-09-10', '2010-04-01', 135000.00, 4, 1), /*id_empleado 4 (coord.Id: 4 animadores) */
	(5, '55555555E', 'Sofía', 'Martínez', 'Gómez', '1982-11-05', '2015-08-22', 125000.00, 5, 1) /*id_empleado 5 (coord.Id: 5 otros) */
	;

	/* --- empleados --- */
INSERT INTO t_empleado (dni, nombre, apellido, apellido2, fecha_nacimiento, fecha_alta, salario, id_coordinador, empresa)
	VALUES
	('66666666F', 'Yumi', 'Kobayashi', NULL, '1987-01-18', '2018-03-15', 70000.00, 1, 1),
	('77777777G', 'José', 'Fernández', 'Ruiz', '1990-05-22', '2017-09-30', 72000.00, 2, 1),
	('88888888H', 'Sakura', 'Nagano', NULL, '1992-12-14', '2019-07-01', 71000.00, 3, 1),
	('99999999I', 'Ana', 'Hernández', 'Sánchez', '1988-04-03', '2016-11-10', 73000.00, 4, 1),
	('00000000J', 'Luis', 'Torres', 'Morales', '1985-08-26', '2018-06-25', 75000.00, 5, 1)
	;

/* --- programadores --- */
INSERT INTO t_programador (id_empleadopro, lenguaje_programacion)
	VALUES
	(1, 'C++'), -- Coordinador
	(6, 'Python') -- Empleado normal
	;

/* --- testers --- */
INSERT INTO t_tester (id_empleadot, plataforma)
	VALUES 
	(2, 'PlayStation 4'), -- Coordinador
	(7, 'PC') -- Empleado normal
	;

/* --- ingenieros sonido --- */
INSERT INTO t_ingeniero_sonido (id_empleadoso, editor_sonido)
	VALUES 
	(3, 'Pro Tools'), -- Coordinador
	(8, 'FL Studio') -- Empleado normal
	;

/* --- animadores --- */
INSERT INTO t_animador (id_empleadoan, programa_animacion)
	VALUES 
	(4, 'Maya'), -- Coordinador
	(9, 'Blender') -- Empleado normal
	;

/* --- otros --- */
INSERT INTO t_otros (id_empleadoo, categoria)
	VALUES
	(5, 'Marketing'), -- Coordinador
	(10, 'Soporte Técnico') -- Empleado normal
	;

/* --- premios --- */
INSERT INTO t_premio (id_premio, nombre)
	VALUES 
	(1, 'Best RPG 2018'),
	(2, 'Game of the Year 2018')
	;

/* --- videojuegos --- */
INSERT INTO t_videojuego (cod_videojuego, nombre, fecha_salida, precio_salida, pegi, nota_metecritic)
	VALUES
	('MHW01', 'Monster Hunter World', '2018-01-26', 59.99, '16', 8.80)
	;

/* --- plataformas.videojuego --- */
INSERT INTO t_plataforma (nombre_plataforma, cod_videojuego)
	VALUES 
	('PC', 'MHW01'),
	('PlayStation 4', 'MHW01'),
	('Xbox One', 'MHW01')
	;

/* --- generos.videojuego --- */
INSERT INTO t_genero (nombre_genero, cod_videojuego)
	VALUES 
	('Action RPG', 'MHW01'),
	('Adventure', 'MHW01')
	;

/* --- empresa.videojuego --- */
INSERT INTO t_videojuego_empresa (empresa, videojuego)
	VALUES (1, 'MHW01')
	;

/* --- empresa.videojuego:premio --- */
INSERT INTO t_videojuego_empresa_premio (empresa, videojuego, premio)
	VALUES
	(1, 'MHW01', 1),
	(1, 'MHW01', 2)
	;
