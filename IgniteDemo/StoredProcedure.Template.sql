CREATE PROCEDURE [StoredProcedure]
AS
BEGIN
EXEC sp_execute_external_script @language = N'R'
    , @script = N'_RCODE_'
    , @input_data_1 = N'_INPUT_QUERY_'

    WITH RESULT SETS ((
		medallion NVARCHAR(max), 
		hack_license NVARCHAR(max),
		new_key NVARCHAR(max)))
END;
