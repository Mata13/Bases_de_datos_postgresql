---------------------------------------------
------------- TAREA - Sesión 12 -------------
---------------------------------------------

-- Normalizar la tabla de sismos

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;

-- Eliminamos registros nulos 
DELETE FROM sismos
WHERE (zona IS NULL OR zona = '')
  AND (placa IS NULL OR placa = '')
  AND (municipio IS NULL OR municipio = '');


-- Ahora buscamos renglones duplicados en la tabla de sismos
SELECT magnitud, latitud, longitud, profundidad, zona, mes, placa, year_s, municipio, entidad, 
       COUNT(*) AS total_duplicados
FROM sismos
GROUP BY magnitud, latitud, longitud, profundidad, zona, mes, placa, year_s, municipio, entidad
HAVING COUNT(*) > 1;


-- Eliminamos los registros duplicados
WITH duplicados AS (
    SELECT CTID, 
           ROW_NUMBER() OVER (
               PARTITION BY magnitud, latitud, longitud, profundidad, zona, mes, placa, year_s, municipio, entidad
               ORDER BY CTID
           ) AS row_num
    FROM sismos
)
DELETE FROM sismos
WHERE CTID IN (SELECT CTID FROM duplicados WHERE row_num > 1);

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;


-- Se busca tener datos de tipo atómico, por lo que de la columna "municipio" 
-- obtenemos dos columnas "municipio" y "entidad"
ALTER TABLE sismos 
	ADD COLUMN nombre_municipio VARCHAR(100),
	ADD COLUMN entidad VARCHAR(10);

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;

-- Llenamos las columnas con los datos
UPDATE sismos 
	SET nombre_municipio = split_part(municipio, ', ', 1),
    	entidad = split_part(municipio, ', ', 2);

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;

-- Eliminamos la columna "municipio"
ALTER TABLE sismos DROP COLUMN municipio;

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;

-- Renombramos la columna nombre_municipio a solo "municipio"
ALTER TABLE sismos
	RENAME COLUMN nombre_municipio TO municipio;

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;

-- Buscamos registros donde entidad es 'N'
SELECT * FROM sismos WHERE entidad = 'N';

-- Eliminar registros donde entidad es 'N'
DELETE FROM sismos WHERE entidad = 'N';


-- Podemos asignarle un número único a "municipio" 
-- para identificar mejor y crear una PRIMARY KEY

-- Creamos la columa 'id_municipio' en la tabla de sismos
ALTER TABLE sismos ADD COLUMN id_municipio INT;

-- Creamos una tabla de los municipios con sus claves únicas
-- esto va a servir para agregar los datos a la tabla de sismos
CREATE TABLE clave_municipios (
	id_municipio SERIAL PRIMARY KEY,
	municipio VARCHAR(100) UNIQUE
);

-- Visualizamos la tabla de clave_municipios
SELECT * FROM clave_municipios;

-- Llenamos la tabla clave_municipios con su clave
INSERT INTO clave_municipios (municipio)
	SELECT DISTINCT municipio FROM sismos;

-- LLenamos la columna "id_municipio" de la tabla sismos
-- con la clave que hay en la tabla clave_municipios
UPDATE sismos 
	SET id_municipio = (SELECT id_municipio FROM clave_municipios 
	WHERE clave_municipios.municipio = sismos.municipio);

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;


-- Podemos asignarle un número único a "entidad" 
-- para identificar mejor y crear una PRIMARY KEY
-- repetimos el proceso de "municipios" aplicado a "entidad"

-- Creamos la columa 'id_entidad' en la tabla de sismos
ALTER TABLE sismos ADD COLUMN id_entidad INT;

-- Visualizamos la tabla de sismos
SELECT * FROM sismos;

-- Creamos una nueva tabla con la entidad y su ID
CREATE TABLE clave_entidad (
	id_entidad SERIAL PRIMARY KEY,
	nombre_entidad VARCHAR(10) UNIQUE
);

-- Visualizamos la tabla clave_entidad
SELECT * FROM clave_entidad;

-- Llenamos la tabla clave_entidad con su clave
INSERT INTO clave_entidad (nombre_entidad)
	SELECT DISTINCT entidad FROM sismos;

-- LLenamos la columna "id_entidad" de la tabla sismos
-- con la clave que hay en la tabla clave_entidad
UPDATE sismos 
	SET id_entidad = (SELECT id_entidad FROM clave_entidad 
	WHERE clave_entidad.nombre_entidad = sismos.entidad);


-- Muestra los valores diferentes de la columna 'zona'
SELECT DISTINCT(zona) FROM sismos;

-- Con lo anterior nos damos cuenta que a la zona
-- le podemos asignar un id para identificarlo mejor
-- y podamos crear una clave primaria en la base de datos de sismos,
-- por lo que repetimos el proceso de "municipios" aplicado a "entidad"

-- Creamos la columa 'id_zona' en la tabla de sismos
ALTER TABLE sismos ADD COLUMN id_zona INT;

-- Muestra la tabla sismos para ver la columna creada
SELECT * FROM sismos;

-- Creamos una nueva tabla con la entidad y su ID llamada 'clave_zona'
CREATE TABLE clave_zona (
	id_zona SERIAL PRIMARY KEY,
	zona VARCHAR(100) UNIQUE
);

-- Muestra la tabla 'clave_zona'
SELECT * FROM clave_zona;

-- Llenamos la tabla clave_zona con su clave
INSERT INTO clave_zona (zona)
	SELECT DISTINCT zona FROM sismos;

-- Llenamos la columna 'id_zona' de la tabla sismos
-- con la clave que hay en la tabla clave_zona
UPDATE sismos
	SET id_zona = (SELECT id_zona FROM clave_zona
	WHERE clave_zona.zona = sismos.zona)


-- Muestra los valores diferentes de la columna 'placa'
SELECT DISTINCT(placa) FROM sismos;

-- Con lo anterior nos damos cuenta que a la placa
-- le podemos asignar un id para identificarlo
-- y con ello crear una clave primaria en la base de datos
-- de sismos, por lo que repetimos el proceso de la 'zona'
-- aplicado a la placa

-- Creamos la columna 'id_placa' en la tabla de sismos
ALTER TABLE sismos ADD COLUMN id_placa INT;

-- Muestra la tabla sismos para ver la columna creada
SELECT * FROM sismos;

-- Creamos uan nueva tabla con la placa y su id llamada 'clave_placa'
CREATE TABLE clave_placa (
	id_placa SERIAL PRIMARY KEY,
	placa VARCHAR(20)
);

-- Muestra la tabla 'clave_placa'
SELECT * FROM clave_placa;

-- Llenamos la tabla clave_placa con su clave
INSERT INTO clave_placa (placa)
	SELECT DISTINCT placa FROM sismos;

-- Llenamos la columna 'id_placa' en la tabla de sismos
-- con la clave que hay en la tabla clave_placa
UPDATE sismos
	SET id_placa = (SELECT id_placa FROM clave_placa
	WHERE clave_placa.placa = sismos.placa)

-- Eliminamos los duplicados manteniendo solo uno
WITH duplicados AS (
    SELECT CTID, 
           ROW_NUMBER() OVER (
               PARTITION BY magnitud, profundidad, id_placa, id_zona, id_municipio, id_entidad, mes, year_s
               ORDER BY CTID
           ) AS row_num
    FROM sismos
)
DELETE FROM sismos
WHERE CTID IN (SELECT CTID FROM duplicados WHERE row_num > 1);


-- Muestra la tabla sismos para ver los cambios
SELECT * FROM sismos;


-- Ahora creamos una clave primaria para tener la base de datos
-- en la Primera Forma Normal (1FN)
ALTER TABLE sismos 
ADD PRIMARY KEY (magnitud, profundidad, id_placa, id_zona, id_municipio, id_entidad, mes, year_s);

-- Eliminamos columnas que no dependan de la clave primaria
ALTER TABLE sismos DROP COLUMN latitud, 
	DROP COLUMN longitud, 
	DROP COLUMN zona, 
	DROP COLUMN placa, 
	DROP COLUMN municipio, 
	DROP COLUMN entidad;

-- Muestra la tabla sismos para ver los cambios en la tabla sismos normalizada
SELECT * FROM sismos;

-- Muestra información sobre las claves primarias definidas en la tabla sismos
SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'sismos' AND constraint_name LIKE '%pkey%';

-- ALTER TABLE clave_entidad DROP COLUMN nombre_entidad;
-- Para eliminar una columna usamos:
-- ALTER TABLE sismos DROP COLUMN id_sismo;