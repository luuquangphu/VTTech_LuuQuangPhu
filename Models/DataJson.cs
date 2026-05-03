using Newtonsoft.Json;
using System.Data;

namespace CRUDCustomer.Models
{
    public static class DataJson
    {
        public static string Datatable(DataTable dt)
        {
            return JsonConvert.SerializeObject(dt);
        }
    }
}
