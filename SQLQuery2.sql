﻿USE [NYCTaxiData]
GO

DECLARE	@return_value Int

EXEC	@return_value = [dbo].[StoredProcedure]

SELECT	@return_value as 'Return Value'

GO