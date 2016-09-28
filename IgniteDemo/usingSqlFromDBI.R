
# This sample uses the DBI interface for communicating with SQL databases.
# From the documentation: 
#
# The interface defines a small set of classes and methods similar in 
# spirit to Perl's DBI, Java's JDBC, Python's DB-API, and Microsoft's 
# ODBC. It defines a set of classes and methods defines what operations 
# are possible and how they are performed:
#
# - connect / disconnect to the DBMS
# - create and execute statements in the DBMS
# - extract results / output from statements
# - error / exception handling
# - information(meta - data) from database objects
# - transaction management(optional)
# 
# For details on usage, and more samples see this documentation site:
# http://rstats-db.github.io/DBI/

source("dependencies_3_3.R")

# You need to require the base DBI library, and the "back end" used.
# In the first example, we will be using RODBC to talk to SQL Server.
# It is worth noting that there is an additional layer of abstraction
# that is being used here - RODBC. In the future, we should have a 
# distinct package (using a name like RSQLServer) that communicates
# directly, in an optimized fashion, with the SQL Server Native 
# client library on Windows and Linux.

library(DBI)
library(RODBCDBI)

# The RODBCDBI package uses data source names to identify the database 
# to connect to. A data source name is a name for a connection string 
# to the database. These are stored per-user or per-machine by Windows.
# 
# You first must create a new ODBC data source name. In this case,
# this sample uses the NYCTaxiData database that is located on this 
# machine. Create it using the ODBC connection manager utility
# that you can access by opening the Start menu and typing "ODBC".

conn <- dbConnect(RODBCDBI::ODBC(), dsn = "NYCTaxiData")

# This will list all the tables in the NYCTaxiData, including all of
# the system tables that are created automatically by SQL Server for
# each database.

dbListTables(conn)

# This will send the SQL query specified by the string to SQL Server
# The dbFetch() API will retrieve the result set as an R dataframe

res <- dbSendQuery(conn, "SELECT TOP 10 * FROM nyctaxi_sample")
df <- dbFetch(res)

res <- dbSendQuery(conn, "SELECT COUNT(*) FROM nyctaxi_sample")
df <- dbFetch(res)

# Let's write the mtcars sample dataframe to SQL server as a new
# table called "mtcars"

# In an ideal world, this works, but for some reason the 
# RODBCDBI package does not implement the dbGetRowsAffected 
# function for the ODBCResult object, which results in the 
# command failing to run. Reporting this to the maintainer of
# RODBCDBI BUGBUG

if (dbExistsTable(conn, "mtcars")) {
    res <- dbSendQuery(conn, "DROP TABLE mtcars")
}

dbWriteTable(conn, "mtcars", mtcars)

# You can run this next query to verify that the data was written
# correctly to the database. You can also run the raw SQL statement
# in the query from the SampleQueries.sql file in this project
# to see the SQL tooling integration into your R projects.

res <- dbSendQuery(conn, "SELECT * FROM mtcars WHERE CYL > 4")
df <- dbFetch(res)

# Assert that the dimensions of the data returned are correct

print(dim(df) == c(21, 12))

dbDisconnect(conn)

# Use the DBI interface to talk to SQLite. Note that this sample uses a 
# SQLite specific back-end for DBI: RSQLite rather than relying on an 
# (incomplete) implementation of a wrapper over ODBC from the RODBCDBI
# package.
#
# For more details on usage of the RSQLite package, read this PDF:
# https://cran.r-project.org/web/packages/RSQLite/RSQLite.pdf

library(RSQLite)

# Access the built-in SQLite database that ships with the RSQLite package

conn <- datasetsDb()
dbListTables(conn)

# Read the mtcars table into a local dataframe

df <- dbReadTable(conn, "mtcars")

# Assert dimensions are identical

print(dim(df) == dim(mtcars))

dbDisconnect(conn)

# Write some data out to a local SQLite file called SQLiteDemo.db, and read
# it back in via a SQL query.

conn <- dbConnect(SQLite(), dbname = "SQLiteDemo.db")

# Write the dataframe to the database, creating a new table called "mtcars"

dbWriteTable(conn, "mtcars", mtcars)

# Now run the query against the new mtcars table

res <- dbSendQuery(conn, "SELECT * FROM mtcars WHERE cyl > 4")
df <- dbFetch(res)

# Assert that the dimensions of the data returned are correct

print(dim(df) == c(21, 12))

dbDisconnect(conn)