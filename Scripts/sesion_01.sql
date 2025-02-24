-- Creamos una tabla en la base de datos mi_primer_base, con 2 columnas:
-- la columna1 son datos de tipo texto de a lo más 20 caracteres incluyendo el espacio
-- la columna2 sus elementos van a ser números enteros
create table mi_primer_tabla(columna1 varchar(20), columna2 int);

--Llenado de datos.
-- Ponemos tres filas
insert into mi_primer_tabla values('Hector Manuel', 3), ('Junior', 20), ('Rocky', 7);

-- Muestra la tabla
select * from mi_primer_tabla;

-- Insertamos una nueva fila
insert into mi_primer_tabla values ('Duquesa Oliveira', 5);

-- Muestra la tabla
select * from mi_primer_tabla;

-- Elimina la tabla creada
drop table mi_primer_tabla;