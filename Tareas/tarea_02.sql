-------------------------------------
------------- Tarea 2 -------------
-------------------------------------

-- Añadir una columna a la tabla 'modulo_victimizacion'
-- que se llame 'nombre_completo'

-- Muestra la tabla 'modulo victimizacion'
SELECT * FROM modulo_victimizacion;

-- Usamos la función CONCAT para unir textos
-- esto es solo una vista de lo que queremos lograr
-- falta agregar esa columna a la tabla original
SELECT nombre, apellido,
	CONCAT(nombre, ' ', apellido)
	AS nombre_completo
FROM modulo_victimizacion;

-- Agregamos la columna 'nombre_completo'
-- a la tabla original
ALTER TABLE modulo_victimizacion 
	ADD COLUMN nombre_completo varchar(50)
	GENERATED ALWAYS AS (nombre || ' ' || apellido) STORED;

-- Muestra la tabla para ver si se muestran los cambios
SELECT * FROM modulo_victimizacion;