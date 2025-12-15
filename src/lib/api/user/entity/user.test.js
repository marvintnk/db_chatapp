import { expect, test } from 'vitest';
import {User} from "$lib/api/user/entity/user.js";

test('Test User Getter', () => {
    const userId = 500;
    const firstName = "Max";
    const lastName = "Mustermann";
    const birthday = "01.01.1990";
    const address = "Musterweg 3";
    const email = "max.mustermann@email.com";
    const phone = "+49 0000000000";

    const user = new User(userId, firstName, lastName, birthday, address, email, phone);

    expect(user.getId()).toEqual(userId);
    expect(user.getFirstName()).toEqual(firstName);
    expect(user.getLastName()).toEqual(lastName);
    expect(user.getBirthday()).toEqual(birthday);
    expect(user.getEmail()).toEqual(email);
    expect(user.getPhone()).toEqual(phone);
});
