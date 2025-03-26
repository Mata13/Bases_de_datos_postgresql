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
-- la columna fecha_def. Si murió se coloca una fecha,
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


-- Cuáles fueron las 3 entidades que más contagios aportaron en dicha fecha?

-- Creamos una tabla auxiliar con los registros que tienen la fecha
-- donde hubo la mayor cantidad de contagios,
-- que fue el 01/08/2021 y fueron 114.
CREATE TABLE covid_conf_ent_fecha_max AS
	SELECT * FROM covid_conf_ent WHERE fecha_sintomas = '01/08/2021';

-- Muestra la nueva tabla
SELECT * FROM covid_conf_ent_fecha_max;

-- Filtramos los estados con mayor cantidad de contagios
SELECT entidad_federativa, COUNT(*) AS total
FROM covid_conf_ent_fecha_max
GROUP BY entidad_federativa
ORDER BY total DESC
LIMIT 3;


-- Qué porcentaje representó cada una de esas entidades respecto
-- del total de contagios de dicha fecha?
SELECT (15 * 100)/114.0 AS porcentaje_DF, 
	(11 * 100)/114.0 AS porcentaje_EDOMEX,
	(10 * 100)/114.0 AS porcentaje_NL;


-- En qué fecha se dió la mayor cantidad de muertes?
SELECT * FROM covid_conf_ent WHERE fecha_def != '9999-99-99';

SELECT fecha_def, COUNT(*) AS total
FROM covid_conf_ent
WHERE fecha_def != '9999-99-99'
GROUP BY fecha_def
ORDER BY total DESC;




-------------------------------------
------ Condición de intubación ------
-------------------------------------

-- De esta tabla solo nos interesa los
-- valores de 1 = SI, 2 = NO.
-- Se muestran los valores y definiciones
-- en el Catalogo_SI_NO.

-- Calcular de cuántos se conoce la condición
-- si fueron o no entubados.
CREATE TABLE covid_conf_int AS SELECT * FROM covid_confirmado WHERE intubado IN (1, 2);

-- Muestra las filas de la tabla que cumplen la condición de intubación
SELECT COUNT(*) FROM covid_conf_int;


-- Calcular total de intubados y el porcentaje
-- respecto de condición de intubación.
SELECT * FROM covid_conf_int WHERE intubado = 1; -- 305 intubados

-- Porcentaje que cumple la condición
SELECT 305 * 100/2483.0; -- 12.28%


-- Calcular total de muertes con condición de intubación conocida
SELECT COUNT(*) FROM covid_conf_int 
	WHERE fecha_def != '9999-99-99'; -- 1141


-- Calcular qué porcentaje de las muertes requirió intubación
SELECT COUNT(*) FROM covid_conf_int 
	WHERE fecha_def != '9999-99-99' 
	AND intubado = 1; -- 254

SELECT (254 * 100)/1141.0 AS porcentaje_de_muertes; -- 22.26%


-- P(Morir e intubarse / morir) = P(intubarse | falleció)
-- Por Teorema de Bayes: P(A|B) = P(B|A) P(A) / P(B)
-- Entonces 
-- P(morir e intubarse |morir) = P(intubarse|muerte) * P(morir) / P(intubarse)
-- = (0.226 * 0.07)/0.12
-- Por lo que pa probabilidad de fallecer dado que te intubaron
SELECT (0.226 * 0.07)/0.12; -- 0.0131
-- Por lo tantro, 13 de cada 100 que requirieron intubarse fallecieron.




------------------------------------------
-- Distribución porcentual de contagios --
------------------------------------------

-- Mostrar, del total de contagios, 
-- la tabla de Pareto respecto de las entidades
CREATE TABLE contagio_por_entidad AS
	SELECT entidad_federativa, COUNT(*) AS total
	FROM covid_conf_ent
	GROUP BY entidad_federativa
	ORDER BY total DESC;

-- Muestra la nueva tabla creada
SELECT * FROM contagio_por_entidad;

-- Muestra el total de contagios
SELECT SUM(total) FROM contagio_por_entidad; -- 16463

-- La tabla de pareto es cuando tienes los datos,
-- los ordenas del mayor al menor
-- y después te preguntas qué porcentaje
-- van representando los acumulados.
-- Al sumar todos debes obtener el 100%.

SELECT 100/16463.0;

SELECT entidad_federativa, total,
	0.0060*SUM(total) OVER(ORDER BY total DESC)
	AS cumsum_total
FROM contagio_por_entidad;

-- Lo que nos dice la tabla acumulada es que
-- de las 32 entidades, las 5 con más contagios
-- cubren la mitad de los contagios del país.
-- Es decir, las primeras 5 entidades son las 
-- causas de la mitad de los contagios del país.
-- En el país hay 130 millones de personas,
-- con que se hubieran atendido esas primeras 5
-- entidades te hubieras librado la mitad de los
-- contagios a nivel nacional.