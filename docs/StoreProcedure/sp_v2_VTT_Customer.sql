USE DemoCustomerNK_CN
GO

--@TYPE:
--0: Load customer list without condition
--1: Load customer list with condition date
--2: Load customer list has schedule
--3: Load customer list has customer_tab
--4: Load customer list has customer_payment

USE DemoCustomerNK_CN
GO

CREATE OR ALTER PROCEDURE [dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
	, @Type INT = 0

AS
BEGIN
	SELECT CDB.*
	INTO #CUSTOMERDASHBOARD
	FROM
	(
		--CASE 1 LOAD CUSTOMER LIST **NO CONDITION
		SELECT TOP 10 C.ID
		FROM VTT_Customer C
		WHERE 
			@Type = 0
			AND C.State = 1
		ORDER BY C.Created DESC

		UNION ALL

		--CASE 2 LOAD CUSTOMER LIST **HAS ENDDATE AND STARTDATE
		SELECT TOP 10 C.ID
		FROM VTT_Customer C
		WHERE 
			@Type = 1
			AND C.State = 1 
			AND C.Created > @StartDate
			AND C.Created <= @EndDate
		ORDER BY C.Created DESC

		UNION ALL

		--CASE 3 LOAD CUSTOMER LIST **HAS SCHEDULE
		SELECT TOP 10 C.ID
		FROM VTT_Customer C
		WHERE 
			@Type = 2
			AND C.State = 1
			AND (@StartDate IS NULL OR C.Created > @StartDate)
			AND (@EndDate IS NULL OR C.Created <= @EndDate)
			AND EXISTS
			(
				SELECT 1
				FROM VTT_Schedule S
				WHERE 
					S.State = 1
					AND S.IsCancel = 1
					AND S.Customer_ID = C.ID
			)
		ORDER BY C.Created DESC

		UNION ALL

		--CASE 3 LOAD CUSTOMER LIST **HAS CUSTOMER_TAB
		SELECT TOP 10 C.ID
		FROM VTT_Customer C
		WHERE 
			@Type = 3
			AND C.State = 1
			AND (@StartDate IS NULL OR C.Created > @StartDate)
			AND (@EndDate IS NULL OR C.Created <= @EndDate)
			AND EXISTS
			(
				SELECT 1
				FROM VTT_Customer_Tab CT
				WHERE 
					CT.IsChoose = 1
					AND CT.State = 1
					AND CT.Customer_ID = C.ID
			)
		ORDER BY C.Created DESC

		UNION ALL

		--CASE 3 LOAD CUSTOMER LIST **HAS CUSTOMER_PAYMENT
		SELECT TOP 10 C.ID
		FROM VTT_Customer C
		WHERE 
			@Type = 4
			AND C.State = 1
			AND (@StartDate IS NULL OR C.Created > @StartDate)
			AND (@EndDate IS NULL OR C.Created <= @EndDate)
			AND EXISTS
			(
				SELECT 1
				FROM VTT_Customer_Payment CP
				WHERE 
					CP.State = 1
					AND CP.Customer_ID = C.ID
			)
		ORDER BY C.Created DESC
	) CDB

	SELECT 
		C.ID,
		Name
		, Phone1
	FROM VTT_Customer C
	INNER JOIN #CUSTOMERDASHBOARD CDB ON CDB.ID = C.ID

	DROP TABLE #CUSTOMERDASHBOARD
END
GO