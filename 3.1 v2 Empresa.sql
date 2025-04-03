-- crear bbdd y usarla

CREATE DATABASE IF NOT EXISTS Empresa_AMIV2;
USE Empresa_AMIV2;

-- crear tablas

CREATE TABLE IF NOT EXISTS T_CLIENTE(
	dni CHAR(9),
	nombre VARCHAR(20) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono CHAR(9) NOT NULL,
	-- restricciones
	CONSTRAINT PRIMARY KEY(dni)
);

CREATE TABLE IF NOT EXISTS T_PRODUCTO(
	codigo CHAR(5) NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	precio_unitario DECIMAL(6,2) NOT NULL,
	-- restricciones
	CONSTRAINT PRIMARY KEY(codigo),
	CONSTRAINT ck_precio_unitario CHECK(
		precio_unitario <= 1500.99)
);

CREATE TABLE IF NOT EXISTS T_CLIENTE_PRODUCTO(
	dni_cliente CHAR(8) NOT NULL,
	codigo_producto CHAR(5) NOT NULL,
	-- restricciones
	CONSTRAINT FK_cliente_producto FOREIGN KEY(dni_cliente)
		REFERENCES T_CLIENTE(dni),
	CONSTRAINT FK_producto_codigo FOREIGN KEY(codigo_producto)
		REFERENCES T_PRODUCTO(codigo)
);

CREATE TABLE IF NOT EXISTS T_PROVEEDOR(
	nif CHAR(9) NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	codigo_producto CHAR(5) NOT NULL,
	-- restricciones
	CONSTRAINT PRIMARY KEY(nif),
	CONSTRAINT FK_codigo_producto_proveedor FOREIGN KEY(codigo_producto)
		REFERENCES T_PRODUCTO(codigo)
);

ALTER TABLE T_PROVEEDOR
	DROP PRIMARY KEY,
	ADD CONSTRAINT UK_nif UNIQUE(nif);
ALTER TABLE T_PROVEEDOR
	ADD COLUMN identificador CHAR(5) NOT NULL,
	ADD CONSTRAINT PRIMARY KEY(identificador);
