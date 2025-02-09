----------------------------------------------------------------------------
-- CTEs (Common Table Expressions
-- Window Functions
----------------------------------------------------------------------------


-----------------------------------------------------------------------
/* Window function */
-----------------------------------------------------------------------
/*Show for each employee their salary together with the minimum and 
maximum salaries of employees in their department.*/
SELECT 
	first_name, 
	last_name,
	department,
	salary,
	MIN(salary) OVER (PARTITION BY department) AS min_salary_dep,
	MAX(salary) OVER (PARTITION BY department) AS max_salary_dep
FROM employees
ORDER BY min_salary_dep

/*Show for each employee the number of employees who are members of the 
same department as them.*/
SELECT 
	first_name,
	last_name, 
	department,
	COUNT(id) OVER (PARTITION BY department) AS num_employees_dep
FROM employees
ORDER BY num_employees_dep DESC


/*Show for each employee the number of employees who started in the same 
month as them.*/
SELECT 
	first_name, 
	last_name,
	start_date,
	COUNT(id) OVER(
	PARTITION BY DATEPART(month, start_date), DATEPART(year, start_date)) AS num_employees
FROM employees
WHERE DATEPART(year, start_date) >= 1990

/*Get a table of employees’ names, salary and start date ordered by start date, 
together with a running total of salaries by start date*/
SELECT
	first_name,
	last_name,
	salary, 
	start_date,
	SUM(salary) OVER (ORDER BY start_date ASC) AS running_total_salary
FROM employees
WHERE DATEPART(year, start_date) >= 1990


/*Get a table of employees showing the order in which they started work with the 
corporation split by department */
SELECT 
	first_name,
	last_name, 
	department,
	start_date,
	RANK() OVER (PARTITION BY department ORDER BY start_date ASC) 'rank_department'
FROM employees
WHERE DATEPART(year, start_date) >= 1990

/*Get a table of employee id, first and last name, grade and salary, together with 
two new columns showing the maximum salary for employees of their grade, and the 
minimum salary for employees of their grade.*/
SELECT 
	id,
	first_name,
	last_name,
	grade, 
	salary,
	MAX(salary) OVER (PARTITION BY grade) 'max_salary_grade',
	MIN(salary) OVER (PARTITION BY grade) 'min_salary_grade'
FROM employees
WHERE grade IS NOT NULL
ORDER BY id ASC




-----------------------------------------------------------------------
 -- CTEs (Common Table Expressions
-----------------------------------------------------------------------

/*Find all the employees in the United States who work the most common full-time equivalent 
hours across the corporation.*/

	/*Resolution without CTE*/
		-- 1º step: find out the most common fte_hours
		SELECT TOP 1 
			fte_hours
			--COUNT(id) as most_common_fte
		FROM employees
		GROUP BY fte_hours
		ORDER BY COUNT(id) DESC

		-- 2º step: Create the main query finding out the emplyees from US and filtering by the most
		-- common fte
		SELECT *
		FROM employees
		WHERE 
			country = 'United States' AND
			fte_hours = (
				SELECT TOP 1 
				fte_hours
				--COUNT(id) as most_common_fte
				FROM employees
				GROUP BY fte_hours
				ORDER BY COUNT(id) DESC
			)

	/*Resolution with CTE*/
		WITH fte_count AS (
			SELECT
				fte_hours,
				COUNT(id) AS count
			FROM employees
			GROUP BY fte_hours
			),
		max_fte_count AS (
			SELECT 
				MAX(count) AS max_count
			FROM fte_count
		),
		min_fte_count AS (
			SELECT
				MIN(COUNT) AS min_count
			FROM fte_count
		),
		most_common_fte AS (
			SELECT
				fte_hours
			FROM fte_count 
			WHERE count = (
				SELECT 
				  max_count 
				FROM max_fte_count
			)
		)
		SELECT * 
		FROM employees
		WHERE 
			country = 'United States' AND 
			fte_hours IN (
				SELECT 
					fte_hours
				FROM most_common_fte
			)

/*Add a column for each employee showing the average salary of their department,
and other column showing if his current salary is higher or above the depatment average*/
SELECT 
	first_name, 
	last_name,
	department,
	salary,
	AVG(salary) OVER (PARTITION BY department) AS avg_salary_dep,
	CASE
		WHEN salary > AVG(salary) OVER (PARTITION BY department) THEN 'TRUE'
		ELSE 'FALSE'
	END AS higher_low
FROM employees

/*Add a column for each employee showing the ratio of their salary to the 
average salary of their team.*/

-- Salary average by team
SELECT 
	t.id,
	t.name 'team_name',
	AVG(e.salary) AS avg_salary
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name, t.id



WITH team_avg(id, name, avg_salary) AS (
	SELECT 
		t.id,
		t.name 'team_name',
		AVG(e.salary) AS avg_salary
	FROM employees AS e LEFT JOIN teams AS t
	ON e.team_id = t.id
	GROUP BY t.name, t.id	
)

