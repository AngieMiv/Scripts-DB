/*
SGDB: MySQL
Script: Políticas de BLOQUEO a nivel de REGISTRO.
*/

/*
Niveles de aislamiento de una transacción:
	1. SERIALIZABLE:  Garantiza que las transacciones se ejecuten de manera secuencial,
			evitando conflictos de concurrencia y asegurando la máxima consistencia de los datos.
	
	2. REPEATABLE READ: Ofrece una instantánea consistente de los datos al inicio de la
			transacción, lo que garantiza que cualquier lectura realizada dentro de la transacción
			vea los mismos datos. Es el valor por decto que toma el nivel de aislamiento en MySQL.
	
	3. READ COMMITTED: Garantiza que una transacción solo vea datos confirmados por otras transacciones.
	
	4. READ UNCOMMITTED: : Permite que una transacción lea datos que aún no han
			sido confirmados por otras transacciones. Mínimo nivel de consistencia de datos.
*/
-- Nivel de aislamiento a nivel global
-- SELECT @@global.transaction_isolation;
-- SET GLOBAL transaction_isolation = 'SERIALIZABLE';

-- Nivel de aislamiento a nivel SESSION.
SELECT @@session.transaction_isolation;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

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
COMMIT; -- Transacción 3: Confirmación de las operaciones iniciadas en la transacción 3


