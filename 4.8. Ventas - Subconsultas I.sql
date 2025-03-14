/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 13, 2025
Script: Consulta de info con Subconsultas
*/

	-- Subconsultas en la cláusula WHERE.
	-- Utiliza los operadores básicos de comparación para realizar las siguientes consultas:

/*1. Devuelve un listado con todos los pedidos que ha realizado Francisco Losa Pesada
 * (Sin utilizar INNER JOIN).*/
/*SELECT *
FROM cliente JOIN pedido
	ON cliente.idCliente  = pedido.idCliente
		WHERE concat(cliente.nombre, ' ', cliente.apellido1, ' ', cliente.apellido2) = 'Francisco Losa Pesada';*/
SELECT *
FROM pedido
	WHERE pedido.idCliente = (SELECT cliente.idCliente
								FROM cliente
								WHERE concat(cliente.nombre, ' ', cliente.apellido1, ' ', cliente.apellido2)
									= 'Francisco Losa Pesada'
								);

/*2. Devuelve el listado de pedidos en los que ha participado el vendedor Rosa Flores Arriba
 * (Sin utilizar INNER JOIN).*/

 SELECT *
 FROM pedido p 
 	WHERE p.idVendedor = (SELECT v.idVendedor
 							FROM vendedor v 
 							WHERE concat(v.nombre, ' ', v.apellido1, ' ', v.apellido2)
 							= 'Rosa Flores Arriba');
 	
/*3. Muestra los datos del cliente que hizo el pedido más caro en 2019
 * (Sin utilizar INNER JOIN).*/
SELECT p.idCliente, p.importeTotal
FROM pedido p
	WHERE year(p.fecha)=2019
	ORDER BY p.importeTotal DESC
	LIMIT 1;

SELECT *
FROM cliente c 
	WHERE c.idCliente IN (SELECT p.idCliente
						FROM pedido p
							WHERE p.importeTotal = (SELECT max(p.importeTotal)
													FROM pedido p
													WHERE YEAR(p.fecha) = 2019
													)
						);

/*4. Muestra la fecha y importe del pedido de menor valor realizado por el cliente Adrián Saltado Cabezas
 * (Sin utilizar INNER JOIN).*/
/*SELECT p.fecha, p.importeTotal, p.idCliente, p.idCliente AS 'id Adrián S. C'
FROM pedido p
	WHERE idCliente = (SELECT idCliente
						FROM cliente c 
						WHERE CONCAT(c.nombre, ' ', c.apellido1, ' ', c.apellido2)
						= 'Adrián Saltado Cabezas')
	ORDER BY p.importeTotal ASC
	LIMIT 1;*/

SELECT p.fecha, p.importeTotal, p.idCliente, p.idCliente AS 'id Adrián S. C'
FROM pedido p
	WHERE idCliente = (SELECT idCliente
						FROM cliente c 
						WHERE CONCAT(c.nombre, ' ', c.apellido1, ' ', c.apellido2)
						= 'Adrián Saltado Cabezas')
	AND p.importeTotal = (SELECT min(p2.importeTotal)
							FROM pedido p2
							WHERE p2.idCliente = p.idCliente
							);
/*5. Devuelve un listado con los datos de los clientes (Nombre y Apellidos) y los pedidos,
 * para aquellos clientes que han realizado un pedido durante el año 2019 con un
 * valor mayor o igual al valor medio de los pedidos realizados durante ese mismo año
 * (Sin utilizar INNER JOIN).*/
SELECT (SELECT c.nombre
		FROM cliente c
			WHERE c.idCliente = p.idCliente) AS nombre, p.*
FROM pedido p
	WHERE year(p.fecha) = 2019
AND p.importeTotal >= (SELECT avg(p2.importetotal)
						FROM pedido p2
							WHERE year(p2.fecha) >= 2019);
 
	-- Subconsultas con ALL y ANY

/*6. Devuelve el pedido más caro que existe en la tabla pedido si hacer uso de MAX, ORDER BY ni LIMIT.*/
SELECT p.*
FROM pedido p 
	WHERE p.importeTotal >= ALL (SELECT p2.importeTotal 
									FROM pedido p2);

/*7. Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando ANY o ALL).*/
SELECT c.*
FROM cliente c
	WHERE c.idCliente != ALL(SELECT DISTINCT p.idCliente
								FROM pedido p);

	-- Subconsultas con IN y NOT IN

/*8. Listado de los clientes que no han realizado ningún pedido.*/
SELECT c.*
FROM cliente c
	WHERE c.idCliente NOT IN (SELECT DISTINCT p.idCliente
								FROM pedido p);

/*9. Listado de los vendedores que han realizado algún pedido*/
SELECT v.*
FROM vendedor v
	WHERE v.idVendedor IN (SELECT DISTINCT p.idVendedor
								FROM pedido p);

	-- Subconsultas con EXISTS y NOT EXISTS

/*10. Devuelve un listado de los clientes que no han realizado ningún pedido.*/
SELECT c.*
FROM cliente c
	WHERE NOT EXISTS (SELECT *
						FROM pedido p 
							WHERE p.idCliente = c.idCliente);

/*11. Devuelve un listado de los vendedores que han participado en algún pedido.*/
SELECT v.*
FROM vendedor v
	WHERE EXISTS (SELECT DISTINCT p.idVendedor
					FROM pedido p
					WHERE p.idVendedor = v.idVendedor);
