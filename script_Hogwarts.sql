DROP DATABASE IF EXISTS Hogwarts;
CREATE DATABASE Hogwarts CHARACTER SET utf8mb4;
USE Hogwarts;

CREATE TABLE casa(
idCasa int UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
Nombre varchar(45)
);
CREATE TABLE alumno (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  fechaNacimiento DATE NOT NULL,
  es_repetidor ENUM('sí', 'no') NOT NULL,
  telefono VARCHAR(9),
  idCasa int UNSIGNED,
  constraint fk_casa_alumno foreign key (idCasa) references casa(idCasa)
);
INSERT INTO casa VALUES (1,'Gryffindor');
INSERT INTO casa VALUES (2,'Slytherin');
INSERT INTO casa VALUES (3,'Ravenclaw');
INSERT INTO casa VALUES (4,'Hufflepuff');

INSERT INTO alumno VALUES(1,'Hermione', 'Granger', NULL, '1979/09/19', 'no', NULL,1);
INSERT INTO alumno VALUES(2,'Fred', 'Weasley', 'Velasco', '1978/04/01', 'no', 619153076,1);
INSERT INTO alumno VALUES(3,'Draco', 'Malfoy', 'García', '1980/06/05', 'sí', NULL,2);
INSERT INTO alumno VALUES(4,'Ronald', 'Weasley', 'Velasco', '1980/03/01', 'no', 672016594,1);
INSERT INTO alumno VALUES(5,'Harry', 'Potter', 'López', '1980/07/31', 'no', NULL,1);
INSERT INTO alumno VALUES(6,'Neville', 'Longbottom', NULL, '1980/07/30', 'sí', NULL,1);
INSERT INTO alumno VALUES(7,'Luna', 'Lovegood', 'Ramírez', '1981/02/13', 'no', 620339890,3);
INSERT INTO alumno VALUES(8,'Ginny', 'Weasley', 'Velasco', '1981/08/11', 'no', 612045533,1);
INSERT INTO alumno VALUES(9,'Myrtle', 'Llorona', 'Hernández', '1929/01/01', 'sí', NULL,3);
INSERT INTO alumno VALUES(10,'Pansy', 'Parkinson', 'Ruiz', '1980/02/03', 'no', NULL,2);
INSERT INTO alumno VALUES(11,'Nymphadora_Dora','Tonks','Martínez','1972-09-01','no',NULL,4);
