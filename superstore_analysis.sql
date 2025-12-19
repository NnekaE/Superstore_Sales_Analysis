/* 1) Create Database and Schema */
IF DB_ID(N'Superstores_DB') IS NULL
	CREATE DATABASE [Superstores_DB];
GO
USE [Superstores_DB];
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='dw')
	EXEC('CREATE SCHEMA dw');
GO

/* 2) Drop Existing DW Tables for a Fresh Start */
DROP TABLE IF EXISTS dw.FactSales, dw.DimShipMode, dw.DimLocation, dw.DimProduct, dw.DimCustomer, dw.DimDate;
GO

/* 3) Create and Populate Dimension Tables */

-- DimDate: Automated Date Key Generation
CREATE TABLE dw.DimDate (
  DateKey INT PRIMARY KEY, [Date] DATE NOT NULL,
  [Year] INT NOT NULL, [Quarter] TINYINT NOT NULL, [Month] TINYINT NOT NULL,
  [MonthName] NVARCHAR(9) NOT NULL, [Day] TINYINT NOT NULL,
  [WeekOfYear] TINYINT NOT NULL, [Is Weekend] BIT NOT NULL
);

DECLARE @d0 DATE=(SELECT MIN(order_date) FROM dbo.us_superstore_data_clean);
DECLARE @d1 DATE=(SELECT MAX(ship_date)  FROM dbo.us_superstore_data_clean);
SET @d0 = DATEADD(DAY,-30,@d0); SET @d1 = DATEADD(DAY,30,@d1);

WITH d AS (
  SELECT @d0 AS dt UNION ALL SELECT DATEADD(DAY,1,dt) FROM d WHERE dt < @d1
)
INSERT INTO dw.DimDate
SELECT CONVERT(INT,FORMAT(dt,'yyyyMMdd')), dt, YEAR(dt),
   	DATEPART(QUARTER,dt), MONTH(dt), DATENAME(MONTH,dt), DAY(dt),
   	DATEPART(WEEK,dt),
   	CASE WHEN DATENAME(WEEKDAY,dt) IN ('Saturday','Sunday') THEN 1 ELSE 0 END
FROM d OPTION (MAXRECURSION 32767);
GO

-- DimCustomer
CREATE TABLE dw.DimCustomer (
  CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
  Customer_ID NVARCHAR(50) NOT NULL UNIQUE,
  Customer_Name NVARCHAR(100) NOT NULL,
  Segment NVARCHAR(50) NOT NULL
);
INSERT INTO dw.DimCustomer(Customer_ID,Customer_Name,Segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM dbo.us_superstore_data_clean;
GO

-- DimProduct
CREATE TABLE dw.DimProduct (
  ProductKey INT IDENTITY(1,1) PRIMARY KEY,
  Product_ID NVARCHAR(50) NOT NULL UNIQUE,
  Category NVARCHAR(50) NOT NULL,
  Sub_Category NVARCHAR(50) NOT NULL,
  Product_Name NVARCHAR(255) NOT NULL
);
INSERT INTO dw.DimProduct(Product_ID,Category,Sub_Category,Product_Name)
SELECT DISTINCT product_id, category, sub_category, product_name
FROM dbo.us_superstore_data_clean;
GO

-- DimLocation
CREATE TABLE dw.DimLocation (
  LocationKey INT IDENTITY(1,1) PRIMARY KEY,
  Country NVARCHAR(50) NOT NULL,
  Region NVARCHAR(50) NOT NULL,
  State NVARCHAR(50) NOT NULL,
  City NVARCHAR(100) NOT NULL,
  Postal_Code NVARCHAR(20) NOT NULL
);
INSERT INTO dw.DimLocation(Country,Region,State,City,Postal_Code)
SELECT DISTINCT country, region, state, city, postal_code
FROM dbo.us_superstore_data_clean;
GO

-- DimShipMode
CREATE TABLE dw.DimShipMode (
  ShipModeKey INT IDENTITY(1,1) PRIMARY KEY,
  Ship_Mode NVARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO dw.DimShipMode(Ship_Mode)
SELECT DISTINCT ship_mode FROM dbo.us_superstore_data_clean;
GO

/* 4) Create and Populate the Fact Table */
CREATE TABLE dw.FactSales (
  FactSalesID BIGINT IDENTITY(1,1) PRIMARY KEY,
  Order_ID NVARCHAR(50) NOT NULL,
  OrderDateKey INT NOT NULL FOREIGN KEY REFERENCES dw.DimDate(DateKey),
  ShipDateKey  INT NOT NULL FOREIGN KEY REFERENCES dw.DimDate(DateKey),
  CustomerKey INT NOT NULL FOREIGN KEY REFERENCES dw.DimCustomer(CustomerKey),
  ProductKey INT NOT NULL FOREIGN KEY REFERENCES dw.DimProduct(ProductKey),
  LocationKey INT NOT NULL FOREIGN KEY REFERENCES dw.DimLocation(LocationKey),
  ShipModeKey INT NOT NULL FOREIGN KEY REFERENCES dw.DimShipMode(ShipModeKey),
  Sales DECIMAL(10,2) NOT NULL, Quantity INT NOT NULL,
  Discount DECIMAL(4,2) NOT NULL, Profit DECIMAL(10,2) NOT NULL
);

INSERT INTO dw.FactSales (
  Order_ID, OrderDateKey, ShipDateKey, CustomerKey, ProductKey, LocationKey, ShipModeKey,
  Sales, Quantity, Discount, Profit
)
SELECT
  f.order_id,
  CONVERT(INT,FORMAT(f.order_date,'yyyyMMdd')),
  CONVERT(INT,FORMAT(f.ship_date,'yyyyMMdd')),
  dc.CustomerKey, dp.ProductKey, dl.LocationKey, sm.ShipModeKey,
  f.sales, f.quantity, f.discount, f.profit
FROM dbo.us_superstore_data_clean f
JOIN dw.DimCustomer dc ON dc.Customer_ID=f.customer_id
JOIN dw.DimProduct  dp ON dp.Product_ID=f.product_id
JOIN dw.DimLocation dl ON dl.Country=f.country AND dl.Region=f.region AND dl.State=f.state
                   	AND dl.City=f.city AND dl.Postal_Code=f.postal_code
JOIN dw.DimShipMode sm ON sm.Ship_Mode=f.ship_mode;
GO
