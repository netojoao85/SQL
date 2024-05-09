
--------------------------------------------------------------------------------------
/* > CREATE 'employees' table
   > Insert first row of values*/
--------------------------------------------------------------------------------------
CREATE TABLE [omni_company].[dbo].[employees] (
	id INT NOT NULL,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50),
	department varchar(50),
	team_id int,
	grade int,
	country varchar(50),
	fte_hours DECIMAL(10,2),
	pension_enrol varchar(50),
	salary int,
	pay_detail_id int,
	start_dat date
);

INSERT INTO [omni_company].[dbo].[employees] VALUES (
	1,'Ibbie', 'Roscrigg', 'iroscrigg0@google.fr','Legal', 9, 0.0, 
	'Nigeria', 0.25, 'Yes', 97667.0,1, '2014-12-25'
);

--DROP TABLE employees;


--------------------------------------------------------------------------------------
/* > CREATE 'committes' table
   > Insert first row of values*/
--------------------------------------------------------------------------------------
CREATE TABLE [omni_company].[dbo].[committees] (
	id INT PRIMARY KEY NOT NULL,
	name varchar(50)
)

INSERT INTO  [omni_company].[dbo].[committees] VALUES (1, 'Health and Safety');

--DROP TABLE  [omni_company].[dbo].[committees];


--------------------------------------------------------------------------------------
/* > CREATE 'employees_committes' table
   > Insert first row of values*/
--------------------------------------------------------------------------------------
CREATE TABLE [omni_company].[dbo].[employees_committees]
(
	id INT PRIMARY KEY NOT NULL,
	employee_id numeric(8),
	commitee_id NUMERIC(5)
);

INSERT INTO  [omni_company].[dbo].[employees_committees] VALUES (1,507, 30);

--DROP TABLE  [omni_company].[dbo].[employees_committees];


--------------------------------------------------------------------------------------
/* > CREATE 'teams' table
   > Insert first row of values*/
--------------------------------------------------------------------------------------
CREATE TABLE [omni_company].[dbo].[teams] (
	id INT PRIMARY KEY NOT NULL,
	name varchar(50),
	charge_cost NUMERIC(5)
);

INSERT INTO [omni_company].[dbo].[teams] VALUES(1, 'Audit Team 1', 30);

--DROP TABLE  [omni_company].[dbo].[teams];


--------------------------------------------------------------------------------------
/* > CREATE 'details' table
   > Insert first row of values*/
--------------------------------------------------------------------------------------
CREATE TABLE [omni_company].[dbo].[details]  (
	id INT NOT NULL,
	local_account_no numeric(20),
	local_sort_code varchar(50),
	iban varchar(50),
	local_tax_code varchar(50)
);

INSERT INTO [omni_company].[dbo].[details] 
VALUES(1, 33305834, '09-95-56', 'HR72 3447 9133 3004 6430 0', 'jc4158o')

--DROP TABLE [omni_company].[dbo].[details]