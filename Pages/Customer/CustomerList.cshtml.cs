using CRUDCustomer.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;

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

        public async Task<IActionResult> OnPostLoadDataList(int CurrentID = 0, int Limit = 10)
        {
            try
            {
                DataTable dt = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_LoadList]"
                        , "@CurrentID", SqlDbType.Int, CurrentID
                        , "@Limit", SqlDbType.Int, Limit
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

        //Soft Delete (State = 0)
        public async Task<IActionResult> OnPostDeleteItem(int ID)
        {
            try
            {
                DataTable data = new DataTable();

                data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Delete]",
                        "@ID", SqlDbType.Int, ID
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
    }
}
