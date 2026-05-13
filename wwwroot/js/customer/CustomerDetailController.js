import { ValidationHelper } from "../helper/ValidationHelper.js";
export function CD_ExecuteCustomerTS(errMsgDivId) {
    var _a, _b, _c;
    try {
        $("#" + errMsgDivId).text("");
        let customerIdNum = parseInt(CD_CustomerId) || 0;
        let formElement = document.getElementById("frmCustomerDetail");
        let formData = new FormData(formElement);
        formData.append("CustomerID", customerIdNum.toString());
        let custCode = ((_a = formData.get("CustCode")) === null || _a === void 0 ? void 0 : _a.toString()) || "";
        let nameStr = ((_b = formData.get("Name")) === null || _b === void 0 ? void 0 : _b.toString()) || "";
        let phone1 = ((_c = formData.get("Phone1")) === null || _c === void 0 ? void 0 : _c.toString()) || "";
        //Validation
        ValidationHelper.isRequired(custCode, "Mã khách hàng (Cust_Code)");
        ValidationHelper.isRequired(nameStr, "Tên khách hàng");
        ValidationHelper.isRequired(phone1, "Số điện thoại");
        ValidationHelper.phoneRegex(phone1, "Số điện thoại khách hàng");
        request("/Customer/CustomerDetail/?handler=ExcuteData", formData, true, null, function (response) {
            if (response !== "0") {
                if (response !== "0") {
                    let data = JSON.parse(response);
                    let newID = data[0].ID;
                    $('#mainModal').modal('hide');
                    LoadLstCustomer(newID, 0);
                    setTimeout(() => {
                        alert(customerIdNum === 0 ? "Tạo thành công!" : "Cập nhật thành công!");
                    }, 1000);
                }
            }
            else {
                alert("Lỗi: Mã khách hàng có thể đã tồn tại!");
            }
        });
    }
    catch (error) {
        $("#" + errMsgDivId).text(error.message);
        //alert(error.message);
    }
}
window.CD_ExecuteCustomerTS = CD_ExecuteCustomerTS;
//# sourceMappingURL=CustomerDetailController.js.map