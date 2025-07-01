/*
SGDB: XXX
Programador: YYY
Fecha: 27/01/2025
Script: Bloque anónimo sobre la base de datos de gestión de permisos.
*/

DO $$
DECLARE
    nombreRol TEXT := 'Estudiante'; 
    num_usuarios INT := 0;
BEGIN
    RAISE NOTICE 'Nombre Rol: %', nombreRol;

    SELECT COUNT(*)
    INTO num_usuarios
    FROM T_USUARIO u
    JOIN T_USUARIO_ROL ur ON u.identificador = ur.id_usuario
    JOIN T_ROL r ON ur.id_rol = r.identificador
    WHERE r.nombre = nombreRol;

    RAISE NOTICE 'Número de Usuarios con el rol %: %' , nombreRol, num_usuarios;
END $$;

