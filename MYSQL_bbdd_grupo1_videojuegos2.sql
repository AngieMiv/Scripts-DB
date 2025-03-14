/* MySQL */

CREATE USER IF NOT EXISTS "bbdd" IDENTIFIED BY "1234";

CREATE DATABASE IF NOT EXISTS BBDD_GRUPO1_VIDEOJUEGOS_2;

USE BBDD_GRUPO1_VIDEOJUEGOS_2;

CREATE TABLE IF NOT EXISTS T_EMPRESA(
	Id_Empresa INT NOT NULL AUTO_INCREMENT,
	Nombre VARCHAR(50) NOT NULL UNIQUE,
	Fecha_Fundacion DATE NOT NULL,
	Propietario VARCHAR(50) NOT NULL,
	Director_Actual VARCHAR(60) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_Empresa)
);

CREATE TABLE IF NOT EXISTS T_EMPLEADO(
	Id_Empleado INT NOT NULL AUTO_INCREMENT,
	Dni CHAR(9) NOT NULL UNIQUE,
	Nombre VARCHAR(40) NOT NULL,
	Apellido VARCHAR(20) NOT NULL,
	Apellido2 VARCHAR(40),
	Fecha_Nacimiento DATE NOT NULL,
	Fecha_Alta DATE NOT NULL,
	Salario DECIMAL(8,2) NOT NULL,
	Id_Coordinador INT NOT NULL,
	Empresa INT NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_Empleado),
	CONSTRAINT fk_coordinador_empleado
		FOREIGN KEY(Id_Coordinador)
			REFERENCES T_EMPLEADO(Id_Empleado),
	CONSTRAINT fk_empresa
		FOREIGN KEY (Empresa)
			REFERENCES T_EMPRESA(Id_Empresa)
);

CREATE TABLE IF NOT EXISTS T_PROGRAMADOR(
	Id_EmpleadoPro INT NOT NULL AUTO_INCREMENT,
	Lenguaje_Programacion VARCHAR(30) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_EmpleadoPro),
	CONSTRAINT fk_empleado_pro
		FOREIGN KEY(Id_EmpleadoPro)
			REFERENCES T_EMPLEADO(Id_Empleado)
);

CREATE TABLE IF NOT EXISTS T_TESTER(
	Id_EmpleadoT INT NOT NULL AUTO_INCREMENT,
	Plataforma VARCHAR(30) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_EmpleadoT),
	CONSTRAINT fk_empleado_t
		FOREIGN KEY (Id_EmpleadoT)
			REFERENCES T_EMPLEADO(Id_Empleado)
);

CREATE TABLE T_INGENIERO_SONIDO(
	Id_EmpleadoSo INT NOT NULL AUTO_INCREMENT,
	Editor_Sonido VARCHAR(40) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_EmpleadoSo),
	CONSTRAINT fk_empleado_so
		FOREIGN KEY (Id_EmpleadoSo)
			REFERENCES T_EMPLEADO(Id_Empleado)
);

CREATE TABLE T_ANIMADOR(
	Id_EmpleadoAn INT NOT NULL AUTO_INCREMENT,
	Programa_Animacion VARCHAR(40) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_EmpleadoAn),
	CONSTRAINT fk_empleado_an
		FOREIGN KEY(Id_EmpleadoAn)
			REFERENCES T_EMPLEADO(Id_Empleado)
);

CREATE TABLE T_OTROS(
	Id_EmpleadoO INT NOT NULL AUTO_INCREMENT,
	Categoria VARCHAR(40) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Id_EmpleadoO),
	CONSTRAINT fk_empleado_o
		FOREIGN KEY (Id_EmpleadoO)
			REFERENCES T_EMPLEADO(Id_Empleado)
);

CREATE TABLE IF NOT EXISTS T_PREMIO(
	Cod_Premio CHAR(5) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Cod_Premio)
);

CREATE TABLE IF NOT EXISTS T_VIDEOJUEGO(
	Cod_Videojuego CHAR(5) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Fecha_Salida DATE NOT NULL,
	Precio_Salida FLOAT(5,2) NOT NULL,
	PEGI CHAR(2) NOT NULL,
	CONSTRAINT
		PRIMARY KEY(Cod_Videojuego),
	CONSTRAINT ck_pegi
		CHECK(PEGI IN('3', '7', '12', '16', '18'))
);

CREATE TABLE IF NOT EXISTS T_PLATAFORMA(
	Nombre_Plataforma VARCHAR(30) NOT NULL,
	Cod_Videojuego CHAR(5) NOT NULL,
	CONSTRAINT
		PRIMARY KEY (Nombre_Plataforma, Cod_Videojuego),
	CONSTRAINT fk_plataf_videoj
		FOREIGN KEY(Cod_Videojuego)
			REFERENCES T_VIDEOJUEGO(Cod_Videojuego)
);

CREATE TABLE IF NOT EXISTS T_GENERO(
	Nombre_Genero VARCHAR(30) NOT NULL,
	Cod_Videojuego CHAR(5) NOT NULL,
	CONSTRAINT
		PRIMARY KEY (Nombre_Genero, Cod_Videojuego),
	CONSTRAINT fk_genero_videoj
		FOREIGN KEY (Cod_Videojuego)
			REFERENCES T_VIDEOJUEGO (Cod_Videojuego)
);

CREATE TABLE IF NOT EXISTS T_VIDEOJUEGO_EMPRESA(
	Empresa INT NOT NULL AUTO_INCREMENT,
	Videojuego CHAR(5) NOT NULL,
	CONSTRAINT
		PRIMARY KEY (Empresa, Videojuego),
	CONSTRAINT fk_videoj_empresa__empresa
		FOREIGN KEY (Empresa)
			REFERENCES T_EMPRESA(Id_Empresa),
	CONSTRAINT fk_videoj_empresa__videoj
		FOREIGN KEY (Videojuego)
			REFERENCES T_VIDEOJUEGO(Cod_Videojuego)
);

CREATE TABLE IF NOT EXISTS T_VIDEOJUEGO_EMPRESA_PREMIO(
	Empresa INT NOT NULL AUTO_INCREMENT,
	Videojuego CHAR(5) NOT NULL,
	Premio CHAR(5) NOT NULL,
	Anyo YEAR NOT NULL,
	CONSTRAINT
		PRIMARY KEY (Empresa, Videojuego, Premio),
	CONSTRAINT fk_videoj_empresa_premio__videoj_empresa
		FOREIGN KEY(Empresa, Videojuego)
			REFERENCES T_VIDEOJUEGO_EMPRESA(Empresa, Videojuego),
	CONSTRAINT fk_videoj_empresa_premio__premio
		FOREIGN KEY (Premio)
			REFERENCES T_PREMIO(Cod_Premio)
);

/* - Editar bbdd: cambiar tipo de cod_premio de char(5) a id_premio int
 * 1º Eliminamos las fks relacionadas con la pk que queremos modificar
 * 2º Eliminamos la pk para modificar el atributo
 * 3º modificamos el atributo poniendole otro nombre y cambiandole el datatype
 * 4º modificamos el data type de premio a int en la tabla relacionada
 * 5º recuperamos primero la pk y luego la fk
 * */
ALTER TABLE T_VIDEOJUEGO_EMPRESA_PREMIO 
	DROP FOREIGN KEY fk_videoj_empresa_premio__premio;

ALTER TABLE T_PREMIO 
	DROP PRIMARY KEY;

ALTER TABLE T_PREMIO 
	CHANGE Cod_Premio Id_Premio INT;

ALTER TABLE T_VIDEOJUEGO_EMPRESA_PREMIO 
	MODIFY COLUMN Premio INT;

ALTER TABLE T_PREMIO 
	ADD PRIMARY KEY(Id_Premio);

ALTER TABLE T_VIDEOJUEGO_EMPRESA_PREMIO 
	ADD CONSTRAINT fk_videoj_empresa_premio__premio
		FOREIGN KEY (Premio)
			REFERENCES T_PREMIO(Id_Premio)

/*
 * Añadir atributo "Nota_Metacritic" a T_VIDEOJUEGO
 */
			
ALTER TABLE T_VIDEOJUEGO
	ADD COLUMN Nota_Metecritic DECIMAL (4, 2);
