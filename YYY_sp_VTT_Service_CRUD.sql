USE DemoCustomerNK_CN
GO	

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Service_LoadList]
	@beginID INT = 0
	, @limit INT = 10
	, @currentID INT = 0
AS
BEGIN
	SELECT LS.*
	INTO #SERVICELIST
	FROM 
	(
		SELECT TOP (@limit) ID
		FROM VTT_Service
		WHERE @currentID <> 0 AND @currentID = ID AND State = 1
		ORDER BY ID DESC

		UNION ALL

		SELECT TOP (@limit) ID
		FROM VTT_Service
		WHERE @currentID = 0 AND (ID < @beginID OR @beginID = 0) AND State = 1
		ORDER BY ID DESC

	) LS

	SELECT 
		V.ID,
		V.Name
		, V.Price
		, UnitCount = ISNULL(V.UnitCount, 0)
		, V.Service_Code
		, Note = ISNULL(V.Note, '')
	FROM #SERVICELIST LS
	INNER JOIN VTT_Service V ON V.ID = LS.ID

	DROP TABLE #SERVICELIST
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Service_LoadDetail]
	@ID INT
AS
BEGIN
	SELECT 
		ID,
		Name
		, Service_Code
		, UnitCount
		, Note
		, Price
	FROM VTT_Service
	WHERE ID = @ID AND State = 1

END
GO

EXEC [dbo].[YYY_sp_VTT_Service_LoadList] @beginID = 0, @limit = 10, @currentID = 0
GO


CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Service_Insert]
	@Name NVARCHAR(MAX),
	@Price FLOAT
	, @ServiceCode NVARCHAR(200)
	, @Note NVARCHAR(MAX)
	, @UnitCount INT
AS
BEGIN
	INSERT INTO VTT_Service
	(
		Name,
		Service_Code
		, UnitCount
		, Note
		, Price
		, State
		, Created
	) 
	VALUES 
	(
		@Name,
		@ServiceCode
		, @UnitCount
		, @Note
		, @Price
		, 1
		, GETDATE()
	)

	DECLARE @NewID INT = SCOPE_IDENTITY();

    SELECT ID
    FROM VTT_Service
    WHERE ID = @NewID

END
GO	

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Service_Update]
	@ID INT,
	@Name NVARCHAR(MAX)
	, @Price FLOAT
	, @ServiceCode NVARCHAR(200)
	, @Note NVARCHAR(MAX)
	, @UnitCount INT
AS
BEGIN
	UPDATE VTT_Service
	SET
		Name = @Name,
		Service_Code = @ServiceCode
		, UnitCount = @UnitCount
		, Note = @Note
		, Price = @Price
	WHERE ID = @ID

	SELECT ID = @ID 
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Service_Delete]
	@ID INT
AS
BEGIN
	UPDATE VTT_Service
	SET State = 1
	WHERE ID = @ID
END
GO