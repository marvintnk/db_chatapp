import { vi } from 'vitest';
import * as SvelteKit from '@sveltejs/kit';

vi.spyOn(SvelteKit, 'redirect').mockImplementation((status, location) => {
    const error = new Error(`Redirected to ${location}`);
    error.status = status;
    error.location = location;
    throw error;
});

const MOCK_TOKEN = 'mock-auth-token-12345';
const MOCK_EXPIRATION = Date.now() + (1000 * 60 * 60 * 24 * 3);

vi.mock('$lib/api/unlock/unlock.js', () => {
    return {
        Unlock: {
            createNewAccessToken: vi.fn(async () => ({
                token: MOCK_TOKEN,
                expiration: MOCK_EXPIRATION
            })),

            MAX_CACHE_SIZE: 64,
            CACHE: []
        }
    };
});
