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

