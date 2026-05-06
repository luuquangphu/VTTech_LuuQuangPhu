using CRUDCustomer.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;

namespace CRUDCustomer.Pages.Service
{
    public class ServiceListModel : PageModel
    {
        private readonly ExecuteDataBase executeDataBase;

        public ServiceListModel(ExecuteDataBase executeDataBase)
        {
            this.executeDataBase = executeDataBase;
        }

        public void OnGet()
        {
        }

        public async Task<IActionResult> OnPostLoadList(int beginID, int currentID, int limit)
        {
            try
            {
                DataTable dt = await executeDataBase.ExecuteDataTable
                    (
                        "[dbo].[YYY_sp_VTT_Service_LoadList]"
                        , "@beginID", SqlDbType.Int, beginID
                        , "@limit", SqlDbType.Int, limit
                        , "@currentID", SqlDbType.Int, currentID
                    );

                if (dt != null)
                {
                    string data = DataJson.Datatable(dt);

                    return Content(data);
                }

                return Content("[]");

            }catch (Exception ex)
            {
                return Content("0");
            }
        }

        public async Task<IActionResult> OnPostDelete(int ID)
        {
            try
            {
                DataTable dt = await executeDataBase.ExecuteDataTable
                    (
                        "[dbo].[YYY_sp_VTT_Service_Delete]",
                        "@ID", SqlDbType.Int, ID
                    );

                int ressult = Convert.ToInt32(dt.Rows[0]["RESULT"].ToString());
                if(ressult == 1)
                {
                    return Content(ressult.ToString());
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
