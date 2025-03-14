/*PostgreSQL*/
CREATE DATABASE bbdd_grupo1_videojuegos_2PG;
CREATE TABLE T_EMPRESA (
      Id_Empresa SERIAL PRIMARY KEY,
      Nombre VARCHAR(50) UNIQUE NOT NULL,
      Fecha_Fundacion DATE NOT NULL,   /*yyyy-mm-dd*/
      Propietario VARCHAR(50) NOT NULL,
      Director_Actual VARCHAR(60) NOT NULL
);
CREATE TABLE T_EMPLEADO(
      Id_Empleado SERIAL PRIMARY KEY,
      Dni CHAR(9) UNIQUE,
      Nombre VARCHAR(40) NOT NULL,
      Apellido VARCHAR(40) NOT NULL,
      Apellido2 VARCHAR(40),
      Fecha_Nacimiento DATE NOT NULL,
      Fecha_Alta DATE NOT NULL,
      Salario DECIMAL(8,2) NOT NULL,  /*ej.: 123456.78*/
      Id_Coordinador INT NOT NULL,
      Empresa SERIAL NOT NULL,
      CONSTRAINT fk_coordinador_empleado
              FOREIGN KEY(Id_Coordinador)
                      REFERENCES T_EMPLEADO(Id_Empleado),
      CONSTRAINT fk_empresa
              FOREIGN KEY(Empresa)
                      REFERENCES T_EMPRESA(Id_Empresa)
);
CREATE TABLE T_PROGRAMADOR(
      Id_EmpleadoPro SERIAL PRIMARY KEY,
      Lenguaje_Programacion VARCHAR(30) NOT NULL,
      CONSTRAINT fk_empleado_pro
              FOREIGN KEY (Id_EmpleadoPro)
                      REFERENCES T_EMPLEADO(Id_Empleado)
);
CREATE TABLE T_TESTER(
      Id_EmpleadoT SERIAL PRIMARY KEY,
      Plataforma VARCHAR(30) NOT NULL,
      CONSTRAINT fk_empleado_t
              FOREIGN KEY (Id_EmpleadoT)
                      REFERENCES T_EMPLEADO(Id_Empleado)
);
CREATE TABLE T_INGENIERO_SONIDO(
      Id_EmpleadoSo SERIAL PRIMARY KEY,
      Editor_Sonido VARCHAR(40) NOT NULL,
      CONSTRAINT fk_empleado_so
              FOREIGN KEY (Id_EmpleadoSo)
                      REFERENCES T_EMPLEADO(Id_Empleado)
);
CREATE TABLE T_ANIMADOR(
      Id_EmpleadoAn SERIAL PRIMARY KEY,
      Programa_Animacion VARCHAR(40) NOT NULL,
      CONSTRAINT fk_empleado_an
              FOREIGN KEY (Id_EmpleadoAn)
                      REFERENCES T_EMPLEADO(Id_Empleado)
);
CREATE TABLE T_OTROS(
      Id_EmpleadoO SERIAL PRIMARY KEY,
      Categoria VARCHAR(40) NOT NULL,
      CONSTRAINT fk_empleado_o
              FOREIGN KEY (Id_EmpleadoO)
                      REFERENCES T_EMPLEADO(Id_Empleado)
);
CREATE TABLE T_PREMIO(
      Cod_Premio CHAR(5) PRIMARY KEY,
      Nombre VARCHAR(50) NOT NULL
);
CREATE TABLE T_VIDEOJUEGO(
      Cod_Videojuego CHAR(5) PRIMARY KEY,
      Nombre VARCHAR(50) NOT NULL,
      Fecha_Salida DATE NOT NULL,
      Precio_Salida DECIMAL(5,2) NOT NULL, /*ej.: 123,45*/
      PEGI CHAR(2) NOT NULL CHECK(PEGI in('3','7','12','16','18'))
);
CREATE TABLE T_PLATAFORMA(
      Nombre_Plataforma VARCHAR(30) NOT NULL,
      Cod_Videojuego CHAR(5) NOT NULL,
      PRIMARY KEY (Nombre_Plataforma, Cod_Videojuego),
      CONSTRAINT fk_plataf_videoj
              FOREIGN KEY(Cod_Videojuego)
                      REFERENCES T_VIDEOJUEGO(Cod_Videojuego)
);
CREATE TABLE T_GENERO(
      Nombre_Genero VARCHAR(30) NOT NULL,
      Cod_Videojuego CHAR(5) NOT NULL,
      PRIMARY KEY (Nombre_Genero, Cod_Videojuego),
      CONSTRAINT fk_genero_videoj
              FOREIGN KEY(Cod_Videojuego)
                      REFERENCES T_VIDEOJUEGO(Cod_Videojuego)
);
CREATE TABLE T_VIDEOJUEGO_EMPRESA(
      Empresa INT NOT NULL,
      Videojuego CHAR(5) NOT NULL,
      PRIMARY KEY (Empresa, Videojuego),
      CONSTRAINT fk_videoj_empresa__empresa
              FOREIGN KEY(Empresa)
                      REFERENCES T_EMPRESA(Id_Empresa),
		CONSTRAINT fk_videoj_empresa__videoj
              FOREIGN KEY(Videojuego)
                      REFERENCES T_VIDEOJUEGO(Cod_Videojuego)
);
CREATE TABLE T_VIDEOJUEGO_EMPRESA_PREMIO(
      Empresa INT NOT NULL,
      Videojuego CHAR(5) NOT NULL,
      Premio CHAR(5) NOT NULL,
      PRIMARY KEY (Empresa, Videojuego, Premio),
      CONSTRAINT fk_videoj_empresa_premio__videoj_empresa
              FOREIGN KEY(Empresa, Videojuego)
                      REFERENCES T_VIDEOJUEGO_EMPRESA(Empresa, Videojuego),
		CONSTRAINT fk_videoj_empresa_premio__premio
              FOREIGN KEY(Premio)
                      REFERENCES T_PREMIO(Cod_Premio)
);
/* - Cambiar tipo de "Cod_Premio CHAR(5)" a "Id_premio INT"
*  1º Eliminamos las FKs relacionadas con la PK que queremos modificar
*  2º Eliminarmos la PK para modificar el atributo
*  3º Modificamos el nombre y el datatype del atributo principal
*  4º Modificamos el datatype de "Premio" en "T_VIDEOJUEGO_EMPRESA_PREMIO" a int
*  5º Recuperamos la PK y la FK
*/
ALTER TABLE T_VIDEOJUEGO_EMPRESA_PREMIO 
	DROP CONSTRAINT fk_videoj_empresa_premio__premio;
ALTER TABLE T_PREMIO
	DROP CONSTRAINT t_premio_pkey;
ALTER TABLE T_PREMIO
	RENAME COLUMN Cod_Premio TO Id_Premio;
ALTER TABLE T_PREMIO 
	ALTER COLUMN Id_Premio TYPE integer USING Id_Premio::INT;
ALTER TABLE T_VIDEOJUEGO_EMPRESA_PREMIO 
	ALTER COLUMN Premio TYPE integer USING Premio::INT;
ALTER TABLE T_PREMIO 
	ADD PRIMARY KEY (Id_Premio);
ALTER TABLE T_VIDEOJUEGO_EMPRESA_PREMIO 
	ADD CONSTRAINT fk_videoj_empresa_premio__premio
		FOREIGN KEY (Premio)
			REFERENCES T_PREMIO(Id_Premio);	
/*
 * - Añadir "Nota_Metacritic" a T_VIDEOJUEGO
 */
ALTER TABLE T_VIDEOJUEGO
	ADD COLUMN Nota_Metecritic DECIMAL (4, 2);