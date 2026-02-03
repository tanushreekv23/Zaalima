USE Consumer360;

CREATE TABLE Retail_Transactions (
    InvoiceNo VARCHAR(20),
    CustomerID INT,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Quantity INT,
    UnitPrice FLOAT,
    InvoiceDate DATETIME,
    Country VARCHAR(50),
    Revenue FLOAT
);

BULK INSERT RetailTransactions
FROM "C:\Users\Tanushree Kanakaraj\Downloads\Zaalima\consumer360_detailed_retail.csv"
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

DROP TABLE IF EXISTS RetailTransactions;
CREATE TABLE RetailTransactions (
    InvoiceNo VARCHAR(20),
    CustomerID INT,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Quantity INT,
    UnitPrice FLOAT,
    InvoiceDate DATETIME2,
    Country VARCHAR(50),
    Revenue FLOAT
);

BULK INSERT RetailTransactions
FROM "C:\Users\Tanushree Kanakaraj\Downloads\Zaalima\consumer360_detailed_retail.csv"
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',   
    TABLOCK
);

DROP TABLE IF EXISTS Retail_Staging;

CREATE TABLE Retail_Staging (
    InvoiceNo VARCHAR(50),
    CustomerID VARCHAR(50),
    ProductID VARCHAR(50),
    ProductName VARCHAR(200),
    Category VARCHAR(100),
    Brand VARCHAR(100),
    Quantity VARCHAR(50),
    UnitPrice VARCHAR(50),
    InvoiceDate VARCHAR(100),
    Country VARCHAR(100),
    Revenue VARCHAR(50)
);

BULK INSERT Retail_Staging
FROM "C:\Users\Tanushree Kanakaraj\Downloads\Zaalima\consumer360_detailed_retail.csv"
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    CODEPAGE = '65001'
);

DROP TABLE IF EXISTS RetailTransactions;

CREATE TABLE RetailTransactions (
    InvoiceNo VARCHAR(20),
    CustomerID INT,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Quantity INT,
    UnitPrice FLOAT,
    InvoiceDate DATETIME2,
    Country VARCHAR(50),
    Revenue FLOAT
);

INSERT INTO RetailTransactions
SELECT
    InvoiceNo,
    CAST(CustomerID AS INT),
    CAST(ProductID AS INT),
    ProductName,
    Category,
    Brand,
    CAST(Quantity AS INT),
    CAST(UnitPrice AS FLOAT),
    TRY_CONVERT(DATETIME2, InvoiceDate),
    Country,
    CAST(Revenue AS FLOAT)
FROM Retail_Staging;

SELECT COUNT(*) FROM RetailTransactions;
SELECT TOP 10 * FROM RetailTransactions;

SELECT TOP 20 * FROM Retail_Staging;
SELECT COUNT(*) FROM Retail_Staging;
SELECT COUNT(*) FROM Retail_Staging WHERE Revenue IS NULL;

SELECT Category, SUM(Revenue) AS TOTAL_REVENUE
FROM RetailTransactions
GROUP BY Category;


SELECT InvoiceNo, CustomerID, Category, Revenue
FROM RetailTransactions;

SELECT DISTINCT Category FROM RetailTransactions;
SELECT DISTINCT Country FROM RetailTransactions;

SELECT *
FROM RetailTransactions
WHERE Revenue > 3000;

SELECT *
FROM RetailTransactions
WHERE Country = 'India'
AND Revenue > 2000;

SELECT ProductName, SUM(Revenue) AS Sales
FROM RetailTransactions
GROUP BY ProductName
ORDER BY Sales DESC;

SELECT TOP 5 ProductName, SUM(Revenue) AS Sales
FROM RetailTransactions
GROUP BY ProductName
ORDER BY Sales DESC;

SELECT 
  SUM(Revenue) AS TotalSales,
  AVG(Revenue) AS AvgOrderValue,
  COUNT(DISTINCT InvoiceNo) AS TotalOrders
FROM RetailTransactions;

SELECT Category, SUM(Revenue) AS Revenue
FROM RetailTransactions
GROUP BY Category
HAVING SUM(Revenue) > 500000;

SELECT 
  Category,
  COUNT(DISTINCT InvoiceNo) AS Orders,
  SUM(Revenue) AS Revenue,
  AVG(Revenue) AS AvgOrderValue
FROM RetailTransactions
GROUP BY Category
ORDER BY Revenue DESC;
