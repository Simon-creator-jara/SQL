--*********************************************************************
-- LABORATORIO EDITOR DE CONSULTAS
-- INSTRUCTOR: David Echeverri
-----------------------------------------------------------------------
- Este laboratorio sera realizado por los alumnos con la supervisi�n del instructor.

-----------------------------------------------------------------------
-- 1. Escribir instrucciones sin conexi�n (offline)
-----------------------------------------------------------------------
USE [AdventureWorks]
GO

1.1 Presione el bot�n "New Query" o "Database Engine Query"
1.2 En el cuadro de dialogo de conexi�n presione "Cancel"
1.3 Escriba la siguiente instrucci�n

SELECT * FROM Production.Product;
GO

1.4 Presione el bot�n "Connect"
1.5 Seleccione la base de datos AdventureWorks
1.6 Presione "Parse"
1.7 Presione "Execute"
1.8 Presione "Display Estimated Execution Plan"
1.9 Modifique la forma de presentar los resultados y ejecute de nuevo la consulta
   a. "Results to Text"
   b. "Results to Grid"
   c. "Results to File"
1.10 Ocultar el panel de resultados
     Men� Windows, Hide results panel

-----------------------------------------------------------------------
-- 2. Indentaci�n
-----------------------------------------------------------------------
SELECT 
	[BusinessEntityID],
	FirstName, 
	MiddleName, 
	LastName,
	EmailPromotion
FROM Person.Person
WHERE LastName = 'Sanchez';
GO

2.1. Seleccione el texto de [BusinessEntityID] a Phone y presione los botones "Increase Indent" 
     y "Decrease Indent"
2.2. Cambie el tama�o del tabulador con: Men� Tools, Options
2.3. Expanda "Text Editor", "All Languages", "Tabs"
2.4. Escriba 1 en "Tab size" y en "Indent size" 

-----------------------------------------------------------------------
-- 3. Maximizar la ventana
-----------------------------------------------------------------------
SHIFT+ALT+ENTER 

Men� Window, "Auto Hide All" 
Presionar el bot�n "Auto Hide" de cada panel  

-----------------------------------------------------------------------
-- 4. Comentarios
-----------------------------------------------------------------------

-- Comentario de una linea
/*
   Comentario de 
   varias lineas
*/

-----------------------------------------------------------------------
-- 5. Multiples ventanas
-----------------------------------------------------------------------
5.1. Abra una nueva ventana presionando el bot�n "New Query"
5.2. Clic secundario en la pesta�a de una de las ventanas y seleccione 
     "New Horizontal Tab Group"
5.3. Para retornar al estado original, en el men� Window clic en "Move to Next Tab Group"
     o cierre las ventanas.

-----------------------------------------------------------------------
-- 6. Creaci�n de scripts de objetos de base de datos
-----------------------------------------------------------------------
En SQL Server Management Studio puede crear scripts para instrucciones:
 select, insert, update y delete. Tambi�n para create, alter, drop, 
 o ejecutar procediemtos almacenados

6.1. En Object Explorer, expanda el servidor, Databases, la base de datos AdventureWorks2012, 
   Tables, y clic secundario en HumanResources.Employee, y seleccione 
   "Script Table As".
2. Tiene 6 opciones de scripts: de un clic en "SELECT To" y luego un clic en 
   "New Query Editor Window"

-----------------------------------------------------------------------
-- 7. Modo SQLCMD
-----------------------------------------------------------------------
Puede utilizar el editor de consultas, como si fuera la l�nea de comandos, 
 para ejecutar instrucciones con utilidad sqlcmd

7.1. Presione "New Query"
7.2. Presione el bot�n "SQLCMD Mode"
   Las instrucciones ser�n ejecutadas en el contexto de seguridad del editor de consultas
7.3. En la lista desplegable "Available Databases" seleccione AdventureWorks20122012
7.4. Escriba las siguientes instrucciones:
 
			SELECT DISTINCT Type FROM Sales.SpecialOffer;
			GO
			!!DIR
			GO
			SELECT ProductCategoryID, Name
			FROM Production.ProductCategory;
			GO

7.5. Presione <F5> para ejecutar las instrucciones Transact-SQL y MS-DOS
     Dos paneles aparecen con los resultados

Importante:
sqlcmd permite la interacci�n con el sistema operativo.
Cuando use el editor de consultas en modo SQLCMD, no ejecute instrucciones interactivas.
El editor de constultas no tiene la habilidad de responder al prompt del 
sistema operativo.

