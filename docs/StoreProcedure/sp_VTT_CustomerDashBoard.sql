USE DemoCustomerNK_CN
GO

--@TYPE:
--0: Load customer list without condition
--1: Load customer list with condition date
--2: Load customer list has schedule
--3: Load customer list has customer_tab
--4: Load customer list has customer_payment

--ERROR CODE:	
-- + -100: EndDate < StartDate
-- + -102: EndDate or StartDate NULL
CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList]
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @Type INT = 1,
    @Limit INT = 10,
    @BeginID INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @StartDate IS NULL OR @EndDate IS NULL
    BEGIN
        SELECT RESULT = -102;
        RETURN;
    END

    IF @EndDate < @StartDate
    BEGIN
        SELECT RESULT = -100;
        RETURN;
    END

    CREATE TABLE #CUSTOMERDB (
        RecordID INT PRIMARY KEY CLUSTERED, 
        CustomerID INT
    );

    IF @Type = 1
    BEGIN
        INSERT INTO #CUSTOMERDB (RecordID, CustomerID)
        SELECT TOP (@Limit) C.ID, C.ID 
        FROM VTT_Customer C
        WHERE 
            C.State = 1 
            AND (@BeginID = 0 OR C.ID < @BeginID)
            AND C.Created >= @StartDate 
            AND C.Created <= @EndDate
        ORDER BY C.ID DESC;
    END

    ELSE IF @Type = 2
    BEGIN
        INSERT INTO #CUSTOMERDB (RecordID, CustomerID)
        SELECT TOP (@Limit) S.ID, S.Customer_ID
        FROM VTT_Schedule S
        WHERE 
            S.State = 1 
            AND (@BeginID = 0 OR S.ID < @BeginID)
            AND S.Created >= @StartDate
            AND S.Created <= @EndDate
        ORDER BY S.ID DESC
    END

    ELSE IF @Type = 3
    BEGIN
        INSERT INTO #CUSTOMERDB (RecordID, CustomerID)
        SELECT TOP (@Limit) CT.ID, CT.Customer_ID
        FROM VTT_Customer_Tab CT
        WHERE 
            CT.IsChoose = 1 
            AND CT.State = 1 
            AND (@BeginID = 0 OR CT.ID < @BeginID)
            AND CT.Created >= @StartDate
            AND CT.Created <= @EndDate
        ORDER BY CT.ID DESC
    END

    ELSE IF @Type = 4
    BEGIN
        INSERT INTO #CUSTOMERDB (RecordID, CustomerID)
        SELECT TOP (@Limit) CP.ID, CP.Customer_ID
        FROM VTT_Customer_Payment CP
        WHERE 
            CP.State = 1 
            AND (@BeginID = 0 OR CP.ID < @BeginID)
            AND CP.Created >= @StartDate
            AND CP.Created <= @EndDate            
        ORDER BY CP.ID DESC
    END

    SELECT 
        CDB.RecordID AS ID,        
        C.ID AS CustomerID,        
        C.Name,
        Phone1 = ISNULL(C.Phone1, ''),
        Note = ISNULL(C.Note, '')
    FROM #CUSTOMERDB CDB
    INNER JOIN VTT_Customer C ON C.ID = CDB.CustomerID
    ORDER BY CDB.RecordID DESC;   

    DROP TABLE #CUSTOMERDB;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadSummary]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
AS
BEGIN
	IF @StartDate IS NULL OR @EndDate IS NULL
	BEGIN
		SELECT RESULT = -102;
		RETURN;
	END

	IF @EndDate < @StartDate
	BEGIN
		SELECT RESULT = -100;
		RETURN;
	END
	
	DECLARE @Sale DECIMAL(18,2) = 0;
	DECLARE @Revenue DECIMAL(18,2) = 0;
	DECLARE @TotalCustomer INT = 0;

	SELECT @Sale = ISNULL(SUM(CT.Price_Discounted), 0)
	FROM VTT_Customer_Tab CT
	WHERE 
		CT.State = 1
		AND CT.IsChoose = 1
		AND CT.Created >= @StartDate
		AND CT.Created <= @EndDate

	SELECT @Revenue = ISNULL(SUM(Amount), 0) + ISNULL(SUM(PaymentDeposit), 0)
	FROM VTT_Customer_Payment CP
	WHERE
		CP.State = 1
		AND CP.Created >= @StartDate
		AND CP.Created <= @EndDate

	SELECT @TotalCustomer = ISNULL(COUNT(*), 0)
	FROM VTT_Customer C
	WHERE
		C.State = 1
		AND C.Created >= @StartDate
		AND C.Created <= @EndDate

	SELECT 
		Sale = @Sale,
		Revenue = @Revenue
		,TotalCustomer = @TotalCustomer
END
GO

EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadSummary] 
	@StartDate = '2025-07-01T00:00:00', 
	@EndDate = NULL
GO

EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-07-01T00:00:00', 
	@EndDate = '2025-07-31T23:59:59', 
	@Type = 1, 
	@BeginID = 0,
	@Limit = 50000
GO

