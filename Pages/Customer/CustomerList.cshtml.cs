using CRUDCustomer.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using System.Drawing;
using System.Reflection;

namespace CRUDCustomer.Pages.Customer
{
    public class CustomerListModel : PageModel
    {
        private readonly ExecuteDataBase executeDataBase;

        public CustomerListModel(ExecuteDataBase executeDataBase)
        {
            this.executeDataBase = executeDataBase;
        }

        public void OnGet()
        {
        }

        public async Task<IActionResult> OnPostLoadDataList(string CustCode, int limit)
        {
            try
            {
                string code = string.IsNullOrEmpty(CustCode) ? "" : CustCode;

                DataTable dt = new DataTable();

                dt = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_LoadList]"
                        , "@Cust_Code", SqlDbType.NVarChar, code
                        , "@limit", SqlDbType.Int, limit
                    );
                if (dt != null)
                {
                    string json = DataJson.Datatable(dt);

                    Console.WriteLine("=== Load List ===\n" + json);
                    return Content(json);
                }
                return Content("[]");
            }
            catch (Exception ex)
            {
                return Content("0");
            }
        }

        public async Task<IActionResult> OnPostLoadDetail(string CustCode)
        {
            try
            {
                DataTable data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_LoadDetail]",
                        "@Cust_Code", SqlDbType.NVarChar, CustCode ?? ""
                    );
                return Content(DataJson.Datatable(data));
            }
            catch (Exception ex)
            {
                return Content("[]");
            }
        }

        //Soft Delete (State = 0)
        public async Task<IActionResult> OnPostDeleteItem(string CustCode)
        {
            try
            {
                DataTable data = new DataTable();

                data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Delete]",
                        "@Cust_Code", SqlDbType.NVarChar, CustCode
                    );
                if (data != null && data.Rows.Count > 0)
                {
                    return Content(data.Rows[0]["RESULT"].ToString());
                }
                return Content("0");
            }
            catch (Exception ex)
            {
                return Content("0");
            }
        }

        public async Task<IActionResult> OnPostUpdateData(string CustCode, string Name, string Note, string Phone1)
        {
            try
            {
                DataTable data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Update]"
                        , "@Cust_Code", SqlDbType.NVarChar, CustCode ?? ""
                        , "@Phone1", SqlDbType.NVarChar, Phone1 ?? ""
                        , "@Name", SqlDbType.NVarChar, Name ?? ""
                        , "@Note", SqlDbType.NVarChar, Note ?? ""
                    );

                if (data != null && data.Rows.Count > 0)
                {
                    return Content(DataJson.Datatable(data));
                }
                return Content("0");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi UpdateData: " + ex.ToString());
                return Content("0");
            }
        }
    }
}
