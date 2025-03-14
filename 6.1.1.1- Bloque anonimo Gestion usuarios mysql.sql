/*
SGDB: MySQL
Programador: AMIV
Fecha: 05/03/2025
Script: Bloque anónimo sobre la base de datos de gestión de permisos de usuarios adaptado a MySQL.
*/

DELIMITER $$

CREATE PROCEDURE contar_usuarios_por_rol(IN nombreRol VARCHAR(50), OUT num_usuarios INT)
BEGIN
    -- Contar el número de usuarios con el rol específico y almacenarlo en la variable de salida
    SELECT COUNT(*)
    	INTO num_usuarios
    FROM T_USUARIO u
    	JOIN T_USUARIO_ROL ur ON u.identificador = ur.id_usuario
    	JOIN T_ROL r ON ur.id_rol = r.identificador
   	 	WHERE r.nombre = nombreRol;
END $$

DELIMITER ;

CALL contar_usuarios_por_rol('Profesor', @resultado);

SELECT @resultado AS 'Número de Usuarios con el rol';



