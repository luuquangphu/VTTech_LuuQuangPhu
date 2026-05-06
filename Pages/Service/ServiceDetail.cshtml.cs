using CRUDCustomer.Models;
using CRUDCustomer.Models.Enums;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;

namespace CRUDCustomer.Pages.Service
{
    public class ServiceDetailModel : PageModel
    {
        public string _CurrentID { get; set; }

        private readonly ExecuteDataBase executeDataBase;

        public ServiceDetailModel(ExecuteDataBase executeDataBase)
        {
            this.executeDataBase = executeDataBase;
        }

        public void OnGet()
        {
            var currentID = Request.Query["CurrentID"];
            _CurrentID = !string.IsNullOrEmpty(currentID) ? currentID.ToString() : "0"; ;
        }

        public async Task<IActionResult> OnPostLoadDetail(int ID)
        {
            try
            {
                DataTable dt = await executeDataBase.ExecuteDataTable
                (
                    "[dbo].[YYY_sp_VTT_Service_LoadDetail]",
                    "@ID", SqlDbType.Int, ID
                );
                string data = DataJson.Datatable(dt);
                if (data != "[]")
                {
                    return Content(data);
                }
                return Content("0");
            }
            catch (Exception ex)
            {
                return Content("0");
            }
        }

        public async Task<IActionResult> OnPostExcuteData(int ID, string ServiceCode, string Name, string Note, float Price, int UnitCount)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Content("0");
                }
                DataTable data = new DataTable();

                if (ID == 0)
                {
                    data = await executeDataBase.ExecuteDataTable(
                        "[YYY_sp_VTT_Service_Insert]",
                        "@ServiceCode", SqlDbType.NVarChar, ServiceCode ?? "",
                        "@Name", SqlDbType.NVarChar, Name ?? "",
                        "@Note", SqlDbType.NVarChar, Note ?? "",
                        "@Price", SqlDbType.Float, Price,
                        "@UnitCount", SqlDbType.Int, UnitCount
                    );
                }
                else
                {
                    data = await executeDataBase.ExecuteDataTable(
                        "[YYY_sp_VTT_Service_Update]",
                        "@ID", SqlDbType.Int, ID,
                        "@ServiceCode", SqlDbType.NVarChar, ServiceCode ?? "",
                        "@Name", SqlDbType.NVarChar, Name ?? "",
                        "@Note", SqlDbType.NVarChar, Note ?? "",
                        "@Price", SqlDbType.Float, Price,
                        "@UnitCount", SqlDbType.Int, UnitCount
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
                Console.WriteLine("Lỗi Service ExecuteData: " + ex.ToString());
                return Content("0");
            }
        }
    }
}

