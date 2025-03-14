/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: 19/12/2024
Script: Consulta de información sobre una Tabla o Funciones.
*/

/*1. Muestra un listado con el código de tienda y la ciudad donde hay tiendas.*/
SELECT codTienda, ciudad
	FROM tienda;

/*2. Devuelve un listado con el nombre, apellidos y el email de los empleados
	cuyo jefe tiene el código de jefe 7.*/
SELECT e.Nombre, e.Apellido1, e.Apellido2, e.email
	FROM empleado e
	WHERE e.codJefe = 7;
	
/*3. Muestra el nombre del cargo, nombre, apellidos y el email del jefe de la empresa.*/
SELECT Cargo, Nombre, Apellido1, Apellido2, email 
	FROM empleado e
	WHERE codJefe IS NULL;

/*4. Muestra un listado con el nombre, apellidos y cargo de aquellos empleados
	que no sean representantes de ventas.*/
SELECT Nombre, Apellido1, Apellido2, Cargo
	FROM empleado e
	WHERE e.cargo NOT IN ('Representante Ventas');
	
/*5. Muestra un listado con el nombre de los todos los clientes españoles.*/
SELECT nombreCliente
	FROM cliente c
	WHERE c.Pais = 'Spain';

/*6. Muestra el listado con los distintos estados por los que puede pasar un pedido.*/
SELECT DISTINCT estado 
	FROM pedido p;

/*7. Muestra un listado con el código de los clientes que realizaron algún pago en 2020.
	Ten en cuenta que deberás eliminar aquellos códigos de cliente que aparezcan repetidos.*/
SELECT DISTINCT c.codCliente
	FROM cliente c JOIN pedido p
	WHERE c.codCliente = p.codCliente AND p.fechaPedido LIKE '2020%'
	ORDER BY c.codCliente ASC;

/*8. Muestra un listado con el código de pedido, el código del cliente, la fecha esperada
	y la fecha de entrega de los pedidos que no han sido entregados a tiempo.*/
SELECT codPedido, codCliente, fechaPrevista, fechaEntrega 
	FROM pedido p
	WHERE fechaPrevista < fechaEntrega;

/*9. Muestra un listado con el código de pedido, el código del cliente, la fecha esperada
	y la fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos
	dos días antes de la fecha esperada*/
SELECT codPedido, codCliente, fechaPrevista, fechaEntrega 
	FROM pedido p
	WHERE ((DATEDIFF(fechaEntrega, fechaPrevista) <= 2) AND (fechaPrevista < fechaEntrega));
	
/*10. Muestra una lista de todos los pedidos comprados en 2019 que fueron rechazados.*/
SELECT codPedido, fechaPedido, estado 
	FROM pedido p
	WHERE p.fechaPedido LIKE '2019%' AND estado = 'Rechazado';

/*11. Muestra una lista con todos los pedidos entregados durante el mes de enero de cualquier año.*/
SELECT codPedido, fechaEntrega
	FROM pedido p
	WHERE MONTH (fechaPedido) = 1 AND fechaEntrega IS NOT NULL;

/*12. Muestra un listado con los pagos realizados con Paypal durante el 2020,
	ordenados de mayor a menor importe.*/
SELECT formaPago, fechaPago, ImporteTotal 
	FROM pago p
	WHERE formaPago = 'PayPal' AND fechaPago LIKE '2020%'
	ORDER BY ImporteTotal ASC;
	
/*13. Muestra la lista de todos los productos del tipo de producto Ornamentales y
	que tienen más de 100 unidades en stock. El listado deberá estar
	ordenado por su precio de venta, mostrando en primer lugar los más caros.*/
SELECT tipo, p.Nombre, p.Stock, p.PrecioVenta 
	FROM TipoProducto tp JOIN producto p
	WHERE p.Stock > 100 AND tp.tipo ='Ornamentales' 
	ORDER BY p.PrecioVenta DESC;
	
/*14. Muestra la lista de todos los productos del tipo de producto Frutales
	que generen un beneficio de más de 15€, ordenados por precio de venta,
	mostrando en primer lugar los más caros.*/
SELECT tipo, p.Nombre, p.Stock, p.PrecioVenta 
	FROM TipoProducto tp JOIN producto p
	WHERE ((p.PrecioVenta - p.PrecioProveedor) > 15) AND (tp.tipo ='Frutales') 
	ORDER BY p.PrecioVenta DESC;
	
/*15. Muestra un listado con los productos del proveedor ‘Viveros EL OASIS’
	que cumplan alguno de los siguientes requisitos:
	Se tiene más de 100 unidades en stock o que generen un beneficio de más de 100€.*/
SELECT p.Proveedor, p.Stock, p.PrecioVenta, p.PrecioProveedor
	FROM producto p
	WHERE (p.Proveedor = 'Viveros EL OASIS') AND ((p.Stock > 100))
		OR (p.Proveedor = 'Viveros EL OASIS') AND ((p.PrecioVenta - p.PrecioProveedor) > 100);

/*16. Muestra un listado con los productos del proveedor ‘Viveros EL OASIS’
	que generen un beneficio de más de 100€ o productos de cualquier
	proveedor de los que se tenga más de 100 unidades en stock.*/
SELECT p.Proveedor, p.Stock, p.PrecioVenta, p.PrecioProveedor
	FROM producto p
	WHERE p.Proveedor = 'Viveros EL OASIS' AND (p.PrecioVenta - p.PrecioProveedor) > 100
		OR  p.Stock > 100;
	
/*17. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid
	y cuyo representante de ventas tenga el código de empleado 8 o 30.*/
SELECT c.codCliente, c.Ciudad, c.codEmpleadoVentas, e.codEmpleado 
	FROM cliente c JOIN empleado e
	ON c.codEmpleadoVentas = e.codEmpleado
	WHERE e.codEmpleado BETWEEN 8 AND 30 AND c.Ciudad = 'Madrid';
	