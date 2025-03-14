-- Crear bbdd mapa mundi 
CREATE DATABASE IF NOT EXISTS Mapa_Mundi;

-- Usar bbdd mapa mundi
USE Mapa_Mundi;

-- Crear tabla T_CONTINENTE
CREATE TABLE IF NOT EXISTS T_CONTINENTE(
	codigo CHAR(2) NOT NULL,
	nombre VARCHAR(25) NOT NULL,
	PRIMARY KEY(codigo)
);

-- Crear tabla T_PAIS
CREATE TABLE IF NOT EXISTS T_PAIS(
	identificador int NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	capital VARCHAR(50) NOT NULL,
	cod_continente CHAR(2) NOT NULL,
	PRIMARY KEY(identificador),
	CONSTRAINT FK_PAIS_CONTINENTE
		FOREIGN KEY(cod_continente) REFERENCES T_CONTINENTE(codigo)
);
