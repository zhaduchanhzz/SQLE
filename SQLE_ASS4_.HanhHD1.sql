--Ha Duc Hanh - Java_05 - HanhHD1


CREATE DATABASE Project_management

GO 
USE Project_management
GO
-- Q2, a, Create the tables (with the most appropriate field/column constraints & types) and add at least 3 records into each created table.

CREATE TABLE Employee(
EmployeeID INT PRIMARY KEY IDENTITY(1,1)
,SupervisorID INT REFERENCES Employee(EmployeeID)
,Employee_last_name VARCHAR(50) not null
,Employee_first_name VARCHAR(50) not null
,EmployeeHireDate DATETIME not null
,Employee_Status INT CHECK(Employee_Status between 0 and 1)
,Social_Security_number DECIMAL(12,0) UNIQUE 
)

CREATE TABLE Projects(
ProjectID  VARCHAR(20) PRIMARY KEY
,SupervisorID int FOREIGN KEY REFERENCES Employee(EmployeeID) 
,ProjectName VARCHAR(50) UNIQUE
,ProjectStartDate DATETIME 
,ProjectDscription VARCHAR(MAX)
,ProjectDetail VARCHAR(MAX)
,ProjectConpletedOn date

)
CREATE TABLE Project_Modules( 
ModuleID VARCHAR(50) PRIMARY KEY
,EmployeeID int FOREIGN KEY REFERENCES Employee(EmployeeID)
,ProjectID VARCHAR(20) FOREIGN KEY REFERENCES Projects(ProjectID)
,ProjectModulesDate DATETIME
,ProjectModulesCompledOn DATETIME 
,ProjectModulesDescription VARCHAR(MAX)
)
CREATE TABLE Work_Done
(
WorkDoneID VARCHAR(25) PRIMARY KEY
,ModuleID VARCHAR(50) FOREIGN KEY REFERENCES Project_Modules(ModuleID)
,WorkDoneDate DATETIME
,WOrkdoneDescription VARCHAR(MAX)
,WorkDoneStatus VARCHAR(7) CHECK (WorkDoneStatus = 'Working' or WorkDoneStatus = 'Waiting' or WorkDoneStatus = 'Done')

)


INSERT INTO Employee 
VALUES
(null,'Lionel','Messi','2021-11-10',1,12345678910)
,(null,'Khi','Nhac Den','2021-12-28',1,12345678911)
,(null,'Ronaldo','Thi Do La','2022-01-25',1,12345678912)
,(1,'Ronaldo','De lima','2021-06-22',1,12345678913)
,(1,'Ricardo','Ka Ka','2021-01-05',1,12345678914)
,(1,'Mohamed','Salah','2021-04-21',1,12345678915)
,(2,'Gao','Ranger','2021-04-21',1,12345678916)
,(2,'Huri','Canger','2021-04-21',1,12345678917)
,(2,'Lord','of the rings','2021-04-21',0,12345678918)


INSERT INTO Projects VALUES 
('Project1',1,'Unikey','2022-01-11','Trai dat nay','Typing vietnamese by Unikey','2022-11-11')
,('Project2',2,'Vietkey','2022-02-10','La cua ','CTyping vietnamese by Vietkey','2022-10-12')
,('Project3',3,'Text to speech','2022-02-10','Chung minh','Typing vietnamese by Mouth','2022-12-13')

INSERT INTO Project_Modules VALUES
('Login',4,'Project1','2022-04-11','2022-06-11','Qua bong xanh')
,('Logout',5,'Project1','2022-04-11','2022-04-11','Bay giua troi xanh')
,('Typing',6,'Project1','2022-04-11','2022-09-13','Bo cau oi')
,('Grifin',7,'Project2','2022-03-13','2022-06-13','Canh chim gu')
,('Minotaur',8,'Project2','2022-03-13','2022-05-13','Thuong men')
,('Hermes',9,'Project2','2022-03-13','2022-05-13','Hai au oi')


INSERT INTO Work_Done VALUES
('Done1','Login','2022-03-11','complete module login','Done')
,('Done2','Logout','2022-04-11','complete  module logout','Done')
,('Done3','Typing','2022-09-13','complete  module tping','Done')



 /* Q2, b,	Write a stored procedure (without parameter) to remove the projects that were completed at
least three months ago. Print out the number of records which are removed from each related
table during the removals.
 */
 


 go
 DROP PROCEDURE DeleteCompleted;  
GO
CREATE PROCEDURE DeleteCompleted 
AS
BEGIN
DELETE FROM Work_Done WHERE ModuleID IN (SELECT ModuleID FROM Project_Modules WHERE  ProjectID = (SELECT a.ProjectID 
FROM (SELECT * FROM ( SELECT e.ProjectID , e.ProjectConpletedOn,DATEDIFF(MONTH,e.ProjectConpletedOn, GETDATE()) 
AS 'Completed' FROM Projects e ) AS Prj_day
WHERE Prj_day.Completed >=3) AS a))
DELETE FROM Project_Modules WHERE ProjectID IN (SELECT a.ProjectID FROM (SELECT * FROM ( SELECT e.ProjectID , e.ProjectConpletedOn,DATEDIFF(MONTH,e.ProjectConpletedOn, GETDATE()) AS 'Completed' FROM Projects e ) AS Prj_day
WHERE Prj_day.Completed >=3) AS a) 
DELETE FROM Projects WHERE ProjectID= (SELECT a.ProjectID FROM (SELECT * FROM ( SELECT e.ProjectID , e.ProjectConpletedOn,DATEDIFF(MONTH,e.ProjectConpletedOn, GETDATE()) AS 'Completed' FROM Projects e ) AS Prj_day
WHERE Prj_day.Completed >=3) AS a) 
SELECT @@ROWCOUNT as 'Number of deleted record'
END
GO
EXEC  DeleteCompleted
 /* Q2, c, Write a stored procedure (with parameter) to print out the modules that a specific employee has
been working on.
 */

GO
CREATE PROCEDURE ModulesOfEmployee  (@EmployeeID INT )
AS
BEGIN
SELECT e.EmployeeID, m.ModuleID FROM  Employee  e join  Project_Modules  m ON  e.EmployeeID = m.EmployeeID 
Where e.EmployeeID =@EmployeeID
END
GO
EXEC  ModulesOfEmployee '4'

 /* Q2, d) Write a user function (with parameter) that return the Works information that a specific employee
has been involving though those were not assigned to him/her.
 */

DROP  Function IF EXISTS Work_Employee
GO
CREATE FUNCTION Employee_Work_info (@EmployeeID INT )
RETURNS TABLE
AS
RETURN (SELECT e.EmployeeID ,w.WorkDoneID, p.ModuleID,w.WOrkdoneDescription  
FROM Employee e join Project_Modules p 
ON e.EmployeeID = p.EmployeeID join Work_Done w 
ON p.ModuleID = w.ModuleID
WHERE e.EmployeeID = @EmployeeID)
GO

 /* e) Write the trigger(s) to prevent the case that the end user to input invalid Projects and Project
Modules information (Project_Modules.ProjectModulesDate < Projects.ProjectStartDate,
Project_Modules.ProjectModulesCompletedOn > Projects.ProjectCompletedOn). */
 
GO
USE Project_management
GO
CREATE  TRIGGER  Modify_Date
ON Project_Modules 
FOR INSERT,UPDATE
AS
BEGIN
DECLARE @modulestartdate date;
DECLARE @projectStartdate date;
DECLARE @@modulcmp date;
DECLARE @projectcmp Date;
SELECT @modulestartdate =  inserted.[ProjectModulesDate] FROM inserted;
SELECT @projectStartdate = Projects.ProjectStartDate FROM Projects WHERE ProjectID = (SELECT inserted.[ProjectID] FROM inserted )
SELECT @@modulcmp = inserted.[ProjectModulesCompledOn] FROM inserted;
SELECT @projectcmp =  Projects.ProjectConpletedOn FROM Projects WHERE PROJECTS.ProjectID = (SELECT inserted.[ProjectID] FROM inserted )
IF @modulestartdate > @projectStartdate or @@modulcmp < @projectcmp
BEGIN
RAISERROR('Time input error Please input Again.', 11, 1);
ROLLBACK TRANSACTION;
END 
END
GO

INSERT INTO Project_Modules VALUES('n23123z',4,'Project1','2022-01-15','2022-03-11','Qua bong xanh')