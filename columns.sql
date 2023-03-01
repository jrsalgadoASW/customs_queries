/*



-- Empresa

CDCIA_USUARIA
DSCIA_USUARIA
NIT_COMPANIA
DSTIPO_ACTIVIDAD

-- Transporte
MODO_TRANSPORTE

-- Importador
NIT_IMPORTADOR
NOMBRE_IMPORTADOR

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


-- SELECT  
--     COD_PAIS_ORIGEN AS CountryId, 
--     PAIS_ORIGEN as CountryName
-- INTO DimCountry
-- FROM  DataSemilla
-- GROUP BY COD_PAIS_ORIGEN, PAIS_ORIGEN;

SELECT * FROM DimCountry;

-- DROP TABLE DimCountry;

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
-- WITH
--     combinedDates
--     AS

--     (

--             SELECT DISTINCT FECHA_APROBACION
--             FROM DataSemilla
--         UNION
--             (
--             SELECT FECHA_DEFINITIVO
--             FROM DataSemilla
--     )
--         UNION
--             (
--             SELECT FECHA_DIGITALIZACION
--             FROM DataSemilla
--     )
--         UNION
--             (
--             SELECT FECHA_EJECUCION
--             FROM DataSemilla
--     )
--         UNION
--             (
--             SELECT FECHA_RECHAZO
--             FROM DataSemilla
--     )
--         UNION
--             (
--             SELECT FECHA_REVISION
--             FROM DataSemilla
--     )
--     )
-- SELECT DISTINCT
--     YEAR(FECHA_APROBACION) AS DateYear,
--     MONTH(FECHA_APROBACION) AS DateMonth,
--     DAY(FECHA_APROBACION) AS DateDay,
--     DATEPART(hour,FECHA_APROBACION) AS DateHour
-- INTO DimDate
-- FROM combinedDates
-- ORDER BY 
--         DateYear, 
--         DateMonth, 
--         DateDay, 
--         DateHour;

SELECT * FROM DimDate
ORDER BY DateYear, 
        DateMonth, 
        DateDay, 
        DateHour;

/*

-- Producto

COD_ITEM
ITEM
TIPO_ITEM
UNIDAD_MEDIDA
EMBALAJE
*/

-- SELECT DISTINCT 
--     COD_ITEM, 
--     ITEM,
--     TIPO_ITEM, 
--     UNIDAD_MEDIDA
-- INTO DimProduct
-- FROM Datasemilla

SELECT * DimProduct;

/*
-- SIA (Intermedario)

NIT_SIA
NOMBRE_SIA

*/

-- SELECT DISTINCT 
--     NIT_SIA, 
--     NOMBRE_SIA
-- INTO DimSia
-- FROM Datasemilla;

SELECT * FROM DimSia


/*

-- Transaccion DimTransaction

TIPO
CDTRANSACCION
DSTRANSACCION
*/
-- SELECT DISTINCT 
--     CDTRANSACCION, 
--     DSTRANSACCION
-- INTO DimTransaction
-- FROM Datasemilla;

SELECT * FROM DimTransaction;
/*

-- Estado

CDESTADO
DSESTADO
*/
-- SELECT DISTINCT 
--     CDESTADO, 
--     DSESTADO
-- INTO DimStatus
-- FROM Datasemilla;

SELECT * FROM DimStatus;