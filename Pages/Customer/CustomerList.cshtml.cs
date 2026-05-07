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

        public async Task<IActionResult> OnPostLoadDataList(int CurrentID = 0, int beginID = 0, int Limit = 10)
        {
            try
            {
                DataTable dt = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_LoadList]"
                        , "@beginID", SqlDbType.Int, beginID
                        , "@Limit", SqlDbType.Int, Limit
                        , "@CurrentId", SqlDbType.Int, CurrentID
                    );
                if (dt != null)
                {
                    string data = DataJson.Datatable(dt);

                    //Console.WriteLine("=== Load List ===\n" + json);
                    return Content(data);
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
                DataTable dt = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Delete]",
                        "@ID", SqlDbType.Int, ID
                    );
                if (dt != null && dt.Rows.Count > 0)
                {
                    int ressult = Convert.ToInt32(dt.Rows[0]["RESULT"].ToString());
                    if (ressult == 1)
                    {
                        return Content(ressult.ToString());
                    }
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
