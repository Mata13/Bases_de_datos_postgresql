-------------------------------------
------------- Sesión 17 -------------
-------------------------------------

-- En esta sesión haremos una práctica final

-- Creamos dos tablas
CREATE TABLE covid_muestra(SEXO INT, ENTIDAD_RES INT, 
	FECHA_SINTOMAS TEXT, FECHA_DEF TEXT, INTUBADO INT,
	EDAD INT, CLASIFICACION_FINAL INT);

CREATE TABLE catalogo_entidades(CLAVE_ENTIDAD INT, 
	ENTIDAD_FEDERATIVA TEXT, ENTIDAD_ABREVIATURA TEXT);

-- Leemos desde la carpeta Covid
COPY covid_muestra(SEXO, ENTIDAD_RES, FECHA_SINTOMAS, 
	FECHA_DEF, INTUBADO, EDAD, CLASIFICACION_FINAL) FROM
	'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Covid/covid_muestra.csv'
	DELIMITER ',' CSV HEADER;

COPY catalogo_entidades FROM 'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Covid/catalogo_entidades.csv'
	DELIMITER ',' CSV HEADER;

-- Muestra la tabla covid_muestras
SELECT * FROM covid_muestra;

-- Muestra los primeros 30 renglones de la tabla covid_muestra
SELECT * FROM covid_muestra LIMIT 30;

-- Muestra la tabla catalogo_entidades
SELECT * FROM catalogo_entidades;




-------------------------------------
--------- Limpieza de datos ---------
-------------------------------------

-- Observación:
-- Los archivos de Excel de 'Catalogos' y 
-- 'Descriptores' sirven para indentificar
-- los datos de las columnas y su significado.


-- Quedarse únicamente con quienes estén
-- confirmados con covid.

-- De a cuerdo con lo revisado en el 'catálogo CLASIFICACION_FINAL'
-- tenemos que los valores: 1, 2, 3 son casos
-- positivos de covid. 

-- Creamos una tabla para guardar los casos confirmados
CREATE TABLE covid_confirmado AS 
	SELECT * FROM covid_muestra WHERE clasificacion_final IN (1, 2, 3);

-- Muestra la nueva tabla covid_confirmado
SELECT * FROM covid_confirmado;


-- Quedarse únicamente con quienes se conoce
-- la entidad de residencia.

-- De acuerdo con el archivo de Excel 'Descriptores'
-- tenemos que los valores de la entidad de residencia
-- del paciente se encuentra en el catálogo entidades.
-- Por lo que nos debemos quedar con los valores de las
-- entidades conocidas, que van de 01 al 32. Debemos
-- eliminar los números 36, 97, 98, 99 de la tabla,
-- ya que esos no nos dicen nada sobre el estado de residencia.

-- Antes de hacerlo, primero eliminamos la tabla covid_confirmado
DROP TABLE covid_confirmado;

-- Ahora creamos de nuevo la tabla para agregar los datos
-- deseados anteriores
CREATE TABLE covid_confirmado AS 
	SELECT * FROM covid_muestra WHERE clasificacion_final IN (1, 2, 3)
	AND entidad_res BETWEEN 1 AND 32;

-- Muestra la nueva tabla covid_confirmado
SELECT * FROM covid_confirmado;




-------------------------------------
------- Enfermedad y decesos --------
-------------------------------------

-- Contar el total de contagios.
SELECT COUNT(*) FROM covid_confirmado;

-- Lo anterior nos arroja que hay 16463 contagiados.


-- Contar el total de defunciones.

-- Como no tenemos como tal una columna
-- que nos diga si el paciente murió pero tenemos
-- la clumna fecha_def. Si murió se coloca una fecha,
-- si no murió se pone 9999-99-99.
-- De esa manera podemos obtener el número
-- de fallecidos.
SELECT COUNT(*) AS total_defunciones 
	FROM covid_confirmado WHERE fecha_def != '9999-99-99';

-- Lo anterior arroja un total de defunciones = 1241.


-- Calcular el porcentaje de defunciones respecto de contagios.
SELECT (1241 * 100) / 16463.0;

-- Esto nos devuelve 7.53811%. Es decir, 
-- que el 7.53% de los enfermos fallecieron.


-- Mostrar las 10 entidades con más contagios junto
-- con el total de contagios.

-- Para resolverlo, primero obtenemos la cantidad de contagiados
-- que hay por entidad.
SELECT COUNT(*) FROM covid_confirmado GROUP BY entidad_res;

-- En catalogo_entidades tenemos el nombre de las entidades
SELECT * FROM catalogo_entidades;

-- Queremos llevar la información de la columna entidad_federativa
-- a la tabla de casos de covid.
-- Por lo que usaremos los left join y crearemos una tabla.
CREATE TABLE covid_conf_ent AS 
	SELECT * FROM covid_confirmado
	LEFT JOIN catalogo_entidades ON covid_confirmado.entidad_res = catalogo_entidades.clave_entidad;

-- Muestra la nueva tabla covid_conf_ent
SELECT * FROM covid_conf_ent;

-- Muestra la tabla con los datos agrupados por entidad
SELECT entidad_federativa, COUNT(*) AS total FROM covid_conf_ent 
	GROUP BY entidad_federativa ORDER BY total DESC;


-- Mostrar las 32 entidades con contagios segregados por sexo.
SELECT entidad_federativa, sexo, COUNT(*) FROM covid_conf_ent 
	GROUP BY entidad_federativa, sexo
	ORDER BY entidad_federativa ASC, sexo ASC;


-- Encontrar la fecha con más contagios registrados.
SELECT fecha_sintomas AS fecha, COUNT(*) AS total FROM covid_conf_ent 
	GROUP BY fecha_sintomas
	ORDER BY total DESC;

-- Con lo anterior vemos que la fecha fue el 01/08/2021 y fueron 114.
-- Min sesion 17 - 57:00