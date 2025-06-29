CREATE TABLE facultad (
    id serial PRIMARY KEY,
    nombre VARCHAR(250) NOT NULL
);

 
CREATE TABLE departamento (
    id serial PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, 
	id_facultad INT not null,
	constraint FK_DEPARTAMENTO_FACULTAD
		FOREIGN KEY (id_facultad) REFERENCES facultad(id)
);

CREATE TABLE alumno (
    id serial PRIMARY KEY,
    nif VARCHAR(9) UNIQUE,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) check(sexo IN('H', 'M')) NOT NULL
);
 
CREATE TABLE profesor (
    id serial PRIMARY KEY,
    nif VARCHAR(9) UNIQUE,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) check(sexo IN('H', 'M')) NOT NULL,
    id_departamento INT NOT NULL,
    activo char(1) check(activo IN('S', 'N')) default 'S' NOT NULL,
    fecha_baja date default null, 
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);
 
 CREATE TABLE grado (
    id serial PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
	id_facultad INT not null,
	constraint FK_GRADO_FACULTAD
		FOREIGN KEY (id_facultad) REFERENCES facultad(id)    
);
 
CREATE TABLE asignatura (
    id serial PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT NOT NULL,
    tipo VARCHAR(25) check(tipo in ('básica', 'obligatoria', 'optativa')) NOT NULL,
    curso smallint NOT NULL,
    cuatrimestre smallint NOT NULL,
    id_profesor INT,
    CONSTRAINT FK_ASIGNATURA_PROFESOR
	    FOREIGN KEY(id_profesor) REFERENCES profesor(id)
);

CREATE TABLE asignatura_grado (
    id_asignatura INT NOT NULL,
    id_grado INT NOT NULL,
    PRIMARY KEY (id_asignatura, id_grado),
    CONSTRAINT FK_ASIGNATURAGRADO_ASIGNATURA
	    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
	CONSTRAINT FK_ASIGNATURAGRADO_GRADO
	    FOREIGN KEY (id_grado) REFERENCES grado(id)
);

CREATE TABLE curso_escolar (
    id serial PRIMARY KEY,
    anyo_inicio date NOT NULL,
    anyo_fin date NOT NULL
);

CREATE TABLE alumno_curso_asignatura (
    id_alumno INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_curso_escolar INT NOT NULL,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);

create table auditoria(
	id_auditoria Serial primary key,
	nombre_tabla varchar(50) not null,
	usuario varchar(20) not null default current_user,
	texto text not null,
	fecha_auditoria timestamp default current_timestamp
);

  /* Facultad */
INSERT INTO facultad VALUES (1, 'Facultad de Ciencias de la Computación e Informática');
INSERT INTO facultad VALUES (2, 'Facultad de Ciencias Matemáticas');
INSERT INTO facultad VALUES (3, 'Facultad de Economía y Empresa');
INSERT INTO facultad VALUES (4, 'Facultad de Educación');
INSERT INTO facultad VALUES (5, 'Facultad de Agronomía y Ciencias Ambientales');
INSERT INTO facultad VALUES (6, 'Facultad de Ciencias Químicas y Físicas');
INSERT INTO facultad VALUES (7, 'Facultad de Filología y Lingüística');
INSERT INTO facultad VALUES (8, 'Facultad de Derecho');
INSERT INTO facultad VALUES (9, 'Facultad de Ciencias Biológicas y Geológicas');

 /* Departamento */
INSERT INTO departamento VALUES (1, 'Departamento de Ingeniería de Software',1);
INSERT INTO departamento VALUES (2, 'Departamento de Álgebra y Geometría',2);
INSERT INTO departamento VALUES (3, 'Departamento de Economía Aplicada',3);
INSERT INTO departamento VALUES (4, 'Departamento de Didáctica y Organización Escolar',4);
INSERT INTO departamento VALUES (5, 'Departamento de Agricultura Sostenible',5);
INSERT INTO departamento VALUES (6, 'Departamento de Química Orgánica',6);
INSERT INTO departamento VALUES (7, 'Departamento de Lingüística General',7);
INSERT INTO departamento VALUES (8, 'Departamento de Derecho Constitucional',8);
INSERT INTO departamento VALUES (9, 'Departamento de Biología Celular',9);
INSERT INTO departamento VALUES (10, 'Departamento de Biología Molecular',9);
INSERT INTO departamento VALUES (11, 'Departamento de Ciencias de la Computación Aplicada',1);
INSERT INTO departamento VALUES (12, 'Departamento de Análisis Matemático',2);
INSERT INTO departamento VALUES (13, 'Departamento de Dirección de Empresas',3);
INSERT INTO departamento VALUES (14, 'Departamento de Psicología de la Educación',4);
INSERT INTO departamento VALUES (15, 'Departamento de Medio Ambiente y Recursos Naturales',5);
INSERT INTO departamento VALUES (16, 'Departamento de Física Teórica',6);
INSERT INTO departamento VALUES (17, 'Departamento de Literatura Comparada',7);
INSERT INTO departamento VALUES (18, 'Departamento de Derecho Internacional',8);
INSERT INTO departamento VALUES (19, 'Departamento de Geología Ambiental',9);
INSERT INTO departamento VALUES (20, 'Departamento de Derecho Ambiental',8);
INSERT INTO departamento VALUES (21, 'Departamento de Matemática Estadística y Computación',2);
INSERT INTO departamento VALUES (22, 'Departamento de Cálculo Numérico',2);
INSERT INTO departamento VALUES (23, 'Departamento de Física Aplicada',6);
 
 /* Persona */
INSERT INTO alumno VALUES (1, '89542419S', 'Juan', 'Saez', 'Vega', 'Almería', 'C/ Mercurio', '618253876', '1992/08/08', 'H');
INSERT INTO alumno VALUES (2, '26902806M', 'Salvador', 'Sánchez', 'Pérez', 'Almería', 'C/ Real del barrio alto', '950254837', '1991/03/28', 'H');
INSERT INTO alumno VALUES (4, '17105885A', 'Pedro', 'Heller', 'Pagac', 'Almería', 'C/ Estrella fugaz', NULL, '2000/10/05', 'H');
INSERT INTO alumno VALUES (6, '04233869Y', 'José', 'Koss', 'Bayer', 'Almería', 'C/ Júpiter', '628349590', '1998/01/28', 'H');
INSERT INTO alumno VALUES (7, '97258166K', 'Ismael', 'Strosin', 'Turcotte', 'Almería', 'C/ Neptuno', NULL, '1999/05/24', 'H');
INSERT INTO alumno VALUES (9, '82842571K', 'Ramón', 'Herzog', 'Tremblay', 'Almería', 'C/ Urano', '626351429', '1996/11/21', 'H');
INSERT INTO alumno VALUES (11, '46900725E', 'Daniel', 'Herman', 'Pacocha', 'Almería', 'C/ Andarax', '679837625', '1997/04/26', 'H');
INSERT INTO alumno VALUES (19, '11578526G', 'Inma', 'Lakin', 'Yundt', 'Almería', 'C/ Picos de Europa', '678652431', '1998/09/01', 'M');
INSERT INTO alumno VALUES (21, '79089577Y', 'Juan', 'Gutiérrez', 'López', 'Almería', 'C/ Los pinos', '678652431', '1998/01/01', 'H');
INSERT INTO alumno VALUES (22, '41491230N', 'Antonio', 'Domínguez', 'Guerrero', 'Almería', 'C/ Cabo de Gata', '626652498', '1999/02/11', 'H');
INSERT INTO alumno VALUES (23, '64753215G', 'Irene', 'Hernández', 'Martínez', 'Almería', 'C/ Zapillo', '628452384', '1996/03/12', 'M');
INSERT INTO alumno VALUES (24, '85135690V', 'Sonia', 'Gea', 'Ruiz', 'Almería', 'C/ Mercurio', '678812017', '1995/04/13', 'M');
INSERT INTO alumno (id, nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo) VALUES
(25, '12345678A', 'Ana', 'González', 'López', 'Madrid', 'Calle Mayor 1', '912345678', '2000-05-15', 'M'),
(26, '23456789B', 'Pedro', 'Martínez', 'Fernández', 'Palencia', 'Calle Principal 2', '987654321', '1999-07-20', 'H'),
(27, '34567890C', 'María', 'Sánchez', 'García', 'Santander', 'Avenida Central 3', '876543210', '2001-03-10', 'M'),
(28, '45678901D', 'Juan', 'Rodríguez', 'Pérez', 'Madrid', 'Plaza Mayor 4', '765432109', '2000-11-25', 'H'),
(29, '56789012E', 'Sara', 'López', 'Martín', 'Palencia', 'Calle Secundaria 5', '654321098', '2002-09-03', 'M'),
(30, '67890123F', 'David', 'Fernández', 'Hernández', 'Santander', 'Paseo de la Playa 6', '543210987', '2001-12-18', 'H'),
(31, '78901234G', 'Lucía', 'Pérez', 'Gómez', 'Madrid', 'Calle del Sol 7', '432109876', '2002-08-05', 'M'),
(32, '89012345H', 'Javier', 'Gómez', 'Sánchez', 'Palencia', 'Avenida del Parque 8', '321098765', '2001-06-12', 'H'),
(33, '90123456I', 'Carmen', 'Martín', 'Muñoz', 'Santander', 'Calle Mayor 9', '210987654', '2000-04-27', 'M'),
(34, '01234567J', 'Daniel', 'Hernández', 'Jiménez', 'Madrid', 'Plaza del Carmen 10', '109876543', '2002-10-30', 'H'),
(35, '98765432K', 'Elena', 'Jiménez', 'Díaz', 'Palencia', 'Calle de la Fuente 11', '987654321', '2001-02-14', 'M'),
(36, '87654321L', 'Miguel', 'Díaz', 'Martínez', 'Santander', 'Avenida de la Estación 12', '876543210', '2000-07-09', 'H'),
(37, '76543210M', 'Paula', 'Muñoz', 'López', 'Madrid', 'Calle Real 13', '765432109', '2002-05-22', 'M'),
(38, '65432109N', 'Marcos', 'Ruiz', 'Sánchez', 'Palencia', 'Paseo de la Alameda 14', '654321098', '2001-09-17', 'H');


/* Profesor */
INSERT INTO profesor VALUES (3, '11105554G', 'Zoe', 'Ramirez', 'Gea', 'Almería', 'C/ Marte', '618223876', '1979/08/19', 'M', 1, 'S', NULL);
INSERT INTO profesor VALUES (5, '38223286T', 'David', 'Schmidt', 'Fisher', 'Almería', 'C/ Venus', '678516294', '1978/01/19', 'H', 2, 'S', NULL);
INSERT INTO profesor VALUES (8, '79503962T', 'Cristina', 'Lemke', 'Rutherford', 'Almería', 'C/ Saturno', '669162534', '1977/08/21', 'M', 3, 'N', '2020/08/21');
INSERT INTO profesor VALUES (10, '61142000L', 'Esther', 'Spencer', 'Lakin', 'Almería', 'C/ Plutón', NULL, '1977/05/19', 'M', 4, 'N', CURRENT_DATE);
INSERT INTO profesor VALUES (12, '85366986W', 'Carmen', 'Streich', 'Hirthe', 'Almería', 'C/ Almanzora', NULL, '1971-04-29', 'M', 4, 'S', NULL);
INSERT INTO profesor VALUES (13, '73571384L', 'Alfredo', 'Stiedemann', 'Morissette', 'Almería', 'C/ Guadalquivir', '950896725', '1980/02/01', 'H', 6, 'S', NULL);
INSERT INTO profesor VALUES (14, '82937751G', 'Manolo', 'Hamill', 'Kozey', 'Almería', 'C/ Duero', '950263514', '1977/01/02', 'H', 1, 'S', NULL);
INSERT INTO profesor VALUES (15, '80502866Z', 'Alejandro', 'Kohler', 'Schoen', 'Almería', 'C/ Tajo', '668726354', '1980/03/14', 'H', 2,  'N', '2023/08/21');
INSERT INTO profesor VALUES (16, '10485008K', 'Antonio', 'Fahey', 'Considine', 'Almería', 'C/ Sierra de los Filabres', NULL, '1982/03/18', 'H', 3, 'S', NULL);
INSERT INTO profesor VALUES (17, '85869555K', 'Guillermo', 'Ruecker', 'Upton', 'Almería', 'C/ Sierra de Gádor', NULL, '1973/05/05', 'H', 4, 'S', NULL);
INSERT INTO profesor VALUES (18, '04326833G', 'Micaela', 'Monahan', 'Murray', 'Almería', 'C/ Veleta', '662765413', '1976/02/25', 'H', 5, 'N', CURRENT_DATE);
INSERT INTO profesor VALUES (20, '79221403L', 'Francesca', 'Schowalter', 'Muller', 'Almería', 'C/ Quinto pino', NULL, '1980/10/31', 'H', 6, 'S', NULL);
INSERT INTO profesor VALUES (21, '13175769N', 'Pepe', 'Sánchez', 'Ruiz', 'Almería', 'C/ Quinto pino', NULL, '1980/10/16', 'H', 1, 'S', NULL);
INSERT INTO profesor VALUES (22, '98816696W', 'Juan', 'Guerrero', 'Martínez', 'Almería', 'C/ Quinto pino', NULL, '1980/11/21', 'H', 1,  'N', '2023/11/21');
INSERT INTO profesor VALUES (23, '77194445M', 'María', 'Domínguez', 'Hernández', 'Almería', 'C/ Quinto pino', NULL, '1980/12/13', 'M', 2,  'N', CURRENT_DATE);
INSERT INTO profesor VALUES (24, '12345678A', 'María', 'García', 'López', 'Madrid', 'Calle Principal 123', '912345678', '1980-05-15', 'M', 20, 'N', '2020/11/21');

--
INSERT INTO profesor (id, nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo, id_departamento) VALUES
(25, '87654321B', 'Juan', 'Martínez', 'Sánchez', 'Barcelona', 'Avenida Central Mayor  456', '934567890', '1975-08-20', 'H', 11),
(26, '98765432C', 'Laura', 'Fernández', 'González', 'Valencia', 'Plaza Mayor 789', '965432109', '1988-03-10', 'M', 6),
(27, '23456789D', 'Carlos', 'López', 'Martín', 'Sevilla', 'Calle Secundaria 456', '955678901', '1972-11-25', 'H', 2),
(28, '34567890E', 'Ana', 'Rodríguez', 'Hernández', 'Bilbao', 'Paseo de la Playa 987', '944321098', '1984-07-03', 'M', 22),
(29, '45678901F', 'David', 'Pérez', 'García', 'Málaga', 'Calle del Sol Mayor 234', '951234567', '1978-09-12', 'H', 21),
(30, '56789012G', 'Elena', 'Sánchez', 'Díaz', 'Granada', 'Avenida del Parque 567', '958765432', '1982-12-28', 'M', 6),
(31, '67890123H', 'Javier', 'López', 'Muñoz', 'Toledo', 'Plaza de la Constitución 345', '925678901', '1976-04-05', 'H', 6),
(32, '78901234I', 'Sara', 'Martínez', 'Ruiz', 'Zaragoza', 'Calle Mayor 678', '976543210', '1990-06-18', 'M', 9),
(33, '89012345J', 'Pedro', 'López', 'Gómez', 'Madrid', 'Calle Mayor 789', '910123456', '1977-10-25', 'H', 10),
(34, '90123456K', 'Carmen', 'Martínez', 'Fernández', 'Barcelona', 'Avenida del Parque Mayor 123', '934567890', '1983-02-14', 'M', 16),
(35, '01234567L', 'Miguel', 'García', 'Pérez', 'Valencia', 'Calle del Mar 456', '960987654', '1979-06-30', 'H', 12),
(36, '98765432M', 'Dalia', 'Rodríguez', 'Sánchez', 'Sevilla', 'Paseo de la Mayor Playa 234', '955432109', '1985-12-05', 'M', 13);



/* Grado */
INSERT INTO grado (id, nombre, id_facultad) values 
	(1, 'Grado en Matemáticas', 2),
	(2, 'Grado en Estadística', 2),
	(3, 'Grado en Matemáticas Aplicadas',2),
	(4, 'Grado en Ingeniería Informática', 1),
	(5, 'Grado en Ciencia de Datos', 1),
	(6, 'Grado en Seguridad Informática',1),
	(7, 'Grado en Biotecnología',9),
	(8, 'Grado en Administración y Dirección de Empresas (ADE)', 3),
	(9, 'Grado en Marketing',3),
	(10, 'Grado en Educación Primaria', 4),
	(11, 'Grado en Educación Infantil', 4),
	(12, 'Grado en Pedagogía',4),	
	(13, 'Grado en Ingeniería Agrícola', 5),
	(14, 'Grado en Ciencias Ambientales', 5),
	(15, 'Grado en Ingeniería Forestal',5),
	(16, 'Grado en Química', 6),
	(17, 'Grado en Física', 6),
	(18, 'Grado en Ingeniería Química',6),
	(19, 'Grado en Lengua y Literatura Españolas', 7),
	(20, 'Grado en Estudios Ingleses', 7),
	(21, 'Grado en Traducción e Interpretación',7),
	(22, 'Grado en Derecho', 8),
	(23, 'Grado en Criminología', 8),
	(24, 'Grado en Relaciones Internacionales',8),		
	(25, 'Grado en Biología', 9),
	(26, 'Grado en Geología', 9),
	(27, 'Grado en Economía', 3);
 
/* Asignatura */
INSERT INTO asignatura VALUES (1, 'Álgegra lineal y matemática discreta', 6, 'básica', 1, 1, NULL);
INSERT INTO asignatura VALUES (2, 'Cálculo', 6, 'básica', 1, 1, NULL);
INSERT INTO asignatura VALUES (3, 'Física para informática', 6, 'básica', 1, 1, 34);
INSERT INTO asignatura VALUES (4, 'Introducción a la programación', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (5, 'Organización y gestión de empresas', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (6, 'Estadística', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (7, 'Estructura y tecnología de computadores', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (8, 'Fundamentos de electrónica', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (9, 'Lógica y algorítmica', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (10, 'Metodología de la programación', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (11, 'Arquitectura de Computadores', 6, 'básica', 2, 1, 3 );
INSERT INTO asignatura VALUES (12, 'Estructura de Datos y Algoritmos I', 6, 'obligatoria', 2, 1, 3 );
INSERT INTO asignatura VALUES (13, 'Ingeniería del Software', 6, 'obligatoria', 2, 1, 14 );
INSERT INTO asignatura VALUES (14, 'Sistemas Inteligentes', 6, 'obligatoria', 2, 1, 3 );
INSERT INTO asignatura VALUES (15, 'Sistemas Operativos', 6, 'obligatoria', 2, 1, 14 );
INSERT INTO asignatura VALUES (16, 'Bases de Datos', 6, 'básica', 2, 2, 14 );
INSERT INTO asignatura VALUES (17, 'Estructura de Datos y Algoritmos II', 6, 'obligatoria', 2, 2, 14 );
INSERT INTO asignatura VALUES (18, 'Fundamentos de Redes de Computadores', 6 ,'obligatoria', 2, 2, 3 );
INSERT INTO asignatura VALUES (19, 'Planificación y Gestión de Proyectos Informáticos', 6, 'obligatoria', 2, 2, 3 );
INSERT INTO asignatura VALUES (20, 'Programación de Servicios Software', 6, 'obligatoria', 2, 2, 14 );
INSERT INTO asignatura VALUES (21, 'Desarrollo de interfaces de usuario', 6, 'obligatoria', 3, 1, 14 );
INSERT INTO asignatura VALUES (22, 'Ingeniería de Requisitos', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (23, 'Integración de las Tecnologías de la Información en las Organizaciones', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (24, 'Modelado y Diseño del Software 1', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (25, 'Multiprocesadores', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (26, 'Seguridad y cumplimiento normativo', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (27, 'Sistema de Información para las Organizaciones', 6, 'optativa', 3, 1, NULL ); 
INSERT INTO asignatura VALUES (28, 'Tecnologías web', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (29, 'Teoría de códigos y criptografía', 6, 'optativa', 3, 1, NULL );
INSERT INTO asignatura VALUES (30, 'Administración de bases de datos', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (31, 'Herramientas y Métodos de Ingeniería del Software', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (32, 'Informática industrial y robótica', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (33, 'Ingeniería de Sistemas de Información', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (34, 'Modelado y Diseño del Software 2', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (35, 'Negocio Electrónico', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (36, 'Periféricos e interfaces', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (37, 'Sistemas de tiempo real', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (38, 'Tecnologías de acceso a red', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (39, 'Tratamiento digital de imágenes', 6, 'optativa', 3, 2, NULL );
INSERT INTO asignatura VALUES (40, 'Administración de redes y sistemas operativos', 6, 'optativa', 4, 1, NULL );
INSERT INTO asignatura VALUES (41, 'Almacenes de Datos', 6, 'optativa', 4, 1, NULL );
INSERT INTO asignatura VALUES (42, 'Fiabilidad y Gestión de Riesgos', 6, 'optativa', 4, 1, NULL );
INSERT INTO asignatura VALUES (43, 'Líneas de Productos Software', 6, 'optativa', 4, 1, NULL );
INSERT INTO asignatura VALUES (44, 'Procesos de Ingeniería del Software 1', 6, 'optativa', 4, 1, NULL );
INSERT INTO asignatura VALUES (45, 'Tecnologías multimedia', 6, 'optativa', 4, 1, NULL );
INSERT INTO asignatura VALUES (46, 'Análisis y planificación de las TI', 6, 'optativa', 4, 2, NULL );
INSERT INTO asignatura VALUES (47, 'Desarrollo Rápido de Aplicaciones', 6, 'optativa', 4, 2, NULL );
INSERT INTO asignatura VALUES (48, 'Gestión de la Calidad y de la Innovación Tecnológica', 6, 'optativa', 4, 2, NULL );
INSERT INTO asignatura VALUES (49, 'Inteligencia del Negocio', 6, 'optativa', 4, 2, NULL );
INSERT INTO asignatura VALUES (50, 'Procesos de Ingeniería del Software 2', 6, 'optativa', 4, 2, NULL );
INSERT INTO asignatura VALUES (51, 'Seguridad Informática', 6, 'optativa', 4, 2, NULL );
INSERT INTO asignatura VALUES (52, 'Biologia celular', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (53, 'Física', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (54, 'Matemáticas I', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (55, 'Química general', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (56, 'Química orgánica', 6, 'básica', 1, 1, NULL );
INSERT INTO asignatura VALUES (57, 'Biología vegetal y animal', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (58, 'Bioquímica', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (59, 'Genética', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (60, 'Matemáticas II', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (61, 'Microbiología', 6, 'básica', 1, 2, NULL );
INSERT INTO asignatura VALUES (62, 'Botánica agrícola', 6, 'obligatoria', 2, 1, NULL );
INSERT INTO asignatura VALUES (63, 'Fisiología vegetal', 6, 'obligatoria', 2, 1, NULL );
INSERT INTO asignatura VALUES (64, 'Genética molecular', 6, 'obligatoria', 2, 1, NULL );
INSERT INTO asignatura VALUES (65, 'Ingeniería bioquímica', 6, 'obligatoria', 2, 1, NULL );
INSERT INTO asignatura VALUES (66, 'Termodinámica y cinética química aplicada', 6, 'obligatoria', 2, 1, NULL );
INSERT INTO asignatura VALUES (67, 'Biorreactores', 6, 'obligatoria', 2, 2, NULL );
INSERT INTO asignatura VALUES (68, 'Biotecnología microbiana', 6, 'obligatoria', 2, 2, NULL );
INSERT INTO asignatura VALUES (69, 'Ingeniería genética', 6, 'obligatoria', 2, 2, NULL );
INSERT INTO asignatura VALUES (70, 'Inmunología', 6, 'obligatoria', 2, 2, NULL );
INSERT INTO asignatura VALUES (71, 'Virología', 6, 'obligatoria', 2, 2, NULL );
INSERT INTO asignatura VALUES (72, 'Bases moleculares del desarrollo vegetal', 4.5, 'obligatoria', 3, 1, NULL );
INSERT INTO asignatura VALUES (73, 'Fisiología animal', 4.5, 'obligatoria', 3, 1, NULL );
INSERT INTO asignatura VALUES (74, 'Metabolismo y biosíntesis de biomoléculas', 6, 'obligatoria', 3, 1, NULL );
INSERT INTO asignatura VALUES (75, 'Operaciones de separación', 6, 'obligatoria', 3, 1, NULL );
INSERT INTO asignatura VALUES (76, 'Patología molecular de plantas', 4.5, 'obligatoria', 3, 1, NULL );
INSERT INTO asignatura VALUES (77, 'Técnicas instrumentales básicas', 4.5, 'obligatoria', 3, 1, NULL );
INSERT INTO asignatura VALUES (78, 'Bioinformática', 4.5, 'obligatoria', 3, 2, NULL );
INSERT INTO asignatura VALUES (79, 'Biotecnología de los productos hortofrutículas', 4.5, 'obligatoria', 3, 2, NULL );
INSERT INTO asignatura VALUES (80, 'Biotecnología vegetal', 6, 'obligatoria', 3, 2, NULL );
INSERT INTO asignatura VALUES (81, 'Genómica y proteómica', 4.5, 'obligatoria', 3, 2, NULL );
INSERT INTO asignatura VALUES (82, 'Procesos biotecnológicos', 6, 'obligatoria', 3, 2, NULL );
INSERT INTO asignatura VALUES (83, 'Técnicas instrumentales avanzadas', 4.5, 'obligatoria', 3, 2, NULL );
INSERT INTO asignatura VALUES (84, 'Legislación Ambiental', 6, 'básica', 1, 1, 24);
INSERT INTO asignatura VALUES (85, 'Física de la Atmósfera y el Clima', 6, 'básica', 1, 1, 26);
INSERT INTO asignatura VALUES (86, 'Física Aplicada a la Ingeniería Civil', 6, 'básica', 1, 1, 26);
INSERT INTO asignatura VALUES (87, 'Asignatura de Bioinformática', 6, 'básica', 1, 1, 25 );
INSERT INTO asignatura VALUES (89, 'Asignatura de Química Biológica', 6, 'básica', 1, 1, 31 );
INSERT INTO asignatura VALUES (90, 'Álgebra Lineal para Informática', 6, 'básica', 1, 1, 27 );
INSERT INTO asignatura VALUES (91, 'Cálculo Numérico', 6, 'básica', 1, 1, 28 );
INSERT INTO asignatura VALUES (92, 'Probabilidad y Estadística para Ciencias de la Computación', 6, 'básica', 1, 1, 21 );




/* ASIGNATURA-GRADO */
INSERT INTO asignatura_grado VALUES (1, 4);
INSERT INTO asignatura_grado VALUES (1, 3);
INSERT INTO asignatura_grado VALUES (1, 2);
INSERT INTO asignatura_grado VALUES (1, 1);
INSERT INTO asignatura_grado VALUES (1, 5);
INSERT INTO asignatura_grado VALUES (1, 6);
INSERT INTO asignatura_grado VALUES (2, 4);
INSERT INTO asignatura_grado VALUES (3, 4);
INSERT INTO asignatura_grado VALUES (4, 4);
INSERT INTO asignatura_grado VALUES (4, 5);
INSERT INTO asignatura_grado VALUES (4, 6);
INSERT INTO asignatura_grado VALUES (5, 4);
INSERT INTO asignatura_grado VALUES (5, 8);
INSERT INTO asignatura_grado VALUES (5, 27);
INSERT INTO asignatura_grado VALUES (6, 1);
INSERT INTO asignatura_grado VALUES (6, 2);
INSERT INTO asignatura_grado VALUES (6, 3);
INSERT INTO asignatura_grado VALUES (6, 5);
INSERT INTO asignatura_grado VALUES (7, 4);
INSERT INTO asignatura_grado VALUES (8, 4);
INSERT INTO asignatura_grado VALUES (9, 4);
INSERT INTO asignatura_grado VALUES (10, 4);
INSERT INTO asignatura_grado VALUES (11, 4);
INSERT INTO asignatura_grado VALUES (12, 4);
INSERT INTO asignatura_grado VALUES (13, 4);
INSERT INTO asignatura_grado VALUES (14, 4);
INSERT INTO asignatura_grado VALUES (15, 4);
INSERT INTO asignatura_grado VALUES (16, 4);
INSERT INTO asignatura_grado VALUES (17, 4);
INSERT INTO asignatura_grado VALUES (18, 4);
INSERT INTO asignatura_grado VALUES (19, 4);
INSERT INTO asignatura_grado VALUES (20, 4);
INSERT INTO asignatura_grado VALUES (21, 4);
INSERT INTO asignatura_grado VALUES (22, 4);
INSERT INTO asignatura_grado VALUES (23, 4);
INSERT INTO asignatura_grado VALUES (24, 4);
INSERT INTO asignatura_grado VALUES (25, 4);
INSERT INTO asignatura_grado VALUES (26, 4);
INSERT INTO asignatura_grado VALUES (27, 4);
INSERT INTO asignatura_grado VALUES (28, 4);
INSERT INTO asignatura_grado VALUES (29, 4);
INSERT INTO asignatura_grado VALUES (30, 4);
INSERT INTO asignatura_grado VALUES (31, 4);
INSERT INTO asignatura_grado VALUES (32, 4);
INSERT INTO asignatura_grado VALUES (33, 4);
INSERT INTO asignatura_grado VALUES (34, 4);
INSERT INTO asignatura_grado VALUES (35, 4);
INSERT INTO asignatura_grado VALUES (36, 4);
INSERT INTO asignatura_grado VALUES (37, 4);
INSERT INTO asignatura_grado VALUES (38, 4);
INSERT INTO asignatura_grado VALUES (39, 4);
INSERT INTO asignatura_grado VALUES (40, 4);
INSERT INTO asignatura_grado VALUES (41, 4);
INSERT INTO asignatura_grado VALUES (42, 4);
INSERT INTO asignatura_grado VALUES (43, 4);
INSERT INTO asignatura_grado VALUES (44, 4);
INSERT INTO asignatura_grado VALUES (45, 4);
INSERT INTO asignatura_grado VALUES (46, 4);
INSERT INTO asignatura_grado VALUES (47, 4);
INSERT INTO asignatura_grado VALUES (48, 4);
INSERT INTO asignatura_grado VALUES (49, 4);
INSERT INTO asignatura_grado VALUES (50, 4);
INSERT INTO asignatura_grado VALUES (51, 4);
INSERT INTO asignatura_grado VALUES (52, 7);
INSERT INTO asignatura_grado VALUES (53, 7);
INSERT INTO asignatura_grado VALUES (53, 17);
INSERT INTO asignatura_grado VALUES (54, 7);
INSERT INTO asignatura_grado VALUES (55, 16);
INSERT INTO asignatura_grado VALUES (55, 17);
INSERT INTO asignatura_grado VALUES (55, 18);
INSERT INTO asignatura_grado VALUES (56, 7);
INSERT INTO asignatura_grado VALUES (57, 7);
INSERT INTO asignatura_grado VALUES (58, 7);
INSERT INTO asignatura_grado VALUES (59, 7);
INSERT INTO asignatura_grado VALUES (60, 7);
INSERT INTO asignatura_grado VALUES (61, 7);
INSERT INTO asignatura_grado VALUES (62, 7);
INSERT INTO asignatura_grado VALUES (63, 7);
INSERT INTO asignatura_grado VALUES (64, 7);
INSERT INTO asignatura_grado VALUES (65, 7);
INSERT INTO asignatura_grado VALUES (66, 7);
INSERT INTO asignatura_grado VALUES (67, 7);
INSERT INTO asignatura_grado VALUES (68, 7);
INSERT INTO asignatura_grado VALUES (69, 7);
INSERT INTO asignatura_grado VALUES (70, 7);
INSERT INTO asignatura_grado VALUES (71, 7);
INSERT INTO asignatura_grado VALUES (72, 7);
INSERT INTO asignatura_grado VALUES (73, 7);
INSERT INTO asignatura_grado VALUES (74, 7);
INSERT INTO asignatura_grado VALUES (75, 7);
INSERT INTO asignatura_grado VALUES (76, 7);
INSERT INTO asignatura_grado VALUES (77, 7);
INSERT INTO asignatura_grado VALUES (78, 7);
INSERT INTO asignatura_grado VALUES (79, 7);
INSERT INTO asignatura_grado VALUES (80, 7);
INSERT INTO asignatura_grado VALUES (81, 7);
INSERT INTO asignatura_grado VALUES (82, 7);
INSERT INTO asignatura_grado VALUES (83, 7);
INSERT INTO asignatura_grado VALUES (84, 14);
INSERT INTO asignatura_grado VALUES (85, 14);
INSERT INTO asignatura_grado VALUES (86, 6);
INSERT INTO asignatura_grado VALUES (87, 7);
INSERT INTO asignatura_grado VALUES (89, 7);
INSERT INTO asignatura_grado VALUES (90,4);
INSERT INTO asignatura_grado VALUES (91, 4);
INSERT INTO asignatura_grado VALUES (92, 4);

/* Curso escolar */
INSERT INTO curso_escolar VALUES (1,  to_date(2014::text, 'YYYY'), to_date(2015::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (2, to_date(2015::text, 'YYYY'), to_date(2016::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (3, to_date(2016::text, 'YYYY'), to_date(2017::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (4, to_date(2017::text, 'YYYY'), to_date(2018::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (5, to_date(2018::text, 'YYYY'), to_date(2019::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (6, to_date(2019::text, 'YYYY'), to_date(2020::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (7, to_date(2020::text, 'YYYY'), to_date(2021::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (8, to_date(2021::text, 'YYYY'), to_date(2022::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (9, to_date(2022::text, 'YYYY'), to_date(2023::text, 'YYYY'));
INSERT INTO curso_escolar VALUES (10, to_date(2023::text, 'YYYY'), to_date(2024::text, 'YYYY'));


/* Alumno se matricula en asignatura */
INSERT INTO alumno_curso_asignatura VALUES (2, 1, 1);
INSERT INTO alumno_curso_asignatura VALUES (2, 2, 1);
INSERT INTO alumno_curso_asignatura VALUES (2, 3, 1);

INSERT INTO alumno_curso_asignatura VALUES (1, 1, 1);
INSERT INTO alumno_curso_asignatura VALUES (1, 2, 1);
INSERT INTO alumno_curso_asignatura VALUES (1, 3, 1);

INSERT INTO alumno_curso_asignatura VALUES (4, 1, 1);
INSERT INTO alumno_curso_asignatura VALUES (4, 2, 1);
INSERT INTO alumno_curso_asignatura VALUES (4, 3, 1);

INSERT INTO alumno_curso_asignatura VALUES (24, 1, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 2, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 3, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 4, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 5, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 6, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 7, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 8, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 9, 5);
INSERT INTO alumno_curso_asignatura VALUES (24, 10, 5);

INSERT INTO alumno_curso_asignatura VALUES (23, 1, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 2, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 3, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 4, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 5, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 6, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 7, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 8, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 9, 5);
INSERT INTO alumno_curso_asignatura VALUES (23, 10, 5);

INSERT INTO alumno_curso_asignatura VALUES (19, 1, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 2, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 3, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 4, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 5, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 6, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 7, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 8, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 9, 5);
INSERT INTO alumno_curso_asignatura VALUES (19, 10, 5);


INSERT INTO alumno_curso_asignatura VALUES (25, 84, 6), (25, 85, 6), (25, 84, 7), (25, 85, 7), (25, 84, 8), (25, 90, 8), (25, 91, 8), (25, 92, 8);
INSERT INTO alumno_curso_asignatura VALUES (26, 84, 6), (26, 85, 6), (26, 86, 6);
INSERT INTO alumno_curso_asignatura VALUES (27, 84, 6), (27, 85, 6), (27, 86, 6), (27, 87, 6), (27, 89, 6), (27, 90, 6), (27, 91, 6), (27, 92, 6);
INSERT INTO alumno_curso_asignatura VALUES (28, 89, 9), (28, 90, 9), (28, 91, 10), (28, 92, 10);
INSERT INTO alumno_curso_asignatura VALUES (29, 84, 6), (29, 85, 6), (29, 86, 6), (29, 87, 6), (29, 89, 6), (29, 90, 6), (29, 91, 6), (29, 92, 6);
INSERT INTO alumno_curso_asignatura VALUES (30, 84, 6), (30, 85, 6), (30, 86, 6);
INSERT INTO alumno_curso_asignatura VALUES (31, 84, 6), (31, 85, 6), (31, 86, 6), (31, 87, 6), (31, 89, 6), (31, 90, 6), (31, 91, 6), (31, 92, 6);
INSERT INTO alumno_curso_asignatura VALUES (32, 91, 10), (32, 92, 10), (32, 23, 10), (32, 24, 10),(32, 1, 10), (32, 2, 10), (32, 4, 10), (32, 5, 10);
INSERT INTO alumno_curso_asignatura VALUES (33, 90, 9), (33, 91, 10), (33, 92, 10);
INSERT INTO alumno_curso_asignatura VALUES (34, 89, 9), (34, 90, 9), (33, 23, 10),(33, 24, 10);
INSERT INTO alumno_curso_asignatura VALUES (35, 84, 6), (35, 85, 6), (35, 86, 6), (35, 87, 6), (35, 89, 6), (35, 90, 6), (35, 91, 6), (35, 92, 6);
INSERT INTO alumno_curso_asignatura VALUES (36, 84, 6), (36, 85, 6), (36, 86, 6), (36, 87, 6), (36, 89, 6), (36, 90, 6), (36, 91, 6), (36, 92, 6);
INSERT INTO alumno_curso_asignatura VALUES (37, 84, 6), (37, 85, 6), (37, 86, 6), (37, 87, 6), (37, 89, 6), (37, 90, 6), (37, 91, 6), (37, 92, 6);
INSERT INTO alumno_curso_asignatura VALUES (38, 84, 6), (38, 85, 6), (38, 86, 6), (38, 87, 6), (38, 89, 6), (38, 90, 6), (38, 91, 6), (38, 92, 6);