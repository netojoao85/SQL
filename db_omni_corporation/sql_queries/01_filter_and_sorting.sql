-- Get the employee with id = 3
SELECT *
FROM employees
WHERE id = 3

-- Get the employees that work more that in part-time (fte_hours >=0.5)
SELECT *
FROM employees
WHERE fte_hours >= 0.5

-- get the employees that are not from Brazil
SELECT *
FROM employees
WHERE country != 'Brazil'

-- Employees from China and started in 2019 onwards
SELECT *
FROM employees
WHERE country = 'China' AND DATEPART(year, start_date) >= 2019

-- Employees from China, started in 2019 onwards or have pension_enrol
SELECT *
FROM employees
WHERE 
	country = 'China' AND 
	(DATEPART(year, start_date) >= 2019 OR pension_enrol = 'Yes')

-- fte_hours between 0.25 and 0.5
SELECT *
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5

-- All employees excepted who started in 2017
SELECT *
FROM employees
WHERE DATEPART(year, start_date) != 2017


-- Add a new column that join the first and last name
SELECT 
	*,
	CONCAT(first_name, ' ', last_name) AS full_name
FROM employees

------------------------------------------------------------------------------------

-- What is the maximum salary in the corporation?
SELECT
	MAX(salary) as max_salary
FROM [omni_company].[dbo].[employees]

-- What is the lower salary in the corporation?
SELECT
	MIN(salary) as min_salary
FROM employees

--What is the higher and lower salary?
SELECT 
	MAX(salary) as max_salary,
	MIN(salary) as min_salary
FROM employees

--What is the average salary in the Human Resources department
SELECT 
	avg(salary) as avg_salary
FROM employees
WHERE department = 'Human Resources';

--Get the details of the longest-serving employee of the corporation.
SELECT TOP 1 *
FROM employees
WHERE DATEPART(year, start_date) >= 1990 --because there are observations with the year of 1900
ORDER BY start_date ASC

--Get the details of the highest paid employee of the corporation in Libya.
SELECT TOP 1 *
FROM employees
WHERE country = 'Libya'
ORDER BY salary DESC

-- Order employees by full-time equivalent hours, highest 
-- first, and then alphabetically by last name.
SELECT *
FROM employees
ORDER BY 
	fte_hours DESC,
	last_name ASC

-- Which are the departments exists in the corporation?
SELECT
	DISTINCT(department)
FROM employees

-- What is the average, higher, and lower salary by department? And the numeber of
-- employees by department.
SELECT
	department,
	AVG(salary) AS avg_salary,
	MAX(salary) AS max_salary,
	MIN(salary) AS min_salary,
	COUNT(id) AS num_employees
FROM employees
GROUP BY department

-- Just for who started in 2000 onwards. What is the average, higher, and lower 
-- salary by department? And the numeber of employees by department.
DECLARE @year INT;
SET @year = 2000

SELECT
	department,
	AVG(salary) AS avg_salary,
	MAX(salary) AS max_salary,
	MIN(salary) AS min_salary,
	COUNT(id) AS num_employees
FROM employees
WHERE DATEPART(YEAR, start_date) >= @year
GROUP BY department


------------------------------------------------------------------------------
-- A STACK OF QUESTIONS
------------------------------------------------------------------------------
-- 1: Find all the employees who work in the ‘Human Resources’ department.
SELECT *
FROM employees
WHERE department = 'Human Resources';

-- 2: Get the first_name, last_name, and country of the employees 
-- who work in the ‘Legal’ department.
SELECT 
	first_name,
	last_name,
	country
FROM employees
WHERE department = 'Legal'

-- 3: Count the number of employees based in Portugal
SELECT 
	COUNT(id) AS num_portugal
FROM employees
WHERE country = 'Portugal'

--4: Count the number of employees based in either Portugal or Spain.
SELECT 
	count(id) AS num_employees_iberia
FROM employees
WHERE country IN ('Portugal', 'Spain')

-- 5: Count the number of pay_details records lacking a local_account_no.
SELECT
	count(id) AS num_empty
FROM details
WHERE local_account_no IS NULL

--6: Are there any pay_details records lacking both a 
-- local_account_no and iban number?
SELECT 
	COUNT(id)
FROM details
WHERE local_account_no IS NULL AND iban IS NULL

-- 7: Get a table with employees first_name and last_name ordered alphabetically 
-- by last_name
SELECT
	first_name,
	last_name
FROM employees
ORDER BY last_name ASC;

-- 8: Get a table of employees first_name, last_name and country, 
-- ordered alphabetically first by country and then by last_name
SELECT 
	first_name,
	last_name, 
	country
FROM employees
ORDER BY 
	country ASC,
	last_name ASC;

-- 9: Find the details of the top ten highest paid employees 
-- in the corporation
SELECT TOP 10 *
FROM employees
ORDER BY salary DESC

-- 10: Find the first_name, last_name and salary of the lowest 
-- paid employee in Hungary.
SELECT TOP 1 
	first_name,
	last_name,
	salary
FROM employees
WHERE country = 'Hungary'
ORDER BY salary ASC


-- 11: How many employees have a first_name beginning with ‘F’?
SELECT 
	COUNT(id) AS num_employees
FROM employees
WHERE first_name like 'F%'

-- 12: Find all the details of any employees with a 
-- ‘yahoo’ email address?
SELECT *
FROM employees
WHERE email like '%yahoo%'

-- 13: Count the number of pension enrolled employees 
-- not based in either France or Germany.
SELECT 
	COUNT(id) as num_employees
FROM employees
WHERE pension_enrol = 'Yes' AND country NOT IN ('France', 'Germany')

--14: What is the maximum salary among those employees in the ‘Engineering’ 
-- department who work 1.0 full-time equivalent hours (fte_hours)?
SELECT
	MAX(salary) AS max_engineering_salary
FROM employees
WHERE department = 'Engineering' AND fte_hours = 1.0

-- 15: Return a table containing each employees first_name, last_name, 
-- full-time equivalent hours (fte_hours), salary, and a new column 
-- effective_yearly_salary which should contain fte_hours multiplied 
-- by salary.
SELECT
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
from employees

-- 16: The corporation wants to make name badges for a forthcoming 
-- conference. Return a column badge_label showing employees’ first_name 
-- and last_name joined together with their department in the 
-- following style: ‘Bob Smith - Legal’. Restrict output to only 
-- those employees with stored first_name, last_name and department.
SELECT 
	first_name, 
	last_name,
	department,
	CONCAT(first_name, ' ', last_name, ' - ', department) AS badge_label
FROM employees
WHERE 
	first_name IS NOT NULL AND
	last_name IS NOT NULL AND
	department IS NOT NULL
	
-- 17: One of the conference organisers thinks it would be nice to 
-- add the year of the employees’ start_date to the badge_label to 
-- celebrate long-standing colleagues, in the following style 
-- ‘Bob Smith - Legal (joined 1998)’. Further restrict output to only 
-- those employees with a stored start_date.
SELECT
	first_name,
	last_name,
	department,
	start_date,
	CONCAT(
		first_name, ' ', last_name, ' - (joined ',
		DATEPART(YEAR, start_date),
		')'
	) AS badge_label
FROM employees
WHERE 
	first_name IS NOT NULL AND
	last_name IS NOT NULL AND
	department IS NOT NULL AND
	start_date IS NOT NULL


-- 18: Return the first_name, last_name and salary of all employees 
-- together with a new column called salary_class with a value 'low' 
-- where salary is less than 40,000 and value 'high' where salary is 
-- greater than or equal to 40,000.
SELECT 
	first_name, 
	last_name,
	salary,
	CASE
		WHEN salary < 40000 THEN 'low'
		WHEN salary IS NULL then NULL
		ELSE 'high'
	END AS salary_class
FROM employees

