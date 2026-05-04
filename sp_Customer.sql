USE DemoCustomerNK_CN
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_LoadList]
    @CurrentID INT = 0,
    @Limit INT = 10
AS
BEGIN
	SELECT TOP (@Limit) 
		  ID
		, Name
		, Cust_Code
		, Phone1
		, Note
	FROM VTT_Customer C 
	WHERE State = 1	AND ID > @CurrentID
	ORDER BY ID ASC;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_LoadDetail]
    @ID INT
AS
BEGIN
    SELECT ID, Cust_Code, Phone1, Name, Note 
    FROM VTT_Customer 
    WHERE ID = @ID AND State = 1;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_Insert]
      @Cust_Code NVARCHAR(50)
    , @Name NVARCHAR(250)
    , @Note NVARCHAR(MAX)
	, @Phone1 NVARCHAR(150)
AS
BEGIN
    INSERT INTO VTT_Customer (Cust_Code, Name, Note, Phone1, Created, Created_By, State)
    VALUES (@Cust_Code, @Name, @Note, @Phone1, GETDATE(), 1, 1);
    
    DECLARE @NewID INT = SCOPE_IDENTITY();

    SELECT 
		ID
		, Cust_Code
		, Name
		, Phone1
		, Note
    FROM VTT_Customer
    WHERE ID = @NewID;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_Update]
	  @ID INT
    , @Cust_Code NVARCHAR(50)
    , @Name NVARCHAR(250)
    , @Note NVARCHAR(MAX)
	, @Phone1 NVARCHAR(150)
AS
BEGIN
    UPDATE VTT_Customer
    SET Cust_Code = @Cust_Code
        , Name = @Name
        , Note = @Note
		, Phone1 = @Phone1
    WHERE ID = @ID;

    SELECT	
		ID
		, Name
		, Cust_Code
		, Phone1
		, Note
	FROM VTT_Customer
	WHERE ID = @ID
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_Delete]
    @ID INT
AS
BEGIN
    UPDATE VTT_Customer
    SET State = 0
    WHERE ID = @ID;
    SELECT 1 AS RESULT;
END
GO

  