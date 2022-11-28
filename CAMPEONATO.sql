CREATE DATABASE campeonato;
USE campeonato;

CREATE TABLE campeonato (
 id_campeonato varchar (12) PRIMARY KEY ,
 nombre_campeonato VARCHAR (30) NOT NULL,
 sede VARCHAR (20) NOT NULL,

);

INSERT INTO campeonato (id_campeonato,nombre_campeonato,sede) VALUES
('camp-111','Campeonato Unifranz','El Alto'),
('camp-222','Campeonato Unifranz','Cochabamba');

CREATE TABLE equipo (
 id_equipo VARCHAR (12) PRIMARY KEY NOT NULL,
 nombre_equipo VARCHAR (30) NOT NULL,
 categoria VARCHAR (8) NOT NULL,
 id_campeonato VARCHAR (12) NOT NULL,
 FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato),
 );

 INSERT INTO equipo (id_equipo,nombre_equipo,categoria,id_campeonato) VALUES
('equ-111','Google','VARONES','camp-111'),
('equ-222','404 Not Found','VARONES','camp-111'),
('equ-333','girls unifranz','MUJERES','camp-111');

CREATE TABLE jugador (
 id_jugador VARCHAR (12) PRIMARY KEY NOT NULL,
 nombres VARCHAR (30) NOT NULL,
 apellidos VARCHAR (50) NOT NULL,
 ci VARCHAR (15) NOT NULL,
 edad INT not null,
 id_equipo VARCHAR (12) NOT NULL,
 FOREIGN KEY (id_equipo) REFERENCES equipo (id_equipo),

 );

 INSERT INTO jugador (id_jugador,nombres,apellidos,ci,edad,id_equipo) VALUES
('jug-111','Carlos','Villa','8997811LP','19','equ-222'),
('jug-222','Pedro','Salas','8997822LP','20','equ-222'),
('jug-333','Saul','Araj','8997833LP','21','equ-222'),
('jug-444','Sandra','Solis','8997844LP','20','equ-333'),
('jug-555','Ana','Mica','8997855LP','23','equ-333');

--Mostrar que jugadores que formen parte del equipo equ-333

SELECT juga.nombres,juga.apellidos
FROM jugador AS juga 
INNER JOIN equipo AS equi ON equi.id_equipo=juga.id_equipo
WHERE equi.id_equipo='equ-333';

SELECT nombres,apellidos
FROM jugador 
WHERE id_equipo='equ-333';

--Crear una funcion que permita saber cuantos jugadores estan inscritos 
--La funcion debe llamarse Crear una funcion que permita saber cuantos jugadores estan inscritos
--La funcion debe llamarse F1_CantidadJugadores()()

CREATE FUNCTION F1_CantidadJugadores()
RETURNS INTEGER AS
BEGIN
  DECLARE @response integer = 0;

  SELECT @response = count(juga.id_jugador)
  FROM jugador AS juga;

  return @response;
end;

select dbo.F1_CantidadJugadores();

--Crear una funcion que permita saber cuantos jugadores estan inscritos
--y que sean de la categoria varones o mujeres.
--La funcion debe llamarse F2_CantidadJugadoresParam()
--La funcion debe recibir un parametro "Varones" o "Mujeres"

CREATE FUNCTION F2_CantidadJugadoresParam(@categoria VARCHAR (10))
RETURNS INTEGER AS
BEGIN

  DECLARE @respuesta integer = 0;
  SELECT  @respuesta = count(juga.id_jugador)
  FROM       jugador  AS juga
  INNER JOIN equipo   AS equi ON equi.id_equipo = juga.id_equipo
  WHERE   equi.categoria = @categoria 

  RETURN @respuesta;

END;
 SELECT dbo.F2_CantidadJugadoresParam('VARONES');
 SELECT dbo.F2_CantidadJugadoresParam('MUJERES');

--Crear una funcion que obtenga el promedio de las edades mayores a una cierta edad.
--La funcion debe llamarse F3_PromedioEdades()
--La funcion debe recibir como parametros 2 valores.
--La categoria.(Varones o Mujeres).
--La edad con la que se comparara(21 años ejemplo)
--Es decir mostrar el promedio de edades que sean de una categoria y que sean mayores a 21 años.

CREATE FUNCTION F3_PromedioEdades(@categoria VARCHAR (10),@edad INTEGER)
RETURNS INTEGER AS
BEGIN

  DECLARE @respuesta integer = 0;
  SELECT  @respuesta = AVG(juga.edad)
  FROM       jugador  AS juga
  INNER JOIN equipo   AS equi ON equi.id_equipo = juga.id_equipo
  WHERE   equi.categoria = @categoria AND juga.edad>@edad

  RETURN @respuesta;

END;
 SELECT dbo.F3_PromedioEdades('VARONES',21);
 SELECT dbo.F3_PromedioEdades('MUJERES',21);

--Crear una funcion que permita concatenar 3 parametros
--La funcion debe llamarse F4_ConcatItems()
--La funcion debe de recibir 3 paramettros.
--Para verificar la correcta creacion de la funcion debe mostrar lo siguiente.
--Mostrar los nombres de los jugadores, el nombre del equipo y la sede concatenada, utilizando la funcion
--que acaba de crear.

CREATE FUNCTION F4_ConcatItems(@idcamp VARCHAR (50),@sede VARCHAR (50),@categoria VARCHAR (50))
RETURNS VARCHAR(50) AS
BEGIN

  DECLARE @respuesta VARCHAR(50);
  
  SELECT @respuesta = CONCAT(juga.nombres,equi.nombre_equipo,camp.sede)
  FROM       jugador  AS juga
  INNER JOIN equipo   AS equi ON equi.id_equipo = juga.id_equipo
  INNER JOIN campeonato AS camp ON camp.id_campeonato=equi.id_campeonato
  WHERE      equi.id_campeonato=@idcamp and camp.sede=@sede and equi.categoria = @categoria
  

  RETURN @respuesta;

END;
 SELECT dbo.F4_ConcatItems('camp-111','El Alto','MUJERES');
 

 DROP FUNCTION F4_ConcatItems;

 
