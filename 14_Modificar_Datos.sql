--*********************************************************************
-- INSTRUCTOR: David Esteban Echeverri 
-- Insertando una fila de datos por valores
-----------------------------------------------------------------------
-- Este laboratorio será realizado por el alumno sin la supervisión del instructor.

-----------------------------------------------------------------------
-- 1. Insertar datos 
-----------------------------------------------------------------------
--1.1 Uso de la instrucción Insert

USE Norte
GO

INSERT Clientes 
(IdCliente, Compania, ContactoNombre, ContactoTitulo,
                  Direccion, Ciudad, region, Pais, Telefono, fax)
VALUES ('TR', 'TR SOLUTIONS','AQUINALDO ISASERE',
        'Gerente', 'Dir Empresa', 'Vancouver', 'BC',
        'Canada', '(200) 555-3392', '(200) 555-7293')

USE Norte
GO
SELECT IdCliente, Compania, ContactoNombre FROM Clientes WHERE IdCliente = 'TR'
GO
DELETE Clientes WHERE IdCliente = 'TR'
GO
--1.2 Uso de INSERT ... SELECT, para adicionar registros al historico de pedidos

USE Norte
GO
--Opción 1 (Afectando LOG)
DELETE FROM Pedidos_Historia
--Opción 2 
TRUNCATE TABLE Pedidos_Historia
GO
INSERT Pedidos_Historia (IdProducto, IdPedido, Cantidad)
 SELECT IdProducto, PD.IdPedido, Cantidad FROM Pedidos_Detalles As PD
 INNER JOIN Pedidos As P ON PD.IdPedido = P.IdPedido
 WHERE FPedido Between '1997-01-01' AND '1997-12-31'

Select * From Pedidos_Historia

-----------------------------------------------------------------------
-- 2. Insertar datos parciales, utilizando defaults
-----------------------------------------------------------------------
--2.1 Datos con columnas de tipo IDENTITY, con default o que permitan null 
--    no son requeridas.

INSERT Despachadores (Compania) VALUES ('Servientrega')
GO
SELECT * FROM Despachadores WHERE Compania = 'Servientrega'
GO
--Ayuda Objetos
sp_help 'Despachadores'

--2.1 Uso de DEFAULT para una columna que permite valores default o null.
USE [Norte]
GO
ALTER TABLE [dbo].[Despachadores] 
ADD  CONSTRAINT [DF_Telefono_Desp]  DEFAULT ('200-123456') FOR [Telefono]
GO

USE Norte
INSERT Despachadores (Compania, Telefono) VALUES ('TCC', DEFAULT)
INSERT Despachadores (Compania, Telefono) VALUES ('Coordinadora', DEFAULT)
SELECT * FROM Despachadores WHERE Compania = 'TCC'

-----------------------------------------------------------------------
-- 3. Crear una tabla usando SELECT INTO 
-----------------------------------------------------------------------
--3.1  Crear una tabla temporal basado en una consulta a la tabla Productos.
--     ¿No es recomendable en uso de Select Into, en su lugar usar un Insert Into?

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmpPrecio]') 
 and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tmpPrecio]

if exists (select * from sys.tables where name = 'tmpprecio')
drop table [dbo].[tmpPrecio]

--Creación tabla Persistente
SELECT Nombre AS producto, PrecioUnd,(PrecioUnd * 1.16) AS Impuesto
 INTO dbo.tmpPrecio
 FROM Productos

 Select * From tmpPrecio

 --Creación tabla Temporal
SELECT Nombre AS producto, PrecioUnd,(PrecioUnd * 1.16) AS Impuesto
 INTO #tmpPrecio
 FROM Productos
  
 Select * From #tmpPrecio
 
-----------------------------------------------------------------------
-- 4. Uso de DELETE
-----------------------------------------------------------------------
--4.1  Borrar los pedidos con fecha >= 6 meses

DELETE Pedidos_Historia WHERE DATEDIFF(MONTH, FPedido, GETDATE()) >= 6

--4.2 Remover filas basado en otras tablas
--    Uso de un Join para remover filas de la tabla Pedidos_Historia 
--    para pedidos tomados en 4/10/2000. 

USE Norte
DELETE FROM Pedidos_Historia
 FROM Pedidos AS P
 INNER JOIN Pedidos_Historia AS PH ON P.IdPedido = PH.IdPedido
 WHERE P.FPedido = '4/14/1997'

--4.3 Igual que el ejemple anterior, pero usando una subconsulta anidada

USE Norte
DELETE FROM Pedidos_Historia
 WHERE IdPedido IN (SELECT IdPedido FROM Pedidos WHERE FPedido = '4/14/1998')

--4.4 Borrado usando TRUNCATE TABLE para remover todos los datos

TRUNCATE TABLE Pedidos_Historia

-----------------------------------------------------------------------
-- 5. Uso de Update
-----------------------------------------------------------------------
--5.1 Actualizar filas basado en datos de la tabla
--    Adicionar un 10% del precio actual a todos los productos
 
USE Norte
UPDATE dbo.Productos SET PrecioUnd = (PrecioUnd * 1.1)

--5.2 Uso de un join para actualizar la tabla Productos adicionando 
--    $2.00 a la columna precio unitariorio para todos los productos suministrado por 
--    los proveedores del país USA. 

UPDATE Productos
 SET PrecioUnd = PrecioUnd + 2
--select PR.* 
 FROM Productos Pr
 INNER JOIN Proveedores P ON Pr.IdProveedor = P.IdProveedor
 WHERE P.Pais = 'USA'

select * From productos

--5.3 Uso de una subconsulta para actualizar la tabla Productos restando 
--    $2 a la columna precio unitariorice para todos los productos suministrado por 
--    los proveedores del país USA.  Note que cada producto tiene unicamente un proveedor.

UPDATE Productos
 SET PrecioUnd = PrecioUnd - 2
 WHERE IdProveedor IN (SELECT IdProveedor FROM Proveedores WHERE Pais = 'USA')

--5.4 Actualiza el total de ventas para todos los pedidos de cada producto 
--    Muchas ordenes de cada producto pueden existir.  
--    Debe adicionar la columna TotalVentas con default = 0 a la tabla Productos

UPDATE Productos 
 SET TotalVentas = (SELECT SUM(Cantidad)
                     FROM Pedidos_Detalles AS PD
                     WHERE Productos.IdProducto = PD.IdProducto)

