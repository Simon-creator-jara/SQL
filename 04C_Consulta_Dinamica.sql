--*********************************************************************
-- LABORATORIO CONSULTA DINAMICA
-- INSTRUCTOR: David Esteban Echeverri Duque
-----------------------------------------------------------------------
-- Este laboratorio será realizado en grupo dirigido por el instructor.

-----------------------------------------------------------------------
-- 1. Script SQL Server
-----------------------------------------------------------------------
USE AdventureWorks
GO

DECLARE @sBD varchar(30), @sTabla varchar(30), @sSQL nvarchar (200)

SET @sBD = 'AdventureWorks'
SET @sTabla = 'HumanResources.Employee'

--SET @sSQL = 'USE ' + @sBD + ' SELECT EmployeeID, Title, BirthDate FROM ' + @sTabla
SET @sSQL = 'SELECT BusinessEntityID, LoginID, BirthDate FROM ' + @sTabla

PRINT @sSQL 

PRINT 'Lista de Empleados'
PRINT ''
EXECUTE sp_executesql @sSQL 

-- EXECUTE (@sSQL)
-- sp_executesql: genera un plan de ejecución más eficiente que EXECUTE
GO


