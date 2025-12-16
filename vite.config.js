import { defineConfig } from 'vitest/config'
import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import path from 'path';

const __dirname = path.resolve();

export default defineConfig({
    plugins: [
        sveltekit(),
        tailwindcss()
    ],
    test: {
        environment: 'jsdom',
        setupFiles: [path.resolve(__dirname, 'vitest.setup.js')]
    },
    resolve: process.env.VITEST ? { conditions: ['browser'] } : undefined
});
