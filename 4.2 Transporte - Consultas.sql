/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 20, 2025
Script: 4.12 - Transporte Consultas I
*/
/*1. Devuelve el número de vehículos que tienen una capacidad de
carga entre 20 y 5000*/
SELECT count(v.identificador)
FROM VEHICULO v
	WHERE v.capacidad_carga BETWEEN 20 AND 5000;

/*2. Devuelve el nombre de los vehículos que no son barcos*/
SELECT v.nombre 
FROM VEHICULO v
	WHERE v.identificador NOT IN (SELECT b.identificador FROM BARCO b);

/*3. Devuelve el nombre de los vehículos que no son barcos, ni
aviones ni camiones, otros vehículos a partir de ahora (crea
una vista asociada a esta información).*/
SELECT v.nombre
FROM VEHICULO v 
	WHERE v.identificador NOT IN (SELECT b.identificador FROM BARCO b)
	AND v.identificador NOT IN (SELECT c.camion_id FROM CAMION c)
	AND v.identificador NOT IN (SELECT a.identificador FROM AVION a);

CREATE OR REPLACE VIEW V_OTROS_VEHICULOS AS
SELECT *
FROM VEHICULO v 
	WHERE v.identificador NOT IN (SELECT b.identificador FROM BARCO b)
	AND v.identificador NOT IN (SELECT c.camion_id FROM CAMION c)
	AND v.identificador NOT IN (SELECT a.identificador FROM AVION a);

/*4. Devuelve la información de otros vehículos cuyo modelo
empieza por 'P'.*/
SELECT *
FROM v_otros_vehiculos vov 
	WHERE vov.codigo_modelo LIKE 'P%';

/*5. Devuelve el nombre de los barcos y aviones cuya capacidad de
carga es mayor o igual que la media de la capacidad de carga
de los vehículos que son camiones y Otros Vehiculos.*/

SELECT AVG(SUM(sum(c.capacidad_carga) + sum(vov.capacidad_carga)))
FROM CAMION c JOIN v_otros_vehiculos vov JOIN VEHICULO v 
	ON v.identificador = c.camion_id AND v.identificador = vov.identificador;

/*6. Devuelve el nombre de los aviones cuya velocidad máxima es
menor que un 7% de su altura máxima.*/


/*7. Devuelve el nombre de los barcos cuya capacidad de carga es
mayor o igual que la media de la capacidad de carga de los
barcos de tipo de propulsión ‘Electrico', y cuya longitud es 
mayor que 5 veces la media de la longitud de los camiones de
cabina ‘simple'.*/


/*8. Devuelve el número de vehículos agrupados de cada tipo
(avión, barco, camión, otros). Utiliza la cláusula UNION*/


/*9. Devuelve un listado con los camiones que realizaron rutas en
febrero de 2024.*/


/*10. Devuelve un listado con los 3 camiones que han realizado
más rutas.*/


/*11. Devuelve un listado de camiones junto con el total de
número de kilómetros de sus rutas.*/


/*12. Devuelve un listado de camiones junto con el número de
rutas, el total de número de kilómetros de sus rutas y la media
de kilómetros de sus rutas.*/


/*13. Devuelve el nombre del camión que realizó la ruta más
recientemente que tuvo un costo está entre 300 y 600 euros y
cuya distancia es mayor que la media de la distancia de las
rutas realizadas.*/