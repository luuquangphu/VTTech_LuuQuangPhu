using Microsoft.Data.SqlClient;
using System.Data;

namespace CRUDCustomer.Models
{
    public class ExecuteDataBase
    {
        private readonly string connectionString;

        public ExecuteDataBase(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("Lỗi khi kết nối vào DB.");
        }

        public async Task<DataTable> ExecuteDataTable(string spName, params object[] parameters)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(spName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        
                        if (parameters != null)
                        {
                            int i = 0;
                            while (i < parameters.Length)
                            {
                                // 1. Nếu là CommandType
                                if (parameters[i] is CommandType ct)
                                {
                                    cmd.CommandType = ct;
                                    i++;
                                    continue;
                                }

                                // 2. Nếu là tên tham số (bắt đầu bằng @)
                                if (parameters[i] is string paramName && paramName.StartsWith("@"))
                                {
                                    // Kiểm tra xem tiếp theo có phải là SqlDbType không (bộ 3: Tên, Loại, Giá trị)
                                    if (i + 1 < parameters.Length && parameters[i + 1] is SqlDbType sqlDataType)
                                    {
                                        object val = (i + 2 < parameters.Length) ? parameters[i + 2] : DBNull.Value;
                                        cmd.Parameters.Add(paramName, sqlDataType).Value = val ?? DBNull.Value;
                                        i += 3;
                                    }
                                    else
                                    {
                                        // Ngược lại coi như là bộ 2: Tên, Giá trị (AddWithValue)
                                        object val = (i + 1 < parameters.Length) ? parameters[i + 1] : DBNull.Value;
                                        cmd.Parameters.AddWithValue(paramName, val ?? DBNull.Value);
                                        i += 2;
                                    }
                                    continue;
                                }
                                i++;
                            }
                        }

                        await conn.OpenAsync();
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            dt.Load(reader);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"ExecuteDataTable Error: {ex.Message}", ex);
            }
            return dt;
        }
        public void Dispose() { }
    }
}
