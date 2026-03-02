CREATE DATABASE MCDENALD
GO
USE MCDENALD
GO
CREATE TABLE Staff(
StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]') NOT NULL,
StaffName VARCHAR(50) NOT NULL,
StaffGender VARCHAR(10) CONSTRAINT ValidateGender CHECK(StaffGender IN ('Male','Female')) NOT NULL,
);

INSERT INTO Staff
VALUES 
('ST001', 'Melani Rodrigo', 'Female'),
('ST002', 'Jeremy Yonathan', 'Male'),
('ST003', 'Ivan Kurnia', 'Male'),
('ST004', 'Robert Santoso', 'Male'),
('ST005', 'Susi Susanti', 'Female'),
('ST006', 'Olivia', 'Female'),
('ST007', 'Rahmat Subardjo', 'Male'),
('ST008', 'Muhammad Salah', 'Male'),
('ST009', 'Riri Saputri', 'Female'),
('ST010', 'Salma Pertiwi', 'Female')
;

CREATE TABLE Store(
StoreID CHAR(5) PRIMARY KEY CHECK (StoreID LIKE 'SO[0-9][0-9][0-9]') NOT NULL,
StoreName VARCHAR(50) NOT NULL,
StoreAddress VARCHAR(50) CHECK (StoreAddress LIKE '%Street') NOT NULL,
StoreNumber VARCHAR(20) CHECK (StoreNumber LIKE '021%') NOT NULL
);

INSERT INTO Store
VALUES
('SO001', 'MCD Kopo', '120 Kopo Street', '021550678'),
('SO002', 'MCD Pasir Koja', '17 Pasir Koja Street', '021642198'),
('SO003', 'MCD Buah Batu', '106 Buah Batu Street', '021625353'),
('SO004', 'MCD Sunda', '78 Sunda Street', '021908166'),
('SO005', 'MCD Sumarecon', '119 Sumarecon Street','021777609'),
('SO006', 'MCD Merdeka', '81 Merdeka Street','021559887'),
('SO007', 'MCD Soekarno Hatta', '97 Soekarno Hatta Street', '021999533'),
('SO008', 'MCD Cibiru', '176 Cibiru Street','021889533'),
('SO009', 'MCD Podomoro', '10 Podomoro Street', '021809158'),
('SO010', 'MCD Setiabudi', '88 Setiabudi Street', '021555508')
;

CREATE TABLE Payment(
PaymentID CHAR(5) PRIMARY KEY CHECK (PaymentID LIKE 'PM[0-9][0-9][0-9]') NOT NULL,
PaymentName VARCHAR (15) CONSTRAINT ValidateMethod CHECK(PaymentName IN ('Cash','ERIS', 'Debit Card', 'EVA', 
																		 'Credit Card',	'DENA','GePay', 'E.Saku', 
																		 'SheppePay','Flep')) NOT NULL
);

INSERT INTO Payment
VALUES
('PM001', 'Cash'),
('PM002', 'ERIS'),
('PM003', 'Debit Card'),
('PM004', 'EVA'),
('PM005', 'Credit Card'),
('PM006', 'DENA'),
('PM007', 'GePay'),
('PM008', 'E.Saku'),
('PM009', 'SheppePay'),
('PM010', 'Flep')
;

CREATE TABLE Customer(
CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]') NOT NULL,
CustomerName VARCHAR(50) NOT NULL,
CustomerGender VARCHAR(10) CONSTRAINT ValidateCustomerGender CHECK(CustomerGender IN ('Male','Female')) NOT NULL,
CustomerAddress VARCHAR(50) CHECK (CustomerAddress LIKE '%Street') NOT NULL,
CustomerNumber VARCHAR(20) CHECK (CustomerNumber LIKE '(+62)%') NOT NULL
);


INSERT INTO Customer
VALUES 
('CU001', 'Sherly Wihardja', 'Female', '17 Kembar Mas Street', '(+62) 81117679'), 
('CU002', 'Siti Semila', 'Female', '65 Cigondewah Street', '(+62) 81341678'),
('CU003', 'Sheren Simorangkir', 'Female', '33 Cibolerang Street', '(+62) 89751888'),
('CU004', 'Nunung Gutawa', 'Female', '4 Kebon Jeruk Street', '(+62) 89915778'),
('CU005', 'Mirna Alexa', 'Female', '71 Sudirman Street', '(+62) 82208163'),
('CU006', 'Ono Sutono', 'Male', '22 Babakan Ciparay Street', '(+62) 89871143'),
('CU007', 'Mugi Muryadi', 'Male', '41 Cimahi Street', '(+62) 81780446'),
('CU008', 'Marvel Christian', 'Male', '10 Sukahaji Street', '(+62) 83091665'),
('CU009', 'Revel Revin', 'Male', '8 Setrasari Street', '(+62) 80815177'),
('CU010', 'Paul Simajuntak', 'Male', '15 Cibuntu Street', '(+62) 89136600')
;

CREATE TABLE ProductType(
ProductTypeID CHAR(5) PRIMARY KEY CHECK (ProductTypeID LIKE 'PT[0-9][0-9][0-9]') NOT NULL,
ProductTypeName VARCHAR(50) CONSTRAINT ValidateTypeName CHECK (ProductTypeName IN('Breakfast', 'Fish', 'Burger', 'Coffee',
																				  'Chicken', 'Family Package','Dessert',
																				  'Sad Meal', 'Meals', 	'Drinks')) NOT NULL
);

INSERT INTO ProductType 
VALUES
('PT001', 'Breakfast'),
('PT002', 'Fish'),
('PT003', 'Burger'),
('PT004', 'Coffee'),
('PT005', 'Chicken'),
('PT006', 'Family Package'),
('PT007', 'Dessert'),
('PT008', 'Sad Meal'),
('PT009', 'Meals'),
('PT010', 'Drinks')
;

CREATE TABLE Product(
ProductID CHAR(5) PRIMARY KEY CHECK (ProductID LIKE 'PR[0-9][0-9][0-9]') NOT NULL,
ProductTypeID CHAR(5) FOREIGN KEY REFERENCES ProductType (ProductTypeID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
ProductName VARCHAR(100) CHECK (LEN(ProductName) >= 5) NOT NULL,
ProductPrice FLOAT(10) NOT NULL,
);


INSERT INTO Product
VALUES
('PR001', 'PT001', 'Sausage Muffin', '18000'),
('PR002', 'PT002', 'Fish & Chips', '39000'),
('PR003', 'PT003', 'Cheeseburger', '25000'),
('PR004', 'PT004', 'Americano', '15000'),
('PR005', 'PT005', 'Chicken Set', '27000'),
('PR006', 'PT006', 'Family Bundle', '120000'),
('PR007', 'PT007', 'McFlurry', '14000'),
('PR008', 'PT008', 'Sad Meal Beef Burger', '32000'),
('PR009', 'PT009', 'Chicken & Rice', '42000'),
('PR010', 'PT010', 'Coca cola', '11000')
;

CREATE TABLE TransactionHeader(
TransactionID CHAR(5) PRIMARY KEY CHECK (TransactionID LIKE 'TR[0-9][0-9][0-9]') NOT NULL,
StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
TransactionDate DATE CHECK (TransactionDate <= GETDATE()) NOT NULL, 
PaymentID CHAR(5) FOREIGN KEY REFERENCES Payment(PaymentID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
StoreID CHAR(5) FOREIGN KEY REFERENCES Store(StoreID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
);

INSERT INTO TransactionHeader
VALUES
('TR001', 'ST001','CU002', '2018-03-03', 'PM003', 'SO001'),
('TR002', 'ST002','CU003', '2018-04-08', 'PM001', 'SO002'),
('TR003', 'ST003','CU004', '2018-08-10', 'PM003', 'SO003'),
('TR004', 'ST004','CU001', '2018-11-19', 'PM003', 'SO004'),
('TR005', 'ST005','CU006', '2019-01-11', 'PM002', 'SO005'),
('TR006', 'ST010','CU005', '2019-03-17', 'PM005', 'SO006'),
('TR007', 'ST009','CU007', '2019-04-20', 'PM005', 'SO007'),
('TR008', 'ST008','CU008', '2019-07-25', 'PM005', 'SO008'),
('TR009', 'ST007','CU006', '2020-02-13', 'PM004', 'SO009'),
('TR010', 'ST006','CU009', '2020-05-16', 'PM001', 'SO010'),
('TR011', 'ST005','CU010', '2020-07-28', 'PM002', 'SO001'),
('TR012', 'ST008','CU010', '2021-09-05', 'PM003', 'SO002'),
('TR013', 'ST009','CU001', '2021-05-17', 'PM004', 'SO003'),
('TR014', 'ST003','CU002', '2021-10-22', 'PM007', 'SO007'),
('TR015', 'ST002','CU005', '2021-11-24', 'PM008', 'SO008')
;

CREATE TABLE TransactionDetail(
TransactionID CHAR(5) FOREIGN KEY REFERENCES TransactionHeader(TransactionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL ,
ProductID CHAR(5) FOREIGN KEY REFERENCES Product(ProductID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
Quantity INT CHECK(Quantity BETWEEN 1 AND 200) NOT NULL
PRIMARY KEY(TransactionID, ProductID)
);
	
INSERT INTO TransactionDetail
VALUES
('TR001', 'PR001', 2),
('TR001', 'PR008', 3),
('TR002', 'PR010', 4),
('TR002', 'PR009', 1),
('TR003', 'PR003', 4),
('TR003', 'PR005', 2),
('TR004', 'PR007', 3),
('TR004', 'PR010', 1),
('TR005', 'PR001', 2),
('TR005', 'PR002', 1),
('TR006', 'PR003', 3),
('TR006', 'PR007', 2),
('TR007', 'PR008', 1),
('TR007', 'PR009', 1),
('TR008', 'PR010', 2),
('TR008', 'PR003', 5),
('TR009', 'PR002', 1),
('TR009', 'PR008', 6),
('TR010', 'PR007', 4),
('TR010', 'PR003', 1),
('TR011', 'PR001', 5),
('TR011', 'PR010', 7),
('TR012', 'PR002', 1),
('TR012', 'PR005', 1),
('TR013', 'PR005', 2),
('TR013', 'PR008', 2),
('TR014', 'PR004', 2),
('TR014', 'PR009', 3),
('TR015', 'PR003', 1),
('TR015', 'PR001', 1)
;