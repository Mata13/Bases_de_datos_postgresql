-------------------------------------
------------- TAREA 1 -------------
-------------------------------------

-------------------------------------
-- De la tabla de calificaciones mostrar los nombres de las mujeres 
-- que tienen 15 años de edad y 10 en matemáticas
-------------------------------------

-- Creamos la tabla de calificaciones
CREATE TABLE calificaciones(nombre varchar(20), 
	sexo varchar(10), edad int, matematicas int, spanish int, biologia int);

-- Agregamos una fila de datos a la tabla
INSERT INTO calificaciones 
	VALUES('Luis', 'hombre', 15, 10, 8, 9), 
	('Maria', 'mujer', 16, 7, 9, 10), 
	('Jose', 'hombre', 15, 7, 6, 9),
	('Ana', 'mujer', 15, 10, 8, 10),
	('Gloria', 'mujer', 16, 9, 7, 8),
	('Dulce', 'mujer', 14, 10, 5, 7),
	('Abigail', 'mujer', 15, 8, 9, 5),
	('Jimena', 'mujer', 16, 8, 9, 5),
	('Raul', 'hombre', 16, 10, 10, 10),
	('Hector', 'hombre', 15, 10, 8, 10),
	('Patricia', 'mujer', 15, 10, 9, 10);
	
-- Se muestra la tabla
SELECT * FROM calificaciones;

-- Mostramos los nombres de las mujeres que tienen
-- 15 años de edad y 10 en matemáticas
SELECT nombre FROM calificaciones
	WHERE sexo IN('mujer')
	AND edad = 15
	AND matematicas = 10;


-------------------------------------
-- De la tabla de modulo_victimizacion de la sesión 03,
-- muestra la subtabla formada por los tres registros
-- con menor pérdida económica
-------------------------------------

-- Muestra la tabla modulo_victimizacion
select * from modulo_victimizacion;

-- Mostramos los 3 registros con menor pérdida económica
SELECT * FROM modulo_victimizacion
	ORDER BY perdida asc limit 3;