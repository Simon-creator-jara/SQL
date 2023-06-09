/* Taller: 1
Instructor: David Echeverri
DB: Norte
Grupo: Daniel González (1039465527), Melissa Rojas (1037597249), Simón Jaramillo (1152225804), Simón Gómez (1017264757)
*/

USE Norte
GO

-- 1. Indique la cantidad de zonas atendidas por cada uno de los empleados, incluso quienes no la tengan. En la salida ilustre el IdEmpleado, y su nombre concatenado.
SELECT E.IdEmpleado, COUNT(EZ.IdZona) AS NumZonas, CONCAT(E.Nombres, ' ', E.Apellidos) AS NombreCompleto FROM dbo.Empleados E
	LEFT JOIN [dbo].[Empleados_Zonas] EZ
	ON E.IdEmpleado = EZ.IdEmpleado
	GROUP BY E.IdEmpleado, CONCAT(E.Nombres, ' ', E.Apellidos)
GO

/*2. Liste la "cantidad" de pedidos asociados a cada despachador discriminados por año, indicando el código del despachador, compañía,
teléfono, año y cantidad (No olvide el PIVOT).
*/
SELECT *
	FROM (SELECT D.IdDespachador, D.Compania, D.Telefono, YEAR(P.FPedido) AS FPed, P.IdPedido FROM dbo.Despachadores D
	LEFT JOIN dbo.Pedidos P
	ON D.IdDespachador = P.IdDespachador) AS DESP
	PIVOT
	(COUNT(IdPedido)
		FOR FPed IN([1996], [1997], [1998])
	) AS Pvt
GO

/* 3. Calcule el promedio de venta de cada producto por año (Realice el ejercicio por valor neto <(Precio*Cantidad)-(Valor del Descuento)>).
Discretizar la salida en rangos Grupo A (0 a 1000 dólares),  Grupo B (1001 a 20000 dólares) y Grupo C (20001 dólares en adelante).
*/
SELECT IdProducto, [1996],
	CASE
		WHEN [1996] <= 1000 THEN 'Grupo A'
		WHEN [1996] > 20000 THEN 'Grupo C'
		ELSE 'Grupo B'
	END AS Grupo1996, [1997], CASE
		WHEN [1997] <= 1000 THEN 'Grupo A'
		WHEN [1997] > 20000 THEN 'Grupo C'
		ELSE 'Grupo B'
	END AS Grupo1997, [1998], CASE
		WHEN [1998] <= 1000 THEN 'Grupo A'
		WHEN [1998] > 20000 THEN 'Grupo C'
		ELSE 'Grupo B'
	END AS Grupo1998
FROM(
SELECT PD.IdProducto, (PD.PrecioUnd * PD.Cantidad)*(1-PD.Descuento) AS PProm, YEAR(P.FPedido) AS FPed  FROM dbo.Pedidos_Detalles PD
	LEFT JOIN dbo.Pedidos P
	ON PD.IdPedido = P.IdPedido) AS Prom
	PIVOT
	(AVG(PProm)
		FOR FPed IN([1996], [1997], [1998])
	) AS Pvt
GO

--4. Liste los 5 y solo los 5 productos más solicitados (Cantidad) en 1998.
SELECT TOP 5 IdProducto, SUM(Cantidad) AS Cant_Total FROM dbo.Pedidos_Detalles Pr
	LEFT JOIN dbo.Pedidos P
	ON P.IdPedido = Pr.IdPedido
	WHERE YEAR(FPedido) = 1998
	GROUP BY IdProducto, YEAR(FPedido)
	ORDER BY 2 DESC
GO

/*5. El usuario requiere una tabla persistente donde se encuentren disponibles los fletes pagados a cada 
Despachador durante los años (FPedido) 1996, 1997 y 1998, la tabla debe contener por lo menos 
el nombre del despachador, el saldo (Sumatoria de Fletes) y el año (Fecha Despacho).*/
SELECT *
INTO FleteDespachadores
FROM (SELECT D.Compania, D.IdDespachador, P.Flete, Year(P.Fpedido) AS Fecha FROM dbo.Despachadores D
	LEFT JOIN dbo.Pedidos P
	ON D.IdDespachador = P.IdDespachador) AS Desp
	PIVOT
	(SUM(Flete)
	FOR Fecha IN([1996], [1997], [1998])
	) AS Pvt
GO

-- 6. Elimine los Despachadores que no tengan pedidos asociados.
BEGIN TRANSACTION
SELECT *
INTO #DespBackup from dbo.Despachadores
DELETE #DespBackup WHERE IdDespachador NOT IN(
	SELECT DISTINCT(D.IdDespachador) FROM dbo.Despachadores D
		RIGHT JOIN dbo.Pedidos P
		ON D.IdDespachador = P.IdDespachador)
IF @@ERROR = 0
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
GO

/*7. El usuario nos solicita que recalculemos para los pedidos de 1998 en lo que respecta al 
saldo por producto, adicionándole un 16% de impuestos (Hacerlo sobre la tabla del punto 5).*/
BEGIN TRANSACTION
UPDATE dbo.FleteDespachadores SET [1998] = ISNULL(([1998] * 1.16),0)
IF @@ERROR = 0
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
GO

--8. Inserte en la tabla regiones (DB Norte) las regiones 6 - Noroccidental y 7 - Nororiental (Con control de transacciones).
BEGIN TRANSACTION
INSERT dbo.Regiones ([IdRegion], [Nombre]) VALUES (6,'Noroccidental')
INSERT dbo.Regiones ([IdRegion], [Nombre]) VALUES (7,'Nororiental')
IF @@ERROR = 0
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
GO

