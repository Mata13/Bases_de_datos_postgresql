-------------------------------------
------------- Sesión 06 -------------
-------------------------------------

-- Con la función redondeo podemos hacerlo de manera directa a un número con dos decimales
SELECT ROUND(32.3861, 2);


-- Funciones CEILING y FLOOR (función techo y función piso)

-- La función piso o también llamada 'parte entera' trunca los decimales para quedarse con el menor número entero
-- piso(X) es el menor número entero tal que piso(X) <= X < piso(X) + 1
-- piso redondea al entero que está a la izquierda
-- piso = FLOOR

-- La función techo redondea al entero que está a la derecha
-- techo = CEIL

-- Obtenemos la función piso y techo en la misma línea de código
SELECT decimales,
	FLOOR(decimales) AS piso,
	CEILING(decimales) AS techo
	FROM modulo_victimizacion;

-- Obtenemos los valores de la función piso y techo
SELECT FLOOR(5.49374);
SELECT FLOOR(-2024.937474);
SELECT CEILING(5.3648383);


-- Función valor absoluto, lo positivo lo deja igual, lo negativo lo vuelve positivo
SELECT ABS(-34);
SELECT ABS(134);


-- Función RANDOM() genera valores aleatorios entre 0 y 1, no lleva parámetros
-- ~U((0,1)). Si X es una Variable Aleatoria uniforme continua,
-- entonces P(X = a) = 0 para cualquier a
SELECT RANDOM();

-- El problema de seleccionar un número aleatorio entre 1, 2, 3, 4, 5, 6.
-- Para resolverlo usamos el Teorema del notebook de 02_Funciones_predefinidas,
-- donde se utiliza la función piso,
-- de la siguiente manera
SELECT FLOOR(6 * RANDOM() + 2);


-- Función semilla sirve para que podamos replicar los mismo resultados
-- hay que seleccionar ambas línea de código y despues ejecutamos
SELECT SETSEED(0.9825);
SELECT RANDOM();


-- Función POWER potencia
SELECT POWER(5, 2);

-- Muestra la tabla completa
SELECT * FROM modulo_victimizacion;

-- Podemos aplicarlo a columnas numéricas
SELECT tipo_delito, num_delito,
	POWER(tipo_delito, num_delito) AS ejemplo_potencia
	FROM modulo_victimizacion;


-- Módulos o residuos
SELECT MOD(1996, 28);

-- También puedes aplicar los módulos a columnas
SELECT perdida, tipo_delito,
	MOD(perdida, tipo_delito) AS modulo
FROM modulo_victimizacion;

-- También puedes aplicar los módulos a columnas
SELECT perdida, tipo_delito,
	MOD(perdida, tipo_delito) AS modulo,
	perdida / tipo_delito AS division
FROM modulo_victimizacion;

-- Raices cuadradas
SELECT SQRT(25);

-- Obtenemos la raíz cuadrada de una columna
SELECT SQRT(perdida) FROM modulo_victimizacion;


----------------- Funciones de texto

-- Muestra la tabla completa
SELECT * FROM modulo_victimizacion;

-- Función UPPER para convertir todo a mayúsculas
SELECT nombre,
	UPPER(nombre) AS mayusculas
FROM modulo_victimizacion;

-- Función LOWER para convertir todo a minúsculas
SELECT nombre,
	LOWER(nombre) AS minusculas
FROM modulo_victimizacion;

-- Uniendo ambas funciones para mostrar los resultados
SELECT nombre,
	UPPER(nombre) AS mayusculas,
	LOWER(nombre) AS minusculas
FROM modulo_victimizacion;


-- Función CONCAT para unir textos
SELECT nombre, apellido,
	CONCAT(nombre, apellido) AS nombre_completo
FROM modulo_victimizacion;

-- Función CONCAT para unir textos
SELECT nombre, apellido,
	CONCAT(nombre, ' ', apellido) AS nombre_completo_espacio,
	CONCAT(nombre, '_', apellido) AS nombre_completo_guion
FROM modulo_victimizacion;

-- Función CONCAT para unir textos
SELECT nombre, apellido,
	CONCAT(nombre, ' ', perdida) AS nombre_completo_espacio,
	CONCAT(nombre, '_', apellido) AS nombre_completo_guion
FROM modulo_victimizacion;

-- Función CONCAT para unir textos
SELECT CONCAT('La persona ', nombre, ' ', apellido, ' ha tenido una pérdida de $', perdida) AS frase
	FROM modulo_victimizacion;

-- Función length para obtener la longitud o cantidad de caracteres
-- Función CONCAT para unir textos
SELECT CONCAT('La persona ', nombre, ' ', apellido, ' ha tenido una pérdida de $', perdida) AS frase,
	LENGTH(CONCAT('La persona ', nombre, ' ', apellido, ' ha tenido una pérdida de $', perdida)) AS longitud_frase
FROM modulo_victimizacion;

-- Función length para obtener la longitud o cantidad de caracteres
-- Función CONCAT para unir textos combinando con UPPER
SELECT CONCAT('La persona ', nombre, ' ', UPPER(apellido), ' ha tenido una pérdida de $', perdida) AS frase,
	LENGTH(CONCAT('La persona ', nombre, ' ', apellido, ' ha tenido una pérdida de $', perdida)) AS longitud_frase
FROM modulo_victimizacion;


-------------------------------------
------------- Sesión 07 -------------
-------------------------------------


-- Funciones TRIM, LTRIM, RTRIM --> sirven para eliminar espacios, TRIM en inglés es ajustar, recortar

-- TRIM corta los espacios
SELECT TRIM('     hola    ');

-- TRIM corta los espacios
SELECT '             hola   ',
	LENGTH('             hola   '),
	TRIM('             hola   '),
	LENGTH(TRIM('             hola   '));

-- LTRIM quita los espacios a la izquierda
SELECT '             hola   ',
	LENGTH('             hola   '),
	LTRIM('             hola   '),
	LENGTH(LTRIM('             hola   '));

-- RTRIM quita los espacios a la derecha
SELECT '             hola   ',
	LENGTH('             hola   '),
	RTRIM('             hola   '),
	LENGTH(RTRIM('             hola   '));


-- Función SUBSTR nos permite eliminar cadenas de texto
-- toma tres argumentos: 1) un texto; 2) a partir de donde vas a recortar
-- 3) es opcional, cuántos lugares vas a recortar

SELECT SUBSTR('hola a todos', 1, 3);

-- En qué posición inicial te paras y cuántos caracteres se debe traer
SELECT SUBSTR('hola a todos', 4, 3);

SELECT SUBSTR('hola a todos', 8, 4);

-- Creamos una tabla para mostrar la utilidad de SUBTR
CREATE TABLE datos(cod_pais char(3), cod_ent char(2), tipo_delito char(2), nombre varchar(50));

-- Insertamos los datos
INSERT INTO datos VALUES ('MEX', '03', '01', 'Luis'),
	('MEX', '05', '04', 'Ana'),
	('MEX', '09', '02', 'Francisco');

-- Muestra la tabla 'datos'
SELECT * FROM datos;

-- Example: Agregar una columna llamada 'Identificador' que sea concatenar
-- cod_pais, cod_ent, tipo_delito

-- se puede usar text en vez de char si no sabes la longitud de los caracteres
-- STORED es para que no se quede solo en una vista o muestra

ALTER TABLE datos ADD COLUMN Identificador VARCHAR(10);
UPDATE datos SET identificador = CONCAT(cod_pais, cod_ent, tipo_delito);

-- Muestra la tabla con la columna identificador
SELECT * FROM datos;

-- Eliminar todas excepto las columnas nombre e identificador
ALTER TABLE datos DROP COLUMN cod_pais, DROP COLUMN cod_ent, DROP COLUMN tipo_delito;

-- Muestra la tabla
SELECT * FROM datos;

-- Aplicamos el SUBSTR y CONCAT juntos para ver lo que nos permite hacer
-- de esta manera obtenemos las claves de entidad y tipo
SELECT SUBSTR(identificador, 1, 3) AS pais,
	SUBSTR(identificador, 4, 2) AS entidad,
	SUBSTR(identificador, 6, 2) AS tipo
FROM datos;


-- Función POSITION permite hacer búsquedas (in string)
-- busca el texto 1 en el texto 2
SELECT POSITION('a t' IN 'hola a todos');

-- Buscamos 'Mex' en la columna de identificador
SELECT POSITION('MEX' IN identificador) FROM datos;

-- Buscamos 'Mex' en la columna de identificador mostrando la tabla
SELECT *, POSITION('MEX' IN identificador) FROM datos;


-- Cambiar el nombre de una columna
ALTER TABLE datos RENAME COLUMN identificador TO id;

-- Mostramos el resultado
SELECT * FROM datos;


-- Cambiar el orden de las columnas se puede hacer de la siguiente manera
-- no se cambia la estructura de la tabla solo es una vista
-- o una tabla virtual
SELECT id, nombre FROM datos;


-- Función LPAD and RPAD

-- Agrega 26 estrellas a la izquierda del texto para que sean de 30 caracteres
SELECT LPAD('hola', 30, '*');

-- Agrega 26 estrellas a la derecha del texto para que sean de 30 caracteres
SELECT RPAD('hola', 30, '*');

-- Puede cortar el string para que cumpla con la longitud del string
SELECT RPAD('hola', 2, '*');

SELECT RPAD('hola', 30, 'SciData');

-- A la columna de nombre le va agregar _ para que llegue a ser de tamaño 40
SELECT *, RPAD(nombre, 40, '_') AS nombre_40 FROM datos;

-- Muestra toda la tabla
SELECT * FROM datos;

-- Añadimos una nueva columna donde ya no es tan sencillo obtenel el nombre
ALTER TABLE datos ADD COLUMN id_nombre_2 text;
UPDATE datos SET id_nombre_2 = CONCAT(RPAD(nombre, 40, ' '), id);

-- Extraemos los nombres con los 40 espacios
SELECT SUBSTR(id_nombre_2, 1, 40) FROM datos;

-- Con un RTRIM eliminamos los espacios a la derecha del nombre para recuperar el nombre
SELECT id_nombre_2, RTRIM(SUBSTR(id_nombre_2, 1, 40)) as Nombre,
	SUBSTR(id_nombre_2, 41, 3) as Pais,
	SUBSTR(id_nombre_2, 44, 2) as Entidad,
	SUBSTR(id_nombre_2, 46, 2) as tipo
FROM datos;

-- Muestra toda la tabla
SELECT * FROM datos;

-- Añadimos una nueva columna donde ya no es tan sencillo obtenel el nombre
ALTER TABLE datos ADD COLUMN id_nombre_3 text;
UPDATE datos SET id_nombre_3 = CONCAT(RPAD(nombre, 40, ' '), id);

-- Con un RTRIM eliminamos los espacios a la derecha del nombre para recuperar el nombre
-- junto con la clave de entidad, pais, tipo
SELECT id_nombre_3, RTRIM(SUBSTR(id_nombre_3, 1, 40)) as Nombre,
	SUBSTR(id_nombre_3, 41, 3) as Pais,
	SUBSTR(id_nombre_3, 44, 2) as Entidad,
	SUBSTR(id_nombre_3, 46, 2) as tipo
FROM datos;


-- Función REVERSE sirve para invertir un texto
SELECT REVERSE('Hola crayola');


-- Función REPEAT sirve para repetir una cadena de texto las veces indicada
SELECT REPEAT('Hola crayola', 3);


-- Función REPLACE nos permite reemplazar en cadenas
SELECT REPLACE('Hola crayola a todos', 'Hola', 'Hola mundo');

-- Función REPLACE nos permite reemplazar en cadenas
SELECT REPLACE('Hola a todos', 'Hola', 'SciData');

-- Muestra la tabla
SELECT * FROM datos;

-- Función REPLACE nos permite reemplazar en cadenas en columnas
SELECT REPLACE(id, 'MEX', 'mex') FROM datos;


-------------------------------------
------------- Sesión 08 -------------
-------------------------------------

-- La cláusula GROUP BY divide a los registros
-- de una tabla, mediante un select, en grupos
-- La sintaxis es la siguiente:
-- SELECT columna_1, ..., columna_n, función_de_agregado
-- (columna a aplicar) FROM nombre_tabla GROUP BY columna_1, ..., columna_n

-- Creamos una nueva tabla
CREATE TABLE info_paises(continente varchar(10), pais varchar(10), cantidad int);

-- Muestra la tabla sin valores
SELECT * FROM info_paises

-- Insertamos los valores
INSERT INTO info_paises VALUES
	('America', 'Mexico', 575),
	('Europ', 'España', 975),
	('Europ', 'Italia', 549),
	('America', 'Mexico', 933),
	('Oceania', 'Australia', 653),
	('Asia', 'Japon', 791),
	('Asia', 'China', 712),
	('America', 'Canada', 674),
	('Asia', 'China', 574),
	('Africa', 'Madagascar', 854);

-- Muestra la tabla para ver si hay cambios
SELECT * FROM info_paises;

-- Aplicamos la función suma a la columna cantidad y muestra el resultado
-- esto es como tener una tabla dinámica con Excel
SELECT continente, sum(cantidad) AS suma FROM info_paises GROUP BY continente;

-- Podemos hacerlo más complejo
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo
FROM info_paises GROUP BY continente;

-- Podemos hacerlo ahora por continente y país
-- Muestra la información agrupada por grupos
SELECT continente, pais,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo
FROM info_paises GROUP BY continente, pais;

-- Conteo, muestra los países que hay en cada continente
SELECT continente,
	COUNT(*)
FROM info_paises GROUP BY continente;

-- Otra muestra de la información
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo,
	COUNT(*) AS total_paises
FROM info_paises GROUP BY continente;

-- Podemos ordenar la información por suma
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo,
	COUNT(*) AS total_paises
FROM info_paises GROUP BY continente ORDER BY suma;

-- Podemos ordenar la información de mayor a menor usando una columna calculada
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo,
	COUNT(*) AS total_paises
FROM info_paises GROUP BY continente ORDER BY suma DESC;

-- Podemos ordenar la información por total porque hay empates
-- el criterio de desempate es el promedio
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo,
	COUNT(*) AS total_paises
FROM info_paises GROUP BY continente ORDER BY suma DESC, promedio DESC;

-- Muestra los grupos que hay pero sin función de agregación
SELECT continente from info_paises GROUP BY continente;

-- Muestra los países que hay en los grupos pero sin función de agregación
SELECT continente, pais from info_paises GROUP BY continente, pais;

SELECT pais, continente from info_paises GROUP BY pais, continente;

SELECT pais, continente, SUM(cantidad) from info_paises GROUP BY pais, continente;


-- La cláusula HAVING es de uso semejante al WHERE
-- se ocupa únicamente en el caso en que tengamos GROUP BY
-- nos devuelve aquellos resultados que cumplen con
-- ciertas condición lógica

-- Muestra el resultado usando HAVING y una condición lógica
-- promedio > 760
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo,
	COUNT(*) AS total_paises
FROM info_paises
GROUP BY continente
HAVING AVG(cantidad) > 760;


-- Muestra el resultado usando HAVING y una condición lógica
-- promedio > 760
-- ordenado por suma
SELECT continente,
	SUM(cantidad) AS suma,
	AVG(cantidad) AS promedio,
	MAX(cantidad) AS maximo,
	MIN(cantidad) AS minimo,
	COUNT(*) AS total_paises
FROM info_paises
GROUP BY continente
HAVING AVG(cantidad) > 760
ORDER BY suma;

-- Muestra la tabla original
SELECT * FROM info_paises;

-- Muestra el resultado usando WHERE y una condición lógica
SELECT * FROM info_paises WHERE cantidad > 729;


-- Elimina la tabla de modulo_victimizacion, no elimina la información
DROP TABLE modulo_victimizacion;

SELECT * FROM modulo_victimizacion;

-- Creamos la tabla de modulo_victimizacion nuevamente
CREATE TABLE modulo_victimizacion(
	entidad varchar(2),
	viv varchar(5),
	hogar varchar(5),
	upm varchar(5),
	renglon varchar(20),
	tipo_delito int,
	num_delito int,
	nombre varchar(50),
	apellido varchar(50),
	perdida int
);

-- Llenamos la tabla usando INSERT
INSERT INTO modulo_victimizacion
	VALUES
	('01', '15', '03', '15', '10', 3, 1, 'Luis', 'Miranda', 2000),
	('01', '15', '03', '15', '10', 3, 2, 'Luis', 'Miranda', 3000),
	('02', '20', '13', '10', '03', 4, 1, 'Oscar', 'Ruiz', 1000),
	('09', '16', '11', '05', '01', 5, 1, 'Raul', 'Ortiz', 4500),
	('32', '12', '11', '02', '04', 2, 1, 'Luisa', 'Ortiz', 300),
	('32', '12', '11', '02', '04', 3, 1, 'Luisa', 'Ortiz', 500),
	('05', '18', '08', '20', '15', 2, 1, 'Maria', 'Gonzalez', 1500),
	('12', '10', '17', '04', '06', 4, 1, 'Pedro', 'Martinez', 2500),
	('07','21','05','12','09',3, 1, 'Ana', 'López',3500),
	('19','07','14','08','11',5, 1, 'Juan', 'Díaz',4000),
	('03','22','09','11','07',2, 1, 'Elena', 'Sánchez',2000),
	('14','11','12','03','02',3, 1, 'Jorge', 'Pérez',3000),
	('28','09','20','07','05',4, 1, 'Laura', 'Ramírez',5000),
	('08','16','18','09','13',2, 1, 'Diego', 'Hernández',1800),
	('21','13','16','06','01',5, 1, 'Sofía', 'Gómez',4200),
	('11','17','02','15','10',3, 1, 'Carlos', 'Fernández',2700);

-- Muestra la tabla para ver los cambios
SELECT * FROM modulo_victimizacion;

-- Contar el número de víctima por tipo de delito y mostrar solo aquellos
-- con más de una víctima
SELECT tipo_delito, COUNT(*)
FROM modulo_victimizacion
GROUP BY tipo_delito
HAVING COUNT(*) > 1;

-- Calcular el promedio de pérdidas por entidad
-- y mostrar solo aquellas entidades con un promedio de pérdida
-- superior a 2000
SELECT entidad, AVG(perdida) AS promedio_perdida
FROM modulo_victimizacion
GROUP BY entidad
HAVING AVG(perdida) > 2000;

-- Muestra la tabla
SELECT * FROM modulo_victimizacion;

-- Listar las viviendas y hogares donde se hayan registrado
-- exactamente dos delitos
SELECT viv, hogar, nombre, COUNT(*)
FROM modulo_victimizacion
GROUP BY viv, hogar, nombre
HAVING COUNT(*) = 2;

-- Mostrar el número de delitos comeditos por cada apellido y nombre
SELECT nombre, apellido, COUNT(*)
FROM modulo_victimizacion
GROUP BY nombre, apellido;

-- Mostrar el máximo de pérdida por entidad y UPM
-- ordenado de mayor a menor
SELECT entidad, upm, MAX(perdida)
FROM modulo_victimizacion
GROUP BY entidad, upm -- upm es como la colonia o fraccionamiento
ORDER BY max(perdida) DESC;

-- En esta Sesión trabajamos con GROUP BY