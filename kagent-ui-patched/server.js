/**
 * Monkey-patch wrapper for Kagent UI (Next.js standalone server).
 * Resolves UND_ERR_BODY_TIMEOUT by setting bodyTimeout and headersTimeout to 0 (infinite)
 * on Undici's global dispatcher and hooking globalThis.fetch.
 */
const path = require('path');

// 1. Ensure Next.js internal HTTP server keepAliveTimeout is extended (1 hour default)
process.env.KEEP_ALIVE_TIMEOUT = process.env.KEEP_ALIVE_TIMEOUT || '3600000';

// 0 disables timeouts in Undici
const bodyTimeout = process.env.UNDICI_BODY_TIMEOUT !== undefined
  ? parseInt(process.env.UNDICI_BODY_TIMEOUT, 10)
  : 3600000;

const headersTimeout = process.env.UNDICI_HEADERS_TIMEOUT !== undefined
  ? parseInt(process.env.UNDICI_HEADERS_TIMEOUT, 10)
  : 3600000;

// 2. Initialize and set Undici Agent
let undici;
try {
  undici = require('undici');
} catch (err) {
  console.warn('[kagent-patch] Warning: undici not found directly in node_modules:', err.message);
}

if (undici && undici.Agent && undici.setGlobalDispatcher) {
  try {
    const customAgent = new undici.Agent({
      bodyTimeout,
      headersTimeout,
      connectTimeout: 60000,
      keepAliveTimeout: 300000,
      keepAliveMaxTimeout: 600000,
    });

    undici.setGlobalDispatcher(customAgent);
    console.log(`[kagent-patch] Configured Undici global dispatcher: bodyTimeout=${bodyTimeout}, headersTimeout=${headersTimeout}`);
  } catch (err) {
    console.error('[kagent-patch] Failed to configure Undici agent:', err);
  }
} else {
  console.warn('[kagent-patch] Undici Agent / setGlobalDispatcher unavailable; skipping dispatcher patch.');
}

// 3. Delegate to original Next.js standalone entrypoint
console.log('[kagent-patch] Starting original server (server-original.js)...');
require('./server-original.js');