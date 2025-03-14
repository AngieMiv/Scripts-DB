DROP DATABASE IF EXISTS Gobierno;
CREATE DATABASE Gobierno CHARACTER SET utf8mb4;
USE Gobierno;

CREATE TABLE ministerio (
  codMinisterio INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  presupuesto DOUBLE UNSIGNED NOT NULL,
  gastos DOUBLE UNSIGNED NOT NULL
);

CREATE TABLE miembro (
  codMiembro INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nif VARCHAR(9) NOT NULL UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  alias VARCHAR(100),
  codigoMinisterio INT UNSIGNED,
  FOREIGN KEY (codigoMinisterio) REFERENCES ministerio(codMinisterio)
);

INSERT INTO ministerio VALUES(1, 'Ministerio de Defensa', 120000, 6000);
INSERT INTO ministerio VALUES(2, 'Ministerio de Economía', 375000, 38000);
INSERT INTO ministerio VALUES(3, 'Ministerio de Ciencia e innovación', 280000, 25000);
INSERT INTO ministerio VALUES(4, 'Ministerio del Aire', 110000, 3000);
INSERT INTO ministerio VALUES(5, 'Ministerio de Consumo', 0, 100000);
INSERT INTO ministerio VALUES(6, 'Ministerio de Igualdad', 0, 0);
INSERT INTO ministerio VALUES(7, 'Ministerio de Pesca', 1000, 1000);

INSERT INTO miembro VALUES(1, '23451596F', 'James', 'Logan', 'Lobezno', 1);
INSERT INTO miembro VALUES(2, '55756320D', 'Bruce', 'Banner', 'Hulk', 3);
INSERT INTO miembro VALUES(3, '36974641B', 'Tío', 'Gilito', NULL, 2);
INSERT INTO miembro VALUES(4, '17705545E', 'Clark', 'Kent','Superman', 4);
INSERT INTO miembro VALUES(5, '25087203C', 'Wade', 'Wilson', 'Deadpool', 5);
INSERT INTO miembro VALUES(6, '84382980M', 'Steve', 'Rogers', 'Capitán América', 1);
INSERT INTO miembro VALUES(7, '23576669X', 'Monty', 'Burns', NULL, 2);
INSERT INTO miembro VALUES(8, '17651431Z', 'Bruce', 'Wayne', 'Batman', 2);
INSERT INTO miembro VALUES(9, '26399183D', 'Tony', 'Stark', 'Iron Man', 3);
INSERT INTO miembro VALUES(10, '44384486H', 'Ernesto','Sevilla','Gañan', 5);
INSERT INTO miembro VALUES(11, '67849283A', 'Natasha','Romanova','Viuda Negra', 1);
INSERT INTO miembro VALUES(12, '41254836R', 'Lisbeth','Salender', NULL, NULL);
INSERT INTO miembro VALUES(13, '82698162B', 'Sarah','Connor', NULL, NULL);
INSERT INTO miembro VALUES(14, '32515162H', 'Arthur','Curry', 'Aquaman', 7);