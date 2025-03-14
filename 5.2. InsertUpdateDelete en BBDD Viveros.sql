/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 10, 2025
Script: 5.2. Insert-Update-Delete en BBDD Viveros
*/
SELECT * FROM detalle_pedido;
/*1. Inserta una nueva oficina en Almería.*/

INSERT INTO tienda VALUES ('ALM-ES','Almería','España','Almería','04003','+34 950 21 00 00','Plaza de la Constitución, s/n','');

/*2. Inserta un empleado para la oficina de Almería que sea representante de ventas.*/

INSERT INTO empleado VALUES (32, 'Alba','Martínez','González','6666','alba@gardening.com','ALM-ES', 7,'Representante Ventas');

/*3. Inserta un cliente que tenga como representante de ventas el empleado
 * que hemos creado en el paso anterior.*/

INSERT INTO cliente VALUES (39, 'Balatro', 'Jaunjo', 'Barbosa', '697848981', '697848982', 'Toto Wolf 48', '', 'Pinar', 'Madrid', 'España', '28333', '7', 101100);


/*4. Inserta un pedido para el cliente que acabamos de crear,
que contenga al menos dos productos diferentes.*/

INSERT INTO pedido VALUES (129, '2025-01-09', '2025-01-19', NULL, 'Pendiente', 'Mitad al pedir y mitad al recibir', 39);
INSERT INTO detalle_pedido
	VALUES
	(129, 'FR-85', 1, 70, 1),
	(129, 'FR-77', 4, 69, 1);

/*5. Actualiza el código del cliente que hemos creado en el paso anterior y
averigua si hubo cambios en las tablas relacionadas.*/

UPDATE cliente SET codCliente = 40 WHERE codCliente = 39;
-- SQL Error [1451] [23000]: Cannot delete or update a parent row: a foreign key constraint fails
-- (`viveros`.`pedido`, CONSTRAINT `fk_cliente_pedido` FOREIGN KEY (`codCliente`)
-- REFERENCES `cliente` (`codCliente`))

/*6. Borra el cliente y averigua si hubo cambios en las tablas relacionadas.*/

DELETE FROM cliente WHERE codCliente = 39;
-- SQL Error [1451] [23000]: Cannot delete or update a parent row: a foreign key constraint fails
-- (`viveros`.`pedido`, CONSTRAINT `fk_cliente_pedido` FOREIGN KEY (`codCliente`)
-- REFERENCES `cliente` (`codCliente`))

/*7. Elimina los clientes que no hayan realizado ningún pedido.*/
DELETE cliente
	FROM cliente LEFT JOIN pedido
		ON cliente.codCliente = pedido.codCliente
			WHERE pedido.codPedido IS NULL;

/*8. Incrementa en un 20% el precio de los productos que no tengan pedidos.*/



/*9. Borra los pagos del cliente con menor límite de crédito.*/



/*10. Establece a 0 el límite de crédito del cliente que menos unidades pedidas tenga
 * del producto 11679.*/



/*11. Modifica la tabla detalle_pedido para incorporar un
 * campo numérico llamado iva.
	a. Establece el valor de ese campo iva a 18 para aquellos registros
		cuyo pedido tenga fecha a partir de Enero de 2009.
	b. A continuación, actualiza el resto de pedidos
		estableciendo el iva al 21.*/



/*12. Modifica la tabla detalle_pedido para incorporar un campo numérico llamado
 * total_linea y actualiza todos sus registros teniendo en cuenta la siguiente fórmula:
 * total_linea = precio_unidad*cantidad * (1 + (iva/100));*/



/*13. Borra el cliente que menor límite de crédito tenga.
 * ¿Es posible borrarlo solo con una consulta? ¿Por qué? */