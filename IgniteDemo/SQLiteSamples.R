
# Demo using the built-in Windows 10 SQLite instance
# You will first need to download and install the 64 bit ODBC driver.
# You can get it from: http://www.ch-werner.de/sqliteodbc/
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

sqlQuery(sqlite, "CREATE TABLE COMPANY (ID INT NOT NULL, NAME TEXT NOT NULL);");
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (1, 'Paul'  );");
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (2, 'Allen' );");
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (3, 'Bill' );");
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (4, 'Steve' );");
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (5, 'David' );");
sqlQuery(sqlite, "INSERT INTO COMPANY (ID,NAME) VALUES (6, 'Kim' );");

# Query database and retrieve data as a dataframe

df <- sqlQuery(sqlite, "SELECT * FROM COMPANY;");

# Remove table when complete

sqlQuery(sqlite, "DROP TABLE COMPANY;");

# Drop the connection

odbcClose(sqlite);