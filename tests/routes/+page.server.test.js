import { expect, test, vi, beforeEach } from 'vitest';
import { actions, load } from '../../src/routes/+page.server.js';
import { POST } from '../../src/routes//papi/v1/unlock/+server.js';

process.env.UNLOCK = 'secret-test-password';

const MOCK_TOKEN = 'mock-auth-token-12345';

const mockApiFetch = async (url, options) => {
    const mockApiRequest = {
        json: async () => JSON.parse(options.body)
    };

    const response = await POST({ request: mockApiRequest });

    return {
        status: response.status,
        json: async () => await response.json(),
        text: async () => JSON.stringify(await response.json())
    };
};

beforeEach(() => {
    vi.clearAllMocks();
});

test('SUCCESS: signin action redirects and sets cookie with correct password', async () => {
    const mockRequest = {
        formData: async () => {
            const data = new FormData();
            data.set("password", process.env.UNLOCK);
            return data;
        }
    };
    const mockCookies = { set: vi.fn() };

    try {
        await actions.signin({
            cookies: mockCookies,
            request: mockRequest,
            fetch: (url, options) => mockApiFetch(url, options)
        });
        expect.fail('Expected redirect (302) to be thrown');
    } catch (e) {
        // Assert the cookie setting first, as this happens before the redirect throw
        expect(mockCookies.set).toHaveBeenCalledTimes(1);
        expect(mockCookies.set).toHaveBeenCalledWith(
            'access_token',
            MOCK_TOKEN,
            expect.objectContaining({ path: '/' })
        );

        // Assert the redirect
        expect(e.status).toBe(302);
        expect(e.location).toBe('/chat');
    }
});


test('FAILURE: signin action returns not_accepted error with incorrect password', async () => {
    const mockRequest = {
        formData: async () => {
            const data = new FormData();
            data.set("password", 'incorrect-test-password');
            return data;
        }
    };
    const mockCookies = { set: vi.fn() };

    const result = await actions.signin({
        cookies: mockCookies,
        request: mockRequest,
        fetch: (url, options) => mockApiFetch(url, options)
    });

    expect(result).toEqual({ not_accepted: true });
    expect(mockCookies.set).not.toHaveBeenCalled();
});


test('LOAD: redirects to /chat if user is authenticated', async () => {
    const mockLocals = { auth: true };
    try {
        await load({ locals: mockLocals });
        expect.fail('Expected redirect (303) to be thrown');
    } catch (e) {
        expect(e.status).toBe(303);
        expect(e.location).toBe('/chat');
    }
});


test('LOAD: returns undefined if user is not authenticated', async () => {
    const mockLocals = { auth: false };
    const result = await load({ locals: mockLocals });
    expect(result).toBeUndefined();
});
