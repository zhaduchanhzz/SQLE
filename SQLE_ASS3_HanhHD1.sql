Use DMS
go

--a Add at least 8 records into each created tables.
--dept table
insert into dept values('A01','Planning',null,'A01','Fvile1')
insert into dept values('A02','Operation',null,'A01','Fvile1')
insert into dept values('A03','Software support',null,'A01','Fvile1')
insert into dept values('AAA','Branch office AAA',null,'A01','Fvile2')
insert into dept values('B01','Branch office B01',null,'B01','Fvile2')
insert into dept values('A11','Branch office A11',null,'B01','Fvile2')
insert into dept values('B12','Branch office B12',null,'B01','Fvile2')
insert into dept values('C12','Branch office C12',null,'CCC','Fvile2')
insert into dept values('C34','Branch office C34',null,'CCC','Fvile2')
insert into dept values('C45','Branch office C45',null,'CCC','Fvile2')
insert into dept values('C56','Branch office C56',null,'CCC','Fvile1')
insert into dept values('CCC','Branch office CCC',null,'A01','Fvile2')
--emp table
insert into emp values('EMP001','Hanh','Ha Duc','CCC','Help desk','10000','5000',1)
insert into emp values('EMP002','Chinh','Ha Duc','A11','Analyst','20000','14000',2)
insert into emp values('EMP003','Zing','Hai','C45','Analyst','30000','13000',3)
insert into emp values('EMP004','Jai','Ba','CCC','Analyst','30000','11000',5)
insert into emp values('EMP005','Jiang','Bon','AAA','Analyst','40000','3000',4)
insert into emp values('EMP006','Hu','Nam','AAA','Analyst','40000','3000',3)
insert into emp values('EMP007','Dai','Sau','AAA','CEO','50000','8000',3)
insert into emp values('EMP008','Hoc','Bay','AAA','ProjectManager','60000','7000',5)
insert into emp values('EMP009','Ep','Tam','AAA','ProjectManager','50000','6000',7)
insert into emp values('EMP010','Biti','Chin','CCC','ProjectManager','50000','5000',3)
insert into emp values('EMP011','Haunzer','Muoi','CCC','ProjectManager','30000','4000',2)
insert into emp values('EMP012','Impact','One','CCC','ProjectManager','20000','3000',4)
insert into emp values('EMP013','Spider','Two','CCC','ProjectManager','20000','2000',5)
insert into emp values('EMP014','Dragon','Three','CCC','Analyst','20000','1000',6)
insert into emp values('EMP015','Dinosaur','Four','CCC','Analyst','33000','11000',6)

-- act table
insert into ACT Values(90,'Activity A')
insert into ACT Values(95,'Activity B')
insert into ACT Values(155,'Activity C')
insert into ACT Values(100,'Activity D')
insert into ACT Values(150,'Activity E')
insert into ACT Values(110,'Activity F')
insert into ACT Values(115,'Activity G')
insert into ACT Values(123,'Activity I')
insert into ACT Values(122,'Activity K')
-- EMPPROJACT table
INSERT INTO EMPPROJACT VALUES ('EMP001','PRJ001',90)
INSERT INTO EMPPROJACT VALUES ('EMP002','PRJ001',90)
INSERT INTO EMPPROJACT VALUES ('EMP003','PRJ001',90)
INSERT INTO EMPPROJACT VALUES ('EMP004','PRJ001',155)
INSERT INTO EMPPROJACT VALUES ('EMP005','PRJ001',150)
INSERT INTO EMPPROJACT VALUES ('EMP006','PRJ001',123)
INSERT INTO EMPPROJACT VALUES ('EMP007','PRJ002',123)
INSERT INTO EMPPROJACT VALUES ('EMP003','PRJ002',123)
INSERT INTO EMPPROJACT VALUES ('EMP009','PRJ002',122)
INSERT INTO EMPPROJACT VALUES ('EMP010','PRJ002',122)
INSERT INTO EMPPROJACT VALUES ('EMP011','PRJ002',122)
INSERT INTO EMPPROJACT VALUES ('EMP012','PRJ002',122)
-- EMPMAJOR table
INSERT INTO EMPMAJOR VALUES ('EMP001','SE','Software Engineer')
INSERT INTO EMPMAJOR VALUES ('EMP002','SE','Software Engineer')
INSERT INTO EMPMAJOR VALUES ('EMP003','SE','Software Engineer')
INSERT INTO EMPMAJOR VALUES ('EMP004','AI','Artificial Intelligence')
INSERT INTO EMPMAJOR VALUES ('EMP005','SE','Software Engineer')
INSERT INTO EMPMAJOR VALUES ('EMP006','SE','Software Engineer')
INSERT INTO EMPMAJOR VALUES ('EMP007','CS','Computer Sience')
INSERT INTO EMPMAJOR VALUES ('EMP003','AI','Artificial Intelligence')
INSERT INTO EMPMAJOR VALUES ('EMP009','AI','Artificial Intelligence')
INSERT INTO EMPMAJOR VALUES ('EMP001','CS','Computer Sience')


--B, Create a non-clustered index on DEPT (dept_name) table with name as “IX_DEPT_depart_name”.

USE DMS;  
GO  
CREATE NONCLUSTERED  INDEX IX_DEPT_depart_name
ON DEPT(dept_name)
GO 
--c. Find employees who are currently working on a project or projects. Employees working on projects will have a row(s) on the EMPPROJACT table.
select EMPPROJACT.emp_no,[proj_no],[last_name]
      ,[first_name]
      ,[dept_no]
      ,[job]
      ,[salary]
      ,[bonus]
      ,[ed_level]  from EMPPROJACT,EMP
where EMP.emp_no =EMPPROJACT.emp_no

-- d, Find employees who work on all activities between 90 and 110
select *  from EMP e join EMPPROJACT emp on e.emp_no = emp.emp_no
where emp.act_no between 90 and 110

--e, Provide a report of employees with employee detail information along with department aggregate information.
Select * from emp
--case 1
select *,avgslr.Average from (Select dept_no ,avg(salary)  as Average from emp group by dept_no) as avgslr join EMP e on avgslr.dept_no = e.dept_no

-- case  2
select * from emp,(Select dept_no ,avg(salary)  as Average from emp group by dept_no) as avgslr where emp.dept_no = avgslr.dept_no
--f , Use CTE technique to provide a report of employees whose education levels are higher than the average education level of their respective department.
go
with avgeducation as (Select dept_no ,avg(ed_level)  as AverageEdu from emp group by dept_no) 
select * from emp,avgeducation where emp.dept_no = avgeducation.dept_no and EMP.ed_level> AverageEdu
go

--
select * From emp where salary in   (select top 5 salary from EMP 
group by salary
order by salary desc) order by salary desc



