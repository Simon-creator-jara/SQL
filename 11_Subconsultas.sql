--*********************************************************************
-- LABORATORIO SUBCONSULTAS
-- INSTRUCTOR: David Esteban Echverri
-----------------------------------------------------------------------
- Este laboratorio será por el alumno sin la supervisión del instructor.

-----------------------------------------------------------------------
-- 1. Subconsulta como una expresión
-----------------------------------------------------------------------
1.1 Precio de todos los productos, mountain bike, el precio promedio y la diferencia
    entre el precio y el precio promedio

USE AdventureWorks;
GO
SELECT Name, ListPrice, 
  (SELECT AVG(ListPrice) FROM Production.Product) AS Average, 
   ListPrice - (SELECT AVG(ListPrice) FROM Production.Product) AS Difference
 FROM Production.Product
 WHERE ProductSubcategoryID = 1

-----------------------------------------------------------------------
-- 2. Subconsulta que utilizan operadores de comparación 
-----------------------------------------------------------------------
2.1 Nombre de los productos cuyo precio es mayor que el precio promedio de lista.

Use AdventureWorks
SELECT Name
 FROM Production.Product
 WHERE ListPrice >
     (SELECT AVG (ListPrice)
       FROM Production.Product)
 
-----------------------------------------------------------------------
-- 3. Subconsulta que utiliza IN y NOT IN
-----------------------------------------------------------------------
3.1 Listar los nombres de los productos que pertenezcan a la subcategoría 
    de bicicletas (Wheels) 

USE AdventureWorks;
GO
SELECT Name 
 FROM Production.Product
 WHERE ProductSubcategoryID IN
     (SELECT ProductSubcategoryID
       FROM Production.ProductSubcategory
       WHERE Name = 'Wheels')

3.2 Igual al anterior, pero usando EXISTS

USE AdventureWorks;
GO
SELECT Name
FROM Production.Product
WHERE EXISTS
    (SELECT * 
     FROM Production.ProductSubcategory
     WHERE ProductSubcategoryID = 
            Production.Product.ProductSubcategoryID AND Name = 'Wheels')
 
-----------------------------------------------------------------------
-- 4. Usando las clausulas EXISTS y NOT EXISTS en subconsultas
-----------------------------------------------------------------------
4.1 Subconsulta correlacionada con el operador EXISTS en el WHERE
    para retornar una lista de empleados con pedidos en el 4/10/2000.

USE Norte
SELECT Apellidos, IdEmpleado
 FROM Empleados AS E
 WHERE EXISTS ( SELECT * FROM Pedidos AS P
                 WHERE E.IdEmpleado = P.IdEmpleado
                  AND P.FPedido = '9/5/1997' )

4.2 Igual resultado al anterior pero usando un join en lugar de  Subconsulta correlacionada
    Note el uso de DISTINCT para retornar una sola fila por cada empleado.

USE Norte
SELECT DISTINCT Apellidos, E.IdEmpleado
 FROM Pedidos AS P
 INNER JOIN Empleados AS E ON P.IdEmpleado = E.IdEmpleado
 WHERE P.FPedido = '9/5/1997'

-----------------------------------------------------------------------
---- 5. Uso de ANY en subconsultas
-------------------------------------------------------------------------
--5.1 Productos cuya precio de lista es mayor o igual que el máximo precio de 
--    cualquier subcategoría

--USE AdventureWorks;
--GO
--SELECT Name
-- FROM Production.Product
-- WHERE ListPrice >= ANY
--    (SELECT MAX (ListPrice)
--      FROM Production.Product
--      GROUP BY ProductSubcategoryID)

--5.2 Encontrar los clientes localizados en un territorio no cubierto por ningun vendedor

--Use AdventureWorks;
--GO
--SELECT CustomerID
-- FROM Sales.Customer
-- WHERE TerritoryID <> ANY
--    (SELECT TerritoryID
--     FROM Sales.SalesPerson)

-------------------------------------------------------------------------
---- 6. Subconsulta correlacionada
-------------------------------------------------------------------------
--6.1 Retornar el nombre y apellido de las personas que tiene un bono de 5000

--USE AdventureWorks;
--GO
--SELECT DISTINCT c.LastName, c.FirstName 
-- FROM Person.Person c JOIN HumanResources.Employee e ON e.BusinessEntityID = c.BusinessEntityID
-- WHERE 5000 = 
--      (SELECT Bonus
--        FROM Sales.SalesPerson sp
--        WHERE e.BusinessEntityID = sp.BusinessEntityID);
 
--6.3  Lista de productos y la mayor cantidad vendida
--     Note que esta Subconsulta correlacionada referencia la misma tabla
--     en la consulta externa; el optimizador generalmente trata esto como un join a si mismo

--USE Norte
--SELECT DISTINCT IdProducto, Cantidad
-- FROM Pedidos_Detalles AS PD1
-- WHERE Cantidad = (SELECT MAX(Cantidad)
--                     FROM Pedidos_Detalles AS PD2
--                     WHERE PD1.IdProducto = PD2.IdProducto)

-------------------------------------------------------------------------
---- 7. Imitar un Join
-------------------------------------------------------------------------
--7.1 Empleados que tienen el mismo jefe que Terri Duffy (Id = 12)

--USE AdventureWorks;
--GO
--SELECT e1.BusinessEntityID As IsEmpleado, e1.BusinessEntityID As IdJefe
-- FROM HumanResources.Employee AS e1
-- WHERE e1.BusinessEntityID =
--      (SELECT e2.BusinessEntityID
--       FROM HumanResources.Employee AS e2
--       WHERE e2.BusinessEntityID = 12)

--7.2 Similar al caso anterior, pero usando un Join
--USE AdventureWorks;
--GO
--SELECT e1.BusinessEntityID As IsEmpleado, e1.BusinessEntityID As IdJefe
-- FROM HumanResources.Employee AS e1
-- INNER JOIN HumanResources.Employee AS e2 
-- ON e1.BusinessEntityID = e2.BusinessEntityID AND e2.BusinessEntityID = 12

-------------------------------------------------------------------------
---- 8. Subconsultas en UPDATE, DELETE e INSERT 
-------------------------------------------------------------------------
--8.1 Aumentar en un 10% el valor de la lista de precios, para productos registrados en la tabla 
--    de compras cuyo proveedor sea el vendedor = 51 

--USE AdventureWorks;
--GO 
--UPDATE Production.Product SET ListPrice = ListPrice * 1.1
-- WHERE ProductID IN
--    (SELECT ProductID 
--      FROM Purchasing.ProductVendor
--      WHERE BusinessEntityID = 51);
--GO

--8.2 Igual al anterior, pero utilizando un join

--USE AdventureWorks;
--GO 
--UPDATE Production.Product SET ListPrice = ListPrice * 1.1
-- FROM Production.Product AS p
-- INNER JOIN Purchasing.ProductVendor AS pv
-- ON p.ProductID = pv.ProductID AND pv.BusinessEntityID = 51;
--GO


 

 
