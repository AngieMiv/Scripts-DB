/*
SGDB: MySQL
Script: uso de COMMIT, ROLLBACK, SAVEPOINT
*/

/* TRANSACCIÓN 1 */
START TRANSACTION; -- Transacción 1: Inicio
	INSERT INTO miembro (nif, nombre, apellido1, alias, codigoMinisterio)
	VALUES ('98765432F', 'Peter', 'Parker', 'Spiderman', 4);
	
	
	INSERT INTO ministerio (nombre, presupuesto, gastos) VALUES ('Ministerio de Sanidad', 250000, 15000);

	SELECT * FROM miembro;
	SELECT * FROM ministerio;
	
SAVEPOINT tras_insertar_ministerio; -- Transacción 1: Guardar estadado intermedio

	UPDATE ministerio SET presupuesto = 130000 WHERE nombre = 'Ministerio de Sanidad';
	
	DELETE FROM miembro WHERE nif ='98765432F';

	SELECT * FROM miembro;
	SELECT * FROM ministerio;

ROLLBACK TO SAVEPOINT tras_insertar_ministerio; -- Transacción 1: Vuelta atrás al estadado intermedio

	UPDATE miembro SET nombre = 'Spidey' WHERE nif ='98765432F';

	SELECT * FROM miembro;

COMMIT; -- Transacción 1: Confirmación de la operación tras el estadado intermedio


/* TRANSACCIÓN 2 */
START TRANSACTION; -- Transacción 2: Inicio
	UPDATE ministerio SET presupuesto = 130000 WHERE codMinisterio = 6;

	DELETE FROM ministerio WHERE codMinisterio = 6;
	
	INSERT INTO ministerio (codMinisterio, nombre, presupuesto, gastos) VALUES (6,'Ministerio de Igualdad', 250000, 15000);
	INSERT INTO miembro (nif, nombre, apellido1, alias, codigoMinisterio)
	VALUES ('98765432X', 'Sarah', 'Parker', 'Bing', 6);
ROLLBACK; -- Transacción 2: Marcha atrás a las operaciones iniciadas en la transacción 2


/* TRANSACCIÓN 3 */
START TRANSACTION; -- Transacción 3: Inicio
	INSERT INTO miembro (nif, nombre, apellido1, alias, codigoMinisterio)
	VALUES ('11111111A', 'John', 'Doe', NULL, 1);
	
	UPDATE miembro SET nombre = 'Jane' WHERE codMiembro = 13;
COMMIT; -- Transacción 2: Confirmación de las operaciones iniciadas en la transacción 3


