-------------------------------------
------------- Sesión 09 -------------
-------------------------------------

-- Creamos una tabla
CREATE TABLE sismos(
	Magnitud NUMERIC,
	Latitud DOUBLE PRECISION,
	Longitud DOUBLE PRECISION,
	Profundidad NUMERIC,
	Municipio VARCHAR(100),
	Zona VARCHAR(100),
	Mes INTEGER,
	Placa VARCHAR(20),
	Year_s INTEGER
);

-- Muestra la tabla sin datos que acabamos de crear
SELECT * FROM sismos;

-- Ahora vamos a leer la tabla sismos.csv que tenemos en la carpeta Data

-- Lista de problemas que sucedieron al intentar leer la tabla y las soluciones:
-- Si aparece el problema de 'Permission denied' te vas al archivo, click, dar acceso,
-- dar en permisos a todos, agregar y compartir

-- Para el error 'SQL state: 22021', este es un problema de codificacion, te vas
-- al bloc de notas, le das en guardar archivo, guardar como csv, codificacion UTF8.
COPY sismos(Magnitud, Latitud, Longitud, Profundidad, Municipio, Zona, Mes, Placa, Year_s)
FROM 'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Data/sismos.csv' -- ruta\nombre del archivo
DELIMITER ',' CSV HEADER; -- delimitado por coma y tiene encabezado

-- Muestra la tabla para ver si se muestran los cambios
SELECT * FROM sismos;

-- Muestra la cantidad de renglones
SELECT COUNT(*) FROM sismos;

-- 1. Seleccionar todos los sismos con magnitud >= 7
SELECT * FROM sismos WHERE magnitud >= 7;

-- 1.1. Muestra la cantidad de sismos que cumplen con la magnitud >= 7
SELECT COUNT(*) FROM sismos WHERE magnitud >= 7;

-- 2. Contar la cantidad de sismos registrados en la zona Centro Sur en el año 2021
SELECT COUNT(*) FROM sismos WHERE zona = 'Centro sur' AND Year_s = 2021;

-- 2.1. Contar la cantidad de sismos registrados en la zona Centro Sur en el año 2021
-- pero sin preocuparnos por si hay mayúsculas y minúsculas usamos ILIKE
SELECT COUNT(*) FROM sismos WHERE zona ILIKE 'centro sur' AND Year_s = 2021;

-- Muestra los valores diferentes de la columna 'zona'
SELECT DISTINCT(zona) FROM sismos;

-- Muestra los valores que hay en la columna 'mes'
SELECT DISTINCT(mes) FROM sismos;

-- 3. Obtener la magnitud promedio de los sismos registrados los meses de mayo
SELECT AVG(magnitud) FROM sismos WHERE mes = 5;

-- 4. Mostrar los municipios donde se registraron sismos con profundidad > 200 km
SELECT municipio FROM sismos WHERE profundidad > 200;

-- 4.1. Mostrar los municipios donde se registraron sismos con profundidad > 200 km
-- pero como no quiero que salgan repetidos los municipios usamos
SELECT DISTINCT(municipio) FROM sismos WHERE profundidad > 200;

-- 4.2. Veamos las placas de los municipios anteriores
SELECT DISTINCT(municipio), placa FROM sismos WHERE profundidad > 200;

-- 5. Listar los sismos ocurridos en la placa de Norteamérica  durante el 2020
SELECT * FROM sismos WHERE placa = 'Norteamérica' AND Year_s = 2020;

-- 5.1 Listar los sismos ocurridos en la placa de Norteamérica  durante el 2020
-- Observamos que la placa de Norteamérica tiene acento por lo que debemos tenerlo encuenta
-- para ello podemos aplicar el siguiente, aunque solo aplica porque solo
-- tenemos la placa de Norteamérica
SELECT * FROM sismos WHERE placa ILIKE 'Norteam%' AND year_s = 2020;

-- 6. Listar los sismos ocurridos en el estado de Puebla
-- Observamos que en la columna de 'municipio' se lista
-- los municipos, estado por lo que aplicamos lo siguiente
SELECT * FROM sismos WHERE municipio ILIKE '%, PUE';

-- 6.1. Listar los sismos ocurridos en el estado de Puebla
-- Esta es otra forma
SELECT * FROM sismos WHERE RIGHT(municipio, 3) ILIKE 'PUE';

-- 6.2. Contar los sismos ocurridos en el estado de Puebla
SELECT COUNT(*) FROM sismos WHERE municipio ILIKE '%, PUE';

-- 7. Cuántos sismos ocurrieron en la región Sureste en diciembre de 2017
SELECT COUNT(*) FROM sismos WHERE zona ILIKE 'sureste' AND mes = 12 AND Year_s = 2017;

-- 8. Mostrar los sismos con magnitud entre 5 y 6 durante 2019
SELECT * FROM sismos WHERE magnitud BETWEEN 5 AND 6 AND Year_s = 2019;

-- 8.1 Mostrar los sismos con magnitud entre 5 y 6 durante 2019
-- Otra forma
SELECT * FROM sismos WHERE magnitud >= 5 AND magnitud <= 6 AND Year_s = 2019;

-- 9. Obtener la profundidad máxima registrada en el municipio de Acapulco
-- Primero veremos si existe Acapulco en la columna de 'municipio'
SELECT * FROM sismos WHERE municipio ILIKE 'acapulco, %';

-- Observamos si el filtro anterior es correcto
SELECT DISTINCT(municipio) FROM sismos WHERE municipio ILIKE 'Acapulco%';

-- Ahora obtenemos la profundidad máxima en Acapulco
SELECT MAX(profundidad) FROM sismos WHERE municipio ILIKE 'acapulco, %';

-- 10. Listar los simos ocurridos durante julio de 2020 en orden descendente de magnitud
SELECT * FROM sismos WHERE mes = 7 AND year_s = 2020 ORDER BY magnitud DESC;

-- 11. Calcular la magnitud mínima, promedio y máxima por entidad
-- Para este problema el problema es aislar la entidad
-- podemos aplicar lo siguiente
SELECT RIGHT(municipio, 4) AS entidad,
	MIN(magnitud) AS min_magnitud,
	AVG(magnitud) AS promedio_magnitud,
	MAX(magnitud) AS max_magnitud
FROM sismos GROUP BY entidad ORDER BY promedio_magnitud DESC;


-- Creamos una tabla con las estadísticas de las entidades del problema anterior
-- esto viene siendo una subtabla
-- Es decir, el resultado de la consulta lo podemos guardar como una tabla nueva
CREATE TABLE ESTADISTICAS_ENTIDADES AS
SELECT RIGHT(municipio, 4) AS entidad,
	MIN(magnitud) AS min_magnitud,
	AVG(magnitud) AS promedio_magnitud,
	MAX(magnitud) AS max_magnitud
FROM sismos GROUP BY entidad ORDER BY promedio_magnitud DESC;

-- Muestra la tabla creada
SELECT * FROM ESTADISTICAS_ENTIDADES;

-- Con lo anterior aprendimos a leer una tabla externa
-- usando POSTGRESQL y con ello hacer diferentes consultas
-- con esos datos


-------------------------------------
------------- Sesión 10 -------------
-------------------------------------

-- En esta Sesión vamos a terminar de trabajar con la tabla de sismos

-- Muestra la tabla de sismos
SELECT * FROM sismos;

SELECT MAX(year_s) FROM sismos;

-- 12. Calcula la magnitud mínima, promedio, y máxima por entidad durante los serán últimos 10 años
SELECT RIGHT(municipio, 4) AS entidad,
	MIN(magnitud) AS min_magnitud,
	AVG(magnitud) AS prom_magnitud,
	MAX(magnitud) AS max_magnitud
FROM sismos
WHERE year_s >= 2012
GROUP BY entidad;

-- 13. Guardar la consulta anterior como una tabla nueva
CREATE TABLE ESTADISTICAS_SISMOS_ENTIDADES AS
SELECT RIGHT(municipio, 4) AS entidad,
	MIN(magnitud) AS min_magnitud,
	AVG(magnitud) AS prom_magnitud,
	MAX(magnitud) AS max_magnitud
FROM sismos
WHERE year_s >= 2012
GROUP BY entidad;

-- MUestra los cambios
SELECT * FROM ESTADISTICAS_SISMOS_ENTIDADES ORDER BY prom_magnitud DESC;

-- 14. Exportar la tabla creada en el ejercicio anterior ESTADISTICAS_SISMOS_ENTIDADES CSV
-- como ESTADISTICAS_SISMOS_ENTIDADES existe como tabla dentro de pgAdmin4
-- pero como tal no existe ese archivo dentro de la computadora
-- para usarlo o enviarlo por correo, etc.
SELECT * FROM ESTADISTICAS_SISMOS_ENTIDADES;

-- Muestra el row de Oaxaca donde la magnitud fue de 7.4
SELECT * FROM sismos WHERE magnitud = 7.4 AND municipio ILIKE '%, OAX' AND year_s >= 2010;

-- Muestra el gran sismo que ocurrió en México en septiembre de 2017
SELECT * FROM sismos WHERE magnitud = 8.2 AND year_s = 2017;

-- Muestra el gran sismo que ocurrió en México en septiembre de 2017 -- otra forma
SELECT * FROM sismos WHERE mes = 9 AND year_s = 2017 AND magnitud > 7;

-- 14. Exportar la tabla creada en el ejercicio anterior ESTADISTICAS_SISMOS_ENTIDADES CSV
-- como ESTADISTICAS_SISMOS_ENTIDADES existe como tabla dentro de pgAdmin4
-- pero como tal no existe ese archivo dentro de la computadora
-- para usarlo o enviarlo por correo, etc.

SELECT * FROM ESTADISTICAS_SISMOS_ENTIDADES;

-- Forma 1: Buscas la tabla que quieres guardar, click derecho,
-- seleccionar IMPORT\EXPORT ---> direccion y nombre del archivo, activar HEADER
-- OK y ya queda guardada

-- Forma 2: usando código
COPY estadisticas_sismos_entidades TO 'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Data/minitabla_2.csv' WITH CSV HEADER;
-- Con lo anterior nos muestra un error por PERMISSION DENIED

-- Con lo anterior aprendimos a leer una tabla externa
-- usando POSTGRESQL y con ello hacer diferentes consultas
-- con esos datos y a exportar la tabla nueva en formato CSV
-- usando la interfaz gráfica de pgAdmin


-------------------------------------
------------- Sesión 10 -------------
-------------------------------------

-- En esta Sesión veremos el álgebra relacional en SQL

-- Creamos una tabla nueva
CREATE TABLE personas (
	llave_primaria_persona VARCHAR(20) PRIMARY KEY,
	entidad VARCHAR(2),
	upm VARCHAR(2),
	vivienda VARCHAR(2),
	hogar VARCHAR(2),
	renglon VARCHAR(2)
);

-- LLenamos la nueva tabla con los datos
INSERT INTO personas (llave_primaria_persona, entidad, upm, vivienda, hogar, renglon) VALUES
('02_02_01_02_01', '02', '02', '01', '02', '01'),
('02_01_03_01_01', '02', '01', '03', '01', '01'),
('01_18_02_01_03', '01', '18', '02', '01', '03'),
('32_12_03_05_04', '32', '12', '03', '05', '04'),
('09_15_04_01_02', '09', '15', '04', '01', '02');

-- Muestra la tabla completa
SELECT * FROM personas;

-- Ejemplo 1:
-- La operación 'selecciona de la Tabla Personas aquellos registros 
-- cuya entidad es Baja California'
SELECT * FROM personas WHERE entidad = '02';

-- Lo anterior lo podemos hacer en R y Python de la siguiente manera:
-- En R: Personas[Personas$entidad == "02"],
-- Personas %>% filter(entidad == "02")
-- En Python: Personas >> filter(_.entidad == "02")

-- Ejemplo 2:
-- La operación "selecciona de la Tabla Personas aquellos registros
-- cuya entidad es Baja California o Aguascalientes"
SELECT * FROM personas WHERE entidad = '02' OR entidad = '01';

-- Ejemplo 3:
-- La operación "Hallar las entidades de la Tabla Personas"
SELECT entidad FROM personas;

-- En R: Personas$entidad,
-- Personas %>% select(entidad), personas[, "entidad"]
-- En Python: Personas >> select(_.entidad)

-- Ejemplo 4:
-- La operación "Hallar las entidades y las UPM de la Tabla Personas"
SELECT entidad, upm FROM personas;

-- En R: Personas$entidad,
-- Personas %>% select(entidad, upm), personas[, c("entidad", "upm")]
-- En Python: Personas >> select(_.entidad, _.upm)

-- rho_personas(entidad | estado)
SELECT entidad AS estado FROM personas;

-- En R: Personas %>% rename(entidad = estado)
-- En Python: Personas >> rename(entidad = estado)

-- pi_upm(entidad = Baja California)(personas)
SELECT upm FROM personas WHERE entidad = '02';

-- pi_(entidad, upm)(sigma_(entidad = Baja California)(personas))
SELECT entidad, upm FROM personas WHERE entidad = '02';

-- En R: Personas %>% filter(entidad = '02') %>% select(entidad, upm)
-- En Python: Personas >> filtrar_.entidad, _.upm)

-- Creamos una nueva tabla 
-- Crear la tabla camisas
CREATE TABLE camisas (
    Id_camisa SERIAL PRIMARY KEY,
    camisa VARCHAR(50),
    Precio DECIMAL
);

-- Insertar datos en la tabla camisas
INSERT INTO camisas (camisa, Precio) VALUES
('lino blanco', 210),
('algodon naranja', 290),
('seda negra', 260);

-- Muestra la tabla de camisas
SELECT * FROM camisas;


-----------------
-----------------
-----------------

-- Creamos una nueva tabla 
-- Crear la tabla pantalones
CREATE TABLE pantalones (
    Id_pantalon SERIAL PRIMARY KEY,
    pantalon VARCHAR(50),
    Precio DECIMAL
);

-- Insertar datos en la tabla pantalones
INSERT INTO pantalones (pantalon, Precio) VALUES
('mezclilla azul', 470),
('mezclilla negra', 730);

-- Muestra la tabla de pantalones
SELECT * FROM pantalones;

-- Ahora aplicamos el producto cartesiano en una nueva tabla
CREATE TABLE camisas_pantalones AS
SELECT camisas.camisa, 
       camisas.precio AS Precio_camisa, 
       pantalones.pantalon, 
       pantalones.precio AS Precio_pantalon, 
       camisas.precio + pantalones.precio AS Precio_final
FROM camisas, pantalones;

-- Muestra la tabla camisas_pantalones
SELECT * FROM camisas_pantalones;

-- Usando CONCAT para presentar la tabla de una forma con mejor estilizado
SELECT CONCAT('Camisa de ', camisas_pantalones.camisa,
              ' con pantalón de ', camisas_pantalones.pantalon) 
                  AS combinacion, 
       Precio_final
FROM camisas_pantalones 
ORDER BY Precio_final DESC;


-----------------
-----------------
-----------------

CREATE TABLE frutas_A (
    ID_A SERIAL PRIMARY KEY,
    Fruta VARCHAR(50) NOT NULL
);

INSERT INTO frutas_A(Fruta) VALUES
('Manzana'),
('Naranja'),
('Plátano'),
('Pepino');


CREATE TABLE frutas_B (
    ID_B SERIAL PRIMARY KEY,
    Fruta VARCHAR(50) NOT NULL
);


INSERT INTO frutas_B(Fruta) VALUES
('Naranja'),
('Manzana'),
('Sandía'),
('Pera');

---- inner join es prácticamente donde si hay coincidencia
SELECT * FROM frutas_A;
SELECT * FROM frutas_B;

SELECT * FROM frutas_A INNER JOIN frutas_B ON frutas_A.Fruta = frutas_B.Fruta;
SELECT * FROM frutas_B INNER JOIN frutas_A ON frutas_B.Fruta = frutas_A.Fruta;


---- left join (todos)
SELECT * FROM frutas_A LEFT JOIN frutas_B ON frutas_A.Fruta = frutas_B.Fruta;


---- left join (sin coincidencia)
SELECT * FROM frutas_A LEFT JOIN frutas_B ON frutas_A.Fruta = frutas_B.Fruta WHERE frutas_B.Fruta IS NULL;


----- full join (todos)
SELECT * FROM frutas_A FULL JOIN frutas_B ON frutas_A.Fruta = frutas_B.Fruta;
SELECT * FROM frutas_B FULL JOIN frutas_A ON frutas_B.Fruta = frutas_A.Fruta;


----- full join (sin coincidencia) esta es como la diferencia simétrica de conjuntos
SELECT * FROM frutas_A FULL JOIN frutas_B ON frutas_A.Fruta = frutas_B.fruta
WHERE frutas_A.Fruta IS NULL OR frutas_B.Fruta IS NULL;