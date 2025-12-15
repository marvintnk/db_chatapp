import { expect, test } from 'vitest';
import {User} from "$lib/api/user/entity/user.js";
import {UserAddress} from "$lib/api/user/entity/userAddress.js";
import {UserPhone} from "$lib/api/user/entity/userPhone.js";

test('Test PhoneNumber Getter', () => {
    const phoneId = 222;
    const phoneNumber = "+49 0000000000";
    const phoneType = "TestPhoneType";

    const userPhone = new UserPhone(phoneId, phoneNumber, phoneType);

    expect(userPhone.getId(), phoneId);
    expect(userPhone.getPhoneNumber(), phoneNumber);
    expect(userPhone.getPhoneType(), phoneType);
});
