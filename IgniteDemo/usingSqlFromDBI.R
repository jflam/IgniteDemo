
# This sample uses the DBI interface for communicating with SQL Server
# For details on usage, and more samples see this documentation site:
# http://rstats-db.github.io/DBI/

source("dependencies_3_3.R")

library(DBI)
library(RODBCDBI)

# You first must create a new ODBC data source name. In this case,
# this sample uses the NYCTaxiData database that is located on this 
# machine. Create it using the ODBC connection manager utility
# that you can access by opening the Start menu and typing "ODBC".

conn <- dbConnect(RODBCDBI::ODBC(), dsn = "NYCTaxiData")

dbListTables(conn)

res <- dbSendQuery(conn, "select top 10 * from nyctaxi_sample")
df <- dbFetch(res)

res <- dbSendQuery(conn, "select count(*) from nyctaxi_sample")
df <- dbFetch(res)

dbDisconnect(conn)

# Use the DBI interface to talk to SQLite

library(RSQLite)

# Access the built-in SQLite database that ships with the RSQLite package

conn <- datasetsDb()
dbListTables(conn)

# Read the mtcars table into a local dataframe

df <- dbReadTable(conn, "mtcars")

dbDisconnect(conn)

# Write some data out to a local SQLite file called SQLiteDemo.db, and read
# it back in via a SQL query.

conn <- dbConnect(SQLite(), dbname = "SQLiteDemo.db")

dbWriteTable(conn, "mtcars", mtcars)

res <- dbSendQuery(conn, "select * from mtcars where cyl > 4")
df <- dbFetch(res)

dbDisconnect(conn)