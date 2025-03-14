-------------------------------------
------------- Sesión 11 -------------
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


-------------------------------------
------------- Sesión 14 -------------
-------------------------------------


----- En esta sesión veremos procedimientos almacenados -----
-- y disparadores 

-- Repaso de funciones donde podemos mandar llamar a los
-- parámetros de la función sin declararle un nombre
CREATE OR REPLACE FUNCTION multiplicar(INT, INT)
RETURNS TEXT
AS 
$$
DECLARE z INT;
BEGIN
z = $1 * $2;
RETURN CONCAT('El producto de ', $1, ' con ', $2, ' es ', z);
END
$$
LANGUAGE plpgsql;

-- Ejecutamos la función
SELECT * FROM multiplicar(2, 3);


-- Los procedimientos almacenados se utilizan 
-- para modificar tablas. 
-- Las funciones se ocupan para hacer cálculos. 
-- Esa es la diferencia

-- Si requieres modificar una tabla, lo correcto es 
-- utilizar un procedimiento almacenado.

-- Ejemplo: 

-- Creamos una tabla
CREATE TABLE cuentas1(
	id INT GENERATED BY DEFAULT AS IDENTITY,
	cliente VARCHAR(100) NOT NULL,
	balance NUMERIC NOT NULL
);

-- Insertamos los datos en la tabla nueva
INSERT INTO cuentas1 (cliente, balance)
VALUES('Jorge', 10000),
	('Héctor', 10000),
	('Ramón', 10000),
	('Luis', 10000),
	('José', 10000),
	('Sofía', 10000),
	('Leticia', 10000),
	('Gloria', 10000);

-- Muestra la tabla 
SELECT * FROM cuentas1;


-- Vamos a crear un nuevo procedimiento que se va a llamar 'Transferir'
-- primero se construye el procedimiento
-- Recordar que los procedimientos modifican la tabla
-- Son funciones especiales
CREATE OR REPLACE PROCEDURE transferir(INT, INT, NUMERIC)
LANGUAGE plpgsql
AS
$$
BEGIN
	UPDATE cuentas1 SET balance = balance - $3 WHERE ID = $1;
	UPDATE cuentas1 SET balance = balance + $3 WHERE ID = $2;
END;
$$;

-- Utilizamos el procedimiento creado
-- Mandamos de Gloria a Sofía $1500
CALL transferir(8, 6, 1500);

-- Muestra la tabla
SELECT * FROM cuentas1;


----- TRIGGERS -----

-- Disparadores
-- Una base de datos es un conjunto de tablas
-- junto con los procedimientos almacenados
-- y disparadores que pueda tener.
-- Los disparadores van asociados a tablas.

-- Un Trigger o disparador es un objeto que se asocia con
-- una tabla en concreto. Este Trigger se ejecuta cuando
-- sucede algún evento sobre la tabla que está asociada 
-- y no es necesario que un usuario la ejecute.

-- Se suelen utilizar para actualizar tablas o hacer respaldos.

-- Para ver un ejemplo creamos una tabla 
-- Esta tabla es la quiero ir llenando cada vez que realice una transferencia.
CREATE TABLE cuentas_antes(
	ID INT GENERATED BY DEFAULT AS IDENTITY,
	cliente VARCHAR(100) NOT NULL,
	balance NUMERIC NOT NULL,
	usuario VARCHAR(250) NOT NULL,
	fecha DATE,
	tiempo TIME
);

-- Muestra la tabla
SELECT * FROM cuentas_antes;

-- Vamos a crear un disparador o Trigger
-- con el fin de que se ejecute justo antes de que 
-- se ejecute cualquier tipo de actualizacion en la tabla.

-- A esta función le vamos a llamar revisar()
-- Esta función crea un trigger
-- Aquí se crea la acción
CREATE OR REPLACE FUNCTION revisar()
RETURNS TRIGGER
AS
$$
DECLARE -- declara variables auxiliares
	Usuario VARCHAR(250) = USER; -- quién realiza la acción 
	Fecha DATE = CURRENT_DATE; -- fecha en la que se realiza la acción
	Tiempo TIME = CURRENT_TIME; -- hora en la que se realiza la acción
BEGIN
	INSERT INTO cuentas_antes VALUES (OLD.id, OLD.cliente, OLD.balance, Usuario, Fecha, Tiempo); -- pone lo que había antes de que se realizara el cambio
	RETURN NEW;
END
$$
LANGUAGE plpgsql;

-- Ahora la siguiente sintaxis lo que no dice es
-- que cuando se active el disparador quiero que 
-- que ejecute la función revisar.
-- Creamos el Trigger o disparador
CREATE TRIGGER antes_actualizar -- nombre del disparador
BEFORE UPDATE ON cuentas1 -- cuándo se va activar
FOR EACH ROW EXECUTE PROCEDURE revisar(); -- qué es lo que va a realizar

-- Muestra la tabla cuentas1
SELECT * FROM cuentas1;

-- Transfiere a Gloria a Sofía $1500
CALL transferir(8, 6, 1500);

-- Muestra la tabla cuentas1 para ver los cambios de la tranferencia de dinero
SELECT * FROM cuentas1;

-- Como ya se modificó cuentas1 vamos a ver cómo se modificaron
SELECT * FROM cuentas_antes;

-- Hacemos otra transferencia
CALL transferir(7, 3, 500);

-- Muestra la tabla cuentas1 para ver los cambios de la tranferencia de dinero
SELECT * FROM cuentas1;

-- Como ya se modificó cuentas1 vamos a ver cómo se modificaron
SELECT * FROM cuentas_antes;

-- Con lo anterior podemos ver quién hizo las transformaciones en la base de datos.

-- Hacemos otra transferencia
CALL transferir(8, 3, 500);

-- Muestra la tabla cuentas1 para ver los cambios de la tranferencia de dinero
SELECT * FROM cuentas1;

-- Como ya se modificó cuentas1 vamos a ver cómo se modificaron
SELECT * FROM cuentas_antes;


-- Creamos una nueva tabla llamada cuentas
CREATE TABLE cuentas (
	ID SERIAL PRIMARY KEY,
	cliente_id INT NOT NULL,
	balance NUMERIC NOT NULL CHECK (balance >= 0)
);

-- Llenamos la tabla con los datos
INSERT INTO cuentas (cliente_id, balance)
VALUES
	(1, 10000),
	(1, 5000),
	(2, 20000),
	(3, 15000),
	(1, 3000);

-- Muestra la tabla cuentas
SELECT * FROM cuentas;

-- Creamos una tabla llamada totales
CREATE TABLE totales AS
	SELECT cliente_id, SUM(balance) AS total_balance
	FROM cuentas
	GROUP BY cliente_id;

-- Muestra la tabla totales
SELECT * FROM totales;

-- Vamos a crear un disparador para cuando un cliente existente crea
-- una nueva cuenta o un cliente nuevo crea su cuenta 
-- y eso se refleje en la tabla de totales.

-- Creamos la función de actualización
CREATE OR REPLACE FUNCTION actualizar_totales()
RETURNS TRIGGER AS $$
BEGIN 
	-- Actualiza el total del cliente afectado
	UPDATE totales
	SET total_balance = (SELECT SUM(balance) FROM cuentas WHERE cliente_id = NEW. cliente_id)
	WHERE cliente_id = NEW.cliente_id;

	-- Si el cliente que llega no es nuevo, lo insertamos en la tabla totales
	IF NOT FOUND THEN
		INSERT INTO totales (cliente_id, total_balance)
		-- VALUES (NEW.cliente_id, (SELECT SUM(balance) FROM cuentas WHERE cliente_id = NEW.cliente_id));
		VALUES (NEW.cliente_id, NEW.balance)
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crea el disparador
CREATE TRIGGER trigger_actualizar_totales -- nombre del disparador
AFTER INSERT OR UPDATE OR DELETE ON cuentas
FOR EACH ROW EXECUTE FUNCTION actualizar_totales();

-- Muestra las tablas para realizar los cambios
SELECT * FROM totales;
SELECT * FROM cuentas;

-- Metemos una nueva fila a la tabla cuentas
-- El cliente 1 va abrir una nueva cuenta con $1700
INSERT INTO cuentas(cliente_id, balance) VALUES (1, 1700);

-- Muestra los cambios
SELECT * FROM totales;
SELECT * FROM cuentas;

-- Llega un nuevo cliente
INSERT INTO cuentas(cliente_id, balance) VALUES (10, 13500);

-- El cliente 2 crea una nueva cuenta
INSERT INTO cuentas(cliente_id, balance) VALUES (2, 12000);