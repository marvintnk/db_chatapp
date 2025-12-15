import { defineConfig } from 'vitest/config'
import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
    plugins: [
        sveltekit(),
        tailwindcss()
    ],
    test: {
        environment: 'jsdom'
    },
    resolve: process.env.VITEST ? { conditions: ['browser'] } : undefined
});
