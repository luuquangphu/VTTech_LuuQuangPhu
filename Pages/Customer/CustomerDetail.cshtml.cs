using CRUDCustomer.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;

namespace CRUDCustomer.Pages.Customer
{
    public class CustomerDetailModel : PageModel
    {
        private readonly ExecuteDataBase executeDataBase;

        public CustomerDetailModel(ExecuteDataBase executeDataBase)
        {
            this.executeDataBase = executeDataBase;
        }

        public void OnGet()
        {  
        }

        public async Task<IActionResult> OnPostInsertData(string CustCode, string Name, string Note, string Phone1)
        {
            try
            {
                DataTable data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Insert]"
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
                Console.WriteLine("Lỗi InsertData: " + ex.ToString());
                return Content("0");
            }
        }
    }
}
