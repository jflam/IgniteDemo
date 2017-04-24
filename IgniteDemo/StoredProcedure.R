# @InputDataSet: input data frame, result of SQL query execution
# @OutputDataSet: data frame to pass back to SQL

# Test code
#library(RODBC)
#conn = odbcDriverConnect(connection = dbConnection)
#InputDataSet <- sqlQuery(conn, iconv(paste(readLines('c:/users/jflam/src/ignitedemo/ignitedemo/storedprocedure.query.sql', encoding = 'UTF-8', warn = FALSE), collapse = '\n'), from = 'UTF-8', to = 'ASCII', sub = ''))

InputDataSet$new_key <-
paste(
    InputDataSet$hack_license,
    InputDataSet$medallion,
    sep = "_"
)

OutputDataSet <- InputDataSet