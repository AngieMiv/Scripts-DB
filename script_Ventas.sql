DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas CHARACTER SET utf8mb4;
USE ventas;

CREATE TABLE cliente (
  idCliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  ciudad VARCHAR(100),
  categoría INT UNSIGNED
);

CREATE TABLE vendedor (
  idVendedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  comision FLOAT
);

CREATE TABLE pedido (
  idPedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  importeTotal DOUBLE NOT NULL,
  fecha DATE,
  idCliente INT UNSIGNED NOT NULL,
  idVendedor INT UNSIGNED NOT NULL,
  CONSTRAINT fk_cliente_pedido FOREIGN KEY (idCliente) REFERENCES cliente(idCliente),
  FOREIGN KEY fk_vendedor_pedido (idVendedor) REFERENCES vendedor(idVendedor)
);

INSERT INTO cliente VALUES(1, 'Elsa', 'Broso', 'Moreno', 'Mallorca', 100);
INSERT INTO cliente VALUES(2, 'Angel', 'Debaño', 'Rojo', 'Toledo', 200);
INSERT INTO cliente VALUES(3, 'Francisco', 'Losa', 'Pesada', 'Madrid', NULL);
INSERT INTO cliente VALUES(4, 'Andrés', 'Trozado', NULL, 'Málaga', 300);
INSERT INTO cliente VALUES(5, 'Lola', 'Mento', 'Martínez', 'Almería', 200);
INSERT INTO cliente VALUES(6, 'Vicente', 'Levidente', 'Moreno', 'Valencia', 100);
INSERT INTO cliente VALUES(7, 'Juan', 'Saltado', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES(8, 'Adrián', 'Saltado', 'Cabezas', 'Lugo', 200);
INSERT INTO cliente VALUES(9, 'Aitor', 'Tilla', 'Hecha', 'Álava', 225);
INSERT INTO cliente VALUES(10, 'Daniel', 'Levidente', 'Martínez', 'Sevilla', 125);

INSERT INTO vendedor VALUES(1, 'Julián', 'Vende', 'Motos', 0.15);
INSERT INTO vendedor VALUES(2, 'Ivana', 'Trampas', 'López', 0.13);
INSERT INTO vendedor VALUES(3, 'Rosa','Flores', 'Arriba', 0.11);
INSERT INTO vendedor VALUES(4, 'María','Fuerte', 'Herrera', 0.14);
INSERT INTO vendedor VALUES(5, 'Derek','Vende', 'Banderas', 0.12);
INSERT INTO vendedor VALUES(6, 'Manuel','Seviste', 'Arriba', 0.13);
INSERT INTO vendedor VALUES(7, 'Antonio','Caros', 'Hijos', 0.11);
INSERT INTO vendedor VALUES(8, 'Alfonso','Hace', 'Puentes', 0.05);

INSERT INTO pedido VALUES(1, 150.5, '2021-10-05', 5, 2);
INSERT INTO pedido VALUES(2, 270.65, '2020-09-10', 1, 5);
INSERT INTO pedido VALUES(3, 65.26, '2021-10-05', 2, 1);
INSERT INTO pedido VALUES(4, 110.5, '2019-08-17', 8, 3);
INSERT INTO pedido VALUES(5, 948.5, '2021-09-10', 5, 2);
INSERT INTO pedido VALUES(6, 2400.6, '2020-07-27', 7, 1);
INSERT INTO pedido VALUES(7, 5760, '2019-09-10', 2, 1);
INSERT INTO pedido VALUES(8, 1983.43, '2021-10-10', 4, 6);
INSERT INTO pedido VALUES(9, 2480.4, '2019-10-10', 8, 3);
INSERT INTO pedido VALUES(10, 250.45, '2018-06-27', 8, 2);
INSERT INTO pedido VALUES(11, 75.29, '2020-08-17', 3, 7);
INSERT INTO pedido VALUES(12, 3045.6, '2020-04-25', 2, 1);
INSERT INTO pedido VALUES(13, 545.75, '2022-01-25', 6, 1);
INSERT INTO pedido VALUES(14, 145.82, '2019-02-02', 6, 1);
INSERT INTO pedido VALUES(15, 370.85, '2020-03-11', 1, 5);
INSERT INTO pedido VALUES(16, 2389.23, '2020-03-11', 1, 5);