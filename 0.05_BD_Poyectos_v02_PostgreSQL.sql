CREATE TABLE T_CENTRO (
    identificador SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL unique,
    tipo VARCHAR(100) not null,                         -- Ej: "INSTITUTO DE EDUCACIÓN SECUNDARIA"
    titularidad VARCHAR(30) not null check(titularidad in ('Público', 'Privado', 'Privado Concertado')),                   -- Ej: "Público"
    titular VARCHAR(100)  not null,                      -- Ej: "COMUNIDAD DE MADRID"
    codigo_centro CHAR(8)  not null unique,                 -- Ej: "28020831"
    area_territorial VARCHAR(30) not null check(area_territorial in ('Madrid-Norte', 'Madrid-Sur', 'Madrid-Este', 'Madrid-Oeste', 'Madrid-Capital')),             -- Ej: "Madrid-Capital"
    direccion VARCHAR(150) not null,                    -- Ej: "calle vía límite 14, 28029, Madrid (Tetuán)"
    telefono VARCHAR(20)  not null,                      -- Ej: "913146706"
    fax VARCHAR(20),                      -- Ej: "913146706"
    url_web VARCHAR(200),                          -- Ej: URL
    correo_electronico VARCHAR(150)            -- Ej: Email
);

CREATE TABLE T_CURSO_ACADEMICO (
	codigo CHAR(9) PRIMARY KEY, -- '2024-2025'
	fecha_inicio DATE NOT NULL, -- 01/09/2024
	fecha_fin DATE NOT NULL, -- 31/08/2025
	nombre VARCHAR(255) NOT NULL, -- 'Curso 2024/2025'
	CONSTRAINT CHK_INICIO_FIN CHECK (fecha_fin > fecha_inicio)
);

CREATE TABLE T_PROYECTO (
    identificador SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT NULL,
	fecha_inicio DATE NOT NULL,
	fecha_fin DATE NULL, 
    url_logo VARCHAR(255) NULL,	
	id_centro int null, 
	CONSTRAINT UK_NOMBRE_PROYECTO UNIQUE (nombre),	     -- No permite repetirse el nombre de PROYECTO
    CONSTRAINT FK_PROYECTO_INSTITUO FOREIGN KEY (id_centro) REFERENCES T_CENTRO (identificador) ON UPDATE CASCADE ON DELETE CASCADE	
);

CREATE TABLE T_CONCEPTO (
	identificador SERIAL PRIMARY KEY, 
	nombre VARCHAR(255) NOT NULL,
	descripcion TEXT NULL,
	CONSTRAINT UK_NOMBRE_CONCEPTO UNIQUE (nombre)	-- No permite repetirse el nombre de CONCEPTO
);

CREATE TABLE T_PATROCINADOR (
	identificador SERIAL PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	imagen bytea NULL,
	CONSTRAINT UK_NOMBRE_PATROCINADOR UNIQUE (nombre)	   -- No permite repetirse el nombre de PATROCINADOR 	
);

CREATE TABLE T_PROYECTO_CURSO (
    id_proyecto INTEGER NOT NULL,
    cod_curso CHAR(9) NOT NULL,
	PRIMARY KEY (id_proyecto, cod_curso),
	CONSTRAINT UK_PROYECTO_CURSO UNIQUE (id_proyecto, cod_curso),
    CONSTRAINT FK_PROYECTOCURSO_PROYECTO FOREIGN KEY (id_proyecto) REFERENCES T_PROYECTO (identificador) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_PROYECTOCURSO_CURSO FOREIGN KEY (cod_curso) REFERENCES T_CURSO_ACADEMICO (codigo) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE T_GASTO (
	identificador SERIAL PRIMARY KEY,
	id_concepto INTEGER NOT NULL,
    id_proyecto INTEGER NOT NULL,
    cod_curso CHAR(9) NOT NULL,
	fecha_gasto DATE NULL,
	precio_unidad DECIMAL(10, 2) NOT NULL CHECK (precio_unidad > 0),
	num_unidades INTEGER NOT NULL DEFAULT 1 CHECK (num_unidades > 0),
	observacion VARCHAR(255) NULL,
	fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
	fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de última modificación		
	CONSTRAINT FK_GASTO_CONCEPTO FOREIGN KEY (id_concepto) REFERENCES T_CONCEPTO (identificador) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT FK_GASTO_CURSOPROYECTO FOREIGN KEY (id_proyecto, cod_curso) REFERENCES T_PROYECTO_CURSO (id_proyecto, cod_curso)  ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE T_INGRESO (
	identificador SERIAL PRIMARY KEY,
	id_patrocinador INTEGER NOT NULL,
    id_proyecto INTEGER NOT NULL,
    cod_curso CHAR(9) NOT NULL,
	fecha_ingreso DATE NULL,
	cantidad DECIMAL(10, 2) NOT NULL CHECK (cantidad > 0),
	observacion VARCHAR(255) NULL,
	fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Fecha de creación
	fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de última modificación			
	CONSTRAINT FK_INGRESO_PATROCINADOR FOREIGN KEY (id_patrocinador) REFERENCES T_PATROCINADOR (identificador) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT FK_INGRESO_CURSOPROYECTO FOREIGN KEY (id_proyecto, cod_curso) REFERENCES T_PROYECTO_CURSO (id_proyecto, cod_curso)  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Históricos
CREATE TABLE T_HISTORICO_CENTRO (
    id SERIAL PRIMARY KEY,
    id_centro INTEGER NOT NULL,
    nombre_anterior VARCHAR(150),
    nombre_nuevo VARCHAR(150),
    direccion_anterior VARCHAR(150),
    direccion_nueva VARCHAR(150),
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE T_AUDITORIA_GASTO (
    id SERIAL PRIMARY KEY,
    id_gasto INTEGER NOT NULL,
    id_concepto INTEGER,
    id_proyecto INTEGER,
    cod_curso CHAR(9),
    fecha_gasto DATE,
    precio_unidad DECIMAL(10,2),
    num_unidades INTEGER,
    observacion VARCHAR(255),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario TEXT NOT NULL default CURRENT_USER
);


-- Datos de inicio
INSERT INTO T_CENTRO (
    nombre, tipo, titularidad, titular, codigo_centro,
    area_territorial, direccion, telefono, fax,
    url_web, correo_electronico
) VALUES
-- Madrid-Capital
('IES "Tetuan de las Victorias"','INSTITUTO DE EDUCACIÓN SECUNDARIA','Público','COMUNIDAD DE MADRID','28020831','Madrid-Capital','calle vía límite 14, 28029, Madrid (Tetuán)','913146706','913157489','http://www.educa.madrid.org/ies.tetuan.madrid','ies.tetuan.madrid@educa.madrid.org'),('IES Ramiro de Maeztu', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019284', 'Madrid-Capital', 'Calle Serrano 127, 28006 Madrid', '915617842', '915617843', 'https://www.educa2.madrid.org/web/centro.ies.ramirodemaeztu.madrid', 'ies.ramirodemaeztu.madrid@educa.madrid.org'),
('IES Isabel la Católica', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019285', 'Madrid-Capital', 'Calle Alfonso XII 3, 28014 Madrid', '914203456', '914203457', 'https://www.educa2.madrid.org/web/centro.ies.isabellacatolica.madrid', 'ies.isabellacatolica.madrid@educa.madrid.org'),
('IES Virgen de la Paloma', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019286', 'Madrid-Capital', 'Calle Francos Rodríguez 106, 28039 Madrid', '915123456', '915123457', 'https://www.educa2.madrid.org/web/centro.ies.virgendelapaloma.madrid', 'ies.virgendelapaloma.madrid@educa.madrid.org'),
('IES Salvador Dalí', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019287', 'Madrid-Capital', 'Calle Verdaguer y García s/n, 28027 Madrid', '914049490', '914049491', 'https://www.educa2.madrid.org/web/centro.ies.salvadordali.madrid', 'ies.salvadordali.madrid@educa.madrid.org'),
('IES Moratalaz', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019288', 'Madrid-Capital', 'Calle del Corregidor Diego de Valderrábano 35, 28030 Madrid', '918258743', '918258744', 'https://www.educa2.madrid.org/web/centro.ies.moratalaz.madrid', 'ies.moratalaz.madrid@educa.madrid.org'),
('IES Herrera Oria', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019189', 'Madrid-Capital', 'Calle de Fermín Caballero 68, 28034 Madrid', '913781940', '913781941', 'https://www.educa2.madrid.org/web/centro.ies.herreraoria.madrid', 'ies.herreraoria.madrid@educa.madrid.org'),
('IES Ciudad Escolar', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019190', 'Madrid-Capital', 'Carretera de Colmenar Viejo km 12.8, 28049 Madrid', '917341244', '917341245', 'https://www.educa2.madrid.org/web/centro.ies.ciudadescolar.madrid', 'ies.ciudadescolar.madrid@educa.madrid.org'),
('IES Clara del Rey', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019191', 'Madrid-Capital', 'Calle del Padre Claret 8, 28002 Madrid', '915195257', '915195258', 'https://www.educa2.madrid.org/web/centro.ies.claradelrey.madrid', 'ies.claradelrey.madrid@educa.madrid.org'),
('IES Enrique Tierno Galván', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019192', 'Madrid-Capital', 'Avenida de Andalucía 6, 28041 Madrid', '913171972', '913171973', 'https://www.educa2.madrid.org/web/centro.ies.enriquetiernogalvan.madrid', 'ies.enriquetiernogalvan.madrid@educa.madrid.org'),
('Colegio Internacional Nicoli', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Colegio Internacional Nicoli S.L.', '28019193', 'Madrid-Capital', 'Paseo de Eduardo Dato 4, 28010 Madrid', '913082030', '913082031', 'https://www.colegiovicoli.com', 'info@colegiovicoli.com'),
('Colegio Edith Stein', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Fundación Edith Stein', '28019194', 'Madrid-Capital', 'Calle Simca 20, 28041 Madrid', '913412879', '913412880', 'https://www.edithstein.es', 'contacto@edithstein.es'),
('Colegio El Valle II', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Grupo Educativo El Valle', '28019195', 'Madrid-Capital', 'Calle de Ana de Austria 60, 28050 Madrid', '917188426', '917188427', 'https://www.colegioelvalle.com', 'info@colegioelvalle.com'),
('Colegio Santa María de la Hispanidad', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Fundación Santa María de la Hispanidad', '28019196', 'Madrid-Capital', 'Calle del Vizconde de Uzqueta 23, 28042 Madrid', '917412584', '917412585', 'https://www.santamariahispanidad.es', 'contacto@santamariahispanidad.es'),
('Colegio Santa María de los Apóstoles', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Fundación Santa María de los Apóstoles', '28019197', 'Madrid-Capital', 'Plaza de la Grosella 4, 28044 Madrid', '914627411', '914627412', 'https://www.santamariadelosapostoles.es', 'info@santamariadelosapostoles.es'),
('Colegio Santa María del Bosque', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Fundación Santa María del Bosque', '28019198', 'Madrid-Capital', 'Calle de la Gaviota 14, 28025 Madrid', '915250000', '915250001', 'https://www.santamariadelbosque.es', 'contacto@santamariadelbosque.es'),
('Instituto Dario Estudio', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Dario Estudio S.L.', '28019208', 'Madrid-Capital', 'Calle Gran Vía 63, 28013 Madrid', '915678901', '915678902', 'https://www.darioestudio.com', 'info@darioestudio.com'),
('Instituto Las Rosas', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Fundación Educativa Las Rosas', '28019218', 'Madrid-Capital', 'Avenida de Niza 24, 28022 Madrid', '914567890', '914567891', 'https://www.lasrosas.edu.es', 'contacto@lasrosas.edu.es'),
-- Madrid-Oeste
('IES Las Rozas I', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019199', 'Madrid-Oeste', 'Calle Real 52, 28230 Las Rozas de Madrid', '916374006', '916374007', 'https://www.educa2.madrid.org/web/centro.ies.lasrozas1.madrid', 'ies.lasrozas1.madrid@educa.madrid.org'),
('IES María de Zayas y Sotomayor', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019310', 'Madrid-Oeste', 'Calle del Romero 2, 28220 Majadahonda', '916396611', '916396612', 'https://www.educa2.madrid.org/web/centro.ies.mariadezayas.madrid', 'ies.mariadezayas.madrid@educa.madrid.org'),
('IES Profesor Máximo Trueba', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019311', 'Madrid-Oeste', 'Calle de Santillana del Mar 22, 28660 Boadilla del Monte', '916321512', '916321513', 'https://www.educa2.madrid.org/web/centro.ies.maximotrueba.madrid', 'ies.maximotrueba.madrid@educa.madrid.org'),
('Colegio Engage', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Engage British School S.L.', '28019312', 'Madrid-Oeste', 'Calle de la Guardia s/n, 28939 Arroyomolinos', '916688289', '916688290', 'https://www.engagebritishschool.com', 'info@engagebritishschool.com'),
-- Madrid-Norte
('IES Leonardo Da Vinci', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019289', 'Madrid-Norte', 'Avenida Guadarrama 42, 28220 Majadahonda', '916789012', '916789013', 'https://www.educa2.madrid.org/web/centro.ies.leonardodavinci.majadahonda', 'ies.leonardodavinci.majadahonda@educa.madrid.org'),
('IES Margarita Salas', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019290', 'Madrid-Norte', 'Calle María Teresa León 1, 28220 Majadahonda', '916789014', '916789015', 'https://www.educa2.madrid.org/web/centro.ies.margaritasalas.majadahonda', 'ies.margaritasalas.majadahonda@educa.madrid.org'),
('IES Las Encinas', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019291', 'Madrid-Norte', 'Avenida Mirasierra 8, 28691 Villanueva de la Cañada', '918123456', '918123457', 'https://www.educa2.madrid.org/web/centro.ies.lasencinas.villanuevadelacanyada', 'ies.lasencinas.villanuevadelacanyada@educa.madrid.org'),
('Instituto Aldeafuente', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Aldeafuente S.A.', '28019292', 'Madrid-Norte', 'Calle Camino Ancho 10, 28109 Alcobendas', '917654321', '917654322', 'https://www.aldeafuente.org', 'info@aldeafuente.org'),
('Instituto Humanitas Bilingual School Tres Cantos', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Fundación Humanitas', '28019293', 'Madrid-Norte', 'Calle del Viento 2, 28760 Tres Cantos', '918765432', '918765433', 'https://www.humanitastrescantos.com', 'contacto@humanitastrescantos.com'),
-- Madrid-Sur
('IES Julio Verne', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019294', 'Madrid-Sur', 'Calle Ingeniería 4, 28918 Leganés', '912345678', '912345679', 'https://www.educa2.madrid.org/web/centro.ies.julioverne.leganes', 'ies.julioverne.leganes@educa.madrid.org'),
('IES Francisco de Quevedo', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019295', 'Madrid-Sur', 'Calle San Román del Valle s/n, 28037 Madrid', '913456789', '913456780', 'https://www.educa2.madrid.org/web/centro.ies.franciscodequevedo.madrid', 'ies.franciscodequevedo.madrid@educa.madrid.org'),
('IES Barrio Loranca', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019296', 'Madrid-Sur', 'Calle Federica Montseny 2, 28942 Fuenlabrada', '914567890', '914567891', 'https://www.educa2.madrid.org/web/centro.ies.barrioloranca.fuenlabrada', 'ies.barrioloranca.fuenlabrada@educa.madrid.org'),
('Instituto CEAC Formación Profesional', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'CEAC S.A.', '28019297', 'Madrid-Sur', 'Plaza Cronos 1, 28037 Madrid', '915678901', '915678902', 'https://www.ceac.es', 'info@ceac.es'),
('Instituto GSD Alcalá', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Gredos San Diego Sociedad Cooperativa', '28019298', 'Madrid-Sur', 'Calle Octavio Paz 15, 28806 Alcalá de Henares', '916789012', '916789013', 'https://www.gsdeducacion.com/alcala', 'contacto@gsdeducacion.com'),
-- Madrid-Este
('IES Isaac Albéniz', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019299', 'Madrid-Este', 'Avenida de Gran Bretaña 18, 28916 Leganés', '917890123', '917890124', 'https://www.educa2.madrid.org/web/centro.ies.isaacalbeniz.leganes', 'ies.isaacalbeniz.leganes@educa.madrid.org'),
('IES Gerardo Diego', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019300', 'Madrid-Este', 'Calle Irlanda s/n, 28223 Pozuelo de Alarcón', '918901234', '918901235', 'https://www.educa2.madrid.org/web/centro.ies.gerardodiego.pozuelodealarcon', 'ies.gerardodiego.pozuelodealarcon@educa.madrid.org'),
('IES Calatalifa', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Público', 'COMUNIDAD DE MADRID', '28019301', 'Madrid-Este', 'Calle San Antonio 2, 28670 Villaviciosa de Odón', '919012345', '919012346', 'https://www.educa2.madrid.org/web/centro.ies.calatalifa.villaviciosadeodon', 'ies.calatalifa.villaviciosadeodon@educa.madrid.org'),
('Instituto CEU San Pablo Claudio Coello', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado', 'Fundación Universitaria San Pablo CEU', '28019302', 'Madrid-Este', 'Calle Claudio Coello 38, 28001 Madrid', '910123456', '910123457', 'https://www.colegioceuclaudiocoello.es', 'info@colegioceuclaudiocoello.es'),
('Instituto Nuestra Señora del Recuerdo', 'INSTITUTO DE EDUCACIÓN SECUNDARIA', 'Privado Concertado', 'Compañía de Jesús', '28019303', 'Madrid-Este', 'Calle Duque de Pastrana 5, 28036 Madrid', '911234567', '911234568', 'https://www.recuerdo.net', 'contacto@recuerdo.net');

-- Insertar Curso
INSERT INTO T_CURSO_ACADEMICO (codigo, fecha_inicio, fecha_fin, nombre) 
VALUES 
('2022-2023', '2022-09-01', '2023-08-31', 'Curso 2022/2023'),
('2023-2024', '2023-09-01', '2024-08-31', 'Curso 2023/2024'),
('2024-2025', '2024-09-01', '2025-08-31', 'Curso 2024/2025');

-- Insertar Proyectos
INSERT INTO T_PROYECTO (nombre, descripcion, id_centro, fecha_inicio ) 
VALUES 
('Hiperbaric', 'Proyecto Hiperbaric, alumnos de 1º de grado medio de electromecánica de vehículos.', 3, '2022-11-01'),
('EcoMotors', 'Proyecto de construcción de un vehículo eléctrico de bajo costo.', 3,'2020-11-01'),
('Speedster', 'Desarrollo de un coche de carreras eléctrico de alto rendimiento.', 3,'2021-11-01'),
('Taller de Robótica Escolar', 'Diseño y construcción de robots para competencias locales.', 1, '2022-10-01'),
('Laboratorio Verde', 'Creación de un huerto escolar con sensores automatizados.', 1, '2023-01-15'),
('Cine y Sociedad', 'Análisis de cine social en tutorías y asignaturas de valores.', 1, '2022-03-10'),
('Revista Digital Escolar', 'Elaboración de una publicación digital con contenido estudiantil.', 1, '2023-11-05'),
('Proyecto STEM Talent', 'Desarrollo de proyectos integrados de Ciencia y Tecnología.', 2, '2022-09-20'),
('Energía Limpia', 'Diseño de prototipos de energías renovables caseras.', 2, '2023-02-12'),
('Fotografía Documental', 'Talleres de fotografía centrados en la vida cotidiana.', 2, '2021-11-18'),
('Escape Room Educativo', 'Diseño de una sala de escape temática de Historia.', 2, '2023-04-25'),
('Biotecnología Escolar', 'Técnicas básicas de biotecnología adaptadas a ESO.', 3, '2022-10-15'),
('EcoMotors 2.0', 'Continuación y mejora del proyecto de vehículo eléctrico.', 3, '2023-10-01'),
('Podcast Escolar', 'Grabación y edición de podcasts semanales por los alumnos.', 3, '2021-04-01'),
('Foro de Humanidades', 'Conferencias y debates sobre temas éticos y sociales.', 3, '2020-12-10'),
('Música y Tecnología', 'Producción de música con herramientas digitales.', 4, '2021-10-01'),
('Estación Meteorológica', 'Montaje de una estación con Arduino y sensores.', 4, '2023-03-01'),
('Inclusión y Diversidad', 'Campañas de sensibilización dentro del centro.', 4, '2022-02-14'),
('Cómic Educativo', 'Creación de un cómic colaborativo de temas escolares.', 4, '2023-05-05'),
('Movilidad Sostenible', 'Estudio de rutas seguras en bicicleta al instituto.', 5, '2021-09-01'),
('Laboratorio de Física Aplicada', 'Talleres prácticos de física y matemáticas.', 5, '2023-01-20'),
('Periodismo Escolar', 'Creación de noticiarios por estudiantes.', 5, '2022-05-11'),
('Debate Intercentros', 'Competencia de debate con otros IES de la zona.', 5, '2023-12-01'),
-- Madrid-Sur (2 proyectos por centro)
('Construcción de Drones', 'Diseño de drones básicos con impresión 3D.', 30, '2022-02-01'),
('Club de Lectura Crítica', 'Análisis literario de obras contemporáneas.', 30, '2023-04-01'),
('Proyecto Hidroponía', 'Cultivo sin suelo en instalaciones del centro.', 31, '2023-02-15'),
('Hackatón Escolar', 'Competición intensiva de desarrollo de apps educativas.', 31, '2022-11-20'),
('Taller de Radio Escolar', 'Producción de programas de radio semanales.', 32, '2021-03-22'),
('Realidad Aumentada en Historia', 'Aplicación de AR para estudiar civilizaciones antiguas.', 32, '2023-09-15'),
('Robótica con LEGO', 'Iniciación a la programación mediante kits LEGO Mindstorms.', 33, '2022-05-05'),
('Cortos Escolares', 'Grabación de cortometrajes educativos por alumnos.', 33, '2023-11-11'),
('Proyecto EcoRecicla', 'Campaña de reciclaje con clasificación automática de residuos.', 34, '2021-12-01'),
('Simulación Empresarial', 'Creación de una cooperativa escolar ficticia.', 34, '2023-06-20'),
('Taller Arduino Básico', 'Iniciación al hardware libre con Arduino.', 6, '2023-10-10'),
('Viaje Científico Virtual', 'Visitas online a laboratorios y centros de investigación.', 7, '2021-11-01'),
('Redacción Periodística', 'Taller de redacción y edición de textos de actualidad.', 8, '2022-05-01'),
('Matemáticas Cotidianas', 'Aplicación de matemáticas en la vida diaria.', 9, '2023-02-01'),
('Cultura y Gastronomía', 'Estudio de la cocina como manifestación cultural.', 10, '2021-09-15'),
('Jóvenes Científicos', 'Feria de ciencia organizada por estudiantes.', 11, '2022-04-10'),
('Taller de Cine en Inglés', 'Realización de cortos en inglés.', 12, '2023-01-15'),
('Realidad Virtual en Aula', 'Proyectos con gafas VR en Historia y Geografía.', 13, '2023-03-15'),
('Biohuerto Escolar', 'Huerto ecológico y compostaje.', 14, '2021-10-10'),
('Club de Ajedrez', 'Torneos y talleres de ajedrez lógico.', 15, '2022-09-20'),
('Modelado 3D', 'Diseño e impresión de modelos 3D.', 16, '2023-05-05'),
('Arte Urbano', 'Taller de graffiti y muralismo con fines educativos.', 17, '2021-03-01'),
('Rutas Históricas', 'Estudio de la historia local mediante visitas.', 18, '2022-11-11'),
('Taller de Emprendimiento', 'Creación de planes de negocio simples.', 19, '2023-07-01'),
('Taller de Debate y Oratoria', 'Técnicas de expresión oral y pensamiento crítico.', 20, '2022-10-01'),
('Tecnología Responsable', 'Uso ético de las TIC en la adolescencia.', 21, '2023-01-15'),
('Diseño de Juegos Educativos', 'Creación de juegos de mesa para aprender contenidos.', 22, '2022-03-10'),
('Historia Interactiva', 'Proyectos digitales sobre historia.', 23, '2021-12-12'),
('Lectura Compartida', 'Programa de lectura entre niveles educativos.', 24, '2023-04-01'),
('Redacción Académica', 'Técnicas para escribir ensayos argumentativos.', 25, '2022-05-01'),
('Medioambiente y Cambio Climático', 'Estudios locales sobre impacto ambiental.', 26, '2023-06-06'),
('Aula del Futuro', 'Diseño de espacios flexibles de aprendizaje.', 27, '2022-07-01'),
('Arte y Emoción', 'Educación emocional a través del arte.', 28, '2023-03-03'),
('Taller de Ilustración', 'Introducción al diseño gráfico e ilustración.', 29, '2021-10-15');

-- Insertar Conceptos
INSERT INTO T_CONCEPTO (nombre, descripcion) 
VALUES 
('Chasis', 'Chasis para el vehículo'),
('Asiento', 'Asiento para el vehículo'),
('Suspensión', 'Sistema de suspensión para el vehículo'),
('Dirección', 'Sistema de dirección para el vehículo'),
('Frenos', 'Frenos del vehículo'),
('Neumáticos y llantas', 'Neumáticos y llantas del vehículo'),
('Elementos comerciales', 'Elementos comerciales para la venta o publicidad'),
('Carrocería', 'Carrocería del vehículo'),
('Cinturón', 'Cinturón de seguridad del vehículo'),
('Equipos de protección', 'Equipos de protección para los conductores'),
('Logística', 'Gastos de logística para el proyecto'),
('Equipamiento, GPS y velocímetro', 'Equipamiento como GPS y velocímetro para el vehículo'),
('Soportes para el vehículo', 'Soportes necesarios para montar el vehículo'),
('Batería', 'Batería para el vehículo'),
('Materiales de Oficina', 'Compra de material para elaboración de planes de negocio.'),
('Alquiler de Espacios', 'Alquiler de espacio para talleres y conferencias.'),
('Impresión de Documentos', 'Impresión de folletos, planes de negocio y materiales educativos.'),
('Honorarios de Expertos', 'Pago a expertos en emprendimiento que impartirán conferencias.'),
('Publicidad', 'Campaña de publicidad para promocionar el taller y atraer participantes.'),
('Kits de Arduino', 'Compra de kits de Arduino y componentes electrónicos.'),
('Material Educativo', 'Compra de manuales y recursos educativos sobre Arduino.'),
('Alquiler de Aula', 'Alquiler de aula para los talleres prácticos.'),
('Honorarios de Formadores', 'Pago a los instructores que enseñarán sobre Arduino.'),
('Transporte de Equipos', 'Costos de transporte de equipos y materiales a las aulas.'),
('Compra de Sensores', 'Compra de sensores de humedad, temperatura y pH para el huerto.'),
('Materiales de Siembra', 'Compra de semillas, tierra, abono y otros materiales para el huerto.'),
('Sistema de Riego Automático', 'Instalación de un sistema de riego automatizado para el huerto.'),
('Invernadero', 'Construcción de un pequeño invernadero para proteger las plantas.'),
('Formación en Agricultura', 'Curso para alumnos sobre técnicas de cultivo y sostenibilidad.'),
('Sensores Meteorológicos', 'Compra de sensores para medir temperatura, humedad, presión y velocidad del viento.'),
('Materiales de Instalación', 'Materiales para la instalación de la estación meteorológica.'),
('Software de Análisis de Datos', 'Adquisición de software para procesar y analizar los datos recogidos.'),
('Alquiler de Espacio para Instalación', 'Alquiler de espacio en el centro para montar la estación meteorológica.'),
('Formación en Meteorología', 'Formación básica para el uso de la estación meteorológica y la interpretación de los datos.');

-- Insertar Patrocinadores
INSERT INTO T_PATROCINADOR (nombre) 
VALUES 
('Soluciones Nerva'),
('Fibritel'),
('Karting Ángel Burgueño'),
('Mann filter'),
('IES Virgen de la Paloma'),
('Acer logística'),
('Talleres TUDAM'),
('Energy Tetuán, S.L.'),
('Banco Santander'),
('Google for Startups'),
('Fundación La Caixa'),
('Endesa'),
('Arduino'),
('RS Components'),
('Fundación Telefónica'),
('Microsoft'),
('Hidroponia España'),
('Ikea'),
('Bosch'),
('Fundación Biodiversidad'),
('Aemet'),
('Siemens'),
('Red Eléctrica Española'),
('Roche');

-- Insertar relaciones entre Proyecto y Curso
-- Asumiendo que el identificador del proyecto insertado en la tabla T_PROYECTO es 1 y el código del curso es '2024/2025'
-- Se deben obtener estos valores previamente o basarse en los identificadores generados en la base de datos.

-- Insertar relación Proyecto - Curso (Proyecto 'Hiperbaric' con Curso '2024/2025')
INSERT INTO T_PROYECTO_CURSO (id_proyecto, cod_curso)  VALUES
(1, '2022-2023'),
(1, '2023-2024'), 
(2, '2022-2023'),
(2, '2023-2024'), 
(3, '2022-2023'),
(3, '2023-2024'), 
(4, '2023-2024'), 
(5, '2023-2024'), 
(6, '2023-2024'), 
(7, '2023-2024'), 
(8, '2023-2024'), 
(9, '2023-2024'), 
(10, '2023-2024'),
(11, '2023-2024'),
(12, '2023-2024'),
(17, '2023-2024'),
(34, '2023-2024'),
(47, '2023-2024'),
(1, '2024-2025'), 
(2, '2024-2025'), 
(3, '2024-2025'), 
(4, '2024-2025'), 
(5, '2024-2025'), 
(6, '2024-2025'), 
(7, '2024-2025'), 
(8, '2024-2025'), 
(9, '2024-2025'), 
(10, '2024-2025'),
(11, '2024-2025'),
(12, '2024-2025'),
(17, '2024-2025'),
(34, '2024-2025'),
(47, '2024-2025');

-- Insertar Gastos 2023/2024
INSERT INTO T_GASTO (id_concepto, id_proyecto, cod_curso, fecha_gasto, precio_unidad, num_unidades, observacion)
VALUES
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Chasis'), 1, '2022-2023', '2024-09-15', 500.00, 1, 'Gasto en Chasis'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Asiento'), 1, '2022-2023', '2024-09-16', 200.00, 1, 'Gasto en Asientos'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Suspensión'), 1, '2022-2023', '2024-09-17', 100.00, 4, 'Gasto en Suspensión'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Dirección'), 1, '2022-2023', '2024-09-18', 800.00, 1, 'Gasto en Dirección'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Frenos'), 1, '2022-2023', '2024-09-19', 600.00, 1, 'Gasto en Frenos'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Neumáticos y llantas'), 1, '2022-2023', '2024-09-20', 250.00, 4, 'Gasto en Neumáticos y llantas'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Elementos comerciales'), 1, '2022-2023', '2024-09-21', 400.00, 1, 'Gasto en Elementos comerciales'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Carrocería'), 1, '2022-2023', '2024-09-22', 1000.00, 1, 'Gasto en Carrocería'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Cinturón'), 1, '2022-2023', '2024-09-23', 200.00, 1, 'Gasto en Cinturón'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Equipos de protección'), 1, '2022-2023', '2024-09-24', 950.00, 1, 'Gasto en Equipos de protección'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Logística'), 1, '2022-2023', '2024-09-25', 150.00, 1, 'Gasto en Logística'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Equipamiento, GPS y velocímetro'), 1, '2022-2023', '2024-09-26', 25.00, 30, 'Gasto en Equipamiento, GPS y velocímetro'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Soportes para el vehículo'), 1, '2022-2023', '2024-09-27', 300.00, 1, 'Gasto en Soportes para el vehículo'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Chasis'), 1, '2023-2024', '2023-09-15', 500.00, 1, 'Gasto en Chasis'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Asiento'), 1, '2023-2024', '2023-09-16', 200.00, 1, 'Gasto en Asientos'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Suspensión'), 1, '2023-2024', '2023-09-17', 100.00, 4, 'Gasto en Suspensión'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Dirección'), 1, '2023-2024', '2023-09-18', 800.00, 1, 'Gasto en Dirección'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Frenos'), 1, '2023-2024', '2023-09-19', 600.00, 1, 'Gasto en Frenos'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Neumáticos y llantas'), 1, '2023-2024', '2023-09-20', 250.00, 4, 'Gasto en Neumáticos y llantas'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Elementos comerciales'), 1, '2023-2024', '2023-09-21', 400.00, 1, 'Gasto en Elementos comerciales'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Carrocería'), 1, '2023-2024', '2023-09-22', 1000.00, 1, 'Gasto en Carrocería'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Cinturón'), 1, '2023-2024', '2023-09-23', 200.00, 1, 'Gasto en Cinturón'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Equipos de protección'), 1, '2023-2024', '2023-09-24', 950.00, 1, 'Gasto en Equipos de protección'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Logística'), 1, '2023-2024', '2023-09-25', 150.00, 1, 'Gasto en Logística'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Equipamiento, GPS y velocímetro'), 1, '2023-2024', '2023-09-26', 25.00, 30, 'Gasto en Equipamiento, GPS y velocímetro'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Soportes para el vehículo'), 1, '2023-2024', '2023-09-27', 300.00, 1, 'Gasto en Soportes para el vehículo'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Batería'), 1, '2023-2024', '2023-09-28', 150.00, 1, 'Gasto en Batería'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Chasis'), 2, '2023-2024', '2024-09-15', 1200.00, 1, 'Gasto en Chasis para EcoMotors'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Neumáticos y llantas'), 2, '2023-2024', '2024-09-16', 300.00, 4, 'Gasto en Neumáticos para EcoMotors'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Batería'), 2, '2023-2024', '2024-09-17', 800.00, 1, 'Gasto en Batería para EcoMotors'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Chasis'), 2, '2022-2023', '2023-09-15', 1200.00, 1, 'Gasto en Chasis para EcoMotors'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Neumáticos y llantas'), 2, '2022-2023', '2023-09-16', 300.00, 4, 'Gasto en Neumáticos para EcoMotors'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Batería'), 2, '2022-2023', '2023-09-17', 800.00, 1, 'Gasto en Batería para EcoMotors'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Chasis'), 3, '2023-2024', '2024-09-15', 1500.00, 1, 'Gasto en Chasis para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Dirección'), 3, '2023-2024', '2024-09-16', 900.00, 1, 'Gasto en Dirección para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Suspensión'), 3, '2023-2024', '2024-09-17', 300.00, 4, 'Gasto en Suspensión para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Neumáticos y llantas'), 3, '2023-2024', '2024-09-18', 250.00, 4, 'Gasto en Neumáticos para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Batería'), 3, '2023-2024', '2024-09-19', 1200.00, 1, 'Gasto en Batería para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Chasis'), 3, '2023-2024', '2023-09-15', 1500.00, 1, 'Gasto en Chasis para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Dirección'), 3, '2022-2023', '2023-09-16', 900.00, 1, 'Gasto en Dirección para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Suspensión'), 3, '2022-2023', '2023-09-17', 300.00, 4, 'Gasto en Suspensión para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Neumáticos y llantas'), 3, '2022-2023', '2023-09-18', 250.00, 4, 'Gasto en Neumáticos para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Batería'), 3, '2022-2023', '2023-09-19', 1200.00, 1, 'Gasto en Batería para Speedster'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Compra de Sensores'), 5, '2023-2024', '2023-10-01', 120.00, 5, 'Compra inicial de sensores para el huerto.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Materiales de Siembra'), 5, '2023-2024', '2023-10-05', 25.00, 20, 'Semillas y tierra para primera fase.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Sistema de Riego Automático'), 5, '2023-2024', '2023-10-12', 450.00, 1, 'Instalación del riego automático.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Invernadero'), 5, '2023-2024', '2023-10-20', 700.00, 1, 'Montaje de invernadero para protección.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Compra de Sensores'), 5, '2024-2025', '2024-10-01', 130.00, 6, 'Reemplazo de sensores defectuosos.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Materiales de Siembra'), 5, '2024-2025', '2024-10-07', 28.00, 15, 'Renovación de siembra para nueva temporada.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Formación en Agricultura'), 5, '2024-2025', '2024-10-15', 300.00, 1, 'Formación para alumnado sobre sostenibilidad.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Sistema de Riego Automático'), 5, '2024-2025', '2024-10-20', 480.00, 1, 'Mantenimiento del sistema de riego.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Sensores Meteorológicos'), 17, '2023-2024', '2023-10-05', 85.00, 4, 'Compra inicial de sensores básicos.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Materiales de Instalación'), 17, '2023-2024', '2023-10-10', 150.00, 1, 'Soportes, cables y herramientas para el montaje.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Software de Análisis de Datos'), 17, '2023-2024', '2023-10-15', 200.00, 1, 'Licencia de software anual.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Formación en Meteorología'), 17, '2023-2024', '2023-10-20', 75.00, 10, 'Curso básico para estudiantes.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Sensores Meteorológicos'), 17, '2024-2025', '2024-09-20', 90.00, 3, 'Reposición de sensores dañados.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Alquiler de Espacio para Instalación'), 17, '2024-2025', '2024-09-25', 300.00, 1, 'Renovación del alquiler del espacio.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Materiales de Instalación'), 17, '2024-2025', '2024-09-28', 100.00, 2, 'Material adicional para la expansión del sistema.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Software de Análisis de Datos'), 17, '2024-2025', '2024-10-01', 210.00, 1, 'Actualización de licencia de software.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Kits de Arduino'), 34, '2023-2024', '2023-09-20', 85.00, 10, 'Compra de kits básicos para los estudiantes.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Material Educativo'), 34, '2023-2024', '2023-09-25', 20.00, 15, 'Compra de manuales impresos y guías.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Alquiler de Aula'), 34, '2023-2024', '2023-10-01', 100.00, 4, 'Alquiler de aula durante un mes.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Honorarios de Formadores'), 34, '2023-2024', '2023-10-05', 250.00, 2, 'Pago a los formadores de Arduino.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Kits de Arduino'), 34, '2024-2025', '2024-09-15', 90.00, 12, 'Compra de kits actualizados para el nuevo curso.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Material Educativo'), 34, '2024-2025', '2024-09-22', 22.00, 18, 'Nuevas ediciones de materiales de formación.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Transporte de Equipos'), 34, '2024-2025', '2024-09-28', 60.00, 3, 'Coste de transporte de kits y pizarras digitales.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Honorarios de Formadores'), 34, '2024-2025', '2024-10-02', 275.00, 2, 'Formadores externos para los nuevos talleres.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Materiales de Oficina'), 47, '2023-2024', '2023-09-20', 15.00, 40, 'Material para actividades de planificación y presentación.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Alquiler de Espacios'), 47, '2023-2024', '2023-09-25', 120.00, 5, 'Alquiler de aula y sala de conferencias.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Impresión de Documentos'), 47, '2023-2024', '2023-10-01', 0.10, 3000, 'Impresión de planes de negocio y folletos.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Honorarios de Expertos'), 47, '2023-2024', '2023-10-05', 500.00, 2, 'Ponencias de dos expertos en emprendimiento.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Materiales de Oficina'), 47, '2024-2025', '2024-09-15', 16.00, 45, 'Actualización de materiales de planificación.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Publicidad'), 47, '2024-2025', '2024-09-22', 300.00, 1, 'Campaña online y cartelería para el evento.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Alquiler de Espacios'), 47, '2024-2025', '2024-09-28', 130.00, 6, 'Alquiler de aula interactiva y salón de actos.'),
((SELECT identificador FROM T_CONCEPTO WHERE nombre = 'Honorarios de Expertos'), 47, '2024-2025', '2024-10-02', 550.00, 2, 'Conferencias de especialistas en startups.');


-- Insertar Ingresos 2023/2024
INSERT INTO T_INGRESO (id_patrocinador, id_proyecto, cod_curso, fecha_ingreso, cantidad, observacion)
VALUES
((select identificador from T_PATROCINADOR where nombre = 'Soluciones Nerva'), 1, '2022-2023', '2024-09-15', 1000.00, 'Donación para chasis'), 
((select identificador from T_PATROCINADOR where nombre = 'Fibritel'), 1, '2022-2023', '2024-09-16', 1500.00, 'Donación para suspensión y elementos comerciales'),
((select identificador from T_PATROCINADOR where nombre = 'Karting Ángel Burgueño'), 1, '2022-2023', '2024-09-17', 800.00, 'Dirección'),
((select identificador from T_PATROCINADOR where nombre = 'Mann filter'), 1, '2022-2023', '2024-09-18', 950.00, 'Donación para equipos de protección'),
((select identificador from T_PATROCINADOR where nombre = 'IES Virgen de la Paloma'), 1, '2022-2023', '2024-09-19', 1000.00, 'Dietas y soportes para vehículo'),
((select identificador from T_PATROCINADOR where nombre = 'Acer logística'), 1, '2022-2023', '2024-09-20', 150.00, 'Logística'),
((select identificador from T_PATROCINADOR where nombre = 'Talleres TUDAM'), 1, '2022-2023', '2024-09-21', 700.00, 'Donación general'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Soluciones Nerva'), 1, '2023-2024', '2023-09-15', 1000.00, 'Donación para chasis'), 
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fibritel'), 1, '2023-2024', '2023-09-16', 1500.00, 'Donación para suspensión y elementos comerciales'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Karting Ángel Burgueño'), 1, '2023-2024', '2023-09-17', 800.00, 'Dirección'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Mann filter'), 1, '2023-2024', '2023-09-18', 950.00, 'Donación para equipos de protección'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'IES Virgen de la Paloma'), 1, '2023-2024', '2023-09-19', 1000.00, 'Dietas y soportes para vehículo'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Acer logística'), 1, '2023-2024', '2023-09-20', 150.00, 'Logística'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Talleres TUDAM'), 1, '2023-2024', '2023-09-21', 700.00, 'Donación general'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Energy Tetuán, S.L.'), 1, '2023-2024', '2023-09-22', 1200.00, 'Donación para batería'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Soluciones Nerva'), 2, '2023-2024', '2024-09-15', 1500.00, 'Donación para el Chasis de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fibritel'), 2, '2023-2024', '2024-09-16', 1800.00, 'Donación para la batería de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Karting Ángel Burgueño'), 2, '2023-2024', '2024-09-17', 1000.00, 'Donación para los neumáticos de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Mann filter'), 2, '2023-2024', '2024-09-18', 1200.00, 'Donación para la logística de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Soluciones Nerva'),2, '2022-2023', '2023-09-15', 1500.00, 'Donación para el Chasis de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fibritel'),2, '2022-2023', '2023-09-16', 1800.00, 'Donación para la batería de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Karting Ángel Burgueño'),2, '2022-2023', '2023-09-17', 1000.00, 'Donación para los neumáticos de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Mann filter'),2, '2022-2023', '2023-09-18', 1200.00, 'Donación para la logística de EcoMotors'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Talleres TUDAM'), 3, '2022-2023', '2024-09-15', 2000.00, 'Donación para el chasis de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Energy Tetuán, S.L.'), 3, '2022-2023', '2024-09-16', 2200.00, 'Donación para dirección de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Acer logística'), 3, '2022-2023', '2024-09-17', 500.00, 'Donación para la logística de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fibritel'), 3, '2022-2023', '2024-09-18', 1500.00, 'Donación para neumáticos de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Soluciones Nerva'), 3, '2022-2023', '2024-09-19', 2500.00, 'Donación para batería de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Talleres TUDAM'), 3, '2022-2023', '2023-09-15', 2000.00, 'Donación para el chasis de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Energy Tetuán, S.L.'), 3, '2022-2023', '2023-09-16', 2200.00, 'Donación para dirección de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Acer logística'), 3, '2022-2023', '2023-09-17', 500.00, 'Donación para la logística de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fibritel'), 3, '2022-2023', '2023-09-18', 1500.00, 'Donación para neumáticos de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Soluciones Nerva'), 3, '2022-2023', '2023-09-19', 2500.00, 'Donación para batería de Speedster'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Hidroponia España'), 5, '2023-2024', '2023-09-15', 1500.00, 'Donación para sensores y riego.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Ikea'), 5, '2023-2024', '2023-09-20', 1000.00, 'Apoyo en materiales de siembra.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Bosch'), 5, '2023-2024', '2023-09-25', 1800.00, 'Financiación del invernadero.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fundación Biodiversidad'), 5, '2024-2025', '2024-09-10', 2200.00, 'Formación y sostenibilidad.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Hidroponia España'), 5, '2024-2025', '2024-09-15', 1600.00, 'Donación para ampliación del sistema de riego.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Ikea'), 5, '2024-2025', '2024-09-20', 1200.00, 'Apoyo a segunda fase de plantación.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Aemet'), 17, '2023-2024', '2023-09-15', 1000.00, 'Apoyo inicial para sensores.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Red Eléctrica Española'), 17, '2023-2024', '2023-09-20', 1200.00, 'Fondos para software y formación.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Roche'), 17, '2023-2024', '2023-09-25', 800.00, 'Apoyo a actividades educativas.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Siemens'), 17, '2024-2025', '2024-09-10', 1500.00, 'Donación para renovación de materiales.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Aemet'), 17, '2024-2025', '2024-09-15', 1100.00, 'Apoyo continuado al mantenimiento del sistema.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Roche'), 17, '2024-2025', '2024-09-20', 900.00, 'Formación adicional y expansión de sensores.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Arduino'), 34, '2023-2024', '2023-09-10', 1000.00, 'Donación inicial para kits y formación.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'RS Components'), 34, '2023-2024', '2023-09-15', 800.00, 'Apoyo económico para compra de componentes.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fundación Telefónica'), 34, '2023-2024', '2023-09-18', 1200.00, 'Financiación para formadores y materiales.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Microsoft'), 34, '2024-2025', '2024-09-10', 1500.00, 'Apoyo al programa de educación tecnológica.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'RS Components'), 34, '2024-2025', '2024-09-12', 950.00, 'Suministro de sensores y piezas electrónicas.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fundación Telefónica'), 34, '2024-2025', '2024-09-16', 1100.00, 'Financiación para formación y logística.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Banco Santander'), 47, '2023-2024', '2023-09-10', 2000.00, 'Patrocinio para fomentar el emprendimiento escolar.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Google for Startups'), 47, '2023-2024', '2023-09-12', 1800.00, 'Apoyo al desarrollo de ideas innovadoras.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fundación La Caixa'), 47, '2023-2024', '2023-09-18', 1500.00, 'Subvención para actividades de inclusión digital.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Endesa'), 47, '2024-2025', '2024-09-10', 1700.00, 'Financiación de iniciativas sostenibles de emprendimiento.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Google for Startups'), 47, '2024-2025', '2024-09-14', 1900.00, 'Colaboración en proyectos tecnológicos educativos.'),
((SELECT identificador FROM T_PATROCINADOR WHERE nombre = 'Fundación La Caixa'), 47, '2024-2025', '2024-09-16', 1600.00, 'Apoyo a jóvenes emprendedores del centro.');


