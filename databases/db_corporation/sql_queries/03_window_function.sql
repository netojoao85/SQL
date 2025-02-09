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

SELECT
	start_date,
	COUNT(id) AS num_entries
	--COUNT(DISTINCT(start_date))
FROM employees
GROUP BY start_date
HAVING COUNT(id) > 1

--WHERE start_date = '1990-02-14'

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

/*Add a column for each employee showing the ratio of their salary to the average 
salary of their team.*/
SELECT 
    e.first_name,
    e.last_name,
    t.name AS team_name,
    e.salary,
    AVG(e.salary) OVER (PARTITION BY t.name) AS avg_salary_team,
    ROUND(e.salary * 100 / AVG(e.salary) OVER (PARTITION BY t.name), 5) AS salary_ratio_team_average
	--ROUND(e.salary / AVG(e.salary) OVER (PARTITION BY e.team_id), 2) AS salary_ratio_team_average
FROM employees AS e 
LEFT JOIN teams AS t ON e.team_id = t.id
WHERE e.salary IS NOT NULL

SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	t.name,
	AVG(e.salary) OVER (PARTITION BY t.name) AS avg_salary_team,
	e.salary/AVG(e.salary) OVER (PARTITION BY t.name) 'ratio'
	--CONVERT(numeric(10,2), e.salary/AVG(e.salary) OVER (PARTITION BY t.name)) AS avg
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id	

