-- Creamos una tabla en la base de datos mi_primer_base, con 2 columnas: 
-- la columna1 son datos de tipo texto de a lo más 20 caracteres incluyendo el espacio
-- la columna2 sus elementos van a ser números enteros
create table mi_primer_tabla(columna1 varchar(20), columna2 int);

--Llenado de datos.
-- Ponemos tres filas
insert into mi_primer_tabla values('Hector Manuel', 3), ('Junior', 20), ('Rocky', 7);

-- Muestra toda la tabla
select * from mi_primer_tabla;

-- Insertamos una nueva fila
insert into mi_primer_tabla values ('Duquesa Oliveira', 5);

-- Muestra la tabla 
select * from mi_primer_tabla;

-- Elimina la tabla creada
-- drop table mi_primer_tabla;

-------------------------------------
------------- Sesión 03 -------------
-------------------------------------

-- Creamos una nueva tabla dentro de esta base de datos con el siguiente orden en las columnas
create table mi_segunda_tabla(apellido varchar(50), matricula char(10), calif int);

-- Llenamos mi_segunda_tabla
insert into mi_segunda_tabla(apellido, calif, matricula) values('Rocky', 9, '1234567890');

-- Agregamos un solo dato, las demás columnas las pone con datos null
insert into mi_segunda_tabla values ('Canelo');

-- Muestra la tabla
select * from mi_segunda_tabla;

-- Podemos insertar valores nulos a mano
insert into mi_segunda_tabla(matricula, apellido, calif) values ('6278162', Null, 7);

-- Muestra la longitud en espacio de memoria
select length(matricula) from mi_segunda_tabla;

------------- Pasando al ejemplo de la documentación -------------
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

-- Muestra toda la tabla
select * from modulo_victimizacion;

-- Selecciona algunas columnas de la tabla, muestra una vista y no ocupa espacio en memoria
select tipo_delito, perdida from modulo_victimizacion;

-- Ordenamientos. En este caso por 'apellido' en orden alfabético y orden ascendente. Solo es una vista, no existe el objeto
select * from modulo_victimizacion order by apellido asc;

-- Ordenamientos. En este caso por 'apellido' en orden alfabético y orden descendente. Solo es una vista, no existe el objeto
select * from modulo_victimizacion order by apellido desc;

-- Ordenamientos 
select * from modulo_victimizacion order by apellido desc, nombre asc;

-- Ordenamientos
select * from modulo_victimizacion order by apellido asc, perdida desc;

-- Ordenamientos
select nombre, apellido, perdida from modulo_victimizacion order by apellido asc, perdida desc; 

-- Ordenamientos
select * from modulo_victimizacion order by 1 desc;

-- drop table modulo_victimizacion

-------------------------------------
------------- Sesión 04 -------------
-------------------------------------

-- Muestra la tabla original
select * from modulo_victimizacion;

-- Selecciona los registros de la tabla donde la perdida es > 1000 
-- el verbo SELECT es para seleccionar columnas, WHERE o el filtro es para filas o registros
-- esto es una vista, por lo que se le puede aplicar lo que sabemos hasta ahora de ordenar y demás
SELECT * FROM modulo_victimizacion WHERE perdida > 1000;

-- Esto es una vista, por lo que se le puede aplicar lo que sabemos hasta ahora de ordenar y demás
SELECT * FROM modulo_victimizacion WHERE perdida > 1000 ORDER BY tipo_delito DESC;

-- Hacemos un filtrado con operadores lógicos 
SELECT * FROM modulo_victimizacion WHERE perdida >= 2000 AND entidad = '01';

-- Hacemos un filtrado donde la perdida es diferente de 2000 
SELECT * FROM modulo_victimizacion WHERE perdida != 2000;

-- Filtrados
SELECT entidad, apellido, perdida FROM modulo_victimizacion WHERE perdida != 2000;

-- Operadores lógicos vienen dados por AND, OR, NOT, IN.

-- Muestra la tabla antes de aplicar los operadores lógicos
SELECT * FROM modulo_victimizacion;

-- Muestra la tabla donde el tipo de delito es 3
SELECT * FROM modulo_victimizacion WHERE tipo_delito IN(3)

-- Muestra la tabla donde el tipo de delito es 3 y ordena por apellido
SELECT * FROM modulo_victimizacion WHERE tipo_delito IN(3) order by apellido desc;

-- Muestra la tabla donde el tipo de delito es 3, 4, o 10 y ordena por apellido
SELECT * FROM modulo_victimizacion WHERE tipo_delito IN(3, 4, 10) order by apellido desc;

-- Muestra el tipo de delito 3 o 4 y que además la persona se llame Luis
SELECT * FROM modulo_victimizacion WHERE tipo_delito IN(3, 4) and nombre IN('Luis');

-- Muestra el tipo de delito 4 y la entidad '02'
SELECT * FROM modulo_victimizacion WHERE tipo_delito IN(4) and entidad = '02';

-- Aplicando indentado
SELECT * FROM modulo_victimizacion
	WHERE tipo_delito in(2, 3)
		AND entidad = '32'
	order by perdida desc, 
		nombre asc;

-- Aplicamos usando NOT
SELECT * FROM modulo_victimizacion 
	WHERE NOT perdida = 4500;

-- La misma respuesta obtendríamos el mismo resultado de la línea anterior
SELECT * FROM modulo_victimizacion
	WHERE perdida != 4500;