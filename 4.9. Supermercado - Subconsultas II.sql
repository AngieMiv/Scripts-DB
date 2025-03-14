/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 17, 2025
Script: Supermercado Subconsultas II
*/

	-- Subconsultas en la cláusula WHERE

/*1. Devuelve todos los productos del proveedor Dulcesol. (Sin
utilizar INNER JOIN)*/
SELECT p.Nombre, p.CodProveedor AS 'Dulcesol'
FROM Producto p
	WHERE p.CodProveedor = (SELECT p2.CodProveedor
							FROM Proveedor p2
								WHERE p2.Nombre = 'Dulcesol');

/*2. Devuelve todos los datos de los productos que son más caros
que el producto más caro del proveedor Dulcesol. (Utilizando
y sin utilizar INNER JOIN).*/
SELECT *
FROM Producto p
	WHERE p.precio > (SELECT max(p2.precio)
						FROM Producto p2
							WHERE p2.CodProveedor = (SELECT p3.CodProveedor
													FROM Proveedor p3
														WHERE p3.Nombre = 'Dulcesol'));
SELECT p.*
FROM Producto p JOIN Proveedor p2
	WHERE p.CodProveedor = p2.CodProveedor
	AND p.precio > (SELECT max(p2.precio)
						FROM Producto p2
							WHERE p2.CodProveedor = (SELECT p3.CodProveedor
													FROM Proveedor p3
														WHERE p3.Nombre = 'Dulcesol'));

/*3. Devuelve el nombre del producto más caro de Dulcesol
(Utilizando y sin utilizar INNER JOIN)*/
SELECT max(p.precio), p.Nombre 
FROM Producto p
	WHERE p.CodProveedor = (SELECT p2.CodProveedor
							FROM Proveedor p2
								WHERE p2.Nombre = 'Dulcesol');

SELECT max(prod.Precio), prod.Nombre 
FROM Producto prod JOIN Proveedor prov
	WHERE prod.CodProveedor = prov.CodProveedor
	AND prov.Nombre = 'Dulcesol';

/*4. Muestra un listado con el nombre de los productos que tienen
el precio más barato que el producto más barato de Dulcesol*/
SELECT p.Nombre, p.Precio 
FROM Producto p
	WHERE p.precio < (SELECT min(p2.precio)
						FROM Producto p2
							WHERE p2.CodProveedor = (SELECT p3.CodProveedor
													FROM Proveedor p3
														WHERE p3.Nombre = 'Dulcesol'));

	-- Subconsultas con ALL y ANY

/*5. Devuelve el producto más caro que existe en la tabla producto
sin hacer uso de MAX, ORDER BY ni LIMIT*/
SELECT *
FROM Producto p
	WHERE p.Precio >= ALL(SELECT precio FROM Producto);


/*6. Devuelve el producto más barato que existe en la tabla
producto sin hacer uso de MIN, ORDER BY ni LIMIT*/
SELECT *
FROM Producto p
	WHERE p.Precio <= ALL (SELECT precio
							FROM Producto);

/*7. Devuelve los nombres de los proveedores que tienen productos
asociados.*/
SELECT p.Nombre 
FROM Proveedor p
	WHERE p.CodProveedor = ANY (SELECT CodProveedor
								FROM Producto);

/*8. Devuelve los nombres de los proveedores que no tienen
productos asociados.*/
SELECT p.Nombre 
FROM Proveedor p
	WHERE p.CodProveedor != ALL (SELECT CodProveedor
								FROM Producto);

	-- Subconsultas con IN y NOT IN

/*9. Devuelve los nombres de los proveedores que tienen productos
asociados.*/
SELECT p.Nombre 
FROM Proveedor p
	WHERE p.CodProveedor IN (SELECT CodProveedor
								FROM Producto);

/*10. Devuelve los nombres de los proveedores que no tienen
productos asociados*/
SELECT p.Nombre 
FROM Proveedor p
	WHERE p.CodProveedor NOT IN (SELECT CodProveedor
								FROM Producto);

	-- Subconsultas con EXISTS y NOT EXISTS

/*11. Devuelve los nombres de los proveedores que tienen
productos asociados.*/
SELECT p.Nombre 
FROM Proveedor p 
	WHERE EXISTS (SELECT *
					FROM Producto p2
						WHERE p2.CodProveedor = p.CodProveedor);

/*12. Devuelve los nombres de los proveedores que no tienen
productos asociados.*/
SELECT p.Nombre 
FROM Proveedor p 
	WHERE NOT EXISTS (SELECT *
					FROM Producto p2
						WHERE p2.CodProveedor = p.CodProveedor);

