-- Find the number of employees within each department of the corporation. Sort 
-- the departments by the most employees
SELECT 
	department,
	count(id) AS num_employees
FROM employees
GROUP BY department
ORDER BY num_employees DESC

-- Find the number of employees jut for the Legal department
SELECT 
	count(id) as num_employees_legal
FROM employees
WHERE department = 'Legal'

-- How many employees are there in each country?
SELECT 
	country,
	COUNT(id) AS num_employees
FROM employees
GROUP BY country
ORDER BY num_employees DESC

--How many employees in each department work either 0.25 or 0.5 FTE hours?
SELECT 
	department,
	count(id) AS num_employees
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department
ORDER BY num_employees DESC

-- Find the longest time served by any one employee in each department.
SELECT 
  department, 
  DATEDIFF(day, MIN(start_date), GETDATE()) AS longest_time
FROM employees 
WHERE DATEPART(year, start_date) >= 1990
GROUP BY department

SELECT 
	department,
	MAX(DATEDIFF(day, start_date, GETDATE())) as longest_time_days,
	MAX(DATEDIFF(year, start_date, GETDATE())) as longest_time_years
FROM employees
WHERE DATEPART(year, start_date) >= 1990 --there are lower years that not make sense
GROUP BY department
ORDER BY longest_time_days DESC

-- How many employees in each department are enrolled in the pension scheme?
SELECT 
	department,
	COUNT(id) AS num_employees
FROM employees
WHERE pension_enrol = 'Yes'
GROUP BY department
ORDER BY num_employees DESC

-- Perform a breakdown by country of the number of employees that do not 
-- have a stored first name.
SELECT 
	country,
	COUNT(id)
FROM employees
WHERE ISNULL(first_name, '') = ''
GROUP BY country



-----------------------------------------------------------
/* HAVING 
   to filter groups by some value of an aggregate function? */
------------------------------------------------------------

-- Show those departments in which at least 40 employees work either 
-- 0.25 or 0.5 FTE hours”
SELECT 
	department,
	count(id) AS num_employees
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department
HAVING count(id) >= 40
ORDER BY num_employees DESC

-- Show any countries in which the minimum salary amongst pension enrolled 
-- employees is less than 21,000 dollars
SELECT 
	country,
	MIN(salary) AS min_salary
FROM employees
WHERE pension_enrol = 'Yes'
GROUP BY country
HAVING MIN(salary) < 21000
ORDER BY count(id) DESC

-- Show any departments in which the earliest start date amongst grade 1 
-- employees is prior to 1991”
SELECT 
	department,
	MIN(DATEPART(year, start_date)) AS start_year
FROM employees
WHERE grade = 1 AND DATEPART(year, start_date) >= 1990
GROUP BY department
HAVING MIN(DATEPART(year, start_date)) < 1991
ORDER BY start_year DESC

-----------------------------------------------------------
/* SUBQUERIES
   to filter groups by some value of an aggregate function? */
------------------------------------------------------------

-- Find all the employees in Japan who earn over the company-wide average salary.
SELECT *
from employees
WHERE 
	country = 'Japan' AND 
	salary > (SELECT AVG(salary) FROM employees WHERE country = 'Japan')

-- “Find all the employees in Legal who earn less than the mean salary in that 
-- same department.”
SELECT *
FROM employees
WHERE 
	department = 'Legal' AND
	salary < (SELECT AVG(salary) FROM employees WHERE department = 'Legal')
ORDER BY salary DESC

-- Find all the employees in the United States who work the most common
-- full-time equivalent hours across the corporation.

/*1) First Calculate the most commom fte_hours*/
SELECT TOP 1
	fte_hours
	--count(id) AS num_employees
FROM employees
GROUP BY fte_hours
ORDER BY count(id) DESC

/*2) Find out the employees from United States that have the fte_hours value from 
 the step 1*/
SELECT *
FROM employees
WHERE 
	country = 'United States' AND 
	fte_hours =  (
		SELECT TOP 1
			fte_hours
		FROM employees
		GROUP BY fte_hours
		ORDER BY count(id) DESC
		)

------------------------------------------------------------
 /*A STACK OF QUERIES*/
------------------------------------------------------------
/* 1a)  Find the first name, last name and team name of employees who are members 
of teams.*/
SELECT 
	 e.first_name,
	 e.last_name,
	 t.name as team_name
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id


/* 1b) Find the first name, last name and team name of employees who are members of 
teams and are enrolled in the pension scheme.*/
SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id
WHERE 
	e.pension_enrol = 'Yes'AND
	NOT ISNULL(first_name, '') = '' AND
	NOT ISNULL(last_name, '') = '' 

/* 1c) Find the first name, last name and team name of employees who are 
members of teams, where their team has a charge cost greater than 80.*/
SELECT 
	e.first_name, 
	e.last_name,
	t.name AS team_name
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id 
WHERE 
	CAST(t.charge_cost AS INT) > 80 AND
	NOT ISNULL(first_name, '') = '' AND
	NOT ISNULL(last_name, '') = ''


/* 2a) Get a table of all employees details, together with their local_account_no 
and local_sort_code, if they have them.*/
SELECT 
	e.*,
	d.local_account_no, 
	d.local_sort_code
FROM employees AS e LEFT JOIN details as d
ON e.pay_detail_id = d.id

/* 2b) Amend your query above to also return the name of the team that each 
employee belongs to. */
SELECT 
	e.*,
	d.local_account_no,
	d.local_sort_code,
	t.name AS team_name
FROM 
	(employees AS e LEFT JOIN details AS d
	 ON e.pay_detail_id = d.id)
LEFT JOIN teams AS t
ON e.team_id = t.id


/* 3a). Make a table, which has each employee id along with the team that employee
belongs to.*/
SELECT 
	e.id AS employee_id,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams as t
ON e.team_id = t.id
ORDER BY team_name ASC


/* 3b). Breakdown the number of employees in each of the teams.*/
SELECT 
	t.name AS team_name,
	COUNT(e.id) AS num_employees
FROM employees AS e LEFT JOIN teams as t
ON e.team_id = t.id
GROUP BY t.name
ORDER BY num_employees DESC

/* 3c). Order the table above by so that the teams with the least employees come first.*/
SELECT
	t.name AS team_name,
	COUNT(e.id) AS num_employees
FROM employees AS e LEFT JOIN teams AS t 
	ON e.team_id = t.id
GROUP BY t.name
ORDER BY num_employees ASC

/* 4a) Create a table with the team id, team name and the count of the number of employees 
in each team.*/
SELECT 
	t.id,
	t.name,
	count(e.id) AS num_employees
FROM teams AS t INNER JOIN	employees AS e
ON t.id = e.team_id
GROUP BY t.id, t.name
ORDER BY num_employees DESC

/*4b) The total_day_charge of a team is defined as the charge_cost of the team multiplied 
by the number of employees in the team. Calculate the total_day_charge for each team.*/
SELECT
	t.id,
	t.name,
	CAST(t.charge_cost AS INT) * COUNT(e.id) AS total_day_charge
FROM employees AS e LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id, t.name, t.charge_cost
ORDER BY total_day_charge DESC

/*4c)  How would you amend your query from above to show only those teams with a 
total_day_charge greater than 5000?*/
SELECT
	e.team_id,
	t.name AS team_name,
	CAST(t.charge_cost AS INT) * COUNT(e.id) AS total_day_charge
FROM employees AS e LEFT JOIN teams as t
ON e.team_id = t.id
GROUP BY e.team_id, t.name, t.charge_cost
HAVING CAST(t.charge_cost AS INT) * COUNT(e.id) > 5000
ORDER BY total_day_charge DESC

/*5) How many of the employees serve on one or more committees?*/
SELECT 
	COUNT(DISTINCT(employee_id)) AS num_employees
FROM employees_committees

SELECT
	employee_id,
	COUNT(id) AS num_services
FROM employees_committees
GROUP BY employee_id
HAVING COUNT(id) >= 1


/*6) How many of the employees do not serve on a committee?*/
SELECT 
	COUNT(*)
FROM employees AS e LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
WHERE ec.employee_id IS NULL