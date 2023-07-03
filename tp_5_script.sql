CREATE TABLE Cine (
	ID_cine bigint primary key not null,
	CUIT bigint not null,
	Nombre varchar (50) not null
)

CREATE TABLE Sala (
	ID_sala bigint primary key not null,
	Tipo varchar (50) not null
)

CREATE TABLE Tarea (
	ID_tarea bigint primary key not null,
	Nombre varchar (50) not null,
	Es_riesgo boolean
)

CREATE TABLE Empleado (
	DNI bigint primary key not null,
	Nombre varchar (50) not null,
	Fecha_inicio date,
	fecha_fin date,
	ID_Cine int,
	supervisado_por int
)

CREATE TABLE Cine_sala (
	ID_Sala int,
	ID_Cine int
)

CREATE TABLE Tarea_empleado(
	DNI bigint,
	ID_Tarea int
)

ALTER TABLE Empleado
	add constraint asignado_a foreign key (ID_Cine) references Cine(ID_Cine),
	add constraint supervisado_por_fk foreign key (supervisado_por) references Empleado(DNI)
	
ALTER TABLE Cine_sala
	add constraint sala_cine primary key (ID_Cine, ID_Sala),
	add constraint id_cine_fk foreign key (ID_Cine) references Cine(ID_Cine),
	add constraint id_sala_fk1 foreign key (ID_Sala) references Sala(ID_Sala)
	
ALTER TABLE Tarea_empleado
	add constraint empleado_dni primary key(DNI, ID_Tarea),
	add constraint el_empleado foreign key (DNI) references Empleado (DNI),
	add constraint la_tarea foreign key (ID_Tarea) references Tarea(ID_Tarea)

INSERT INTO Cine (ID_cine, CUIT, Nombre) VALUES (5, 61291929893, 'illum');
INSERT INTO Cine (ID_cine, CUIT, Nombre) VALUES (9, 86194852330, 'id');

INSERT INTO Sala (ID_sala, tipo) VALUES (0, 'Comun');
INSERT INTO Sala (ID_sala, tipo) VALUES (2, 'Ultra');
INSERT INTO Sala (ID_sala, tipo) VALUES (3, 'HD');
INSERT INTO Sala (ID_sala, tipo) VALUES (5, 'Común');
INSERT INTO Sala (ID_sala, tipo) VALUES (8, 'HD');

INSERT INTO Cine_Sala (ID_Cine, ID_Sala) VALUES (5, 0);
INSERT INTO Cine_Sala (ID_Cine, ID_Sala) VALUES (5, 3);
INSERT INTO Cine_Sala (ID_Cine, ID_Sala) VALUES (5, 8);
INSERT INTO Cine_Sala (ID_Cine, ID_Sala) VALUES (9, 2);
INSERT INTO Cine_Sala (ID_Cine, ID_Sala) VALUES (9, 5);

INSERT INTO Empleado (DNI,Nombre,ID_Cine,fecha_inicio,fecha_fin,supervisado_por)
VALUES
  (20599421,'Brielle Mendez',9,'Apr 3, 2019',NULL,NULL),
  (22211008,'Nash Abbott',9,'Feb 7, 2020','Dec 28, 2020',20599421),
  (39409537,'Melinda Manning',5,'Jul 12, 2019',NULL,22211008),
  (33752869,'Hu Snyder',9,'Mar 22, 2019','Jan 4, 2021',39409537),
  (33807023,'Yuli Slater',5,'Dec 23, 2019','Aug 6, 2020',22211008),
  (32748731,'Christen Bowen',9,'Feb 21, 2020',NULL,39409537),
  (31130764,'Regina Briggs',5,'Jan 30, 2020','Aug 5, 2020',22211008),
  (14854147,'Cedric Burt',5,'Jan 14, 2020',NULL,39409537),
  (17914042,'Knox Garcia',5,'Nov 1, 2019',NULL,39409537);

INSERT INTO Tarea (ID_Tarea, Nombre, Es_riesgo) VALUES (0, 'Limpieza', False);
INSERT INTO Tarea (ID_Tarea, Nombre, Es_riesgo) VALUES (6, 'Orden', False);
INSERT INTO Tarea (ID_Tarea, Nombre, Es_riesgo) VALUES (9, 'Reposición', True);

INSERT INTO Tarea_Empleado (ID_Tarea, DNI) VALUES (0, 20599421);
INSERT INTO Tarea_Empleado (ID_Tarea, DNI) VALUES (6, 20599421);
INSERT INTO Tarea_Empleado (ID_Tarea, DNI) VALUES (9, 20599421);
INSERT INTO Tarea_Empleado (ID_Tarea, DNI) VALUES (0, 31130764);

SELECT count(*) FROM Empleado WHERE fecha_fin IS NULL;

SELECT (CUIT) FROM cine WHERE cine.nombre = 'illum'

SELECT count(*) FROM tarea_empleado, empleado, tarea
WHERE tarea.nombre = 'Limpieza' AND tarea.ID_Tarea =
tarea_empleado.ID_Tarea AND empleado.DNI =
tarea_empleado.DNI AND empleado.fecha_fin is NULL;

DROP TABLE Empleado, Cine_sala, Cine, Sala, Tarea, Tarea_empleado cascade

alter table Sala add column capacidad INT;

CREATE TABLE Tipo_sala(
	ID_tipo int PRIMARY KEY
)

alter table Sala
	alter column tipo type int using tipo::int,
	add CONSTRAINT Tipo_de_sala FOREIGN KEY (tipo) REFERENCES Tipo_sala(ID_tipo)
	

