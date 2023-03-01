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
ALTER COLUMN CountryId int NOT NULL;


SELECT *
FROM DimCountry
ORDER BY CountryId;

GO


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

WITH
    combinedDates
    AS

    (

            SELECT DISTINCT FECHA_APROBACION
            FROM DataSemilla
        UNION
            (
            SELECT FECHA_DEFINITIVO
            FROM DataSemilla
    )
        UNION
            (
            SELECT FECHA_DIGITALIZACION
            FROM DataSemilla
    )
        UNION
            (
            SELECT FECHA_EJECUCION
            FROM DataSemilla
    )
        UNION
            (
            SELECT FECHA_RECHAZO
            FROM DataSemilla
    )
        UNION
            (
            SELECT FECHA_REVISION
            FROM DataSemilla
    )
    )
SELECT DISTINCT
    YEAR(FECHA_APROBACION) AS DateYear,
    MONTH(FECHA_APROBACION) AS DateMonth,
    DAY(FECHA_APROBACION) AS DateDay,
    DATEPART(hour,FECHA_APROBACION) AS DateHour
INTO DimDate
FROM combinedDates
ORDER BY 
        DateYear, 
        DateMonth, 
        DateDay, 
        DateHour;

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
DROP TABLE IF EXISTS DimProdct;

SELECT DISTINCT 
    COD_ITEM, 
    ITEM,
    TIPO_ITEM, 
    UNIDAD_MEDIDA
INTO DimProduct
FROM Datasemilla

SELECT *
DimProduct;


---------------------------------------SIA

/*

NIT_SIA
NOMBRE_SIA

*/

DROP TABLE IF EXISTS DimProdct;

SELECT DISTINCT 
    NIT_SIA, 
    NOMBRE_SIA
INTO DimSia
FROM Datasemilla;

SELECT *
FROM DimSia


--------------------------------------- TRANSACTION

/*
TIPO
CDTRANSACCION
DSTRANSACCION
*/

DROP TABLE IF EXISTS DimTransaction;

SELECT DISTINCT 
    CDTRANSACCION, 
    DSTRANSACCION
INTO DimTransaction
FROM Datasemilla;

SELECT *
FROM DimTransaction;




-----------------------------------------Estado
/*


CDESTADO
DSESTADO
*/
DROP TABLE IF EXISTS DimStatus;
-- SELECT DISTINCT 
--     CDESTADO, 
--     DSESTADO
-- INTO DimStatus
-- FROM Datasemilla;

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
FROM DataSemilla

SELECT *
FROM DimCompany;

---------------------------------------Transporte
/*
-- Transporte
MODO_TRANSPORTE
*/


DROP TABLE IF EXISTS DimTransport;

SELECT DISTINCT
MODO_TRANSPORTE
INTO DimTransport
FROM Datasemilla
WHERE MODO_TRANSPORTE IS NOT NULL;

SELECT * FROM DimTransport

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

SELECT * FROM  DimImporter;

