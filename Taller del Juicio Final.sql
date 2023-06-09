/* 
Parvulitos SQL 

Taller Varios
Docente: David Echeverri
DB: Norte
Nota: Para todos los ejercicios realice construya al final 
el código de prueba para el ejercicio.

Punto 1. 
Construya una función escalar que retorne un cálculo de valor neto.
Ojo: Simplemente debe recibir parámetros cantidad, precio y descuento.
Controle los valores nulos.

Punto 2.
Construya una función tipo tabla que retorne los pedidos 
asociados a un "Empleado" (Parámetro de Entrada IdEmpleado), se debe indicar 
Nombre del Empleado, neto todo el pedido (Función del punto 1) y fecha del mismo (Fpedido).

Punto 3.
Construya una función tipo tabla que retorne el total de las ventas netas por 
Producto, asociados a un "Empleado" (Parámetro de Entrada IdEmpleado) 
indicando Nombre del Empleado y año. Emplee el PIVOT por año. :~

Punto 4. 
Se solicita crear los PA´s (Uno por cada acción) que permitan adicionar, borrar, y editar 
clientes con Try Catch y control de transacciones.
--¡Sí!... son tres USP´s.
	
Punto 5.
Crear una vista con Opción de Chequeo para adicionar Empleados con código 
máximo de idempleado 20... (Se me olvido cómo se hace...)	  

Punto 6
Construya una vista que permita observar el promedio de los fletes asociados a cada mes 
del año 1997 (Columnas) por despachador asociado (Filas).

Punto 7
Construya XXXXXXX (No tengo la menor idea) que permita crear de forma dinámica 
una tabla que contenga los valores sumarizados de los pedidos por cada año.
La tabla debe contener: 

IdCliente, IdEmpleado, IdDespachador, ValorNeto, Flete, ValorBruto, ValorDescuento 
La tabla debe quedar disponible al cerrar la conexión (Persistente).

Punto 8 
Construya una función tipo tabla que retorne los productos que no se vendieron en un año especifico.

Punto 9.
Construya una consulta que permita encontrar el neto mínimo, máximo y promedio de un empleado
durante un año especifico. (Ejemplo 1997). Emplee PIVOT.
(Neto a nivel de Pedido)

Punto 10.
Se solicita crear un PA que entregue el total (Cantidad) y valor (Neto) de los pedidos asociados a 
un empleado en un año determinado como parámetro de salida. 

Punto 11.
Construya un procedimiento almacenado que retorne un cálculo de valor neto.
Ojo: Simplemente debe recibir parámetros cantidad, precio y descuento.
Debe contar con parámetro de salida que indique el Neto
Controle los valores nulos.

Punto 12.
Construya una función tipo tabla que entregue según un parámetro de categoría las ventas por Regiones (Columnas)
y Productos (Filas)
Controle los valores nulos.

Punto 13.
Construya un procedimiento almacenado que sea capaz de capturar los errores de ejecución de un código SQL 
y los almacene en una tabla de Errores en la DB Norte. 
La estructura debe almacenar:
	ERROR_NUMBER_STR,
	ERROR_SEVERITY_STR,
	ERROR_STATE_STR,
	ERROR_PROCEDURE_STR,
	ERROR_LINE_STR,
	ERROR_MESSAGE_STR,
	FECHA_EJECUCION_DATE,
	USUARIO_STR
Controle los valores nulos.

Punto 14.
Construya una función tipo escalar que si encuentra en un texto (Parámetro de entrada) 
"PAO, PAO, FEO, FEO" lo reemplace por "Jejejeje".

Punto 15.
Construya una función tipo escalar que retorne entre el 5 y 10 caracteres de una cadena string de 15 posiciones.

Punto 16:
Dudas del público. 

#ChuchoChuchoEnQueMeMeti
*/


/*Punto 1. 
Construya una función escalar que retorne un cálculo de valor neto.
Ojo: Simplemente debe recibir parámetros cantidad, precio y descuento.
Controle los valores nulos.*/

USE Norte
GO

CREATE OR ALTER FUNCTION dbo.calculoNeto(@Cantidad int, @Precio int, @Descuento decimal)
RETURNS decimal

AS
BEGIN 
	DECLARE @Resultado int;
	IF (@Precio IS NULL)
		SET @Resultado=0
	ELSE
		SET @Resultado = (@Cantidad*@Precio)*(1-@Descuento)

	RETURN @Resultado
END 
GO

SELECT Cantidad,PrecioUnd,Descuento,dbo.calculoNeto(Cantidad,PrecioUnd,Descuento) AS Valor_Neto FROM dbo.Pedidos_Detalles
GO


/*Punto 2.
Construya una función tipo tabla que retorne los pedidos 
asociados a un "Empleado" (Parámetro de Entrada IdEmpleado), se debe indicar 
Nombre del Empleado, neto todo el pedido (Función del punto 1) y fecha del mismo (Fpedido).*/


CREATE OR ALTER FUNCTION dbo.FunPedidos(@IdEmpleado  int)
RETURNS table 

AS

	RETURN (
	SELECT t2.Nombres AS Nombre, dbo.calculoNeto(t3.Cantidad,t3.PrecioUnd,t3.Descuento) AS Neto, t1.FPedido AS FPedido 
	FROM dbo.Pedidos as t1 LEFT JOIN
	dbo.Empleados as t2 ON (t1.IdEmpleado=t2.IdEmpleado) 
	LEFT JOIN dbo.Pedidos_Detalles as t3 on (t1.IdPedido=t3.IdPedido)
	WHERE t1.IdEmpleado=@IdEmpleado
	)
GO


SELECT * FROM dbo.FunPedidos(3)
GO


/*Punto 3.
Construya una función tipo tabla que retorne el total de las ventas netas por 
Producto, asociados a un "Empleado" (Parámetro de Entrada IdEmpleado) 
indicando Nombre del Empleado y año. Emplee el PIVOT por año. :~*/


CREATE OR ALTER FUNCTION dbo.groupSell(@IdEmpleado int)
RETURNS table 
AS 
	RETURN(
	SELECT * FROM 
	(Select t1.IdProducto AS PROD,(t1.Cantidad*t1.PrecioUnd)*(1-t1.Descuento) AS VALOR,year(t2.FPedido) AS ANIO, t3.Nombres AS NOMBRE
	FROM dbo.Pedidos_Detalles AS t1 LEFT JOIN dbo.Pedidos AS t2 ON (t1.IdPedido=t2.IdPedido) LEFT JOIN dbo.Empleados AS t3 ON (t2.IdEmpleado=t3.IdEmpleado)
	WHERE t3.IdEmpleado=@IdEmpleado
	) AS f1
	PIVOT
	(
		SUM(VALOR)
		FOR ANIO IN([1996], [1997], [1998])
	) AS f2)
GO

SELECT *
FROM dbo.groupSell(3)
GO

/*Punto 4. 
Se solicita crear los PA´s (Uno por cada acción) que permitan adicionar, borrar, y editar 
clientes con Try Catch y control de transacciones.
--¡Sí!... son tres USP´s.*/

CREATE OR ALTER PROCEDURE dbo.borrar  
@row nchar(5) =NULL
AS

 BEGIN TRY
 BEGIN TRANSACTION;

 DELETE dbo.Clientes WHERE IdCliente=@row;
 COMMIT TRANSACTION; 
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() as IdError, ERROR_MESSAGE() as Error;




 IF (XACT_STATE()) = -1 
 BEGIN
  PRINT 'Transacción en estado no cometido. La transacción será reversada.'
  ROLLBACK TRANSACTION;
 END;
 ELSE IF (XACT_STATE()) = 1 
 BEGIN
  PRINT 'La transacción puede ser cometida. Se hará un commit.'
  COMMIT TRANSACTION;   
 END;
END CATCH;
GO

CREATE OR ALTER PROCEDURE dbo.adicion 
@IdCliente nchar(5) =NULL,
@Compania nvarchar(40) =NULL,
@ContactoNombre nvarchar(30) = NULL,
@ContactoTitulo nvarchar(30) = NULL,
@Direccion nvarchar(60) =NULL,
@Ciudad nvarchar(15) =NULL,
@region nvarchar(15) = NULL,
@Pais nvarchar(15) = NULL,
@Telefono nvarchar(24) = NULL,
@fax nvarchar(24) = NULL
AS

 BEGIN TRY
 BEGIN TRANSACTION;

 INSERT dbo.Clientes 
(IdCliente, Compania, ContactoNombre, ContactoTitulo,
                  Direccion, Ciudad, region, Pais, Telefono, fax)
VALUES (@IdCliente, @Compania, @ContactoNombre, @ContactoTitulo,
                  @Direccion, @Ciudad, @region, @Pais, @Telefono, @fax)
 COMMIT TRANSACTION; 
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() as IdError, ERROR_MESSAGE() as Error;




 IF (XACT_STATE()) = -1 
 BEGIN
  PRINT 'Transacción en estado no cometido. La transacción será reversada.'
  ROLLBACK TRANSACTION;
 END;
 ELSE IF (XACT_STATE()) = 1 
 BEGIN
  PRINT 'La transacción puede ser cometida. Se hará un commit.'
  COMMIT TRANSACTION;   
 END;
END CATCH;
GO


CREATE OR ALTER PROCEDURE dbo.editar
@IdCliente nchar(5) ,
@Compania nvarchar(40) ,
@ContactoNombre nvarchar(30) ,
@ContactoTitulo nvarchar(30) ,
@Direccion nvarchar(60) ,
@Ciudad nvarchar(15) ,
@region nvarchar(15) ,
@Pais nvarchar(15) ,
@Telefono nvarchar(24),
@fax nvarchar(24)
AS

 BEGIN TRY
 BEGIN TRANSACTION;

 UPDATE dbo.Clientes 
 SET 
 Compania=@Compania, 
 ContactoNombre=@ContactoNombre, 
 ContactoTitulo=@ContactoTitulo,
 Direccion=@Direccion, 
 Ciudad=@Ciudad, 
 Region=@Region, 
 Pais=@Pais, 
 Telefono=@Telefono, 
 Fax=@Fax
 WHERE IdCliente=@IdCliente
 COMMIT TRANSACTION; 
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() as IdError, ERROR_MESSAGE() as Error;




 IF (XACT_STATE()) = -1 
 BEGIN
  PRINT 'Transacción en estado no cometido. La transacción será reversada.'
  ROLLBACK TRANSACTION;
 END;
 ELSE IF (XACT_STATE()) = 1 
 BEGIN
  PRINT 'La transacción puede ser cometida. Se hará un commit.'
  COMMIT TRANSACTION;   
 END;
END CATCH;
GO


Exec dbo.adicion   'TRI', 'TRI SOLUTIONS','AQUINALDO ISASERE',
        'Gerente', 'Dir Empresa', 'Vancouver', 'BC',
        'Canada', '(200) 555-3392', '(200) 555-7293'
GO

Exec dbo.editar 'Tri','Si','AQUINALDO ISASERE',
        'Gerente', 'Dir Empresa', 'Vancouver', 'BC',
        'Canada', '(200) 555-3392', '(200) 555-7293'
GO

Exec dbo.borrar  'TRI'
GO

/*Punto 5.
Crear una vista con Opción de Chequeo para adicionar Empleados con código 
máximo de idempleado 20... (Se me olvido cómo se hace...)	*/


CREATE OR ALTER VIEW dbo.vEmpleados
AS
 SELECT IdEmpleado, Apellidos, Nombres, Cargo, TituloCortesia, FCumpleanos, FContrato, Direccion, Ciudad, Region, Pais, TelCasa, Extension, Foto, Notas, Reporta_A,
  RutaFoto
  FROM dbo.Empleados
  WHERE CAST(IdEmpleado AS INT) <= 20
  WITH CHECK OPTION;
GO

INSERT INTO dbo.vEmpleados (IdEmpleado, Apellidos, Nombres, Cargo, TituloCortesia, FCumpleanos, FContrato, Direccion, Ciudad, Region, Pais, TelCasa, Extension, Foto, Notas, Reporta_A,
  RutaFoto)
 VALUES(21, 'J', 'Andres', 'Pres', 'A', NULL, NULL, 'Calle 33', 'Medellin', 'Antioquia', 'Colombia', '3214345','321',NULL,NULL,NULL,NULL);
 GO


/*Punto 6
Construya una vista que permita observar el promedio de los fletes asociados a cada mes 
del año 1997 (Columnas) por despachador asociado (Filas).	*/

CREATE OR ALTER VIEW dbo.fDespachador
AS

SELECT * FROM 
(SELECT t2.IdDespachador AS Despachador, t1.Flete AS Flete, month(t1.FPedido) AS Mes FROM dbo.Pedidos AS t1 LEFT JOIN 
dbo.Despachadores AS t2 ON (t1.IdDespachador=t2.IdDespachador)
WHERE year(t1.FPedido)=1997) AS t1
PIVOT 
(AVG(Flete)
FOR Mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS t2
GO

SELECT * FROM dbo.fDespachador
GO

/*Punto 7
Construya XXXXXXX (No tengo la menor idea) que permita crear de forma dinámica 
una tabla que contenga los valores sumarizados de los pedidos por cada año.
La tabla debe contener: 

IdCliente, IdEmpleado, IdDespachador, ValorNeto, Flete, ValorBruto, ValorDescuento 
La tabla debe quedar disponible al cerrar la conexión (Persistente).*/



/*Punto 8 
Construya una función tipo tabla que retorne los productos que no se vendieron en un año especifico.*/

CREATE OR ALTER FUNCTION dbo.noVendidos(@Anio int)
RETURNS table 
AS

RETURN (SELECT IdProducto FROM dbo.Productos WHERE IdProducto NOT IN (SELECT DISTINCT t2.IdProducto FROM dbo.Pedidos AS t1 LEFT JOIN dbo.Pedidos_Detalles AS t2 on (t1.IdPedido=t2.IdPedido)
WHERE year(t1.FPedido)=@Anio))

GO

SELECT *
FROM dbo.noVendidos(1996)
GO

/*Punto 9.
Construya una consulta que permita encontrar el neto mínimo, máximo y promedio de un empleado
durante un año especifico. (Ejemplo 1997). Emplee PIVOT.
(Neto a nivel de Pedido)*/

CREATE OR ALTER FUNCTION dbo.NetoAnio(@Anio int)
RETURNS table 
AS
RETURN(
WITH minimo AS (SELECT * FROM 
(SELECT t2.IdEmpleado AS IdEmpleado,(t1.Cantidad*t1.PrecioUnd)*(1-t1.Descuento) AS Neto, year(t2.FPedido) AS FPed
FROM dbo.Pedidos_Detalles AS t1 LEFT JOIN dbo.Pedidos AS t2
ON (t1.IdPedido= t2.IdPedido) WHERE year(t2.FPedido)=@Anio) AS t1
PIVOT 
(MIN(Neto)
FOR FPed IN ([1996],[1997],[1998])
) AS t2),

maximo AS(SELECT * FROM 
(SELECT t2.IdEmpleado AS IdEmpleado,(t1.Cantidad*t1.PrecioUnd)*(1-t1.Descuento) AS Neto, year(t2.FPedido) AS FPed
FROM dbo.Pedidos_Detalles AS t1 LEFT JOIN dbo.Pedidos AS t2
ON (t1.IdPedido= t2.IdPedido) WHERE year(t2.FPedido)=@Anio) AS t1
PIVOT 
(MAX(Neto)
FOR FPed IN ([1996],[1997],[1998])
) AS t2),

promedio AS(SELECT * FROM 
(SELECT t2.IdEmpleado AS IdEmpleado,(t1.Cantidad*t1.PrecioUnd)*(1-t1.Descuento) AS Neto, year(t2.FPedido) AS FPed
FROM dbo.Pedidos_Detalles AS t1 LEFT JOIN dbo.Pedidos AS t2
ON (t1.IdPedido= t2.IdPedido) WHERE year(t2.FPedido)=@Anio) AS t1
PIVOT 
(AVG(Neto)
FOR FPed IN ([1996],[1997],[1998])
) AS t2)


SELECT t1.[IdEmpleado] AS IdEmpleado, t1.[1996] AS MIN_1996, t1.[1997] AS MIN_1997, t1.[1998] AS MIN_1998, t2.[1996] AS MAX_1996, t2.[1997] AS MAX_1997, t2.[1998] AS MAX_1998,t3.[1996] AS AVG_1996, t3.[1997] AS AVG_1997, t3.[1998] AS AVG_1998
FROM minimo AS t1 LEFT JOIN maximo AS t2 ON (t1.IdEmpleado=t2.IdEmpleado) LEFT JOIN promedio AS t3 ON (t1.IdEmpleado=t3.IdEmpleado)
)
GO
SELECT *
FROM dbo.NetoAnio(1996)
GO




/*Punto 10.
Se solicita crear un PA que entregue el total (Cantidad) y valor (Neto) de los pedidos asociados a 
un empleado en un año determinado como parámetro de salida. */


CREATE OR ALTER PROCEDURE dbo.qValue
@Anio int,
@cant int output,
@neto decimal(10,3) output
AS
	SET NOCOUNT ON;
	WITH s as(SELECT t2.IdEmpleado,count(t1.IdPedido) as suma, SUM((t1.Cantidad*t1.PrecioUnd)*(1-t1.Descuento)) As Neto,year(t2.FPedido) AS Anio FROM dbo.Pedidos_Detalles AS t1 
	LEFT JOIN dbo.Pedidos AS t2 ON (t1.IdPedido=t2.IdPedido)
	WHERE year(t2.FPedido)=@Anio
	GROUP BY t2.IdEmpleado,year(t2.FPedido))
	Select @cant=t.suma, @neto=t.Neto from s as t

	return 

GO
DECLARE @cant int, @neto decimal(10,3)

EXECUTE dbo.qValue
    1996, @cant = @cant OUTPUT,@neto=@neto output

print(cast(@neto as varchar(255)))

GO

/*Punto 11.
Construya un procedimiento almacenado que retorne un cálculo de valor neto.
Ojo: Simplemente debe recibir parámetros cantidad, precio y descuento.
Debe contar con parámetro de salida que indique el Neto
Controle los valores nulos. */

CREATE OR ALTER PROCEDURE dbo.Neto 
@Cantidad int,
@Precio int, 
@Descuento decimal(10,3)
AS
	DECLARE @Resultado int
	BEGIN
	IF (@Precio IS NULL) OR (@Cantidad IS NULL)
		SET @Resultado =0
	ELSE
		SET @Resultado = (@Cantidad*@Precio)*(1-@Descuento)

	PRINT(@Resultado)
	RETURN @Resultado
	
	END
	
GO
Exec dbo.Neto NULL,1000,0.2
GO

/*Punto 12.
Construya una función tipo tabla que entregue según un parámetro de categoría las ventas por Regiones (Columnas)
y Productos (Filas)
Controle los valores nulos.
*/


CREATE OR ALTER FUNCTION dbo.vRegiones (@Categoria int)
RETURNS table 
AS 
RETURN(
SELECT IdProducto,ISNULL(Oriente,0) AS Oriente ,ISNULL(Occidente,0) AS Occidente ,ISNULL(Norte,0) AS Norte ,ISNULL(Sur,0) AS Sur FROM 
(SELECT t1.IdProducto AS IdProducto, (t2.PrecioUnd*t2.Cantidad)*(1-t2.Descuento) AS Neto,t7.Nombre AS Nombre
FROM dbo.Productos AS t1 LEFT JOIN dbo.Pedidos_Detalles AS t2 ON (t1.IdProducto=t2.IdProducto) LEFT JOIN dbo.Categorias AS t3 ON (t1.IdCategoria=t3.IdCategoria)
LEFT JOIN dbo.Pedidos AS t4 ON (t4.IdPedido=t2.IdPedido) LEFT JOIN dbo.Empleados_Zonas AS t5 ON (t4.IdEmpleado=t5.IdEmpleado)
LEFT JOIN dbo.Zonas AS t6 ON (t6.IdZona=t5.IdZona) LEFT JOIN dbo.Regiones AS t7 ON (t6.IdRegion=t7.IdRegion)
WHERE t3.IdCategoria=@Categoria) AS t1
PIVOT
(SUM(Neto)
FOR Nombre IN ([Oriente],[Occidente],[Norte],[Sur])
) AS t2)

GO

SELECT *
FROM dbo.vRegiones(3)
GO

/*Punto 13.
Construya un procedimiento almacenado que sea capaz de capturar los errores de ejecución de un código SQL 
y los almacene en una tabla de Errores en la DB Norte. 
La estructura debe almacenar:
	ERROR_NUMBER_STR,
	ERROR_SEVERITY_STR,
	ERROR_STATE_STR,
	ERROR_PROCEDURE_STR,
	ERROR_LINE_STR,
	ERROR_MESSAGE_STR,
	FECHA_EJECUCION_DATE,
	USUARIO_STR
Controle los valores nulos.
*/
CREATE OR ALTER PROCEDURE spGetError_Informacion 
AS

  INSERT INTO dbo.ERRORES (IdError,Severidad,Estado,Procedencia,Linea,MensajeError)
  VALUES (ISNULL(ERROR_NUMBER(),'Sin ERROR'),ISNULL(ERROR_SEVERITY(),'Sin ERROR'),ISNULL(ERROR_STATE(),'Sin ERROR'),ISNULL(ERROR_PROCEDURE(),'Sin ERROR'),ISNULL(ERROR_LINE(),'Sin ERROR'),ISNULL(ERROR_MESSAGE(),'Sin ERROR'))
GO


BEGIN TRY
 SELECT 1/0; -- División por cero (0) que genera error
END TRY
BEGIN CATCH
 EXECUTE spGetError_Informacion; -- Llamar rutina de notificación de error
END CATCH;
GO

/*Punto 14.
Construya una función tipo escalar que si encuentra en un texto (Parámetro de entrada) 
"PAO, PAO, FEO, FEO" lo reemplace por "Jejejeje".
*/

CREATE OR ALTER FUNCTION dbo.compare(@param varchar(255))
RETURNS VARCHAR(255)
AS
BEGIN
	Declare @compare varchar(255), @Resul varchar(255)
	set @param=ltrim(rtrim(@param))
	set @compare='%PAO, PAO, FEO, FEO%'

	IF ( UPPER(@param) like UPPER(@compare))
		SET @Resul=REPLACE(@param,'PAO, PAO, FEO, FEO','Jejejeje')
	ELSE
		SET @Resul=@param
	RETURN @Resul
END
GO

SELECT dbo.compare('NO pao, pao, feo, feo HOLA')
GO

/*Punto 15.
Construya una función tipo escalar que retorne entre el 5 y 10 caracteres de una cadena string de 15 posiciones.
*/

CREATE OR ALTER FUNCTION dbo.cutString(@param VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @Result VARCHAR(255)
	SET @param=rtrim(ltrim(@param))


	IF (LEN(@param)>=15)
		
		SET @Result=SUBSTRING(@param,5,6)
	ELSE
		SET @Result='ERROR: parámetro debe ser >= 15'

	RETURN @Result
END
GO

SELECT dbo.cutString('                    V')
GO
