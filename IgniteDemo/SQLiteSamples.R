
# Demo using the SQLite ODBC driver instance. This is implemented
# as an ODBC driver that wraps *by value* the SQLite library. 
#
# You will first need to download and install the 64 bit ODBC driver.
# You can get it from: http://www.ch-werner.de/sqliteodbc/
#
# Since this wraps the SQLite library, it will typically lag behind 
# the latest version of SQLite available from https://sqlite.org.
# At the time of this writing, the current version available 
# at SQLite.org is 3.14.2 (2016-09-12) and the version of SQLite
# available as part of RSQLite is 3.13.0 (2016-05-18).
# 
# This demo also has a dependency on the RODBC package, which is 
# satisfied by the sourcing of the dependencies.R file

source("dependencies.R")
library(RODBC);

# You will first need to create a system data source name using
# the ODBC connection manager (in Windows, press Start and type "ODBC").
# The name of the data source name is specified in the call to the
# odbcConnect() function - "SQLiteDemo"

sqlite <- odbcConnect("SQLiteDemo", rows_at_time = 1, believeNRows = FALSE);

# Print connection details

odbcGetInfo(sqlite)

# Insert some sample data into the SQLite database

sqlQuery(sqlite, "CREATE TABLE COMPANY (ID INT NOT NULL, NAME TEXT NOT NULL);")
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (1, 'Paul'  );")
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (2, 'Allen' );")
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (3, 'Bill' );")
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (4, 'Steve' );")
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (5, 'David' );")
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (6, 'Kim' );")

# Query database and retrieve data as a dataframe

df <- sqlQuery(sqlite, "SELECT * FROM COMPANY;")

# Remove table when complete

sqlQuery(sqlite, "DROP TABLE COMPANY;")

# Drop the connection

odbcClose(sqlite)

# Another variation of this sample using the RSQLite package.In this
# example, you can create an in-memory SQLite database, and load it
# or save it with data directly from R dataframes.
#
# The latest version of this can be found on Github:
# https://github.com/rstats-db/RSQLite

library(DBI)

# Create an ephemeral in-memory RSQLite database

con <- dbConnect(RSQLite::SQLite(), ":memory:")

dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)

dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")

# You can fetch all results:

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
dbClearResult(res)

# Or a chunk at a time

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while (!dbHasCompleted(res)) {
    chunk <- dbFetch(res, n = 5)
    print(nrow(chunk))
}

# Cleanup

dbClearResult(res)
dbDisconnect(con)