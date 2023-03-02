/*
-- Omitidos

EMBALAJE
SNDECLARACION
NIT_EXPORTADOR
NOMBRE_EXPORTADOR
SUBPARTIDA
DESCRIP_SUBPARTIDA
UNIDAD_SUBPARTIDA
BULTOS
UNIDAD_COMERCIAL
NMCONVERSION
[B] COD_ZONAFRANCA
[B] COD_PAIS_PROCEDENCIA
[B] PAIS_PROCEDENCIA
[B] FMM
[B] CDFACTURA 
[B] CDDOC_TRANSPORTE
[B] CDDOC_EXPORTACION

-- Medidas

TASA_CAMBIO
CANTIDAD
PRECIO
PESO_BRUTO
PESO_NETO
FLETES
FOB

*/

-------Paises
/*
-- Paises
Pais Cod_pais

COD_PAIS_ORIGEN
PAIS_ORIGEN
COD_PAIS_COMPRA
PAIS_COMPRA
COD_PAIS_DESTINO
PAIS_DESTINO
COD_PAIS_BANDERA
BANDERA
*/

DROP TABLE IF EXISTS DimCountry;

SELECT
    COD_PAIS_ORIGEN AS CountryId,
    PAIS_ORIGEN as CountryName
INTO DimCountry
FROM DataSemilla
GROUP BY COD_PAIS_ORIGEN, PAIS_ORIGEN;

UPDATE DimCountry
SET CountryId = 0, 
    CountryName = 'N/A'
WHERE CountryId IS NULL AND CountryName IS NULL

ALTER TABLE DimCountry
ALTER COLUMN CountryId INT NOT NULL;

ALTER TABLE DimCountry
ADD CONSTRAINT DimCountry_PK PRIMARY KEY (CountryId);


SELECT *
FROM DimCountry
ORDER BY CountryId;


--------TIEMPO

/*

-- Tiempo
Año Mes Dia Hora Cuarto Semestre 
FECHA_DEFINITIVO
FECHA_APROBACION
FECHA_EJECUCION
FECHA_REVISION
FECHA_RECHAZO
FECHA_DIGITALIZACION

*/
DROP TABLE IF EXISTS DimDate;

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2008-01-01';
SET @EndDate = '2028-12-31';
WITH
    DateSequence
    AS
    (
                    SELECT @StartDate AS DateTimeValue
        UNION ALL
            SELECT DATEADD(hour, 1, DateTimeValue)
            FROM DateSequence
            WHERE DateTimeValue < @EndDate
    )
SELECT
    YEAR(DateTimeValue) AS DateYear,
    MONTH(DateTimeValue) AS DateMonth,
    DAY(DateTimeValue) AS DateDay,
    DATEPART(hour,DateTimeValue) AS DateHour,
    DATEPART(WEEKDAY, DateTimeValue) AS DateWeekDay,
    DATENAME(WEEKDAY, DateTimeValue) AS DateWeekDayName,
    DATENAME(MONTH, DateTimeValue) AS DateMonthName
INTO DimDate
FROM DateSequence
OPTION
(MAXRECURSION
0);

ALTER TABLE DimDate 
ADD DateId INT IDENTITY(1,1) PRIMARY KEY;

INSERT INTO DimDate(
    DateDay, 
    DateHour, 
    DateMonth, 
    DateYear,
    DateWeekDay, 
    DateMonthName, 
    DateWeekDayName
    ) 
VALUES (NULL, NULL, NULL, NULL, NULL, 'Sin Mes', 'Sin Día de Semana');

ALTER TABLE DimDate
ADD Semester varchar(12);
UPDATE DimDate
SET Semester = CASE WHEN DateMonth <= 6 THEN '1st semestre'
                WHEN DateMonth IS NULL THEN 'Sin semestre'
                    ELSE '2nd semestre'
               END;
        
SELECT *
FROM DimDate
ORDER BY DateYear, 
        DateMonth, 
        DateDay, 
        DateHour;


---------------------------------------PRODUCTO
/*
COD_ITEM
ITEM
TIPO_ITEM
UNIDAD_MEDIDA
EMBALAJE
*/
DROP TABLE IF EXISTS DimProduct;

SELECT DISTINCT
    COD_ITEM,
    ITEM,
    TIPO_ITEM,
    UNIDAD_MEDIDA
INTO DimProduct
FROM Datasemilla;

ALTER TABLE DimProduct 
ADD ProductId INT IDENTITY(1,1) PRIMARY KEY;

SELECT *
FROM DimProduct
ORDER BY COD_ITEM;


-- SELECT  COUNT(ITEM) as itemcount, TIPO_ITEM, UNIDAD_MEDIDA, (COD_ITEM) 
-- FROM DimProduct
-- GROUP BY  COD_ITEM, TIPO_ITEM, UNIDAD_MEDIDA
-- HAVING COUNT(ITEM) > 1;


---------------------------------------SIA

/*

NIT_SIA
NOMBRE_SIA

*/

DROP TABLE IF EXISTS DimSia;

SELECT DISTINCT
    NIT_SIA,
    NOMBRE_SIA
INTO DimSia
FROM Datasemilla;

ALTER TABLE DimSia
ADD siaID INT PRIMARY KEY IDENTITY(1,1);


SELECT *
FROM DimSia;



--------------------------------------- TRANSACTION


/*
TIPO
CDTRANSACCION
DSTRANSACCION
*/

DROP TABLE IF EXISTS DimTransactionType;

SELECT DISTINCT
    CDTRANSACCION,
    DSTRANSACCION
INTO DimTransactionType
FROM Datasemilla;

ALTER TABLE DimTransactionType
ALTER COLUMN CDTRANSACCION INT NOT NULL;

ALTER TABLE DimTransactionType
ADD CONSTRAINT DimTransaction_PK PRIMARY KEY (CDTRANSACCION);

SELECT *
FROM DimTransactionType;




-----------------------------------------Estado
/*


CDESTADO
DSESTADO
*/
DROP TABLE IF EXISTS DimStatus;

SELECT DISTINCT
    CDESTADO,
    DSESTADO
INTO DimStatus
FROM Datasemilla;

ALTER TABLE DimStatus
ALTER COLUMN CDESTADO VARCHAR(50) NOT NULL;

ALTER TABLE DimStatus
ADD CONSTRAINT DimStatus_PK PRIMARY KEY (CDESTADO);

SELECT *
FROM DimStatus;


----------------------------------------EMPRESA
DROP TABLE IF EXISTS DimCompany;

SELECT DISTINCT
    CDCIA_USUARIA,
    DSCIA_USUARIA,
    NIT_COMPANIA,
    DSTIPO_ACTIVIDAD
INTO DimCompany
FROM DataSemilla;

ALTER TABLE DimCompany
ALTER COLUMN CDCIA_USUARIA NVARCHAR(50) NOT NULL;

ALTER TABLE DimCompany
ADD CONSTRAINT DimCompanu_PK PRIMARY KEY (CDCIA_USUARIA);

SELECT *
FROM DimCompany;


-------------------------------------------- Importador
/*
NIT_IMPORTADOR
NOMBRE_IMPORTADOR
*/

DROP TABLE IF EXISTS DimImporter;

SELECT DISTINCT
    NIT_IMPORTADOR,
    NOMBRE_IMPORTADOR
INTO DimImporter
FROM Datasemilla
WHERE NIT_IMPORTADOR IS NOT NULL

ALTER TABLE DimImporter
ALTER COLUMN NIT_IMPORTADOR VARCHAR(50) NOT NULL;

ALTER TABLE DimImporter
ADD CONSTRAINT DimImporter_PK PRIMARY KEY (NIT_IMPORTADOR);

SELECT *
FROM DimImporter;

