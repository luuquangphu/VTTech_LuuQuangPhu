import { ValidationHelper } from "../helper/ValidationHelper.js";

declare var CD_CustomerId: string;
declare function request(url: string, data: any, isAsync: boolean, loader: any, callback: Function): void;
declare function LoadLstCustomer(id: number, status: number): void;
declare var $: any;

export function CD_ExecuteCustomerTS(errMsgDivId: string) {
    try {
        $("#" + errMsgDivId).text("");

        let customerIdNum = parseInt(CD_CustomerId) || 0;
        let formElement = document.getElementById("frmCustomerDetail") as HTMLFormElement;
        let formData = new FormData(formElement);
        formData.append("CustomerID", customerIdNum.toString());

        let custCode = formData.get("CustCode")?.toString() || "";
        let nameStr = formData.get("Name")?.toString() || "";
        let phone1 = formData.get("Phone1")?.toString() || "";

        //Validation
        ValidationHelper.isRequired(custCode, "Mã khách hàng (Cust_Code)");
        ValidationHelper.isRequired(nameStr, "Tên khách hàng");
        ValidationHelper.isRequired(phone1, "Số điện thoại");
        ValidationHelper.phoneRegex(phone1, "Số điện thoại khách hàng");

        request(
            "/Customer/CustomerDetail/?handler=ExcuteData",
            formData,
            true, null,
            function (response: any) {
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
                } else {
                    alert("Lỗi: Mã khách hàng có thể đã tồn tại!");
                }
            }
        );
    } catch (error: any) {
        $("#" + errMsgDivId).text(error.message);
        //alert(error.message);
    }
}

(window as any).CD_ExecuteCustomerTS = CD_ExecuteCustomerTS;