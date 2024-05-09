# -------------------------------------------------------------------------
# This function establish the communication with a SQL server database.
# After the communication was established, it insert a table into the selected 
# Server and database.
#     
#    It has as arguments: 
#       > server (the name of the server to connect), 
#       > database (the name of the database)
#       > table (the name the table to insert the data) 
#       > data (directory path of the csv file /table to update into the db)
# ------------------------------------------------------------------------------- 

library(RODBC)
library(sqldf)
library(tidyverse)

sqlServer_insertValues <- function(server, database, table, data) {
  
  # Establish connection to SQL Server
  conn <- odbcDriverConnect(
    paste0("Driver={SQL Server};",
           "Server=", server, ";",
           "Database=", database, ";",
           "Trusted_Connection=yes")
  )
  
  # Insert data into SQL Server
  sqlSave(conn, dat = data, tablename = table, append = TRUE, fast = FALSE, rownames = FALSE)
  
  # Close connection
  odbcClose(conn)
  
}
