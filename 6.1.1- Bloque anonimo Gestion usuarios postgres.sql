/*
SGDB: Postgres
Programador: AMIV
Fecha: 05/03/2025
Script: Bloque anónimo sobre la base de datos de gestión de permisos de usuarios.
*/

/* Este código básicamente obtiene el número de usuarios que tienen un rol específico 
 * (en este caso, "Estudiante") y lo muestra en la consola con mensajes de 
 * RAISE NOTICE.
 * */

DO $$ -- Inicia un bloque anónimo en PL/pgSQL
DECLARE
    nombreRol TEXT := 'Profesor'; -- Declara una variable 'nombreRol' de tipo TEXT y le asigna el valor 'Estudiante'
    num_usuarios INT := 0; -- Declara una variable 'num_usuarios' de tipo INT y la inicializa en 0
BEGIN -- Inicia el bloque de código ejecutable, donde se colocan las instrucciones que se van a ejecutar
	-- Imprime un mensaej en la consola con el nombre del rol
    RAISE NOTICE 'Nombre Rol: %', nombreRol; 

    SELECT COUNT(*) -- Cuenta el número de usuarios con el rol especificado
    INTO num_usuarios -- Guarda el resultado en la variable 'num_usuarios'
    FROM T_USUARIO u
    JOIN T_USUARIO_ROL ur ON u.identificador = ur.id_usuario -- Une la tabla de usuarios con la tabla intermedia
    JOIN T_ROL r ON ur.id_rol = r.identificador -- Une la tabla intermedia con la tabla de roles
    WHERE r.nombre = nombreRol; -- Filtra por el rol almacenado en la variable 'nombreRol'
	
	-- Muestra un mensaje con la cantidad de usuarios que tienen el rol 'Estudiante
    RAISE NOTICE 'Número de Usuarios con el rol %: %' , nombreRol, num_usuarios;
END $$; -- Finaliza el bloque anónimo y marca el final del código ejecutable