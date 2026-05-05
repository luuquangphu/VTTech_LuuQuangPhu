using CRUDCustomer.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;

namespace CRUDCustomer.Pages.Customer
{
    public class CustomerDetailModel : PageModel
    {
        private readonly ExecuteDataBase executeDataBase;

        public string _CurrentID { get; set; }

        public CustomerDetailModel(ExecuteDataBase executeDataBase)
        {
            this.executeDataBase = executeDataBase;
        }

        public void OnGet()
        {
            var currentId = Request.Query["CurrentID"];
            if (!string.IsNullOrEmpty(currentId))
            {
                _CurrentID = currentId.ToString();
            } else
            {
                _CurrentID = "0";
            }
        }

        public async Task<IActionResult> OnPostLoadDetail(int ID)
        {
            try
            {
                DataTable data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_LoadDetail]",
                        "@ID", SqlDbType.Int, ID
                    );
                return Content(DataJson.Datatable(data));
            }
            catch (Exception ex)
            {
                return Content("[]");
            }
        }

        public async Task<IActionResult> OnPostExcuteData(int CustomerID, string CustCode, string Name, string Note, string Phone1)
        {
            try
            {
                DataTable data = new DataTable();

                if (CustomerID == 0)
                {
                    data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Insert]"
                        , "@Cust_Code", SqlDbType.NVarChar, CustCode ?? ""
                        , "@Phone1", SqlDbType.NVarChar, Phone1 ?? ""
                        , "@Name", SqlDbType.NVarChar, Name ?? ""
                        , "@Note", SqlDbType.NVarChar, Note ?? ""
                    );
                } else
                {
                    data = await executeDataBase.ExecuteDataTable
                    ("[YYY_sp_VTT_Customer_Update]"
                        , "@ID", SqlDbType.Int, CustomerID
                        , "@Cust_Code", SqlDbType.NVarChar, CustCode ?? ""
                        , "@Phone1", SqlDbType.NVarChar, Phone1 ?? ""
                        , "@Name", SqlDbType.NVarChar, Name ?? ""
                        , "@Note", SqlDbType.NVarChar, Note ?? ""
                    );
                }
                

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
