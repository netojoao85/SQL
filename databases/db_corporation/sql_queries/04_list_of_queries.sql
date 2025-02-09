/* 1 - How many employee records are lacking both a grade and salary?*/
SELECT 
	COUNT(id) 'count'
FROM employees
WHERE grade IS NULL AND salary IS NULL


/* 2 - Produce a table with the two following fields (columns):
  > the department
  > the employees full name (first and last name)
Order your resulting table alphabetically by department, and then by last name*/
SELECT 
	first_name,
	last_name,
	department,
	CONCAT(first_name, ' ', last_name) 'full_name'
FROM employees
ORDER BY department ASC, last_name ASC


/* 3 - Find the details of the top ten highest paid employees who have a last_name 
beginning with ‘A’.*/
SELECT TOP 10 *
FROM employees
WHERE last_name like 'A%'
ORDER BY salary DESC


/* 4 - Obtain a count by department of the employees who started work with 
the corporation in 2003.*/
SELECT 
	department,
	COUNT(id) 'num_employees'
FROM employees
WHERE DATEPART(year, start_date) = 2003
GROUP BY department
ORDER BY num_employees DESC


/* 5 - Obtain a table showing department, fte_hours and the number of employees 
in each department who work each fte_hours pattern. Order the table alphabetically 
by department, and then in ascending order of fte_hours.*/
SELECT 
	department,
	fte_hours,
	COUNT(id) 'num_employees'
FROM employees
GROUP BY department, fte_hours
ORDER BY department ASC


/* 6 - Provide a breakdown of the numbers of employees enrolled, not enrolled, and 
with unknown enrollment status in the corporation pension scheme.*/
SELECT
	pension_enrol,
	COUNT(*) 'num_employees'
FROM employees
GROUP BY pension_enrol


/* 7 - Obtain the details for the employee with the highest salary in the ‘Accounting’ 
department who is not enrolled in the pension scheme?*/
SELECT TOP 1 *
FROM employees
WHERE 
	pension_enrol = 'No' AND
	department = 'Accounting'
ORDER BY salary DESC


/* 8 - Get a table of country, number of employees in that country, and the average salary 
of employees in that country for any countries in which more than 30 employees are based. 
Order the table by average salary descending.*/
SELECT 
	country, 
	COUNT(id) 'num_employees',
	AVG(salary) 'avg_salary_country'
FROM employees
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY avg_salary_country DESC


/* 9 - Return a table containing each employees first_name, last_name, full-time equivalent 
hours (fte_hours), salary, and a new column effective_yearly_salary which should contain 
fte_hours multiplied by salary. Return only rows where effective_yearly_salary is more 
than 30000.*/
SELECT 
	first_name, 
	last_name,
	fte_hours, 
	salary, 
	fte_hours * salary 'effective_yearly_salary'
FROM employees
WHERE fte_hours * salary > 30000
ORDER BY effective_yearly_salary DESC


/* 10 - Find the details of all employees in either Data Team 1 or Data Team 2*/
SELECT 
	e.*,
	t.name 'team_name'
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
WHERE t.name IN ('Data Team 1', 'Data Team 2')


/* 11 - Find the first name and last name of all employees who lack a local_tax_code.*/
SELECT 
	e.first_name, 
	e.last_name,
	d.local_sort_code
FROM employees AS e LEFT JOIN details as d
ON e.pay_detail_id = d.id
WHERE d.local_sort_code IS NULL OR ISNULL(d.local_sort_code, '') = ''


/* 12 - The expected_profit of an employee is 
defined as (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends upon 
the team to which the employee belongs. Get a table showing expected_profit for each employee.*/
SELECT 
	e.first_name,
	e.last_name,
	t.name,
	e.salary,
	e.fte_hours,
	t.charge_cost,
	(48 * 35 * t.charge_cost - e.salary * e.fte_hours) 'profit'
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
ORDER BY profit DESC


/* 13 - Find the first_name, last_name and salary of the lowest paid employee in Japan who 
works the least common full-time equivalent hours across the corporation.*/
WITH most_common_fte AS (
	SELECT TOP 1 
		fte_hours
	--COUNT(id) 'num_employees'
	FROM employees
	GROUP BY fte_hours
	ORDER BY COUNT(id) DESC
)

SELECT TOP 1
	first_name,
	last_name,
	country,
	fte_hours,
	salary
FROM employees
WHERE 
	country = 'Japan' AND 
	salary IS NOT NULL AND
	fte_hours = (SELECT * FROM most_common_fte)
ORDER BY salary ASC


/* 14 - Obtain a table showing any departments in which there are two or more employees 
lacking a stored first name. Order the table in descending order of the number of employees 
lacking a first name, and then in alphabetical order by department.*/
SELECT 
	department,
	COUNT(id) 'num_employees'
FROM employees
WHERE ISNULL(first_name, '') =''
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY num_employees DESC, department ASC


/* 15 - Return a table of those employee first_names shared by more than one employee, 
together with a count of the number of times each first_name occurs. Omit employees 
without a stored first_name from the table. Order the table descending by count, and 
then alphabetically by first_name.*/
SELECT 
	first_name,
	COUNT(id) 'num_employees'
FROM employees
WHERE NOT ISNULL(first_name, '') = ''
GROUP BY first_name
HAVING COUNT(id) > 1
ORDER BY num_employees DESC, first_name


/* 16 - Find the proportion of employees in each department who are grade 1.*/

-- Proportion from total employees of coorporation with grade = 1
WITH num_employees_grade AS (
	SELECT 
		COUNT(id) 'num_employees'
	FROM employees
	--WHERE grade = 1
	--GROUP BY department
)
SELECT 
	department,
	COUNT(id) 'num_employees',
	COUNT(id) * 100 / (SELECT * FROM num_employees_grade) 'proportion'
FROM employees
WHERE grade = 1
GROUP BY department
ORDER BY proportion DESC

-- Find the proportion of employees in each department who are grade 1.*/
SELECT 
    department, 
    SUM(CAST(CASE WHEN grade = 1 THEN 1 ELSE 0 END AS INT)) / CAST(COUNT(id) AS REAL) 'proportion'
FROM employees 
GROUP BY department
ORDER BY proportion DESC


/* 17 - Get a list of the id, first_name, last_name, department, salary and fte_hours 
of employees in the largest department. Add two extra columns showing the ratio of each 
employee’s salary to that department’s average salary, and each employee’s fte_hours to 
that department’s average fte_hours.*/

/*WITH aux_department AS (
	SELECT department, COUNT(id) 'count' FROM [omni_company].[dbo].[employees] GROUP BY department
),
max_dep AS (SELECT MAX(count) 'max_count' FROM aux_department),
min_dep AS(SELECT MIN(count) 'min_coun' FROM aux_department),
most_common_dep AS (SELECT department FROM aux_department WHERE count = (SELECT max_count FROM max_dep))*/

WITH most_common_dep AS (
	SELECT TOP 1
		department
		--COUNT(id) 'count'
	FROM [omni_company].[dbo].[employees]
	GROUP BY department
	ORDER BY COUNT(id) DESC
)

SELECT 
	id,first_name, last_name, department, salary, fte_hours,
	--AVG(salary) OVER (PARTITION BY (SELECT * FROM most_common_dep)) 'avg_salary_dep',
	CONVERT(numeric(10,3), salary / CONVERT(numeric(10,3), AVG(salary) OVER (PARTITION BY (SELECT * FROM most_common_dep)))) 'ratio_salary',
	--AVG(fte_hours) OVER (PARTITION BY (SELECT * FROM most_common_dep)) 'avg_fte_dep',
	CONVERT(numeric(10,3), fte_hours / AVG(fte_hours) OVER (PARTITION BY (SELECT * FROM most_common_dep))) 'ratio_fte'
FROM [omni_company].[dbo].[employees]
WHERE department = (SELECT * FROM most_common_dep)


/* 18 - Have a look again at your table for MVP question 6. It will likely contain a blank 
cell for the row relating to employees with ‘unknown’ pension enrollment status. This is 
ambiguous: it would be better if this cell contained ‘unknown’ or something similar. Can 
you find a way to do this, perhaps using a combination of COALESCE() and CAST(), or a 
CASE statement?*/
SELECT 
	COALESCE(NULLIF(pension_enrol, ''), 'unknown') 'pension_enrol',
	COUNT(*) 'count'
FROM employees
GROUP BY pension_enrol


/* 19 - Find the first name, last name, email address and start date of all the employees 
who are members of the ‘Equality and Diversity’ committee. Order the member employees by 
their length of service in the company, longest first.*/
SELECT 
	e.first_name,
	e.last_name,
	e.email,
	e.start_date
FROM 
	(employees AS e LEFT JOIN employees_committees AS ec
	ON e.id = ec.employee_id)
LEFT JOIN committees AS c
ON ec.commitee_id = c.id
WHERE c.name = 'Equality and Diversity'
ORDER BY e.start_date ASC



/* 20 - Use a CASE() operator to group employees who are members of committees into 
salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000). A NULL salary 
should lead to 'none' in salary_class. 
Count the number of committee members in each salary_class.*/
WITH aux AS(
	SELECT
		e.id 'id_employee',
		e.first_name,
		e.last_name,
		e.salary,
		c.name 'name_commitee',
		CASE
			WHEN salary < 40000 THEN 'low'
			WHEN salary IS NULL THEN 'none'
			WHEN ISNULL(salary, '') = '' THEN 'none'
			ELSE 'high'	
		END 'salary_class'
	FROM 
		(employees AS e LEFT JOIN employees_committees AS ec
		 ON e.id = ec.employee_id)
	LEFT JOIN committees AS c
	ON ec.commitee_id = c.id
	WHERE c.name IS NOT NULL
)

SELECT 
	salary_class,
	COUNT(*) 'count_employees'
FROM aux
GROUP BY salary_class


/*EXTRA 1 - get a table with the employees with the higher salary in each department*/
	
	-- Two different approaches:
	-- > Option 1: Join the CTE with main query
	-- > Option 2: In the main query, using the CTE as a subquery

WITH department_salary AS (
	SELECT
		department,
		MAX(salary) 'max_salary',
		MIN(salary) 'min_salary',
		AVG(salary) 'avg_salary'
	FROM employees
	GROUP BY department
)

-- Option 1
/*
SELECT
	e.first_name,
	e.last_name,
	e.department,
	e.salary
FROM employees AS e INNER JOIN department_salary AS ds
ON e.department = ds.department 
WHERE e.salary = ds.max_salary
*/


-- Option 2
SELECT
	first_name,
	last_name,
	department,
	salary
FROM employees AS e
WHERE salary = (SELECT min_salary FROM department_salary WHERE department = e.department)

/*Which departments have more than 35 employees with a salary greather or equal the 
average salary of their department*/
WITH department_salary AS (
	SELECT
		department,
		MAX(salary) 'max_salary',
		MIN(salary) 'min_salary',
		AVG(salary) 'avg_salary',
		COUNT(id) 'num_employees'
	FROM employees
	GROUP BY department
)
SELECT
	department,
	COUNT(id) 'num_employees'
FROM employees AS e
WHERE salary >= (SELECT avg_salary FROM department_salary AS ds WHERE ds.department = e.department)
GROUP BY department
HAVING COUNT(id) > 35
ORDER BY num_employees DESC

/*Who are the employers that have a salary above the average salary of their department*/
WITH department_salary AS (
	SELECT
		department,
		MAX(salary) 'max_salary',
		MIN(salary) 'min_salary',
		AVG(salary) 'avg_salary',
		COUNT(id) 'num_employees'
	FROM employees
	GROUP BY department
)
SELECT 
	e.first_name, 
	e.last_name,
	e.department,
	e.salary,
	(SELECT avg_salary FROM department_salary AS ds WHERE ds.department = e.department) 'dep_avg_salary'
	--AVG(e.salary) OVER (PARTITION BY e.department) 'department_avg_salary'
FROM employees AS e
WHERE 
	salary > (SELECT avg_salary FROM department_salary AS ds WHERE ds.department = e.department)


-- find all the employees in the Japan who earn more than the average salary 
-- of all employees*/

WITH average_salary AS (
	SELECT 
		AVG(salary) 'total_avg_salary'
	FROM employees
)

SELECT *
FROM employees
WHERE 
	country = 'Japan' AND
	salary > (SELECT total_avg_salary FROM average_salary)

/* -- find all the employees in the USA who work the most common fte-hours 
 -- across the corporation*/

 WITH fte_group AS (
	 SELECT TOP 1
		 fte_hours,
		 COUNT(id) 'num_employees'
	 FROM employees
	 GROUP BY fte_hours
	 ORDER BY num_employees DESC
 )
 SELECT *
 FROM employees
 WHERE 
	country = 'United States' AND
	fte_hours = (SELECT fte_hours FROM fte_group)

/* -- find all the employees in the USA who work the most common fte-hours and less common
 -- across the corporation*/

 WITH fte_group AS (
	 SELECT
		 fte_hours,
		 COUNT(id) 'num_employees'
	 FROM employees
	 GROUP BY fte_hours
 ),
 most_common AS (
	SELECT TOP 1
		fte_hours,
		num_employees
	FROM fte_group
	ORDER BY num_employees DESC
 ),
 less_common AS (
	SELECT TOP 1
		fte_hours,
		num_employees
	FROM fte_group
	ORDER BY num_employees ASC
)

SELECT *
FROM employees
WHERE 
	country = 'United States' AND
	fte_hours IN ((SELECT fte_hours FROM most_common), (SELECT fte_hours FROM less_common))


