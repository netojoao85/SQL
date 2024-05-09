
#/////////////////////////////////////////////////////////////////////////////
#
# get the database connection function ---------------------------------------
# 
#   > establish the connection with the database
#   > insert values from a csv file into a database table
#
#/////////////////////////////////////////////////////////////////////////////
source(here::here("db_omni_corporation/R_scripts/functions/function_insertTableValues.R"), local = TRUE)




#/////////////////////////////////////////////////////////////////////////////
#
# Select the table to connect and insert values from the csv file ------------
#
#/////////////////////////////////////////////////////////////////////////////

## table 'employees' ----------------------------------
sqlServer_insertValues(
  server = "JOAONETO\\SQL_JNETO", # SQL Server name
  database = "omni_company", # database name
  table = "employees", #table name
  data = filter(read_csv("db_omni_corporation/raw_data/omni_employees.csv"), id > 1)
)


## table 'committees' ----------------------------------
sqlServer_insertValues(
  server = "JOAONETO\\SQL_JNETO", # SQL Server name
  database = "omni_company", # database name
  table = "committees", #table name
  data = filter(read_csv("db_omni_corporation/raw_data/omni_committees.csv"), id > 1)
)


## table 'employees_committes' ----------------------------------
sqlServer_insertValues(
  server = "JOAONETO\\SQL_JNETO", # SQL Server name
  database = "omni_company", # database name
  table = "employees_committees", #table name
  data = filter(read_csv("db_omni_corporation/raw_data/omni_employees_committees.csv"), id > 1)
)


## table 'details' ----------------------------------
sqlServer_insertValues(
  server = "JOAONETO\\SQL_JNETO", # SQL Server name
  database = "omni_company", # database name
  table = "details", #table name
  data = filter(read_csv("db_omni_corporation/raw_data/omni_pay_details.csv"), id > 1)
)


## table 'teams' ----------------------------------
sqlServer_insertValues(
  server = "JOAONETO\\SQL_JNETO", # SQL Server name
  database = "omni_company", # database name
  table = "teams", #table name
  data = filter(read_csv("db_omni_corporation/raw_data/omni_teams.csv"), id > 1)
)


