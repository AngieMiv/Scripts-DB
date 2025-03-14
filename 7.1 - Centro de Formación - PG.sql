/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Feb 10, 2025
Script: Centro de Formación
*/

/*PostgreSQL*/

CREATE DATABASE Centro_de_Formacion;

CREATE TYPE DIRECCION AS(
	Direccion_Nombre VARCHAR(60),
	Direccion_Numero VARCHAR(4),
	Direccion_CodigoPostal INT,
	Direccion_Localidad VARCHAR(60)
);

CREATE TABLE T_PERSONA (
	NIF CHAR(9) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    Direccion DIRECCION,
  	Telefono INT[] NOT NULL /* O también Telefono INT ARRAY NOT NULL,*/
);


CREATE TABLE T_PROFESOR(
      Formacion_Principal VARCHAR(50) NOT NULL
) INHERITS (T_PERSONA);

CREATE TABLE T_ALUMNO(
	Id_Alumno SERIAL NOT NULL
) INHERITS (T_PERSONA);
