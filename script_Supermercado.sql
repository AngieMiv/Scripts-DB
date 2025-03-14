DROP DATABASE IF EXISTS Supermercado;
CREATE DATABASE Supermercado CHARACTER SET utf8mb4;
USE Supermercado;

CREATE TABLE Proveedor (
  CodProveedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Producto (
  CodProducto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Precio DOUBLE NOT NULL,
  CodProveedor INT UNSIGNED NOT NULL,
  CONSTRAINT fk_Proveedor_Producto
  FOREIGN KEY (CodProveedor) REFERENCES Proveedor(CodProveedor)
);

INSERT INTO Proveedor VALUES(1, 'Bebidas refrescantes');
INSERT INTO Proveedor VALUES(2, 'Bodegas Comando G');
INSERT INTO Proveedor VALUES(3, 'Aguas turbias');
INSERT INTO Proveedor VALUES(4, 'Queen mother');
INSERT INTO Proveedor VALUES(5, 'Monster Snack');
INSERT INTO Proveedor VALUES(6, 'Dulcesol');
INSERT INTO Proveedor VALUES(7, 'Camaleón');
INSERT INTO Proveedor VALUES(8, 'Visius');
INSERT INTO Proveedor VALUES(9, 'Zerveza');

INSERT INTO Producto VALUES(1, 'Risketos', 1.26, 5);
INSERT INTO Producto VALUES(2, 'Sobaos', 8.98, 6);
INSERT INTO Producto VALUES(3, 'Ampersand', 14.95, 4);
INSERT INTO Producto VALUES(4, 'Naranjas', 28, 7);
INSERT INTO Producto VALUES(5, 'Tortas de anís', 1.80, 6);
INSERT INTO Producto VALUES(6, 'Coca-Cola', 2.96, 1);
INSERT INTO Producto VALUES(7, 'Aquarius', 3.99, 1);
INSERT INTO Producto VALUES(8, 'Vino tinto \'El hombre bala\'', 15.73, 2);
INSERT INTO Producto VALUES(9, 'Vino tinto \'Reina de los deseos 2018\'', 90, 2);
INSERT INTO Producto VALUES(11, 'H2Os', 0.80, 3);