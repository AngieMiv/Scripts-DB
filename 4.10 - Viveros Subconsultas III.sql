/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 20, 2025
Script: 4.10 - Viveros Sub-Consultas III
*/

	-- Subconsultas en la cláusula WHERE

/*1. Devuelve el nombre del cliente que tiene el mayor límite de crédito.*/
SELECT c.nombreCliente, c.limiteCredito 
FROM cliente c
	WHERE c.codCliente = (SELECT c2.codCliente 
							FROM cliente c2 
								WHERE c2.limiteCredito = (SELECT MAX(c3.limiteCredito)
															FROM cliente c3));

/*2. Devuelve el nombre del producto que tiene el precio de venta más caro.*/
SELECT p.Nombre, p.PrecioVenta 
FROM producto p
	WHERE p.codProducto = (SELECT p2.codProducto
							FROM producto p2
								WHERE p2.precioVenta = (SELECT MAX(p3.precioVenta)
														FROM producto p3));

/*3. Listado de los clientes cuyo límite de crédito sea mayor que los pagos que ha realizado (Sin INNER JOIN).*/
SELECT *
FROM cliente c
	WHERE c.limiteCredito > (SELECT sum(p.ImporteTotal)
							FROM pago p
								WHERE p.codCliente = c.codCliente);

	-- Subconsultas con ALL y ANY
/*4. Muestra el nombre del cliente con mayor límite de crédito.*/
SELECT MAX(c3.limiteCredito)
	FROM cliente c3)
	
/*5. Muestra el nombre del producto que tiene el precio de venta más caro.*/
SELECT *
FROM producto p
	WHERE p.PrecioVenta >= ALL (SELECT p2.precioVenta
								FROM producto p2);
	
/*6. Datos del producto que menos unidades tiene en stock.*/
SELECT *
FROM producto p
	WHERE p.Stock <= ALL (SELECT p2.Stock
								FROM producto p2);
 
	-- Subconsultas con IN y NOT IN

/*7. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.*/

/*8. Listado que muestre los clientes que han realizado ningún pago.*/
SELECT *
FROM cliente c 
	WHERE c.codCliente NOT IN (SELECT p.codCliente
								FROM pago p
									WHERE p.ImporteTotal IS NOT NULL);

/*9. Listado de los productos que nunca han aparecido en un pedido que se encuentre en
 * estado Rechazado o Entregado.*/
SELECT *
FROM producto p
	WHERE p.codProducto NOT IN (SELECT dp.codProducto
								FROM detalle_pedido dp
									WHERE dp.codPedido IN (SELECT ped.codPedido
															FROM pedido ped
															WHERE ped.estado IN ('Rechazado', 'Entregado')));

/*10. Devuelve el nombre, apellidos, cargo y extensión de la oficina de aquellos
 * empleados que no sean representante de ventas de ningún cliente.*/
SELECT *
FROM empleado e
	WHERE e.codEmpleado NOT IN (SELECT c.codEmpleadoVentas
								FROM cliente c
									WHERE c.codEmpleadoVentas = e.codEmpleado)
	AND e.Cargo != 'Representante Ventas';

/*11. Devuelve las tiendas donde no trabajan ninguno de los empleados que hayan sido los
 * representantes de ventas de algún cliente que haya realizado la compra
 * de algún producto del tipo Frutales.*/
SELECT *
FROM tienda t
	WHERE t.codTienda IN (SELECT e.codTienda
							FROM empleado e
							WHERE e.codEmpleado NOT IN (SELECT c.codEmpleadoVentas
														FROM cliente c
														WHERE c.codCliente IN (SELECT p.codCliente
																				FROM pedido p
																				WHERE p.codPedido IN(SELECT dp.codPedido
																										FROM detalle_pedido dp
																										WHERE dp.codProducto IN (SELECT p.codProducto
																																	FROM producto p
																																	WHERE p.TipoProducto = 'Frutales')
																				)
														)
							)
);

/*12. Listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.*/


	-- Subconsultas con EXISTS y NOT EXISTS

/*13. Devuelve un listado que muestre solamente los clientes españoles que no han realizado ningún pago.*/
SELECT *
FROM cliente c 
	WHERE c.Pais = 'Spain'
	AND NOT EXISTS (SELECT *
					FROM pago p
						WHERE p.codCliente = c.codCliente);

/*14. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.*/
SELECT *
FROM cliente c 
	WHERE EXISTS (SELECT *
					FROM pago p
						WHERE p.codCliente = c.codCliente);

/*15. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.*/
SELECT *
FROM producto p
	WHERE EXISTS (SELECT *
					FROM detalle_pedido dp
						WHERE dp.codProducto = p.codProducto);

