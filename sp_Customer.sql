USE DemoCustomerNK_CN
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_LoadList]
    @Cust_Code NVARCHAR(50),
    @limit INT
AS
BEGIN
    SELECT TOP (@limit) 
		Cust_Code
		,Name
		,Phone1
		,Note
    FROM VTT_Customer
    WHERE State = 1 
      AND (@Cust_Code = '' OR Cust_Code = @Cust_Code)
    ORDER BY Cust_Code DESC;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_LoadDetail]
    @Cust_Code NVARCHAR(50)
AS
BEGIN
    SELECT Cust_Code, Phone1, Name, Note 
    FROM VTT_Customer 
    WHERE Cust_Code = @Cust_Code AND State = 1;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_Insert]
    @Cust_Code NVARCHAR(50),
    @Name NVARCHAR(250),
    @Note NVARCHAR(MAX),
	@Phone1 NVARCHAR(150)
AS
BEGIN
    INSERT INTO VTT_Customer (Cust_Code, Name, Note, Phone1, Created, Created_By, State)
    VALUES (@Cust_Code, @Name, @Note, @Phone1, GETDATE(), 1, 1);
    
    SELECT 1 AS RESULT, @Cust_Code AS Cust_Code;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_Update]
    @Cust_Code NVARCHAR(50),
    @Name NVARCHAR(250),
    @Note NVARCHAR(MAX),
	@Phone1 NVARCHAR(150)
AS
BEGIN
    UPDATE VTT_Customer
    SET Cust_Code = @Cust_Code,
        Name = @Name,
        Note = @Note,
		Phone1 = @Phone1
    WHERE Cust_Code = @Cust_Code;

    SELECT 1 AS RESULT, @Cust_Code AS Cust_Code;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_Customer_Delete]
    @Cust_Code NVARCHAR(50)
AS
BEGIN
    UPDATE VTT_Customer
    SET State = 0
    WHERE Cust_Code = @Cust_Code;
    SELECT 1 AS RESULT;
END
GO


EXEC [dbo].[YYY_sp_VTT_Customer_LoadList] 
    @Cust_Code = N'', 
    @limit = 10;


EXEC [dbo].[YYY_sp_VTT_Customer_LoadDetail] @Cust_Code = ''

EXEC [dbo].[YYY_sp_VTT_Customer_Delete] @Cust_Code = ''
  