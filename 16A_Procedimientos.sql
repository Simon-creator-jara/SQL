--*********************************************************************
-- LABORATORIO PROCEDIMIENTOS ALMACENADOS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado por el alumno sin la supervisión del instructor.

-----------------------------------------------------------------------
--  1. Crear un PA con valores predeterminados
-----------------------------------------------------------------------
1.1 Crear el PA

Use AdventureWorks
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spValores_Predeterminados]') AND type in (N'P', N'PC'))
 DROP PROCEDURE [dbo].[spValores_Predeterminados]
GO


CREATE OR ALTER PROCEDURE dbo.spValores_Predeterminados 
 @intPrimero int = NULL,  
 @intSegundo int = 2,    
 @intTercero int = 3     
AS
-- Listar los valores.
 SELECT @intPrimero As Primero, @intSegundo As Segundo, @intTercero As Tercero
GO

1.2. Ejecutar PA sin suministrar parámetros

EXECUTE spValores_Predeterminados                

1.2. Ejecutar PA todos los parámetros sumistrados

EXECUTE spValores_Predeterminados 10, 20, 30     

1.3  Ejecutar PA solamente el segundo parámetro suministrado por nombre

EXECUTE spValores_Predeterminados @intSegundo = 500 

1.4 Ejecutar PA unicamente el primero y el tercer parámetro son suminstrados

EXECUTE spValores_Predeterminados 40, NULL 50           -- Error de sintaxis
EXECUTE spValores_Predeterminados 40, @intTercero = 50 

-----------------------------------------------------------------------
-- 2. Mensajes de error en PA
-----------------------------------------------------------------------
Use AdventureWorks
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spMensaje_Error]') AND type in (N'P', N'PC'))
 DROP PROCEDURE [dbo].[spMensaje_Error]
GO

CREATE OR ALTER PROCEDURE dbo.spMensaje_Error 
@intParametro int = NULL     
AS

 IF @intParametro IS NULL OR @intParametro < 10 
	BEGIN
	  PRINT 'Valor NULL o Menor de 10'
	  GOTO Salir 
	END
 ELSE 
	Print 'La vida es bella!!!'

 SELECT @intParametro As Parametro
 RETURN

Salir:
 PRINT 'ERROR: parámetro debe ser >= 10'
 RAISERROR ('ERROR: parámetro debe ser >= 10', 11, 1) WITH LOG
 RETURN (1)
GO

Exec dbo.spMensaje_Error
Exec dbo.spMensaje_Error 20
GO

--Punto 3 de Cultura General. No ejecutar
-------------------------------------------------------------------------
---- 3. Crear un PA que utilice un código de retorno
-------------------------------------------------------------------------
--3.1 Crear el PA

--Use Norte
--GO
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spVentas_Por_Producto]') AND type in (N'P', N'PC'))
-- DROP PROCEDURE [dbo].[spVentas_Por_Producto]
--GO

--CREATE PROCEDURE dbo.spVentas_Por_Producto 

--@IdProducto int = NULL, @Ano int,
--@Ventas_Anuales int OUTPUT        
--AS  
--/* @IdProducto: Código del producto
--   @Ventas_Anuales: unidades anuales vendidas

--   Codigos de retorno (Return)
--   0 Ejecución exitosa. 
--   1 Parámetro requerido no especificado. 
--   2 Valor invalido de parámetro. 
--   3 Error recuperando valor de ventas. 
--   4 Unidades vendidas = NULL para el producto suministrado 

--*/

---- Validar el parámetro @IdProducto
-- IF @IdProducto IS NULL
-- BEGIN
--   PRINT 'ERROR: Debe especificar un producto'
--   RETURN(1)
-- END
-- ELSE
-- BEGIN
---- Asegurar que el producto es valido
--   IF (SELECT COUNT(*) FROM Productos WHERE IdProducto = @IdProducto) = 0 
--    RETURN(2)
-- END

---- Recuperar las ventas del titulo especificado y asignarla al par. de salida
----use norte 
--SELECT 
--@Ventas_Anuales = sum(cantidad) 
--FROM Pedidos_Detalles PD
--  INNER JOIN Pedidos P ON PD.IdPedido = P.IdPedido
--  WHERE IdProducto = @IdProducto and year(P.FPedido) = @Ano

---- Chequer errores SQL Server
-- IF @@ERROR <> 0 
-- BEGIN
--   RETURN(3)
-- END
-- ELSE
-- BEGIN
---- Chequear si Cantidad es NULL
--  IF @Ventas_Anuales IS NULL
--   RETURN(4)   
--  ELSE
---- EXITO!!
--   RETURN(0)
-- END
--GO

--3.2 Ejecutar PA que utiliza un código de retorno

---- Declarar la variable que obtiene el codigo de retorno del procedimiento
--DECLARE @Ventas_AnualesXTitulo int, @Retorno int

--EXECUTE @Retorno = spVentas_Por_Producto 'Sushi, Anyone?', @Ventas_Anuales = @Ventas_AnualesXTitulo OUTPUT
---- El anterior debe fallar 
----EXECUTE @Retorno = spVentas_Por_Producto 11, 1996, @Ventas_Anuales = @Ventas_AnualesXTitulo OUTPUT 

----select @retorno

-- IF @Retorno = 0  --  Chequear el codigo de retorno
-- BEGIN
--  PRINT 'Ejecución satisfactoria'
--  PRINT 'Ventas por Sushi, Anyone?: ' + CONVERT(varchar(6), @Ventas_AnualesXTitulo)
-- END
-- ELSE IF @Retorno = 1
--  PRINT 'ERROR: Ningún título fue especificado'
-- ELSE IF @Retorno = 2 
--  PRINT 'ERROR: Un titulo invalido fue suministrado'
-- ELSE IF @Retorno = 3
--   PRINT 'ERROR: Un error ocurrió al retornar las ventas'  
--GO

--3.3 Ejecutar PA que utiliza un código de retorno

--DECLARE @Ventas_AnualesXTitulo int
--EXECUTE spVentas_Por_Producto 
-- 'Libro no existente', @Ventas_Anuales = @Ventas_AnualesXTitulo OUTPUT 

--Print 'Ventas por titulo: ' + Convert(varchar, @Ventas_AnualesXTitulo)

-----------------------------------------------------------------------
-- 4. Recompilar PA
-----------------------------------------------------------------------
Use Norte;
exec sp_recompile 'dbo.spMensaje_Error'
GO

-----------------------------------------------------------------------
-- 5. Información de PA
-----------------------------------------------------------------------
SELECT * FROM sys.sql_modules 

USE AdventureWorks;
GO
SELECT OBJECT_DEFINITION (OBJECT_ID(N'dbo.spValores_Predeterminados')) AS [Definicion PA]; 
GO

USE Norte;
GO
EXEC sp_helptext 'dbo.spValores_Predeterminados';
GO
