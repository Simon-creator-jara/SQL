--*********************************************************************
-- LABORATORIO FUNCIONES DEFINIDAS POR EL USUARIO
-- INSTRUCTOR: David Echeverri
-----------------------------------------------------------------------
--- Este laboratorio será por el alumno sin la supervisión del instructor.
--- En clase solo ejecute los puntos 1 al 2, las demás instrucciones son para 
--  trabajo fuera de clase

-----------------------------------------------------------------------
-- 1. Funciones escalares
-----------------------------------------------------------------------
--1.1 Función escalar que retorna el nivel de stock en el inventario de un producto

USE AdventureWorks;
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetStock]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
 DROP FUNCTION [dbo].[fnGetStock]
GO

CREATE FUNCTION dbo.fnGetStock (@IdProducto int)
RETURNS int 
AS 
/* Descripción: Retorna el nivel de stock para un producto

PARAMETROS:
 @IdProducto: Código de producto

EJEMPLO:
 SELECT ProductModelID, Name, dbo.fnGetStock(ProductID)AS StockActual
  FROM Production.Product
  WHERE ProductModelID BETWEEN 75 and 80;
*/
BEGIN
	 DECLARE @iResultado int;
		 SELECT @iResultado = SUM(p.Quantity) 
		  FROM Production.ProductInventory p 
		   WHERE p.ProductID = @IdProducto AND p.LocationID = '6';

		 IF (@iResultado IS NULL) 
			SET @iResultado = 0

	 RETURN @iResultado
END;
GO

--	Llamado
SELECT dbo.fnGetStock(1)

USE AdventureWorks
go 
SELECT 
distinct
ProductID,
dbo.fnGetStock(ProductID) AS Inventario
FROM Production.ProductInventory
WHERE ProductID IN(1,2,3)



1.2 Función escalar que escribe un caracter cada X caracteres

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSeparador_Agregar]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
 DROP FUNCTION [dbo].[fnSeparador_Agregar]
GO

CREATE FUNCTION dbo.fnSeparador_Agregar(@sChar CHAR(1), @NPosiciones int, @sValor VARCHAR(250)) 
 RETURNS Varchar (250)
AS
BEGIN
/* Descripción: Escribe un caracter cada 3 caracteres
   Fecha: 2006-11-14

PARAMETROS:
   @sChar: Caracter separador 
   @NPosiciones: cada cuantos caracteres escribir un separador (3) 
   @sValor: Texto al cual adicionar separadores

EJEMPLO:
 Select dbo.fnSeparador_Agregar ('.', 3, '0123456789') As Espacios
*/
 DECLARE @nPOS INT, @sCadena Varchar (100)
 IF LEN(@sValor) <= @NPosiciones
  RETURN(@sValor)

 SET @sCadena = ''
 SET @nPOS = 1
 WHILE @nPOS <= LEN(@sValor) - @NPosiciones
 BEGIN
   SET @sCadena = @sCadena + SUBSTRING(@sValor, @nPos, @NPosiciones) + @sChar
  SET @nPos = @nPos + @NPosiciones
 END
 SET @sCadena = @sCadena + SUBSTRING(@sValor, @nPOS, @NPosiciones) 
 RETURN(@sCadena)
END
GO

GRANT REFERENCES, EXECUTE ON [dbo].[fnSeparador_Agregar] TO [public]

-- Ejecutar función en forma independiente
Select dbo.fnSeparador_Agregar ('.', 3, '0123456789') As Espacios

-- Ejecutar función en una instrucción Select
Select dbo.fnSeparador_Agregar ('.', 3, LastName) As Apellido From Person.Person

-----------------------------------------------------------------------
-- 2. Función tabla en linea
-----------------------------------------------------------------------
USE AdventureWorks;
GO
CREATE VIEW CustomersByRegion
AS
SELECT distinct
P.FirstName + ' ' + p.LastName, AD.City
FROM 
	SALES.Customer CU 
	INNER JOIN person.BusinessEntity BU
	ON BU.BusinessEntityID = CU.PersonID
	INNER JOIN Person.Person P
	ON BU.BusinessEntityID = P.BusinessEntityID
    INNER JOIN PERSON.BusinessEntityAddress BUA
	ON BUA.BusinessEntityID= BU.BusinessEntityID
	INNER JOIN PERSON.Address AD
	ON BUA.AddressID = AD.AddressID	
    INNER JOIN person.StateProvince SP
	ON SP.StateProvinceID = AD.StateProvinceID 
WHERE SP.Name = N'Washington';
GO

USE AdventureWorks;
GO
CREATE FUNCTION dbo.ufn_CustomerNamesInRegion
                 ( @Region nvarchar(50) )
RETURNS table
AS
RETURN (
        SELECT distinct
			P.FirstName + ' ' + p.LastName as Name, AD.City
			FROM SALES.Customer CU 
			INNER JOIN person.BusinessEntity BU
				ON BU.BusinessEntityID = CU.PersonID
			INNER JOIN Person.Person P
				ON BU.BusinessEntityID = P.BusinessEntityID
			INNER JOIN PERSON.BusinessEntityAddress BUA
				ON BUA.BusinessEntityID= BU.BusinessEntityID
			INNER JOIN PERSON.Address AD
				ON BUA.AddressID = AD.AddressID	
			INNER JOIN person.StateProvince SP
				ON SP.StateProvinceID = AD.StateProvinceID 
			WHERE SP.Name = @Region
       )
GO
-- Ejemplo llamar la función para una región dada
SELECT *
FROM dbo.ufn_CustomerNamesInRegion(N'Washington')
GO

-----------------------------------------------------------------------
-- 3. Ver información de funciones
-----------------------------------------------------------------------
USE AdventureWorks;
GO
SELECT * FROM sys.objects WHERE type IN ('IF','TF','FN','FS','FT');
GO

-- Retorna parámetros asociados con las funciones
SELECT o.name AS FunctionName, p.*
 FROM sys.objects AS o
 JOIN sys.parameters as p ON o.object_id = p.object_ID
 WHERE type IN ('IF','TF','FN','FS','FT');
GO


USE AdventureWorks;
GO
SELECT OBJECT_DEFINITION(OBJECT_ID('[dbo].[ufnGetProductListPrice]'));
GO





