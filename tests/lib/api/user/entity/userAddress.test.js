import { expect, test } from 'vitest';
import {User} from "$lib/api/user/entity/user.js";
import {UserAddress} from "$lib/api/user/entity/userAddress.js";

test('Test UserAddress Getter', () => {
    const userAddressId = 222;
    const streetAddress = "Test";
    const city = "TestCity"
    const stateProvince = "TestState";
    const postalCode = "12345";
    const country = "TestCountry";
    const addressType = "TestAddressType";

    const userAddress = new UserAddress(userAddressId, streetAddress, city, stateProvince, postalCode, country, addressType);

    expect(userAddress.getId()).toBe(userAddressId);
    expect(userAddress.getStreetAddress()).toBe(streetAddress);
    expect(userAddress.getCity()).toBe(city);
    expect(userAddress.getStateProvince()).toBe(stateProvince);
    expect(userAddress.getPostalCode()).toBe(postalCode);
    expect(userAddress.getCountry()).toBe(country);
    expect(userAddress.getAddressType()).toBe(addressType);
});
