/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 10, 2025
Script: Aplicar los conocimientos sobre la sentencia SELECT aplicada multi-tablas
(JOINS) y GroupBy. Consulta de información sobre una Tabla o Funciones.
*/

/*1. Muestra un listado de los pagos realizados con los nombres de los clientes que realizaron cada pago.*/
SELECT c.nombreCliente, p.*
FROM pago p JOIN cliente c ON p.codCliente = c.codCliente;

/*2. Muestra un listado de los pagos realizados con los nombres de los clientes que realizaron cada pago 
que cumplen que: el nombre del cliente contiene la palabra 'jardin'
(sin diferenciar entre minúsculas y mayúsculas) el importe del pago está entre 8500 y 20000 €,
y el pago se realizó en el mes de febrero.*/
SELECT *
	FROM pago p JOIN cliente c
		ON p.codCliente = c.codCliente 
	WHERE lower(c.nombreCliente) LIKE '%jardin%'
		AND p.ImporteTotal BETWEEN 8500 AND 20000
		AND month(p.fechaPago) = 2;

/*3. Muestra un listado de los pagos realizados, los nombres de los clientes así como el
nombre del representante de ventas asociado al cliente teniendo en cuenta que:
el cliente es una sociedad limitada (ya sea que finalicen su nombre con 'SL', 'S.L.' o 'S.L')*/
SELECT e.Nombre, c.nombreCliente, count(p.ImporteTotal) AS numeroPagos
FROM pago p JOIN cliente c
	ON p.codCliente = c.codCliente
		JOIN empleado e
			ON c.codEmpleadoVentas = e.codEmpleado 
	WHERE (c.nombreCliente LIKE '%SL' OR c.nombreCliente LIKE '%S.L.' OR c.nombreCliente LIKE 'S.L')
	AND e.CARGO = 'Representante Ventas'
	GROUP BY c.codCliente;

/*4. Muestra un listado de los pagos realizados, los nombres de los clientes así como el
nombre del representante de ventas asociado al cliente teniendo en cuenta que:
El cliente es de la región de Madrid, de la ciudad de Sydney o cuyo país es France,
o el importe es menor de 10.000 €*/
SELECT c.nombreCliente, e.Nombre AS Nombre_Representante, c.Region, c.Pais , p.*
FROM pago p JOIN cliente c
	ON p.codCliente = c.codCliente
		JOIN empleado e
			ON c.codEmpleadoVentas = e.codEmpleado 
	WHERE (c.Region = 'Madrid' OR c.Ciudad = 'Sydney' OR c.Ciudad = 'France' OR p.ImporteTotal < 10000);

/*5. Muestra un listado de los pagos realizados, los nombres del cliente,
del jefe del representante de ventas asociado al cliente, la tienda
(se formará por la  ́concatenación del código de la tienda, de la ciudad en la que está la tienda
y del código postal de la misma) en la que trabaja teniendo en cuenta que: el importe es menor de 10.000 €,
y el nombre del representante de ventas no sean ni Rintarou ni Sandra.*/

SELECT c.nombreCliente, e2.Nombre AS Nombre_JEFE_Representante,
concat(t.codtienda, '-', t.Ciudad, '-', t.CP) AS Tienda
	FROM pago p JOIN cliente c
		ON p.codCliente = c.codCliente
		JOIN empleado e
		ON c.codEmpleadoVentas = e.codEmpleado
		JOIN empleado e2
		ON e.codJefe = e2.codEmpleado
		JOIN tienda t
		ON e.codtienda = t.codTienda
	WHERE p.ImporteTotal < 10000 AND e2.Nombre != 'Rintarou' AND e2.Nombre != 'Sandra';
			
				
/*6. Muestra un listado de los clientes , con el número de pedidos realizados siempre que hayan realizado
más de 20 pedidos.*/

SELECT c.nombreCliente, c.codCliente, count(p.codCliente) AS pedidos
	FROM cliente c JOIN pedido p
		ON c.codCliente = p.codCliente
	GROUP BY c.codCliente
		HAVING pedidos > 20; 

/*7. Muestra un listado que muestre el número de pedidos de productos con un stock mayor de 50 ,
que se encuentran en un estado Pendiente, realizado en el país y la ciudad de los clientes,
siempre que hayan realizado menos pedidos que número de tiendas hay en la base de datos
(el número de tiendas se obtiene como subconsulta escalar).*/

SELECT c.pais, c.Ciudad, count(DISTINCT p.codPedido) AS pedidos_pendientes
	FROM cliente c JOIN pedido p
		ON c.CodCliente = p.codCliente
	JOIN detalle_pedido dp
		ON p.codCliente = dp.codPedido 
	JOIN producto pr
		ON dp.codProducto = pr.codProducto
	WHERE pr.Stock > 50 AND p.estado = 'pendiente'
	GROUP BY c.pais, c.Ciudad;

/*8. Muestra un listado que muestre el número de pedidos cuya descripción en texto del tipo de producto
comienza por 'Plantas', , que se encuentran en un estado Pendiente, realizado en el país y la ciudad
de los cliente, siempre que hayan realizado entre 15 y 35 pedidos.*/

SELECT c.pais, c.Ciudad, count(DISTINCT p.codPedido) AS numero_pedidos
	FROM cliente c JOIN pedido p
		ON c.CodCliente = p.codCliente
	JOIN detalle_pedido dp
		ON p.codCliente = dp.codPedido 
	JOIN producto pr
		ON dp.codProducto = pr.codProducto
	JOIN TipoProducto tp
		ON pr.TipoProducto = tp.tipo 
	WHERE tp.descripcion_texto LIKE 'Plantas%' AND p.estado = 'Pendiente'
	GROUP BY c.pais, c.Ciudad 
	HAVING numero_pedidos BETWEEN 15 AND 35;
	
/*9. Muestra un listado que muestre el número de pedidos realizados por cada proveedor
para aquellos productos que son regalados por el proveedor.*/

SELECT pr.Proveedor, count(DISTINCT p.codPedido) AS numero_pedidos
	FROM pedido p JOIN detalle_pedido dp
		ON p.codCliente = dp.codPedido
	JOIN producto pr
		ON dp.codProducto = pr.codProducto
	WHERE pr.PrecioProveedor = 0
	GROUP BY pr.Proveedor;

/*10. Muestra un listado que muestre el número de pedidos realizados por cada proveedor
para aquellos productos que son regalados por el proveedor, entregados en el año 2020
y cuya fecha prevista de entrega es mayor , al menos en dos día, que la fecha de entrega.*/

SELECT pr.Proveedor, count(DISTINCT p.codPedido) AS numero_pedidos
	FROM pedido p JOIN detalle_pedido dp
		ON p.codCliente = dp.codPedido
	JOIN producto pr
		ON dp.codProducto = pr.codProducto
	WHERE pr.PrecioProveedor = 0
		AND year(p.fechaEntrega) = 2020
		AND p.fechaPrevista >= p.fechaEntrega + 2
	GROUP BY pr.Proveedor;

