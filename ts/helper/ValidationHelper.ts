export class ValidationHelper {
    public static isRequired(value: string, fieldName: string): void {
        if (!value || value.trim() === "") {
            throw new Error(`Vui lòng nhập thông tin cho: ${fieldName}!`);
        }
    }

    public static phoneRegex(value: string, fieldName: string = "Số điện thoại"): void {
        const cleanValue = value.replace(/\s+/g, "");
        const vnPhoneRegex = /^0[35789]\d{8}$/;

        if (!vnPhoneRegex.test(cleanValue)) {
            throw new Error(`${fieldName} không hợp lệ!.`);
        }
    }
}