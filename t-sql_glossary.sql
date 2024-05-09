select * from friends


-- Create a table
CREATE TABLE friends (
	id INT NOT NULL,
	first_name varchar(30),
	last_name varchar(30),
	birthdate date
)


--Insert rows
INSERT INTO friends VALUES(1, 'Irina', 'Munroe', '1949-05-30')
INSERT INTO friends VALUES(2, 'Joel', 'Martin', '1945-04-30')
INSERT INTO friends VALUES(3, 'Jonh', 'Smith', '1940-05-30')


/* CREATE A PRIMARY KEY (PK) IN AN EXISTING TABLE
In this case: the variable id of the friends table will be assigned as a pk
with the name PK_friends_id*/
ALTER TABLE friends
	ADD CONSTRAINT PK_friends_id PRIMARY KEY CLUSTERED (id)


-- Change values
UPDATE friends
SET first_name = 'Iryna' 
WHERE first_name = 'Irina'


-- Add new columns/variables
ALTER TABLE friends
	ADD email varchar(50)

UPDATE friends
SET email = 'first@email.com'
WHERE id = 1

UPDATE friends
SET email = 'second@email.com'
WHERE id = 2

UPDATE friends
SET email = 'third@email.com'
WHERE id = 3

--Delete existing records
DELETE FROM friends
WHERE email = 'first@email.com'

--Clean all table
TRUNCATE TABLE friends

-- Eliminate/Delete the table
DROP TABLE friends

--rename column/variable
EXEC sp_rename 'friends.email', 'email_personal', 'COLUMN'

--rename table
EXEC sp_rename 'friends', 'friends_childhood'
