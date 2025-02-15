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
	GENERATED ALWAYS AS(nombre || ' ' || apellido) STORED;

-- Muestra la tabla para ver si se muestran los cambios
SELECT * FROM modulo_victimizacion;


-- Añadir una columna a la tabla 'modulo_victimizacion'
-- que se llame 'dif_prom' que muestre la diferencia
-- entre la pérdida de la persona
-- y la pérdida promedio

-- Primero voy a mostrar los que se quiere antes de agregar la columna a la tabla
-- Muestra el promedio de la pérdida
SELECT AVG(perdida) AS perdida_prom 
	FROM modulo_victimizacion;

-- Muestra la columna 'dif_prom'
SELECT perdida,
	perdida - (SELECT AVG(perdida) FROM modulo_victimizacion) AS dif_prom
FROM modulo_victimizacion;

-- Agregamos la columna 'dif_prom' sin datos
-- a la tabla original
ALTER TABLE modulo_victimizacion ADD COLUMN dif_prom DOUBLE PRECISION;

-- Muestra la tabla para ver los cambios
SELECT * FROM modulo_victimizacion;

-- Ahora, agregamos los datos a la columna
-- Agregar la columna 'dif_prom' sin usar GENERATED sin valores
ALTER TABLE modulo_victimizacion ADD COLUMN dif_prom DOUBLE PRECISION;

-- Calcular y actualizar los valores de 'dif_prom'
-- Muestra los valores de la 'perdida' - perdida promedio
UPDATE modulo_victimizacion
	SET dif_prom = perdida - (SELECT AVG(perdida) 
FROM modulo_victimizacion);

-- Muestra la tabla para ver los cambios realizados
SELECT * FROM modulo_victimizacion;

-- Creamos una nueva columna calculada llamada
-- 'texto' que muestre la frase 
-- "La persona que vive en (entidad) cuyo nombre es (NOMBRE) (APELLIDO) 
-- tuvo una pérdida de $$$$, 
-- que es (dif_prom) respecto de la pérdida promedio"

-- Creamos la nueva columna 'texto' sin valores
ALTER TABLE modulo_victimizacion
	ADD COLUMN texto text;

--Muestro lo que quiero lograr
SELECT CONCAT('La persona que vive en ', entidad, 
	', cuyo nombre es ', nombre_completo, 
	', tuvo una pérdida de $', perdida, ', que es $', dif_prom,
	' respecto de la pérdida promedio.') AS texto FROM modulo_victimizacion;

-- Ahora, busco colocar lo anterior en la columna 'texto'
UPDATE modulo_victimizacion
	SET texto = CONCAT('La persona que vive en ', entidad, 
	', cuyo nombre es ', nombre_completo, 
	', tuvo una pérdida de $', perdida, ', que es $', dif_prom,
	' respecto de la pérdida promedio.');

-- Muestra la tabla para ver los cambios
SELECT * FROM modulo_victimizacion;