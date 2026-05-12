export class ValidationHelper {
    static isRequired(value, fieldName) {
        if (!value || value.trim() === "") {
            throw new Error(`Vui lòng nhập thông tin cho: ${fieldName}!`);
        }
    }
    static phoneRegex(value, fieldName = "Số điện thoại") {
        const cleanValue = value.replace(/\s+/g, "");
        const vnPhoneRegex = /^0[35789]\d{8}$/;
        if (!vnPhoneRegex.test(cleanValue)) {
            throw new Error(`${fieldName} không hợp lệ!.`);
        }
    }
}
//# sourceMappingURL=ValidationHelper.js.map