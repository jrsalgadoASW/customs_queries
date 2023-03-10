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

DROP TABLE IF EXISTS FactImportRegistry;

DROP TABLE IF EXISTS DimCountry;
DROP TABLE IF EXISTS DimDate;
DROP TABLE IF EXISTS DimProduct;
DROP TABLE IF EXISTS DimSia;
DROP TABLE IF EXISTS DimTransactionType;
DROP TABLE IF EXISTS DimStatus;
DROP TABLE IF EXISTS DimCompany;
DROP TABLE IF EXISTS DimImporter;

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

CREATE TABLE [dbo].[DimCountry]
(
    [CountryCod] [int] NOT NULL,
    [CountryName] [nvarchar](50) NULL,
    [CountryId] [int] IDENTITY(1,1) NOT NULL,
    CONSTRAINT [DimCountry_PK] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


WITH
    origen
    AS

    (

        SELECT DISTINCT
            ISNULL(COD_PAIS_ORIGEN, 0) AS CountryCod,
            ISNULL(PAIS_ORIGEN,'Pais no especificado') AS CountryName
        FROM DataSemilla
    ),
    procedencia
    AS
    (

        SELECT DISTINCT
            ISNULL(COD_PAIS_PROCEDENCIA, 0) AS CountryCod,
            ISNULL(PAIS_PROCEDENCIA,'Pais no especificado') AS CountryName
        FROM DataSemilla
    ),
    compra
    AS

    (
        SELECT DISTINCT
            ISNULL(COD_PAIS_COMPRA, 0) AS CountryCod,
            ISNULL(PAIS_COMPRA,'Pais no especificado') AS CountryName
        FROM DataSemilla

    ),
    bandera
    AS

    (
        SELECT DISTINCT
            ISNULL(COD_PAIS_BANDERA, 0) AS CountryCod,
            ISNULL(BANDERA,'Pais no especificado') AS CountryName
        FROM DataSemilla

    ),
    destino
    AS

    (
        SELECT DISTINCT
            ISNULL(COD_PAIS_DESTINO, 0) AS CountryCod,
            ISNULL(PAIS_DESTINO,'Pais no especificado') AS CountryName
        FROM DataSemilla

    )
INSERT INTO DimCountry
    (CountryCod, CountryName)
    SELECT DISTINCT CountryCod, CountryName
    FROM origen
UNION
    (SELECT CountryCod, CountryName
    FROM bandera)
UNION
    (SELECT CountryCod, CountryName
    FROM compra)
UNION
    (SELECT CountryCod, CountryName
    FROM procedencia)
UNION
    (SELECT CountryCod, CountryName
    FROM destino)
ORDER BY CountryCod;

--------TIEMPO

/*

-- Tiempo
A??o Mes Dia Hora Cuarto Semestre 
FECHA_DEFINITIVO
FECHA_APROBACION
FECHA_EJECUCION
FECHA_REVISION
FECHA_RECHAZO
FECHA_DIGITALIZACION

*/

CREATE TABLE [dbo].[DimDate]
(
    [DateYear] [int] NULL,
    [DateMonth] [int] NULL,
    [DateDay] [int] NULL,
    [DateHour] [int] NULL,
    [DateWeekDay] [int] NULL,
    [DateWeekDayName] [nvarchar](30) NULL,
    [DateMonthName] [nvarchar](30) NULL,
    [DateId] [int] IDENTITY(1,1) NOT NULL,
    [Semester] [varchar](12) NULL,
    PRIMARY KEY CLUSTERED 
(
	[DateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

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
INSERT INTO DimDate
    (DateYear, DateMonth, DateDay, DateHour, DateWeekDay, DateWeekDayName, DateMonthName)
SELECT
    ISNULL( YEAR(DateTimeValue),-1) AS DateYear,
    ISNULL(MONTH(DateTimeValue),-1) AS DateMonth,
    ISNULL(DAY(DateTimeValue),-1) AS DateDay,
    ISNULL(DATEPART(hour,DateTimeValue),-1) AS DateHour,
    DATEPART(WEEKDAY, DateTimeValue) AS DateWeekDay,
    DATENAME(WEEKDAY, DateTimeValue) AS DateWeekDayName,
    DATENAME(MONTH, DateTimeValue) AS DateMonthName
FROM DateSequence
OPTION
(MAXRECURSION
0);

INSERT INTO DimDate
    (
    DateDay,
    DateHour,
    DateMonth,
    DateYear,
    DateWeekDay,
    DateMonthName,
    DateWeekDayName
    )
VALUES
    (-1, -1, -1, -1, -1, 'Sin Mes', 'Sin D??a de Semana');


UPDATE DimDate
SET Semester = CASE 
                WHEN DateMonth = -1 THEN 'Sin semestre'
                WHEN DateMonth <= 6 THEN '1st semestre'
                ELSE '2nd semestre'
               END;
        

GO

---------------------------------------PRODUCTO
/*
COD_ITEM
ITEM
TIPO_ITEM
UNIDAD_MEDIDA
EMBALAJE
*/
CREATE TABLE [dbo].[DimProduct]
(
    [COD_ITEM] [nvarchar](50) NULL,
    [ITEM] [nvarchar](100) NULL,
    [TIPO_ITEM] [nvarchar](50) NULL,
    [UNIDAD_MEDIDA] [nvarchar](50) NULL,
    [ProductId] [int] IDENTITY(1,1) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO DimProduct
    (COD_ITEM, ITEM, TIPO_ITEM, UNIDAD_MEDIDA)
SELECT DISTINCT
    COD_ITEM,
    ITEM,
    TIPO_ITEM,
    UNIDAD_MEDIDA
FROM Datasemilla;


GO


---------------------------------------SIA

/*

NIT_SIA
NOMBRE_SIA

*/
CREATE TABLE [dbo].[DimSia]
(
    [NIT_SIA] [nvarchar](50) NULL,
    [NOMBRE_SIA] [nvarchar](50) NULL,
    [siaID] [int] IDENTITY(1,1) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[siaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO DimSia
    (NIT_SIA, NOMBRE_SIA)
SELECT DISTINCT
    NIT_SIA,
    NOMBRE_SIA
FROM Datasemilla;


GO

--------------------------------------- TRANSACTION


/*
TIPO
CDTRANSACCION
DSTRANSACCION
*/
CREATE TABLE [dbo].[DimTransactionType]
(
    [CDTRANSACCION] [int] NOT NULL,
    [DSTRANSACCION] [nvarchar](100) NULL,
    CONSTRAINT [DimTransaction_PK] PRIMARY KEY CLUSTERED 
(
	[CDTRANSACCION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


INSERT INTO DimTransactionType
    (CDTRANSACCION, DSTRANSACCION)
SELECT DISTINCT
    CDTRANSACCION,
    DSTRANSACCION
FROM Datasemilla;


GO


-----------------------------------------Estado
/*


CDESTADO
DSESTADO
*/
CREATE TABLE [dbo].[DimStatus]
(
    [CDESTADO] [varchar](50) NOT NULL,
    [DSESTADO] [nvarchar](50) NULL,
    CONSTRAINT [DimStatus_PK] PRIMARY KEY CLUSTERED 
(
	[CDESTADO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO DimStatus
    (CDESTADO, DSESTADO)
SELECT DISTINCT
    CDESTADO,
    DSESTADO
FROM Datasemilla;

UPDATE DimStatus
SET CDESTADO = 0 
WHERE CDESTADO IS NULL;

GO


----------------------------------------EMPRESA

CREATE TABLE [dbo].[DimCompany]
(
    [CDCIA_USUARIA] [nvarchar](50) NOT NULL,
    [DSCIA_USUARIA] [nvarchar](50) NULL,
    [NIT_COMPANIA] [nvarchar](50) NULL,
    [DSTIPO_ACTIVIDAD] [nvarchar](50) NULL,
    CONSTRAINT [DimCompanu_PK] PRIMARY KEY CLUSTERED 
(
	[CDCIA_USUARIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


INSERT INTO DimCompany
    (CDCIA_USUARIA, DSCIA_USUARIA, NIT_COMPANIA, DSTIPO_ACTIVIDAD)
SELECT DISTINCT
    CDCIA_USUARIA,
    DSCIA_USUARIA,
    NIT_COMPANIA,
    DSTIPO_ACTIVIDAD
FROM DataSemilla;

GO

-------------------------------------------- Importador
/*
NIT_IMPORTADOR
NOMBRE_IMPORTADOR
*/

CREATE TABLE [dbo].[DimImporter]
(
    [NIT_IMPORTADOR] [varchar](50) NULL,
    [NOMBRE_IMPORTADOR] [nvarchar](100) NULL,
    [ImporterId] [int] IDENTITY(1,1) NOT NULL,
    CONSTRAINT [DimImporter_PK] PRIMARY KEY CLUSTERED 
(
	[ImporterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO DimImporter
    (NIT_IMPORTADOR, NOMBRE_IMPORTADOR)
SELECT DISTINCT
    NIT_IMPORTADOR,
    NOMBRE_IMPORTADOR
FROM Datasemilla;

GO
------------------------------------------------FACTS

CREATE TABLE FactImportRegistry
(
    IdFact INT IDENTITY(1,1) PRIMARY KEY,

    -----Rechazo
    FechaRechazoID INT,
    -----Aprobacion
    FechaAprobacionID INT,
    -----Definitivo
    FechaDefinitivoID INT,
    -----Revision
    FechaRevisionID INT,
    -----Digitalizacion
    FechaDigitalizacionID INT,
    -----Producto
    ProductoID INT,
    -----Origen
    PaisOrigenID INT,
    -----Bandera
    PaisBanderaID INT,
    -----Destino
    PaisDestinoID INT,
    -----Procedencia
    PaisProcedenciaID INT,
    -----Compra
    PaisCompraID INT,
    -------------------------------EMPRESA---------------------------
    EmpresaID NVARCHAR(50) NOT NULL,
    -------------------------------IMportado---------------------------
    ImporterId INT,
    -------------------------------SIA---------------------------
    SiaID INT,
    -------------------------------ESTADO---------------------------
    EstadoID VARCHAR(50),
    -------------------------------Tipo Transaccion---------------------------
    TipoTransaccionID INT,


    CANTIDAD float,
    PRECIO float,
    PESO_BRUTO float,
    PESO_NETO float,
    FLETES float,
    FOB float,

    FOREIGN KEY (EmpresaID) REFERENCES DimCompany(CDCIA_USUARIA),
    FOREIGN KEY (EstadoID) REFERENCES DimStatus(CDESTADO),
    FOREIGN KEY (TipoTransaccionID) REFERENCES DimTransactionType(CDTRANSACCION),
    FOREIGN KEY (SiaID) REFERENCES DimSia(siaID),
    FOREIGN KEY (ProductoID) REFERENCES DimProduct(ProductId),

    FOREIGN KEY (FechaAprobacionID) REFERENCES DimDate(DateId),
    FOREIGN KEY (FechaDefinitivoID) REFERENCES DimDate(DateId),
    FOREIGN KEY (FechaDigitalizacionID) REFERENCES DimDate(DateId),
    FOREIGN KEY (FechaRechazoID) REFERENCES DimDate(DateId),
    FOREIGN KEY (FechaRevisionID) REFERENCES DimDate(DateId),

    FOREIGN KEY (PaisBanderaID) REFERENCES DimCountry(CountryId),
    FOREIGN KEY (PaisCompraID) REFERENCES DimCountry(CountryId),
    FOREIGN KEY (PaisDestinoID) REFERENCES DimCountry(CountryId),
    FOREIGN KEY (PaisOrigenID) REFERENCES DimCountry(CountryId),
    FOREIGN KEY (PaisProcedenciaID) REFERENCES DimCountry(CountryId),

    FOREIGN KEY (ImporterId) REFERENCES DimImporter(ImporterId)
);

GO

DROP FUNCTION IF EXISTS GetDateID;

GO

CREATE FUNCTION GetDateID(@date datetime)
RETURNS INT
AS
BEGIN
    DECLARE @id int;
    SELECT @id = DateId
    FROM DimDate dd
    WHERE
    (ISNULL(DATEPART(WEEKDAY,@date),-1) = dd.DateDay) AND
        (ISNULL(DATEPART(MONTH,@date),-1) = dd.DateMonth) AND
        (ISNULL(DATEPART(YEAR,@date),-1) = dd.DateYear) AND
        (ISNULL(DATEPART(HOUR,@date),-1) = dd.DateHour)
    ;
    --Function body goes here
    RETURN @id;
END;
GO

INSERT INTO FactImportRegistry
    (

    FechaRechazoID,
    FechaAprobacionID,
    FechaDefinitivoID,
    FechaRevisionID,
    FechaDigitalizacionID,

    ProductoID,

    PaisOrigenID,
    PaisBanderaID,
    PaisDestinoID,
    PaisProcedenciaID,
    PaisCompraID,

    EmpresaID,
    ImporterId,
    SiaID,
    EstadoID,

    TipoTransaccionID,

    CANTIDAD,
    PRECIO,
    PESO_BRUTO,
    PESO_NETO,
    FLETES,
    FOB
    )
SELECT
    -----Rechazo
    ddRechazo.DateId AS FechaRechazoID,
    -----Aprobacion
    ddAprobacion.DateId AS FechaAprobacionID,
    -----Definitivo
    ddDefinitivo.DateId AS FechaDefinitivoID,
    -----Revision
    ddRevision.DateId AS FechaRevisionID,
    -----Digitalizacion
    ddDigitalizacion.DateId AS FechaDigitalizacionID,
    -----Producto
    dp.ProductId AS ProductoID,
    -----Origen
    dcOrigen.CountryId AS PaisOrigenID,
    -----Bandera
    dcBandera.CountryId AS PaisBanderaID,
    -----Destino
    dcDestino.CountryId AS PaisDestinoID,
    -----Procedencia
    dcProcedencia.CountryId AS PaisProcedenciaID,
    -----Compra
    dcCompra.CountryId AS PaisCompraID,
    -------------------------------EMPRESA---------------------------
    dCompany.CDCIA_USUARIA AS EmpresaID,
    -------------------------------IMportado---------------------------
    di.ImporterId,
    -------------------------------SIA---------------------------
    dSia.siaID AS SiaID,
    -------------------------------ESTADO---------------------------
    dStatus.CDESTADO AS EstadoID,
    -------------------------------Tipo Transaccion---------------------------
    dtt.CDTRANSACCION AS TipoTransaccionID,

    -----------METRICAS
    ds.CANTIDAD,
    ds.PRECIO,
    ds.PESO_BRUTO,
    ds.PESO_NETO,
    ds.FLETES,
    ds.FOB


FROM DataSemilla ds
    --------------------------FECHAS----------------------------------------
    -----Rechazo
    INNER JOIN DimDate ddRechazo ON 
    (ISNULL(DATEPART(WEEKDAY,ds.FECHA_RECHAZO),-1) = ddRechazo.DateDay) AND
        (ISNULL(DATEPART(MONTH,ds.FECHA_RECHAZO),-1) = ddRechazo.DateMonth) AND
        (ISNULL(DATEPART(YEAR,ds.FECHA_RECHAZO),-1) = ddRechazo.DateYear) AND
        (ISNULL(DATEPART(HOUR,ds.FECHA_RECHAZO),-1) = ddRechazo.DateHour)

    -----Aprobacion
    INNER JOIN DimDate ddAprobacion ON 
        (ISNULL(DATEPART(WEEKDAY,ds.FECHA_APROBACION),-1) = ddAprobacion.DateDay) AND
        (ISNULL(DATEPART(MONTH,ds.FECHA_APROBACION),-1) = ddAprobacion.DateMonth) AND
        (ISNULL(DATEPART(YEAR,ds.FECHA_APROBACION),-1) = ddAprobacion.DateYear) AND
        (ISNULL(DATEPART(HOUR,ds.FECHA_APROBACION),-1) = ddAprobacion.DateHour)

    -----Definitivo
    INNER JOIN DimDate ddDefinitivo ON 
        (ISNULL(DATEPART(WEEKDAY,ds.FECHA_DEFINITIVO),-1) = ddDefinitivo.DateDay) AND
        (ISNULL(DATEPART(MONTH,ds.FECHA_DEFINITIVO),-1) = ddDefinitivo.DateMonth) AND
        (ISNULL(DATEPART(YEAR,ds.FECHA_DEFINITIVO),-1) = ddDefinitivo.DateYear) AND
        (ISNULL(DATEPART(HOUR,ds.FECHA_DEFINITIVO),-1) = ddDefinitivo.DateHour)

    -----Definitivo
    INNER JOIN DimDate ddEjecucion ON 
        (ISNULL(DATEPART(WEEKDAY,ds.FECHA_EJECUCION),-1) = ddEjecucion.DateDay) AND
        (ISNULL(DATEPART(MONTH,ds.FECHA_EJECUCION),-1) = ddEjecucion.DateMonth) AND
        (ISNULL(DATEPART(YEAR,ds.FECHA_EJECUCION),-1) = ddEjecucion.DateYear) AND
        (ISNULL(DATEPART(HOUR,ds.FECHA_EJECUCION),-1) = ddEjecucion.DateHour)

    -----Revision
    INNER JOIN DimDate ddRevision ON 
        (ISNULL(DATEPART(WEEKDAY,ds.FECHA_REVISION),-1) = ddRevision.DateDay) AND
        (ISNULL(DATEPART(MONTH,ds.FECHA_REVISION),-1) = ddRevision.DateMonth) AND
        (ISNULL(DATEPART(YEAR,ds.FECHA_REVISION),-1) = ddRevision.DateYear) AND
        (ISNULL(DATEPART(HOUR,ds.FECHA_REVISION),-1) = ddRevision.DateHour)

    -----Digitalizacion
    INNER JOIN DimDate ddDigitalizacion ON 
        (ISNULL(DATEPART(WEEKDAY,ds.FECHA_DIGITALIZACION),-1) = ddDigitalizacion.DateDay) AND
        (ISNULL(DATEPART(MONTH,ds.FECHA_DIGITALIZACION),-1) = ddDigitalizacion.DateMonth) AND
        (ISNULL(DATEPART(YEAR,ds.FECHA_DIGITALIZACION),-1) = ddDigitalizacion.DateYear) AND
        (ISNULL(DATEPART(HOUR,ds.FECHA_DIGITALIZACION),-1) = ddDigitalizacion.DateHour)

    -------------------------------PRODUCTO---------------------------
    INNER JOIN DimProduct dp ON 
        (ds.ITEM = dp.ITEM) AND
        (dp.TIPO_ITEM = ds.TIPO_ITEM) AND
        (dp.UNIDAD_MEDIDA = ds.UNIDAD_MEDIDA) AND
        (dp.COD_ITEM = ds.COD_ITEM)

    -------------------------------PAIS---------------------------
    -----Origen
    INNER JOIN DimCountry dcOrigen ON
        ISNULL(ds.COD_PAIS_ORIGEN, 0) = dcOrigen.CountryCod AND
        ISNULL(ds.PAIS_ORIGEN, 'Pais no especificado') = dcOrigen.CountryName

    -----Bandera
    INNER JOIN DimCountry dcBandera ON
        ISNULL(ds.COD_PAIS_BANDERA, 0) = dcBandera.CountryCod AND
        ISNULL(ds.Bandera, 'Pais no especificado') = dcBandera.CountryName

    -----Destino
    INNER JOIN DimCountry dcDestino ON
        ISNULL(ds.COD_PAIS_DESTINO, 0) = dcDestino.CountryCod AND
        ISNULL(ds.PAIS_DESTINO, 'Pais no especificado') = dcDestino.CountryName

    -----Procedencia
    INNER JOIN DimCountry dcProcedencia ON
        ISNULL(ds.COD_PAIS_PROCEDENCIA, 0) = dcProcedencia.CountryCod AND
        ISNULL(ds.PAIS_PROCEDENCIA, 'Pais no especificado') = dcProcedencia.CountryName

    -----Compra
    INNER JOIN DimCountry dcCompra ON
        ISNULL(ds.COD_PAIS_COMPRA, 0) = dcCompra.CountryCod AND
        ISNULL(ds.PAIS_COMPRA, 'Pais no especificado') = dcCompra.CountryName

    -------------------------------EMPRESA---------------------------
    INNER JOIN DimCompany dCompany ON 
        ISNULL(dCompany.CDCIA_USUARIA,0) = ISNULL(ds.CDCIA_USUARIA,0)

    -------------------------------IMPORTADOR---------------------------
    INNER JOIN DimImporter di ON 
        ISNULL(ds.NIT_IMPORTADOR,0) = ISNULL(di.NIT_IMPORTADOR,0) AND
        ISNULL(ds.NOMBRE_IMPORTADOR,0) = ISNULL(di.NOMBRE_IMPORTADOR,0)

    -------------------------------SIA---------------------------
    INNER JOIN DimSia dSia ON 
        ISNULL(ds.NIT_SIA,0) =  ISNULL(dSia.NIT_SIA,0) AND
        ISNULL(ds.NOMBRE_SIA,0) =  ISNULL(dSia.NOMBRE_SIA,0)

    -------------------------------ESTADO---------------------------
    INNER JOIN DimStatus dStatus ON 
        ISNULL(ds.CDESTADO,0) = ISNULL(dStatus.CDESTADO,0)

    -------------------------------Tipo Transaccion---------------------------
    INNER JOIN DimTransactionType dtt ON 
        ISNULL(ds.CDTRANSACCION,0) = ISNULL(dtt.CDTRANSACCION,0);
GO

SELECT * FROM FactImportRegistry;

GO