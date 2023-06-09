--*********************************************************************
-- LABORATORIO MANEJADORES DE ERROR Y TRANSACCIONES
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio ser� realizado por el alumno sin la supervisi�n del instructor.
- En clase solo ejecute los puntos 1 al 3, las dem�s instrucciones son para 
  trabajo fuera de clase

 --Solo de referencia (Cultura General)
-------------------------------------------------------------------------
---- 1. Usar mensajes de error creados por el usuario en bloques Try ... Catch
-------------------------------------------------------------------------
--1.1 Crear un mensaje personalizado
--IF EXISTS (SELECT message_id FROM sys.messages WHERE message_id = 50010)
-- EXECUTE sp_dropmessage 50010;
--GO

--EXECUTE sp_addmessage @msgnum = 50010,
-- @severity = 16, 
-- @msgtext = N'Mensaje proveniente del bloque Try %s.';
--GO

--1.2 Uso de manejadores de error

--BEGIN TRY 
-- -- Generar error en bloque try externo.
-- RAISERROR (50010, -- IdMensaje.
--            16, -- Severidad,
--            1, -- Estado,
--            N'externo 1'); -- par�metro a ser reemplazado en texto de mensaje.
--END TRY 
--BEGIN CATCH 
-- PRINT N'Error en bloque 1: ' + ERROR_MESSAGE();

-- BEGIN TRY 
--  -- Inicar TRY...CATCH anidado y generar un nuevo error 
--  RAISERROR (50010, 10, 2, 'interno 2') WITH LOG; 
-- END TRY 
-- BEGIN CATCH 
--  PRINT N'Error en bloque 2: ' + ERROR_MESSAGE();
-- END CATCH; 

-- PRINT N'Error en bloque 1: ' + ERROR_MESSAGE();
--END CATCH; 
--GO

-----------------------------------------------------------------------
-- 2. Funciones para recuperar datos de error en bloque Catch
-----------------------------------------------------------------------
2.1 Procedimiento que retorna informaci�n de error

USE AdventureWorks;
GO

IF OBJECT_ID ('spGetError_Informacion', 'P') IS NOT NULL
 DROP PROCEDURE spGetError_Informacion;
GO

CREATE PROCEDURE spGetError_Informacion
AS
 SELECT 
  ERROR_NUMBER() AS IdError,
  ERROR_SEVERITY() AS Severidad,
  ERROR_STATE() as Estado,
  ERROR_PROCEDURE() as Procedencia,
  ERROR_LINE() as Linea,
  ERROR_MESSAGE() as MensajeError;
GO

2.2 Retornar informaci�n al usuario sobre error por divisi�n por cero

BEGIN TRY
 SELECT 1/0; -- Divisi�n por cero (0) que genera error
END TRY
BEGIN CATCH
 EXECUTE spGetError_Informacion; -- Llamar rutina de notificaci�n de error
END CATCH;
GO

-----------------------------------------------------------------------
-- 3. Manejo de transacciones
-----------------------------------------------------------------------
USE Norte;
GO

IF OBJECT_ID (N'Libros_Transacciones', N'U') IS NOT NULL
 DROP TABLE Libros_Transacciones;
GO

CREATE TABLE Libros_Transacciones
(
 IdLibro int PRIMARY KEY,
 Titulo  NVARCHAR(100)
);
GO

BEGIN TRY
 BEGIN TRANSACTION;
 -- La siguiente instrucci�n genera error por que la columna Autor no existe en tabla
 ALTER TABLE Libros_Transacciones DROP COLUMN Autor;
 COMMIT TRANSACTION; -- Si la instrucci�n sucede, cometer la transacci�n 
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() as IdError, ERROR_MESSAGE() as Error;

 -- XACT_STATE = 0 significa que no hay transaccion, y un COMMIT o ROLLBACK 
 -- puede generar error

 IF (XACT_STATE()) = -1 -- Evaluar si la transacci�n no fue cometida
 BEGIN
  PRINT 'Transacci�n en estado no cometido. La transacci�n ser� reversada.'
  ROLLBACK TRANSACTION;
 END;
 ELSE IF (XACT_STATE()) = 1 -- Evaluar si la transacci�n est� activa y valida
 BEGIN
  PRINT 'La transacci�n puede ser cometida. Se har� un commit.'
  COMMIT TRANSACTION;   
 END;
END CATCH;
GO
