/*
Simon Gomez Montoya CC: 1017264757
Simon Jaramillo Vellez CC: 1152225804
*/

USE Norte
GO

-- 1. Identifique los ID de pedidos del año 1998

SELECT IdPedido
	FROM dbo.Pedidos 
	WHERE year(FPedido)='1998'
GO

-- 2. Liste los nombres de los despachadores sin duplicados

SELECT DISTINCT Compania
	FROM dbo.Despachadores
GO

-- 3. Liste los empleados (id, nombres+apellidos) y los clientes (id,compania) en un solo set de datos

SELECT convert(nchar,IdEmpleado) as Id, concat(Nombres,Apellidos) as Nombre
	FROM dbo.Empleados
	UNION ALL
SELECT IdCliente,Compania
	FROM dbo.Clientes
GO

-- 4. Liste los 5 primeros registros de venta neta más altos en la table Pedidos_Detalle

SELECT TOP 5 IdPedido,IdProducto,PrecioUnd,Cantidad,Descuento, (Cantidad*PrecioUnd*(1-Descuento)) AS VentaNeta
	FROM dbo.Pedidos_Detalles
	ORDER BY 6 DESC
GO

--5 Indique los despachadores (Id y Nombres) que tienen pedidos en el año 1997

SELECT DISTINCT t1.IdDespachador, t1.Compania
	FROM dbo.Despachadores AS t1 
	LEFT JOIN dbo.Pedidos AS t2 ON (t1.IdDespachador=t2.IdDespachador)
	WHERE year(t2.FPedido)='1997'
GO

SELECT DISTINCT t1.IdDespachador, t1.Compania
	FROM dbo.Despachadores AS t1 
	WHERE t1.IdDespachador IN (SELECT t2.IdDespachador FROM dbo.Pedidos AS t2 WHERE year(t2.FPedido)='1997')
GO



