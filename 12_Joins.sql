--*********************************************************************
-- LABORATORIO JOINS
-- INSTRUCTOR: David Esteban Echverri
-----------------------------------------------------------------------
- Este laboratorio será por el alumno sin la supervisión del instructor.

-----------------------------------------------------------------------
-- 1. Uso de Alias para nombres de tabla
-----------------------------------------------------------------------
1.1  Muestra los nombres de Compañia, IdCliente, y la cantidad vendida
     de las tablas de clientes y ventas.  No se usa alias en el Join

USE Norte
SELECT 
	Compania, 
	Pedidos.IdCliente, 
	Cantidad
 FROM 
	Clientes 
		INNER JOIN Pedidos 
			ON Clientes.IdCliente = Pedidos.IdCliente
		INNER JOIN Pedidos_Detalles 
			ON Pedidos.IdPedido = Pedidos_Detalles.IdPedido
GO

1.2 Igual al anterior, pero usando alias en el Join
USE Norte
SELECT Compania, P.IdCliente, PD.Cantidad
 FROM Clientes AS C INNER JOIN Pedidos AS P ON C.IdCliente = P.IdCliente
 INNER JOIN Pedidos_Detalles AS PD ON P.IdPedido = PD.IdPedido
GO

-----------------------------------------------------------------------
-- 2. Usando Inner Joins
-----------------------------------------------------------------------
2.1  Nombres de los productos y las compañías que los suministran.
     Productos sin proveedor y proveedores sin producnos no serán listados

USE Norte
SELECT Nombre, Compania
 FROM Productos INNER JOIN Proveedores 
 ON Productos.IdProveedor = Proveedores.IdProveedor

2.2 Nombre de los clientes que hayan realizado pedidos después del 1/1/98.

USE Norte
SELECT DISTINCT Compania, FPedido
 FROM Pedidos As P INNER JOIN Clientes As C ON P.IdCliente = C.IdCliente
 WHERE convert(datetime, FPedido, 120) > '1998-01-15'

-----------------------------------------------------------------------
-- 3. Usando Outer Joins
-----------------------------------------------------------------------
3.1 Muestra los nombres de Cliente, IdCliente, y la cantidad vendida
    Note que los Clientes quienes no hayan comprado algún producto son listados,
    pero valores nulos aparecen en algunas columnas

USE Norte
SELECT 
	Compania, 
	P.IdCliente, 
	PD.Cantidad
 FROM Clientes As C 
		LEFT JOIN Pedidos As P 
			ON C.IdCliente = P.IdCliente
		INNER JOIN Pedidos_Detalles AS PD 
			ON P.IdPedido = PD.IdPedido

3.2 Lista los clientes que tengan pedidos.  Recupera una fila por cada cliente
    (aunque no tengan pedidos) y filas adicionales para clientes con multiples pedidos

USE Norte
SELECT Compania, C.IdCliente, FPedido 
 FROM Clientes As C LEFT JOIN Pedidos As P ON C.IdCliente = P.IdCliente
GO

3.3 Incluir todos los vendedores en el conjunto de resultados, aunque no estén 
    asignados a un territorio

USE AdventureWorks;
GO
SELECT st.Name AS Territorio, sp.[BusinessEntityID] As IdVendedor
 FROM Sales.SalesTerritory st 
 RIGHT JOIN Sales.SalesPerson sp
 ON st.TerritoryID = sp.TerritoryID
 ORDER BY st.Name;
 
3.4 Retornar los productos que no tengan pedidos y los pedidos que el código de producto 
    no case con un producto

USE AdventureWorks;
-- OUTER seguido de la palabra FULL es opcional
SELECT p.Name, sod.SalesOrderID
 FROM Production.Product p
 FULL OUTER JOIN Sales.SalesOrderDetail sod
 ON p.ProductID = sod.ProductID
 WHERE p.ProductID IS NULL OR sod.ProductID IS NULL
 ORDER BY p.Name ;

-----------------------------------------------------------------------
-- 4. Usando Cross Joins
-----------------------------------------------------------------------
4.1 Lista todas las posibles combinaciones de las dos columnas

USE Norte
SELECT Compania, Categorias.Nombre
 FROM Clientes CROSS JOIN Categorias
GO

-----------------------------------------------------------------------
-- 5. Unir una tabla a si misma
-----------------------------------------------------------------------
5.1 Lista de pares de empleados que tengan el mismo trabajo
    Cuando el WHERE incluye el operador menor que (<),
    filas que casan con si misma y filas duplicadas son eliminadas. 

USE Norte
SELECT a.IdEmpleado, LEFT(a.Apellidos,10) As Apellidos,
 LEFT(a.Cargo,10) AS Cargo,
 b.IdEmpleado, LEFT(b.Apellidos,10) AS Apellidos,
 LEFT(b.Cargo,10) AS Cargo
 FROM Empleados AS a
 INNER JOIN Empleados AS b ON a.Cargo = b.Cargo
 WHERE a.IdEmpleado < b.IdEmpleado
GO

5.2 Encontrar las filas en la tabla ProductVendor en la cual dos más filas tienen el 
    mismo ProductID pero diferente VendorID (esto es, productos con mas de un vendedor)

USE AdventureWorks;
GO
SELECT DISTINCT p1.[BusinessEntityID], p1.ProductID
FROM Purchasing.ProductVendor p1
    INNER JOIN Purchasing.ProductVendor p2
    ON p1.ProductID = p2.ProductID
WHERE p1.[BusinessEntityID] <> p2.[BusinessEntityID]
ORDER BY p1.[BusinessEntityID]

-----------------------------------------------------------------------
-- 6. Combinando multiples conjuntos de resultados con UNION
-----------------------------------------------------------------------
USE Norte
SELECT (Nombres + ' ' + Apellidos) AS Nombre, Ciudad FROM Empleados
UNION ALL
SELECT Compania, Ciudad FROM Clientes
GO
 
 
