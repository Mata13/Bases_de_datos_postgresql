-------------------------------------
------------- Sesión 13 -------------
-------------------------------------

-- FUNCIONES EN SQL

-- En esta sesión veremos funciones

-- Vamos a crear una función a la cual le proporcionas dos números: precio y descuento.
-- Lo que va a devolver es el precio final con el descuento proporcionado.

-- Por ejemplo, si un precio es de 420 y hay un 10% de descuento, entonces debe devolver
-- como resultado 378

-- Crea la función
CREATE OR REPLACE FUNCTION calculate_discount(price numeric, discount_percent numeric)
RETURNS numeric AS $$
DECLARE
	discounted_price numeric; -- variable auxiliar que se llama precio_descontado
BEGIN -- cuerpo de la función
	discounted_price := price - (price * discount_percent / 100);
	RETURN discounted_price; -- el RETURN siempre es necesario, debe devolver algo
END;
$$ LANGUAGE 'plpgsql';

-- Ejecutamos la función:

-- Si el precio es 420 y hay 10% de descuento, el final debe ser 378
SELECT * FROM calculate_discount(420, 10);

-- Si el precio es 5000 y hay 15% de descuento
SELECT * FROM calculate_discount(5000, 15);


-- Creamos una función a la cual le proporcionas dos números enteros X and Y,
-- y devuelva X + Y
CREATE OR REPLACE FUNCTION sumar(X INT, Y INT)
RETURNS INT AS
$$
DECLARE
	Z INT; -- variable auxiliar
BEGIN
	Z = X + Y;
	RETURN Z;
END
$$
LANGUAGE 'plpgsql';

-- Ejecutamos la función:
SELECT * FROM sumar(5, 102);
SELECT * FROM sumar(3, 5);

-- Modificación de la función sumar

-- Dado que el DECLARE es opcional,
-- a veces es mejor quitar el DECLARE y luego es mejor dejarlo.
-- Modificamos la función reducir las línea de código
CREATE OR REPLACE FUNCTION sumar_modificado(X INT, Y INT)
RETURNS INT AS
$$
BEGIN
	RETURN X + Y;
END
$$
LANGUAGE 'plpgsql';

-- Ejecutamos la función
SELECT * FROM sumar_modificado(5, 105);
SELECT * FROM sumar_modificado(66, 1);
SELECT * FROM sumar_modificado(122, 1);


--------------------------------------
------------- Librería ---------------
--------------------------------------

-- Creamos las siguientes tablas
CREATE TABLE clientes(Cliente_ID INT, Nombre TEXT);
CREATE TABLE libros(ISBN TEXT, Titulo TEXT, Autor TEXT,
	Editorial TEXT, Año_de_publicacion INT, Genero TEXT,
	Precio_de_venta NUMERIC);
CREATE TABLE ventas(Venta_ID INT, ISBN TEXT, Fecha_de_venta DATE,
	Cliente TEXT, Precio_de_venta NUMERIC);

-- Después de crear las tablar hay que ortorgar los permisos
-- en la carpeta de libreria, click derecho, dar acceso a,
-- usuarios específicos, everyone, compartir, listo

-- Después llenamos la tabla clientes usando COPY
-- COPY clientes(Cliente_ID, Nombre)
-- FROM 'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Libreria/clientes.csv'
-- DELIMITER ',' CSV HEADER;
-- Usando COPY sale error de que faltan datos en la columna nombre

-- Llenamos la tabla de manera manual
INSERT INTO clientes(Cliente_id, Nombre) VALUES
	(1, 'Juan Pérez'),
	(2, 'Ana Gómez'),
	(3, 'María López'),
	(4, 'Pedro Martínez'),
	(5, 'Luis Rodríguez');

-- Muestra la tabla clientes
SELECT * FROM clientes;

-- Llenamos la tabla libros usando COPY
COPY libros(ISBN, Titulo, Autor, Editorial, Año_de_publicacion, Genero, Precio_de_venta)
FROM 'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Libreria/libros.csv'
DELIMITER ',' CSV HEADER;

-- Muestra la tabla libros
SELECT * FROM libros;

-- Llenamos la tabla ventas usando COPY
COPY ventas(Venta_ID, ISBN, Fecha_de_venta, Cliente, Precio_de_venta)
FROM 'C:/Users/matma/Documents/Developer/Courses/Bases_de_datos_postgresql/Libreria/ventas.csv'
DELIMITER ',' CSV HEADER;

-- Muestra la tabla ventas
SELECT * FROM ventas

-- Muestra la tabla de libros
SELECT * FROM libros;


-- Vamos a crear una función para agregar un nuevo libro a la tabla libros
CREATE OR REPLACE FUNCTION agregar_libro(isbn text,
	titulo text,
	autor text,
	editorial text,
	año_de_publicacion int,
	genero text,
	precio_de_venta numeric
	)
RETURNS int AS
$$
BEGIN
	INSERT INTO libros VALUES (isbn, titulo, autor, editorial, año_de_publicacion, genero, precio_de_venta);
RETURN 0;
END
$$
LANGUAGE 'plpgsql';

-- Ejecutamos la función
SELECT * FROM agregar_libro('978-3-16-148410-0',
	'El libro de la serlva',
	'Rudyard Kipling',
	'Editorial A',
	1984,
	'Aventura',
	15.99);

-- Muestra la tabla libros con el nuevo registro
SELECT * FROM libros;


-- Crear una función para añadir una venta


-- Crear una función para calcular el total de ventas de un libro por ISBN


-- Crear una función para obtener el número de ventas por clientes
-- (es decir, cuántas compras hizo)


-- Crear una función para obtener los libros vendidos en un rango de fechas

-- Como necesitamos extraer el título del libro hacemos un JOIN
-- esto es lo que necesitamos que haga la función
SELECT libros.isbn, libros.titulo, ventas.fecha_de_venta, ventas.cliente, ventas.precio_de_venta
FROM libros
JOIN ventas ON libros.isbn = ventas.isbn
WHERE ventas.fecha_de_venta BETWEEN '2023-05-02' AND '2023-05-04';

-- Ahora creamos la función
CREATE OR REPLACE FUNCTION libros_vendidos_rango(fecha_inicio date, fecha_final date)
RETURNS TABLE (isbn text, titulo text, fecha_de_venta date, cliente text, precio_de_venta numeric) AS 
$$
BEGIN
RETURN QUERY
SELECT libros.isbn, libros.titulo, ventas.fecha_de_venta, ventas.cliente, ventas.precio_de_venta
FROM libros
JOIN ventas ON libros.isbn = ventas.isbn
WHERE ventas.fecha_de_venta BETWEEN fecha_inicio AND fecha_final;
END;
$$
LANGUAGE 'plpgsql';

-- Ejecutamos la función
SELECT * FROM libros_vendidos_rango('2023-05-01', '2023-05-02');

-- Creamos una tabla con las fechas filtradas
CREATE TABLE fechas_filtradas AS SELECT * FROM libros_vendidos_rango('2023-05-01', '2023-05-02');

-- Muestra la tabla fechas_filtradas
SELECT * FROM fechas_filtradas;