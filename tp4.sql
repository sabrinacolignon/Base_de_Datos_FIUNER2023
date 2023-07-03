CREATE TABLE CLIENTES (
  ID_Cliente INT PRIMARY KEY, 
  DNI BIGINT NOT NULL, 
  Nombre VARCHAR(30) NOT NULL, 
  Razon_Social VARCHAR(30) NOT NULL, 
  CUIT BIGINT, 
  CUIL BIGINT NOT NULL, 
  Direccion VARCHAR(50), 
  Telefono BIGINT, 
  Contacto VARCHAR(40), 
  Gerente VARCHAR(40), 
  Actividad VARCHAR(50)
);
CREATE TABLE CONTRATISTA (
  ID_Contratista INT PRIMARY KEY, 
  DNI BIGINT NOT NULL, 
  Nombre VARCHAR(30) NOT NULL, 
  Razon_Social VARCHAR(30) NOT NULL, 
  CUIT BIGINT, 
  CUIL BIGINT NOT NULL, 
  Direccion VARCHAR(50), 
  Telefono BIGINT, 
  Contacto VARCHAR(40)
);
CREATE TABLE EMPLEADO (
  ID_Empleado INT PRIMARY KEY, 
  DNI BIGINT NOT NULL, 
  Nombre VARCHAR(30) NOT NULL, 
  CUIL BIGINT NOT NULL, 
  Direccion VARCHAR(50), 
  Telefono BIGINT, 
  Cargo VARCHAR(25) NOT NULL, 
  Salario DECIMAL(7, 2) NOT NULL, 
  Fecha_Ingreso DATE NOT NULL
);
CREATE TABLE ESPECIALIDAD (
  ID_Especialidad INT PRIMARY KEY, 
  Tipo VARCHAR(25) NOT NULL, 
  Nombre VARCHAR(30) NOT NULL
);
CREATE TABLE PROYECTO (
  ID_Proyecto INT PRIMARY KEY, -- 
  EMPLEADO_ID_Empleado INT, 
  Tipo VARCHAR(30), -- es mas optimo y para buscar en indices se que cada 30bytes encuentro el otro
  Ubicacion VARCHAR(50), 
  Costo DECIMAL(9, 2), 
  Nro_Etapas INT, 
  Fecha_Inicio DATE, 
  Duracion INT, 
  CONSTRAINT emp_in_proy_fk FOREIGN KEY(EMPLEADO_ID_Empleado) REFERENCES EMPLEADO(ID_Empleado)
); -- arriba: restriccion 
CREATE TABLE PLANOS (
  ID_Plano INT PRIMARY KEY, 
  ESPECIALIDAD_ID_Especialidad INT, 
  PROYECTO_ID_Proyecto INT, 
  Tipo VARCHAR(30) NOT NULL, 
  Corte VARCHAR(40) NOT NULL, 
  Ubicacion VARCHAR(40) NOT NULL, 
  CONSTRAINT espec_in_plano_fk FOREIGN KEY(ESPECIALIDAD_ID_Especialidad) REFERENCES ESPECIALIDAD(ID_Especialidad), 
  CONSTRAINT proy_in_plano_fk FOREIGN KEY(PROYECTO_ID_Proyecto) REFERENCES PROYECTO(ID_Proyecto)
);
CREATE TABLE PRESTAMO (
  ID_Prestamo INT PRIMARY KEY, 
  PROYECTO_ID_Proyecto INT, 
  Monto DECIMAL(9, 2) NOT NULL, 
  Monto_Cuota DECIMAL(9, 2) NOT NULL, 
  Plazo INT DEFAULT 12, 
  Entidad_Prestamista VARCHAR(50), 
  CONSTRAINT proy_in_presta_fk FOREIGN KEY(PROYECTO_ID_Proyecto) REFERENCES PROYECTO(ID_Proyecto)
);
CREATE TABLE CLIENTES_has_PROYECTO (
  CLIENTES_ID_Cliente INT, 
  PROYECTO_ID_Proyecto INT, 
  CONSTRAINT client_proy_pk PRIMARY KEY(
    CLIENTES_ID_Cliente, PROYECTO_ID_Proyecto
  ), 
  CONSTRAINT client_cp_fk FOREIGN KEY(CLIENTES_ID_Cliente) REFERENCES CLIENTES(ID_Cliente), 
  CONSTRAINT proy_cp_fk FOREIGN KEY(PROYECTO_ID_Proyecto) REFERENCES PROYECTO(ID_Proyecto)
);
CREATE TABLE CONTRATISTA_has_ESPECIALIDAD (
  CONTRATISTA_ID_Contratista INT, 
  ESPECIALIDAD_ID_Especialidad INT, 
  CONSTRAINT cont_espec_pk PRIMARY KEY(
    CONTRATISTA_ID_Contratista, ESPECIALIDAD_ID_Especialidad
  ), 
  CONSTRAINT cont_ce_fk FOREIGN KEY(CONTRATISTA_ID_Contratista) REFERENCES CONTRATISTA(ID_Contratista), 
  CONSTRAINT espec_ce_fk FOREIGN KEY(ESPECIALIDAD_ID_Especialidad) REFERENCES ESPECIALIDAD(ID_Especialidad)
);
CREATE TABLE Proy_Cont_Espec ( -- tiene 3 filas, restriccion de clave primaria compuesta
  PROYECTO_ID_Proyecto INT, 
  CONTRATISTA_ID_Contratista INT, 
  ESPECIALIDAD_ID_Especialidad INT, 
  CONSTRAINT client_cont_espec_pk PRIMARY KEY(
    PROYECTO_ID_Proyecto, CONTRATISTA_ID_Contratista, 
    ESPECIALIDAD_ID_Especialidad
  ), --abajo: 3 restricciones foraneas
  CONSTRAINT proy_pce_fk FOREIGN KEY(PROYECTO_ID_Proyecto) REFERENCES PROYECTO(ID_Proyecto), 
  CONSTRAINT cont_pce_fk FOREIGN KEY(CONTRATISTA_ID_Contratista) REFERENCES CONTRATISTA(ID_Contratista), 
  CONSTRAINT espec_pce_fk FOREIGN KEY(ESPECIALIDAD_ID_Especialidad) REFERENCES ESPECIALIDAD(ID_Especialidad)
);
CREATE TABLE PROYECTO_has_EMPLEADO (
  PROYECTO_ID_Proyecto INT, 
  EMPLEADO_ID_Empleado INT, 
  CONSTRAINT proy_emp_pk PRIMARY KEY(
    PROYECTO_ID_Proyecto, EMPLEADO_ID_Empleado
  ), 
  CONSTRAINT proy_pe_fk FOREIGN KEY(PROYECTO_ID_Proyecto) REFERENCES PROYECTO(ID_Proyecto), 
  CONSTRAINT emp_pe_fk FOREIGN KEY(EMPLEADO_ID_Empleado) REFERENCES EMPLEADO(ID_Empleado)
);

drop table proyecto_has_empleado;
drop table proy_cont_espec;
drop table clientes_has_proyecto;
drop table contratista_has_especialidad;
drop table prestamo;
drop table planos;
drop table proyecto;
drop table clientes;
drop table especialidad;
drop table contratista;
drop table empleado;