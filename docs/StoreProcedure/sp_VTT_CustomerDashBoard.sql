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

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList]
    @StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
	, @Type INT = 0
	, @Limit INT = 10
	, @BeginID INT = 0
AS
BEGIN
    IF (@StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @EndDate < @StartDate)
    BEGIN 
		SELECT RESULT = -100; 
		RETURN; 
	END

    CREATE TABLE #CUSTOMERDB (ID INT);

    IF @Type = 0
        INSERT INTO #CUSTOMERDB
        SELECT TOP (@Limit) ID 
		FROM VTT_Customer
        WHERE 
			State = 1 
			AND (@BeginID = 0 OR ID < @BeginID)
			AND @StartDate IS NULL 
			AND @EndDate IS NULL
        ORDER BY Created DESC;

    ELSE IF @Type = 1
        INSERT INTO #CUSTOMERDB
        SELECT TOP (@Limit) ID 
		FROM VTT_Customer
        WHERE 
			State = 1 
			AND (@BeginID = 0 OR ID < @BeginID)
			AND Created >= @StartDate 
			AND Created <= @EndDate
        ORDER BY Created DESC;

    ELSE IF @Type = 2
        INSERT INTO #CUSTOMERDB
        SELECT TOP (@Limit) C.ID 
		FROM VTT_Customer C
        WHERE 
			C.State = 1 
			AND (@BeginID = 0 OR C.ID < @BeginID)
			AND (@StartDate IS NULL OR C.Created >= @StartDate)
			AND (@EndDate IS NULL OR C.Created <= @EndDate)
			AND EXISTS (
						SELECT 1 
						FROM VTT_Schedule S
						WHERE 
							S.State = 1 
							AND S.Customer_ID = C.ID
						)
        ORDER BY C.Created DESC;

    ELSE IF @Type = 3
        INSERT INTO #CUSTOMERDB
        SELECT TOP (@Limit) C.ID 
		FROM VTT_Customer C
        WHERE 
		C.State = 1 
			AND (@BeginID = 0 OR C.ID < @BeginID)
			AND (@StartDate IS NULL OR C.Created >= @StartDate)
			AND (@EndDate IS NULL OR C.Created <= @EndDate)
			AND EXISTS (
						SELECT 1 
						FROM VTT_Customer_Tab CT
						WHERE 
							CT.IsChoose = 1 
							AND CT.State = 1 
							AND CT.Customer_ID = C.ID
						)
        ORDER BY C.Created DESC;

    ELSE IF @Type = 4
        INSERT INTO #CUSTOMERDB
        SELECT TOP (@Limit) C.ID 
		FROM VTT_Customer C
        WHERE 
			C.State = 1 
			AND (@BeginID = 0 OR C.ID < @BeginID)
			AND (@StartDate IS NULL OR C.Created >= @StartDate)
			AND (@EndDate IS NULL OR C.Created <= @EndDate)
			AND EXISTS (
						SELECT 1 
						FROM VTT_Customer_Payment CP
						WHERE 
							CP.State = 1 
							AND CP.Customer_ID = C.ID
						)
        ORDER BY C.Created DESC;


    SELECT 
		C.ID, 
		C.Name
		,Phone1 = ISNULL(C.Phone1, '')
		,Note = ISNULL(C.Note, '')
    FROM VTT_Customer C
    INNER JOIN #CUSTOMERDB CDB ON CDB.ID = C.ID
    ORDER BY C.Created DESC;

    DROP TABLE #CUSTOMERDB;
END
GO	

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadSummary]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
AS
BEGIN
	IF (@StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @EndDate < @StartDate)
	BEGIN
		SELECT RESULT = -100
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
		AND (@StartDate IS NULL OR CT.Created >= @StartDate)
		AND (@EndDate IS NULL OR CT.Created <= @EndDate)

	SELECT @Revenue = ISNULL(SUM(Amount), 0) + ISNULL(SUM(PaymentDeposit), 0)
	FROM VTT_Customer_Payment CP
	WHERE
		CP.State = 1
		AND (@StartDate IS NULL OR CP.Created >= @StartDate)
		AND (@EndDate IS NULL OR CP.Created <= @EndDate)

	SELECT @TotalCustomer = ISNULL(COUNT(*), 0)
	FROM VTT_Customer C
	WHERE
		C.State = 1
		AND (@StartDate IS NULL OR C.Created >= @StartDate)
		AND (@EndDate IS NULL OR C.Created <= @EndDate)

	SELECT 
		Sale = @Sale,
		Revenue = @Revenue
		,TotalCustomer = @TotalCustomer
		, RESULT = 1
END
GO

EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadSummary] 
	@StartDate = '2025-07-20', 
	@EndDate = '2025-08-01'
GO

-- 1. Case 1 không có enddate và start date và type = 0, beginID = 0
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = NULL, 
	@EndDate = NULL, 
	@Type = 0, 
	@BeginID = 0
GO

-- 2. (LOADMORE) Case 1 không có enddate và start date và type = 0, beginID = 11225
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = NULL, 
	@EndDate = NULL, 
	@Type = 0, 
	@BeginID = 11225
GO

-- 3. Case 1 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 0, beginID = 0
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-07-20', 
	@EndDate = '2025-08-01', 
	@Type = 0, 
	@BeginID = 0
	--, @Limit = 55
GO

-- 5. Case 2 có enddate = '2025-12-01' và start date = '2022-12-01' và type = 1, beginID = 0
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-07-20', 
	@EndDate = '2025-08-01',  
	@Type = 1, 
	@BeginID = 0
	--, @Limit = 56
GO

-- 6. Case 2 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 1, beginID = 194
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2022-12-01', 
	@EndDate = '2022-12-30', 
	@Type = 1, 
	@BeginID = 194
GO

-- 7. Case 3 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 2, beginID = 0
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-07-20', 
	@EndDate = '2025-08-01', 
	@Type = 2, 
	@BeginID = 0
	, @Limit = 100
GO

-- 8. Case 3 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 2, beginID = 10
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-12-01', 
	@EndDate = '2022-12-01', 
	@Type = 2, 
	@BeginID = 10
GO

-- 9. Case 3 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 3, beginID = 0
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = NULL, 
	@EndDate = NULL, 
	@Type = 3, 
	@BeginID = 0
	, @Limit = 100
GO

-- 10. Case 3 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 3, beginID = 10
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-07-20', 
	@EndDate = '2025-08-01', 
	@Type = 3, 
	@BeginID = 11195
GO

-- 11. Case 3 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 4, beginID = 0
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = NULL, 
	@EndDate = NULL, 
	@Type = 4, 
	@BeginID = 0
GO

-- 12. Case 3 có enddate = '2022-12-01' và start date = '2025-12-01' và type = 4, beginID = 10
EXEC [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList] 
	@StartDate = '2025-12-01', 
	@EndDate = '2022-12-01', 
	@Type = 4, 
	@BeginID = 10
GO
