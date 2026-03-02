USE MCDenald
--1 Female Transaction Masking & Volume Report
SELECT REPLACE(td.TransactionID, 'R', LEFT(CustomerName,1)) AS TransactionID, 
CustomerName, SUM(Quantity) AS 'TotalQuantity'
FROM Customer c JOIN TransactionHeader th
	ON c.CustomerID = th.CustomerID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
WHERE CustomerName LIKE '%a%' AND CustomerGender = 'Female'
GROUP BY td.TransactionID,CustomerName

--2 Mid-Year Late-Month Customer Purchase Averaging
SELECT td.TransactionID, CustomerName, AVG(Quantity) AS 'Average Quanitity' 
FROM Customer c JOIN TransactionHeader th
	ON c.CustomerID = th.CustomerID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
WHERE MONTH(TransactionDate) > 5 AND DAY(TransactionDate)  >14
GROUP BY td.TransactionID, CustomerName

--3 Even-ID Product Category Performance Summary
SELECT pt.ProductTypeID, UPPER(ProductTypeName) AS 'ProductTypeName', COUNT(pt.ProductTypeID) AS 'TotalProductType', SUM(Quantity) AS 'Total Quantity'
FROM ProductType pt JOIN Product p
	ON pt.ProductTypeID = p.ProductTypeID
	JOIN TransactionDetail td
	ON p.ProductID = td.ProductID
WHERE ProductTypeName LIKE '%e%' AND RIGHT(pt.ProductTypeID,1) IN ('0','2','4','6','8')
GROUP BY pt.ProductTypeID, ProductTypeName

--4 Post-2019 Male Customer Purchase Extremes
SELECT td.TransactionID, 'Mr. ' + LOWER(CustomerName) AS 'Customer Name', MIN(Quantity) AS 'MinimumPurchase', MAX(Quantity) AS 'MaximumPurchase' 
FROM Customer c JOIN TransactionHeader th
	ON c.CustomerID = th.CustomerID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
WHERE YEAR(TransactionDate) > 2019 AND CustomerGender = 'Male'
GROUP BY td.TransactionID, CustomerName

--5 First-Half Month High-Value Product Sales
SELECT td.TransactionID, TransactionDate, StaffName, CONCAT(p.ProductID, '-' , LEFT(ProductName,1)) AS 'ProductID', ProductName 
FROM TransactionHeader th JOIN Staff s
	ON th.StaffID = s.StaffID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
	JOIN Product p
	ON p.ProductID = td.ProductID,
	(SELECT AVG(ProductPrice) AS Average FROM Product) AS AveragePrice
WHERE ProductPrice > AveragePrice.Average AND DAY(TransactionDate) <  16


--6 Detailed Revenue Summary for Specific Customer Demographics
SELECT CONVERT(VARCHAR,TransactionDate, 106) AS 'TransactionDate', LOWER(CustomerName) AS 'CustomerName', 
(SELECT SUM(ProductPrice*Quantity) AS Total
FROM TransactionDetail td JOIN Product pro
	ON td.ProductId = pro.ProductID)
AS TotalPrice
FROM Customer c JOIN TransactionHeader th
	ON c.CustomerID = th.CustomerID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
	JOIN Product p
	ON p.ProductID = td.ProductID
WHERE LEN(CustomerName ) > 7 AND CustomerAddress LIKE '%i%'
GROUP BY TransactionDate, CustomerName

--7 Below-Average Revenue Analysis for Multi-Word Payment Methods
SELECT REPLACE(td.TransactionID, 'R', UPPER(RIGHT(CustomerName,1)))AS 'TransactionID', 
CONVERT(VARCHAR,TransactionDate, 107) AS 'TransactionDate', 
CustomerName, SUM(ProductPrice*Quantity) AS 'TotalPrice'
FROM Customer c JOIN TransactionHeader th
	ON c.CustomerID = th.CustomerID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
	JOIN Product p
	ON td.ProductID = p.ProductID
	JOIN Payment
	ON th.PaymentID = Payment.PaymentID,
	(SELECT AVG(Price.TotalPrice) AS AverageTotalPrice
		FROM (SELECT SUM(ProductPrice*Quantity) AS TotalPrice
			FROM Customer c JOIN TransactionHeader th
			ON c.CustomerID = th.CustomerID
			JOIN TransactionDetail td
			ON th.TransactionID = td.TransactionID
			JOIN Product p
			ON td.ProductID = p.ProductID
			GROUP BY CustomerName) AS Price) AS Average
WHERE PaymentName LIKE ('% %') 
GROUP BY td.TransactionID, TransactionDate, CustomerName, Average.AverageTotalPrice
HAVING SUM(ProductPrice*Quantity) < Average.AverageTotalPrice

--8 High-Quantity Performance at Odd-Numbered Stores
SELECT DISTINCT td.TransactionID, 'Mr/Ms ' + CustomerName AS 'CustomerName', CustomerNumber, REPLACE(StoreName, 's','''s'  ) AS StoreName
FROM Customer c JOIN TransactionHeader th
	ON c.CustomerID = th.CustomerID
	JOIN Store st
	ON th.StoreID = st.StoreID
	JOIN TransactionDetail td
	ON Th.TransactionID = td.TransactionID,
	(SELECT AVG(Quantity) AS qty
	FROM TransactionDetail) AS AverageQuantity
WHERE RIGHT(StoreNumber,1) IN ('1','3','5','7','9') AND Quantity > AverageQuantity.qty 





GO
--9 Staff_Female_Productivity_History
CREATE VIEW staff_activeness AS
SELECT td.TransactionID, YEAR(TransactionDate) AS 'Year of TransactionDate', StaffName, SUM(Quantity) AS 'TotalQuantity',
(SELECT AVG(TotalQuantity.Total) AS Average FROM
		(SELECT SUM(Quantity) AS Total
		FROM TransactionHeader th JOIN Staff st
		ON th.StaffID = st.StaffID 
		JOIN TransactionDetail td
		ON th.TransactionID = td.TransactionID
		GROUP BY td.TransactionID) AS TotalQuantity) AS AverageQuantity
FROM TransactionHeader th JOIN Staff st
	ON th.StaffID = st.StaffID 
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
WHERE StaffGender = 'Female' AND DATEDIFF(YEAR, TransactionDate, GETDATE()) <= 6 
GROUP BY td.TransactionID, TransactionDate, StaffName

GO

--10 Early_Year_Short_Label_Payment_Stats
CREATE VIEW payment_method_usage AS
SELECT th.PaymentID, PaymentName, MIN(Quantity) AS 'Minimum Quantity' , MAX(Quantity) AS 'Maximum Quantity'
FROM Payment pay JOIN TransactionHeader th
	ON pay.PaymentID = th.PaymentID
	JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID
WHERE MONTH(TransactionDate) < 5 AND LEN(PaymentName) < 5
GROUP BY th.PaymentID, PaymentName