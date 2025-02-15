-------------------------------------
------------- Sesión 05 -------------
-------------------------------------

-- Añadir una columna a una tabla existente

-- Muestra la tabla existente
SELECT * FROM modulo_victimizacion;

-- Agregamos la columna 'edad' a la tabla, se agrega con datos nulos
ALTER TABLE modulo_victimizacion ADD edad int;

-- Muestra la tabla
SELECT * FROM modulo_victimizacion;

-- Podemos eliminar una columna (edad) con todos los datos de la tabla usando lo siguiente
ALTER TABLE modulo_victimizacion DROP COLUMN edad;

-- Muestra la tabla para verificar que eliminamos la columna
SELECT * FROM modulo_victimizacion;

-- Usando AFTER podemos decirle en donde añadir la tabla
-- ALTER TABLE nombre_de_la_tabla ADD nueva_columna tipo_de_dato AFTER columna_existente; no funciona!

-- Muestra la tabla completa
SELECT * FROM modulo_victimizacion;

-- Puedes eliminar a 'L'
DELETE FROM modulo_victimizacion WHERE nombre LIKE 'L';

-- Muestra la tabla completa
SELECT * FROM modulo_victimizacion;

-- Añadir una columna calculada, que se construye a partir de las columnas que conoces
-- Para agregar una columna calculada son necesarios los paréntesis y la cláusula STORED
-- Con el STORED si estás modificando la tabla original
ALTER TABLE modulo_victimizacion ADD COLUMN ejemplo int GENERATED ALWAYS AS (tipo_delito + num_delito) STORED;

-- Muestra la tabla 
SELECT * FROM modulo_victimizacion;

-- Añadir una columna calculada, que se construye a partir de las columnas que conoces
ALTER TABLE modulo_victimizacion ADD COLUMN ejemplo_2 int GENERATED ALWAYS AS (tipo_delito * num_delito) STORED;

-- Muestra la tabla 
SELECT * FROM modulo_victimizacion;

-- Añadir una columna calculada, que se construye a partir de las columnas que conoces
ALTER TABLE modulo_victimizacion ADD COLUMN ejemplo_3 int GENERATED ALWAYS AS (tipo_delito - num_delito) STORED;

-- Muestra la tabla
SELECT * FROM modulo_victimizacion;

-- Si queremos eliminar la columna 3
ALTER TABLE modulo_victimizacion DROP ejemplo_3;

-- Muestra la tabla para verificar si eliminamos la columna ejemplo_3
SELECT * FROM modulo_victimizacion;

-- Eliminamos lo que hemos creado hasta ahora
DROP TABLE modulo_victimizacion;

-- Volvemos a crear la tabla modulo_victimizacion desde cero
CREATE TABLE modulo_victimizacion(entidad varchar(2), 
	viv varchar(5), 
	hogar varchar(5), 
	upm varchar(5), 
	renglon varchar(20), 
	tipo_delito int,
	num_delito int,
	nombre varchar(50),
	apellido varchar(50),
	perdida int);

-- Llenado de datos, si tienen el mismo orden que el CREATE TABLE ya no lo escribimos para ahorrarnos espacio
INSERT INTO modulo_victimizacion 
	VALUES ('01', '15', '03', '15', '10', 3, 1, 'Luis', 'Miranda', 2000),
	('01', '15', '03', '15', '10', 3, 2, 'Luis', 'Miranda', 3000),
	('02', '20', '13', '10', '03', 4, 1, 'Oscar', 'Ruiz', 1000),
	('09', '16', '11', '05', '01', 5, 1, 'Raul', 'Ortiz', 4500),
	('32', '12', '11', '02', '04', 2, 1, 'Luisa', 'Ortiz', 300),
	('32', '12', '11', '02', '04', 3, 1, 'Luisa', 'Ortiz', 500);

-- Muestra la tabla 
SELECT * FROM modulo_victimizacion;


----- FUNCIONES PREDEFINIDAS

-- Promedio de una columna
SELECT AVG(perdida)FROM modulo_victimizacion;

-- Calculamos la suma total de la columna
SELECT SUM(perdida) FROM modulo_victimizacion;

-- Podemos pedir las dos cosas al mismo tiempo -> suma y promedio
SELECT AVG(perdida), SUM (perdida) FROM modulo_victimizacion;

-- Obtenemos el min y max de la columna
SELECT MIN(perdida), MAX(perdida) FROM modulo_victimizacion;

-- Hacemos los 4 juntos
SELECT MIN(perdida), MAX(perdida), SUM(perdida), AVG(perdida) FROM modulo_victimizacion;


-- Conteo
-- Obtenemos la cantidad de filas que tiene esta tabla
SELECT COUNT(*) FROM modulo_victimizacion;

-- Obtenemos los registros con el nombre de Luis%, es decir, Luis y Luisa
SELECT * FROM modulo_victimizacion WHERE nombre LIKE 'Luis%';

-- Obtenemos el número de personas que llevan la palabra 'Luis%'
SELECT COUNT(*) FROM modulo_victimizacion WHERE nombre LIKE 'Luis%';


-- Revisamos lo alias
-- Usando lo siguiente veremos lo de los alias, hace un cálculo y le pone un nombre
-- Solo muestra información, no ocupa lugar en la compu
-- solamente es una vista
SELECT MIN(perdida) AS minima_perdida, 
	MAX(perdida) AS maxima_perdida, 
	SUM(perdida) AS perdida_total, 
	AVG(perdida) AS perdida_promedio
FROM modulo_victimizacion;


----- FUNCIONES NUMÉRICAS
-- Se aplican a datos de tipo numérico

-- Muestra la tabla completa
SELECT * FROM modulo_victimizacion;

-- Calculamos el promedio de la perdida
SELECT AVG(perdida) FROM modulo_victimizacion;

-- Aplicamos el redondeo al promedio con dos decimales
SELECT ROUND(AVG(perdida), 2) as promedio_redondeado FROM modulo_victimizacion;

-- Agregamos una nueva columna para aplicar alguna de las funciones numéricas
ALTER TABLE modulo_victimizacion ADD COLUMN decimales DECIMAL(10, 2) GENERATED ALWAYS AS (perdida / 13.0) STORED;

-- Muestra la tabla para ver el resultado
SELECT * FROM modulo_victimizacion;

-- Muestra solo la columna de decimales
SELECT decimales FROM modulo_victimizacion;

-- Redondea la columna decimales a un dígito
SELECT ROUND(decimales, 1) FROM modulo_victimizacion;

-- Redondea la columna decimales
SELECT ROUND(decimales, 1) FROM modulo_victimizacion;

-- Muestra toda la tabla pero además muestra la columna de decimales redondeada a un dígito 
-- con el nombre 'col_redondeada' 
SELECT *, ROUND(decimales, 1) AS col_redondeada FROM modulo_victimizacion;

-- Puedes especificar el orden de las columnas usando SELECT


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