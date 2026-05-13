using CRUDCustomer.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Data;

namespace CRUDCustomer.Pages.CustomerDashBoard
{
    [IgnoreAntiforgeryToken]
    public class CustomerDashBoardModel : PageModel
    {
        private readonly ExecuteDataBase executeDataBase;

        public CustomerDashBoardModel (ExecuteDataBase executeDataBase)
        {
            this.executeDataBase = executeDataBase;
        }

        public void OnGet()
        {
        }

        /// <summary>
        /// Load Customer List for @Type
        /// </summary>
        /// <param name="Type">
        ///     Type = 0 No condition
        ///     Type = 1 filter for @EndDate and @StartDate
        ///     Type = 2 filter for @EndDate and @StartDate and has schedule
        ///     Type = 3 filter for @EndDate and @StartDate and has customer_tab
        ///     Type = 4 filter for @EndDate and @StartDate and has customer_payment
        /// </param>
        /// <param name="Limit">Number of records retrieved in a single query</param>
        /// <param name="BeginID">The last record ID from the previous query</param>
        /// <param name="StartDate">Date start</param>
        /// <param name="EndDate">Date End</param>
        /// <returns>
        ///     -100: Invalid Date (EndDate < StartDate)
        ///     -102: StartDate or EndDate null
        ///     []: no data
        ///     [data]: Response of the query
        ///     0: Error query
        /// </returns>
        public async Task<IActionResult> OnPostLoadList
        (
                int Type = 0
                , int Limit = 10
                , int BeginID = 0
                , DateTime? StartDate = null
                , DateTime? EndDate = null
        )
        {
            try
            {
                if (StartDate == DateTime.MinValue) StartDate = null;
                if (EndDate == DateTime.MinValue) EndDate = null;

                Console.WriteLine("===LOAD LIST" + StartDate + EndDate);

                DataTable dt = await executeDataBase.ExecuteDataTable
               (
                   "[dbo].[YYY_sp_VTT_CustomerDashBoard_LoadList]",
                   "@Type", SqlDbType.Int, Type
                   , "@Limit", SqlDbType.Int, Limit
                   , "@BeginID", SqlDbType.Int, BeginID
                   , "@StartDate", SqlDbType.DateTime, StartDate.HasValue ? (object)StartDate.Value : DBNull.Value
                   , "@EndDate", SqlDbType.DateTime, EndDate.HasValue ? (object)EndDate.Value : DBNull.Value
               );

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Columns.Contains("RESULT"))
                    {
                        return Content(dt.Rows[0]["RESULT"].ToString());
                    }

                    return Content(DataJson.Datatable(dt));
                }

                return Content("[]");
            }
            catch (Exception ex)
            {
                return Content("0");
            }
        }

        /// <summary>
        /// Load Summary Sale(Doanh số), Revenue(Doanh thu), TotalCustomer(Tổng khách hàng)
        /// </summary>
        /// <param name="StartDate">Date start</param>
        /// <param name="EndDate">Date End</param>
        /// <returns>
        ///     []: No data
        ///     [data]: Response of query
        ///     0: Error query
        ///     -100: Invalid Date (EndDate < StartDate)
        ///     -102: StartDate or EndDate null
        /// </returns>
        public async Task<IActionResult> OnPostLoadSummary
        (
            DateTime? StartDate = null
            , DateTime? EndDate = null
        )
        {
            try
            {
                DataTable dt = await executeDataBase.ExecuteDataTable
               (
                   "[dbo].[YYY_sp_VTT_CustomerDashBoard_LoadSummary]",
                   "@StartDate", SqlDbType.DateTime, StartDate.HasValue ? (object)StartDate.Value : DBNull.Value
                   , "@EndDate", SqlDbType.DateTime, EndDate.HasValue ? (object)EndDate.Value : DBNull.Value
               );

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Columns.Contains("RESULT"))
                    {
                        return Content(dt.Rows[0]["RESULT"].ToString());
                    }

                    return Content(DataJson.Datatable(dt));
                }

                return Content("[]");
            }
            catch (Exception ex)
            {
                return Content("0");
            }
        }

        public async Task<IActionResult> OnPostExportAllList
        (
            int Type = 1
            , DateTime? StartDate = null
            , DateTime? EndDate = null
        )
        {
            try
            {
                if (StartDate == DateTime.MinValue) StartDate = null;
                if (EndDate == DateTime.MinValue) EndDate = null;

                DataTable dt = await executeDataBase.ExecuteDataTable
               (
                   "[dbo].[YYY_sp_VTT_CustomerDashBoard_ExportAllList]",
                   "@Type", SqlDbType.Int, Type
                   , "@StartDate", SqlDbType.DateTime, StartDate.HasValue ? (object)StartDate.Value : DBNull.Value
                   , "@EndDate", SqlDbType.DateTime, EndDate.HasValue ? (object)EndDate.Value : DBNull.Value
               );

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Columns.Contains("RESULT"))
                    {
                        return Content(dt.Rows[0]["RESULT"].ToString());
                    }

                    return Content(DataJson.Datatable(dt));
                }

                return Content("[]");
            }
            catch (Exception ex)
            {
                Console.WriteLine("ExportAll Error: " + ex.Message);
                return Content("0");
            }
        }
    }
}
