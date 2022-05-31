USE master
DROP DATABASE GuitarShopDB
GO


CREATE DATABASE GuitarShopDB
GO
USE GuitarShopDB
GO

-- Create Data base GuitarShopDB and create the tables with the most appropriate constraints and type

CREATE TABLE Products(
ProductID INT IDENTITY(1,1) PRIMARY KEY
,ProductCode VARCHAR(10) CHECK(LEN(ProductCode) = 10) UNIQUE NOT NULL
,ProductName VARCHAR(100) NOT NULL
,[Description] VARCHAR(500) NOT NULL 
,DateAdded DATETIME
)

CREATE TABLE Customers(
CustomerID INT IDENTITY(1,1) PRIMARY KEY
,Email VARCHAR(100) UNIQUE NOT NULL
,[Password] VARCHAR(100) NOT NULL
,FirstName NVARCHAR(100) NOT NULL
,LastName NVARCHAR(100) NOT NULL
,[Address] VARCHAR(200) 
,IsPasswordChanged BIT DEFAULT 0
)

CREATE TABLE Orders(
OrdersID INT IDENTITY(1,1) PRIMARY KEY
,CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) 
,OrderDate DATETIME NOT NULL
,ShipAddress VARCHAR(200) 
)

CREATE TABLE OrderItems(
OrdersID  INT FOREIGN KEY REFERENCES Orders(OrdersID) 
,ProductID INT FOREIGN KEY REFERENCES Products(ProductID) 
,Quantity INT NOT NULL CHECK(Quantity >0)
,UnitPrice MONEY NOT NULL
,DiscountPercent DECIMAL(4,2) NOT NULL CHECK (DiscountPercent BETWEEN 0 AND 75)
)


-- INSERT values in to the created table

INSERT INTO Products VALUES ('PRODUCT001','Electric Guitar','Using electric to play','2000-04-19')
,('PRODUCT002','Imagine Guitar','Using brain to play','2001-04-19')
,('PRODUCT003','Uklele','Using hand to play','2003-04-19')
,('PRODUCT004','Electric Guitar 01','Using electric to play','2005-04-19')
,('PRODUCT005','Electric Guitar 02','Using electric to play','2007-04-19')
,('PRODUCT006','Electric Guitar 03','Using electric to play','2009-04-19')
,('PRODUCT007','Electric Guitar 04','Using electric to play','2015-04-04')
,('PRODUCT008','Electric Guitar 05','Using electric to play','2020-04-19')
,('PRODUCT009','Electric Guitar 06','Using electric to play','2021-04-19')
,('PRODUCT010','Electric Guitar 07','Using electric to play','2022-04-19')
,('PRODUCT011','Electric Guitar 08','Using electric to play',GETDATE())
,('PRODUCT012','Electric Guitar 09','Using electric to play',GETDATE())
,('PRODUCT013','Electric Guitar 10','Using electric to play',GETDATE())
,('PRODUCT014','Electric Guitarr','Using electric to play',GETDATE())
,('PRODUCT015','Electric Guitarrrr','Using electric to play',GETDATE())


INSERT INTO Customers VALUES('emailcus001@gmail.com','password',N'fname',N'lname','Viet Nam',1)
,('emailcus002@gmail.com','password',N'Hạnh',N'Hà Đức','Viet Nam',1)
,('emailcus003@gmail.com','password',N'Messi',N'Lionel','Viet Nam',1)
,('emailcus004@gmail.com','password',N'Dvanci',N'Leonardo','Viet Nam',0)
,('emailcus005@gmail.com','password',N'Ensiten',N'Albert','Viet Nam',0)
,('emailcus006@gmail.com','password',N'Tesla',N'Nicola','Viet Nam',0)
,('emailcus007@gmail.com','password',N'Musk',N'Elon','Viet Nam',0)
,('emailcus008@gmail.com','password',N'Gate',N'Bill','Viet Nam',0)
,('emailcus009@gmail.com','password',N'Ma',N'Jack','Viet Nam',0)
,('emailcus010@gmail.com','password',N'Phúc',N'Nguyễn Xuân','Viet Nam',0)
,('emailcus011@gmail.com','password',N'Thành',N'Nguyễn Tất','Viet Nam',0)
,('emailcus012@gmail.com','password',N'Minh',N'Hồ Chí','Viet Nam',0)
,('emailcus013@gmail.com','password',N'Hồng',N'Hoàng Phi','Viet Nam',0)
,('emailcus014@gmail.com','password',N'Giáp',N'Võ Nguyên','Viet Nam',0)
,('emailcus015@gmail.com','password',N'Hương',N'Nguyễn Thị Lan','Viet Nam',0)
,('rick@raven.com','password',N'Thor',N'Thờ o','Viet Nam',0)

INSERT INTO Orders VALUES (1,'2022-03-03','Hoa Lac')
,(1,'2022-03-03','Ha Noi')
,(1,'2022-03-01','Ha Noi')
,(1,'2022-03-02','Ha Noi')
,(2,'2022-03-03','Trung Quoc')
,(3,'2022-03-04','Trung Quoc')
,(4,'2022-03-05','Trung Quoc')
,(5,'2022-03-06','Lon Don')
,(6,'2022-03-07','Lon Don')
,(4,'2022-03-08','Lon Don')
,(7,GETDATE(),'Madagascar')
,(7,GETDATE(),'Madagascar')
,(7,GETDATE(),'Madagascar')
,(7,GETDATE(),'Madagascar')
,(7,GETDATE(),'Madagascar')
,(7,GETDATE(),'Madagascar')
,(8,GETDATE(),'Madagascar')

INSERT INTO OrderItems VALUES (1,2,100,1500,10)
,(1,3,20,2000,15)
,(1,4,10,10000,20)
,(1,4,22,10000,10)
,(2,2,100,1500,10)
,(2,3,1,2000,50)
,(3,4,10,5555,10)
,(3,2,3,1500,20)
,(4,2,11,1500,30)
,(4,1,12,1234,20)
,(4,3,3,2000,10)
,(4,4,1,10000,10)
,(7,5,1,5000,70)
,(7,6,1,6000,60)
,(7,7,1,7000,30)
,(7,8,1,8000,40)
,(7,9,1,9000,50)
,(8,5,1,5000,20)
,(8,6,1,6000,25)
,(8,7,1,7000,30)


-- B, Query Return added product at leat 12 months ago
SELECT [ProductCode]
      ,[ProductName]
      ,[Description]
      ,[DateAdded]
  FROM [GuitarShopDB].[dbo].[Products] P WHERE DATEDIFF( MONTH,p.[DateAdded] , GETDATE()) > 12
 ORDER BY  DATEDIFF( MONTH,p.DateAdded , GETDATE()) DESC


 -- C, Query Update data in Customers table 

 UPDATE Customers  SET [password] = 'Secret''@1234!', IsPasswordChanged = 1 WHERE Email ='rick@raven.com' AND IsPasswordChanged = 0


 -- D, Query product have unit price  greater than 500 and less than 2000
  SELECT ProductName, UnitPrice, DateAdded FROM  Products p  JOIN OrderItems o ON p.ProductID = o. ProductID
 WHERE UnitPrice > 500 AND UnitPrice < 2000
 ORDER BY DateAdded DESC

 -- E, Query return customers with full name

 SELECT CustomerID,(LastName+', ' + FirstName) AS [Fullname],Email,[Address] FROM Customers