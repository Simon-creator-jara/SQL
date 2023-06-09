--*********************************************************************
-- LABORATORIO VISTAS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será por el alumno sin la supervisión del instructor.

-----------------------------------------------------------------------
-- Crear una vista para seleccioar datos
-----------------------------------------------------------------------
1.1 Las dos definiciones siguientes crean la misma vista
    Note los nombres de los campos usando alias o en el encabezado de la instrucción

USE Norte
GO
--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vClientes_Y_Proveedores_Ciudad]'))
-- DROP VIEW [dbo].[vClientes_Y_Proveedores_Ciudad]
--GO

CREATE OR ALTER VIEW dbo.vClientes_Y_Proveedores_Ciudad 
AS
 SELECT Ciudad, Compania, ContactoNombre As Contacto, 'Cliente' As Tipo FROM Clientes
 UNION 
 SELECT Ciudad, Compania, ContactoNom, 'Proveedor' FROM Proveedores
GO

-- Similar a la anterior, no la ejecute.
CREATE VIEW dbo.vClientes_Y_Proveedores_Ciudad (Ciudad, Compania, Contacto, Tipo)
AS
 SELECT Ciudad, Compania, ContactoNombre, 'Cliente' FROM Clientes
 UNION 
 SELECT Ciudad, Compania, ContactoNom, 'Proveedor' FROM Proveedores
GO

1.2 Consultar información de la vista anterior

Select * From vClientes_Y_Proveedores_Ciudad 
 WHERE Ciudad = 'Berlin'
 ORDER BY Ciudad, Compania

-----------------------------------------------------------------------
-- 2. Modificar datos con una vista
-----------------------------------------------------------------------
2.1 Crear la vista en la tabla de clientes

Use Norte
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vClientes]'))
 DROP VIEW [dbo].[vClientes]
GO

CREATE VIEW dbo.vClientes
AS
 SELECT IdCliente, Compania, ContactoNombre, ContactoTitulo, Direccion,
  Ciudad, Region, Pais, Telefono, Fax
  FROM dbo.Clientes
  WHERE Region = 'WA'
  WITH CHECK OPTION;
GO


2.2 Consultar los datos

SELECT * FROM dbo.vClientes


2.3 Modificar datos con la vista

INSERT INTO dbo.vClientes (IdCliente, Compania, ContactoNombre, ContactoTitulo, 
 Direccion, Ciudad, Region, Pais, Telefono, Fax)
 VALUES('00001', 'A', 'A', 'A', 'A', 'A', 'WA', 'A', 'A', 'A');

SELECT * FROM dbo.vClientes

INSERT INTO dbo.vClientes (IdCliente, Compania, ContactoNombre, ContactoTitulo, 
 Direccion, Ciudad, Region, Pais, Telefono, Fax)
 VALUES('00002', 'A', 'A', 'A', 'A', 'A', 'OR', 'A', 'A', 'A');

UPDATE dbo.vClientes SET Compania = 'Compañia B'
 WHERE IdCliente = '00001'

SELECT * FROM dbo.vClientes

DELETE FROM dbo.vClientes
 WHERE IdCliente = '00001'

SELECT * FROM dbo.vClientes

CREATE UNIQUE CLUSTERED INDEX IDX_vClientes
 ON dbo.vClientes (IdCliente);
GO

-----------------------------------------------------------------------
-- 3. Crear un índice en un vista 
-----------------------------------------------------------------------
Use Norte
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vClientes]'))
 DROP VIEW [dbo].[vClientes]
GO

CREATE VIEW dbo.vClientes
 WITH SCHEMABINDING
AS
 SELECT IdCliente, Compania, ContactoNombre, ContactoTitulo, Direccion,
  Ciudad, Region, Pais, Telefono, Fax
  FROM dbo.Clientes
  WHERE Region = 'WA'
  WITH CHECK OPTION;
GO

CREATE UNIQUE CLUSTERED INDEX IDX_vClientes
 ON dbo.vClientes (IdCliente);
GO

-- En SQL Standar edition el optimizador no toma en cuenta el índice en forma automática
-- Ejecute el plan de ejecución de la siguiente instrucción
SELECT * FROM dbo.vClientes WITH (Index(IDX_vClientes))


-----------------------------------------------------------------------
-- PREGUNTAS PARA EL ALUMNO:
-----------------------------------------------------------------------
1. ¿Para modificar datos que es mejor, usar procedimientos almacenados o vistas?
2. ¿Si una vista tiene un Where que cláusuar utiliza, para que las modificaciones 
   a los datos unicamente afecten a las filas que casen con el Where? 

-----------------------------------------------------------------------
-- CONSULTA:
-----------------------------------------------------------------------
¿En qué consiste las vistas índexadas?
¿Qué versión de SQL soporta vistas indexadas y cuáles son las diferencias?