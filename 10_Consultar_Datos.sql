--*********************************************************************
-- LABORATORIO CONSULTAR DATOS
-- INSTRUCTOR: David Esteban Echverri
-----------------------------------------------------------------------
- Este laboratorio ser� realizado por los alumno sin la supervisi�n del instructor.
- En clase solo ejecute el punto uno (1), las dem�s instrucciones son para 
  trabajo fuera de clase

-----------------------------------------------------------------------
-- 1. Formatear el conjunto de resultados
-----------------------------------------------------------------------
1.1 Cambiar el nombre de columnas

use AdventureWorks

SELECT [BusinessEntityID] As IdContacto, Title As Titulo, LastName As Apellido 
 FROM [Person].[Person]
 ORDER BY LastName, FirstName

1.2 Usando literales
-- Esta instrucci�n presenta un error, la siguiente lo corrige
SELECT LastName As Apellido, FirstName As Nombre, 
 'Identificaci�n: ' + [BusinessEntityID] As IdContacto 
 FROM [Person].[Person]
 ORDER BY LastName, FirstName

SELECT LastName As Apellido, FirstName As Nombre, 
 'Identificaci�n: ' + Convert(varchar, [BusinessEntityID]) As IdContacto 
 FROM [Person].[Person]
 ORDER BY LastName, FirstName

1.3 Aplicando un formato de fecha
SELECT LastName As Apellido, FirstName As Nombre, 
 Convert(varchar(10), ModifiedDate, 120), ModifiedDate
 FROM [Person].[Person]
 ORDER BY LastName, FirstName

-----------------------------------------------------------------------
-- 2. Uso de operadores l�gicos y de comparaci�n
-----------------------------------------------------------------------
2.1 Listar los clientes con pedidos en un rango de fechas y total en un rango de valores

SELECT SalesOrderID, OrderDate, CustomerID, SubTotal, TaxAmt, TotalDue
 FROM [Sales].[SalesOrderHeader]
 WHERE OrderDate >= '2006-08-01' AND OrderDate <= '2008-08-30'
 AND TotalDue BETWEEN 500 AND 1000
 ORDER BY TotalDue DESC, OrderDate DESC
GO

2.2 Uso de comparadores de caracteres

SELECT [BusinessEntityID], Title, FirstName, LastName
 FROM [Person].[Person]
 WHERE LastName LIKE 'Ala%'
 ORDER BY LastName, FirstName

-----------------------------------------------------------------------
-- 3. Usar una lista de valores como criterio
-----------------------------------------------------------------------
3.1 Listar los teritorios de ventas para las regiones de Francia y USA 

SELECT TerritoryID, Name, CountryRegionCode, [Group]
 FROM [Sales].[SalesTerritory]
 WHERE CountryRegionCode IN ('FR', 'US')
 ORDER BY Name

3.2 Similar a la anterior, pero la escritura es m�s larga

SELECT TerritoryID, Name, CountryRegionCode, [Group]
 FROM [Sales].[SalesTerritory]
 WHERE CountryRegionCode = 'FR' OR CountryRegionCode = 'US'
 ORDER BY Name

-----------------------------------------------------------------------
-- 4. Recuperar valores desconocidos
-----------------------------------------------------------------------
4.1 Listar los contactos a los que se les desconoce el Email

SELECT [BusinessEntityID], Title, FirstName, LastName
 FROM [Person].[Person]
 WHERE [EmailPromotion] IS NULL OR LTrim([EmailPromotion]) = ''

-----------------------------------------------------------------------
-- 5. Ordenar datos
-----------------------------------------------------------------------
5.1 Ordenar por apellido y nombre

SELECT [BusinessEntityID], Title, FirstName, LastName
 FROM [Person].[Person]
 ORDER BY LastName, FirstName

5.2  Similar al anterior, pero el numero indica la posicion del campo en la lista

SELECT [BusinessEntityID], Title, FirstName, LastName
 FROM [Person].[Person]
 ORDER BY 4, 3

-----------------------------------------------------------------------
-- 6. Eliminando filas duplicadas
-----------------------------------------------------------------------
6.1 Listar las regione sin duplicados

SELECT DISTINCT CountryRegionCode, [Group]
 FROM [Sales].[SalesTerritory]
 ORDER BY CountryRegionCode

SELECT CountryRegionCode, [Group]
 FROM [Sales].[SalesTerritory]
 ORDER BY CountryRegionCode

-----------------------------------------------------------------------
-- 7. Listar los TOP n Values
-----------------------------------------------------------------------
7.1  Listar los 7 productos con mayor cantidad vendida 

SELECT TOP 7 SalesOrderID, SalesOrderDetailID, OrderQty, ProductID
 FROM [Sales].[SalesOrderDetail]
 ORDER BY OrderQty DESC

7.2 Similar a la anterior, pero incluir valores iguales al ultimo  valor encontrado.  

SELECT TOP 7 WITH TIES SalesOrderID, SalesOrderDetailID, OrderQty, ProductID
 FROM [Sales].[SalesOrderDetail]
 ORDER BY OrderQty DESC

-----------------------------------------------------------------------
-- 8. Crear consultas con las plantillas de MSMS
-----------------------------------------------------------------------
1. En Object explorer expanda la carpeta Databases, AdventureWorks, Tablas
2. De un clic secundario en la tabla HumanResorces.Department y seleccione
   Scrip table as, Select to, New query editor window 
3. Ejecute la consulta

-----------------------------------------------------------------------
-- PREGUNTAS PARA EL ALUMNO
-----------------------------------------------------------------------
1. �Para que se utiliza la instrucci�n SELECT?
2. �Qu� dificultades tiene usted al crear una consulta?
3. �C�mo retornar informaci�n de dos o m�s tablas?

-----------------------------------------------------------------------
-- TAREA PARA EL ALUMNO
-----------------------------------------------------------------------
1. Tabla pedidos. Escriba una consulta de los pedidos que tengan Fecha 
   mayor al d�a actual y menor que el d�a actual + 1. Tenga en cuenta que los campos 
   tipo fecha almacenan la hora, la cual debe ser truncada cuando realice la comparaci�n
   La consulta debe retornar la informaci�n del pedido y la fecha sin hora en formato:
   yyyy-MM-dd.  
