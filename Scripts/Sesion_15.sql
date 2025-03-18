-------------------------------------
------------- Sesión 15 -------------
-------------------------------------

-- En esta Sesión veremos la creación y asignación de roles
-- y tareas a usuarios

-------------------------------------
-- Las siguientes líneas de código
-- fueron ejecutadas en la terminal
-- de SQL Shell
-------------------------------------

-- Muestra todos los usuarios
\du

-- Salir de la terminal SQL
\q

-- Podemos crear un usuario desde la terminal
CREATE USER nombre_del_usuario WITH PASSWORD 'poner_el_password';

-- Muestra las tablas que hay en la base de datos
\dt

-------------------------------------
-- Desde la creación de los usuarios
-- es importante asignar los permisos
-- para que pueda trabajar sin problemas
-------------------------------------

-- Crear un usuario que pueda crear bases de datos
CREATE USER nombre_del_usuario WITH PASSWORD 'password' CREATEDB;

-- Este usuario va a poder crear usuarios y roles
CREATE USER usuario03 WITH PASSWORD 'abcd' CREATEROLE;

-- Este usuario va a poder crear bases de datos y roles
CREATE USER usuario03 WITH PASSWORD 'abcd' CREATEROLE CREATEDB;



-------------------------------------
-- Con lo anterior vimos los atributos de los
-- usuarios, ahora veremos los privilegios de los
-- usuarios. Es decir, que pueden hacer
-- sobre las tablas, pero las tablas viven
-- dentro de las bases de datos.
--
-- Desde el superusuario es necesario entrar a la
-- base de datos y luego darle privilegios.
--
-- Básicamente los privilegios son:
-- 1) Mostrar una tabla 'SELECT'
-- 2) Actualizar una columna de tabla 'UPDATE'
-- 3) Meter datos a una tabla 'INSERT TO' (meter una o varias filas)
-- 4) Borrar información de una tabla 'DELETE'
--
-- Las 4 anteriores son las palabras 'mágicas'.
--
-- Para dar privilegios usamos la siguiente
-- sintaxis:
-- GRANT palabra_magica ON nombre_tabla TO usuario;
-------------------------------------


-- Quiero que usuario1 pueda ver la tabla 'totales'
-- de la base de datos 'cuentas'
GRANT SELECT ON totales TO usuario1;


-- Quiero que usuario1 pueda ver la tabla 'cuentas'
-- de la base de datos 'cuentas'
GRANT SELECT ON cuentas TO usuario1;


-- Supongamos que quiero que el usuario1
-- solomente pueda ver algunas columnas de la tabla
-- cuentas1
GRANT SELECT(id, balance) ON cuentas1 TO usuario1;


-- Para darle permiso a usuario1 de agregar filas
-- a la tabla cuentas
GRANT INSERT ON cuentas TO usuario1;


-- Para darle permiso a usuario1 de agregar filas
-- a la tabla totales
GRANT INSERT ON totales TO usuario1;


-- Para darle permiso a usuario1 de actualizar
-- y eliminar una tabla, hacemos lo siguiente
-- solo hay que tener en cuenta la seguridad
-- porwue si borra la información de la tabla
-- ni siquiera el superusuario la va a poder
-- recuperar
GRANT UPDATE, DELETE ON totales TO usuario1;


-- Podemos quitar permisos de la siguiente manera

-- Este quita el permiso de poder visualizar toda
-- la tabla de totales al usuario1
REVOKE SELECT ON totales FROM usuario1;


-- Podemos quitarle el permiso de agregar filas a la tabla
-- totales al usuario1
REVOKE INSERT ON totales FROM usuario1;


-- Podemos quitarele todos los permisos al usuario1
REVOKE ALL ON totales FROM usuario1;


-- El superusuario puede eliminar usuarios
-- pero primero hay que eliminar todos sus
-- privilegios
DROP USER usuario1;