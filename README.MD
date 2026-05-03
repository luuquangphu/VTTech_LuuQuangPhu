Ứng dụng Web .NET CORE 8 thực hiện CRUD cho bảng VTT_Customer  
- Connect SQL bằng Microsoft.Data.SqlClient  
- Sử dụng Store Procedure để thực hiện CRUD trên bảng VTT_Customer:  
    + Create  
    + Read (LoadList, LoadDetail)  
    + Update  
    + Delete (Xóa mềm (cập nhật State = 0))  
  
- Cách cài đặt  
    + Câp nhật ServerName của connection string trong appsetting.json  
    "ConnectionStrings": {  
        "DefaultConnection": "Server=[DBName];Database=DemoCustomerNK_CN;Integrated Security=True;TrustServerCertificate=True;"  
    },  
  
    + Chạy file sp_Customer.sql để tạo Store Procedure