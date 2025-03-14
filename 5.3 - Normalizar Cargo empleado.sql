/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 23, 2025
Script: 5.3. Normalizar campo Cargo de empleado
*/

/*PASOS A SEGUIR
 * 1. Crear la tabla Cargo.
 * 2. Introducir los cargos que hay en empleado con select distinct cargo from empleado;
 * 3. Crear idCargo en Empleado.
 * 4. Asignar el idCargo que corresponda según está en cargo.
 * 5. Eliminar el campo cargo de empleado.*/

	-- 1. Crear tabla cargo
CREATE TABLE cargo (
	identificador int UNSIGNED AUTO_INCREMENT NOT NULL,
	nombre varchar(50),
	PRIMARY KEY (identificador)
);

ALTER TABLE cargo DROP COLUMN nombre,
	ADD COLUMN nombre varchar(50) NOT NULL;

	-- 2. Cargar los cargos que hay en empleado en la tabla cargo
INSERT INTO cargo(nombre)
	SELECT DISTINCT cargo FROM empleado;
	
	-- 3. crear idCargo en empleado
ALTER TABLE empleado ADD COLUMN idCargo int NOT NULL;

	-- 4. asignar el idCargo según el cargo del empleado
UPDATE empleado e 
	SET e.idCargo = (SELECT c.identificador
						FROM cargo c
						WHERE c.nombre = e.cargo);

	-- 5. eliminar columna cargo de tala empleado
ALTER TABLE empleado DROP COLUMN cargo;

	-- 6. asignar la fk que vincula el idCargo con el identificador de la tabla cargo
ALTER TABLE empleado
	ADD CONSTRAINT fk_empleado_cargo FOREIGN KEY (idCargo) REFERENCES cargo(identificador);