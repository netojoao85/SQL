-- Split the start_date into 3 new columns. One with the year, other with the month, and
-- the last with the day.
SELECT 
	*,
	DATEPART(year, start_date) AS start_date_year,
	DATEPART(month, start_date) AS start_date_month,
	DATEPART(day, start_date) AS start_date_day
FROM employees


SELECT 
	DATEPART(year, start_date) AS start_date_year,
	DATEPART(month, start_date) AS start_date_month,
	DATEPART(day, start_date) AS start_date_day,
	DATEPART(year, getdate()) AS today_year,
	DATEPART(month, getdate()) AS today_month,
	DATEPART(day, getdate()) AS today_day
FROM employees



-- What are the employees that started in March of 1989?
Declare @year int, @month int;
SET  @year = 2001
SET @month = 3

select * 
from employees
where 
	datepart(year, start_date) like @year AND
	datepart(month, start_date) like @month

-- How many employees started in March of 1989?
Declare @year int, @month int;
SET  @year = 2001
SET @month = 3

select 
	COUNT(id)
from employees
where 
	datepart(year, start_date) like @year AND
	datepart(month, start_date) like @month
