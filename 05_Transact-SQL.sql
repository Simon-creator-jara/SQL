--*********************************************************************
-- LABORATORIO INTRODUCCIÓN A TRANSACT-SQL
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado por los alumnos, cosulte al instructor  
  si no entiende el código que está ejecutando.
- Seleccione las instrucciones y ejecutelas por partes, observe los resultados 

-----------------------------------------------------------------------
-- 1. Definición de variables
-----------------------------------------------------------------------
Use AdventureWorks
GO

-- Declaracion de variables
DECLARE  @Id smallint, @sNombre varchar(50)

-- Asignación usando SET 
SET @Id = 1;

-- Asignación usando SELECT
SELECT @sNombre = Name FROM [HumanResources].[Department]
 WHERE DepartmentID = @Id;

-- Imprimir resultado con SELECT
SELECT @sNombre AS 'Departamento'

-- Imprimir resultados con Print (note que debe convertir la variable numérica a varchar)
PRINT 'IdDepto: ' + CONVERT(varchar, @Id)
PRINT 'Nombre: ' + @sNombre
GO 

-----------------------------------------------------------------------
-- 2. Instrucciones de control de flujo
-----------------------------------------------------------------------
2.1 Uso de IF...ELSE, uso de Begin ... End, uso de RETURN
Al ejecutar la siguiente instrucción obtiene un error.
¿Qué debe escribir para que el batch de instrucciones pueda ser ejecutado?

Declare @iError int
SET @iError = @@ERROR

IF (@iError = 0)
BEGIN
 PRINT 'Ningun error encontrado. Las transacciones serán cometidas.'
 COMMIT
END
ELSE
BEGIN
 PRINT 'Error encontrado. Las transacciones serán reversadas.'
 PRINT 'IdError: ' + CONVERT(varchar(10), @iError)
 ROLLBACK
END
RETURN 
GO

2.2 Uso de GoTo

IF (SELECT SYSTEM_USER) = 'Nomina'
   GOTO Etiqueta_Salario

SELECT SYSTEM_USER
RETURN

Etiqueta_Salario:
 Print 'Calculando salario ...'
 -- Instrucciones
GO

2.2 Uso de WAITFOR

WAITFOR DELAY '00:00:02'
SELECT BusinessEntityID FROM AdventureWorks.HumanResources.Employee;

Esperar hasta las 10:00 pm para realizar un chequeo a la BD
No ejecute las siguientes líneas
--USE AdventureWorks;
--GO
--BEGIN
-- WAITFOR TIME '22:00';
-- DBCC CHECKALLOC;
--END;
--GO

2.3 Uso de WHILE, BREAK, CONTINUE 

Declare @i int
Set @i = 1
WHILE (@i < 10)
Begin
 Print @i;
 Set @i = @i + 1;
End
GO

2.4 Uso de Case

2.4.1 Case en una instrucción de selección de datos, consultando valores fijos

USE AdventureWorks
GO
SELECT Name As Nombre, 
 CASE Name
  WHEN 'Human Resources' THEN 'HR'
  WHEN 'Finance' THEN 'FI'
  WHEN 'Information Services' THEN 'IS'
  WHEN 'Executive' THEN 'EX'
  WHEN 'Facilities and Maintenance' THEN 'FM'
 END AS Abreviaturas
FROM AdventureWorks.HumanResources.Department
 WHERE GroupName = 'Executive General and Administration';

2.4.2 Case en una instrucción de selección de datos, consultando rango de valores

SELECT ProductNumber As IdProducto, ListPrice As 'Precio de lista', Name As Nombre, 
'Rango de precio' = CASE 
  WHEN ListPrice =  0 THEN 'Precio $0'
  WHEN ListPrice < 50 THEN 'Debajo de $50'
  WHEN ListPrice >= 50 and ListPrice < 250 THEN 'Entre $[50, 250)'
  WHEN ListPrice >= 250 and ListPrice < 1000 THEN 'Entre  $[250, 1000)'
  ELSE 'Mayor a $1000'
 END
FROM Production.Product
 ORDER BY ProductNumber;

2.4.3 Case en una instrucción de asignación
Presione el botón: "Result to Text" 

SET NOCOUNT ON -- No retorna al cliente el numero de filas afectadas
DECLARE @n tinyint, @sTipo varchar (5)
SET @n = 5

IF (@n BETWEEN 4 and 6)
BEGIN
 WHILE (@n > 0)
 BEGIN

  SELECT @sTipo = 
   CASE 
    WHEN (@n % 2) = 1 THEN 'Impar'   -- (%: Modulo resultado de dividir dos numeros)
    ELSE 'Par'
   END 
  
  SELECT @n AS 'Numero', @sTipo As 'Tipo'
  
  SET @n = @n - 1
 END
END
ELSE
 PRINT 'Fuera del Rango'
GO 

-----------------------------------------------------------------------
-- PREGUNTAS PARA EL ALUMNO:
-----------------------------------------------------------------------
Responda las siguientes preguntas según el punto 1. Definición de variables
1. ¿Cuál es la diferencia de usar SET o SELECT en asignación de variables?
2. ¿Cuál es el uso de print?
3. ¿Pará que se utiliza punto y coma (;) al final de una línea?
4. ¿En qué parte del código debe ir la palabra GO?
5. ¿Qué pasa si escribe el GO en la mitad de las instrucciones?

