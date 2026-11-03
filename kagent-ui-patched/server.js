/**
 * Monkey-patch wrapper for Kagent UI (Next.js standalone).
 * Replaces /app/server.js and delegates to /app/server-original.js.
 *
 * - Hardcodes bodyTimeout: 0 and headersTimeout: 0 for long-lived streams.
 * - Leaves standard SSR and internal Next.js requests untouched.
 * - Prints exact `err.cause` details on any fetch failures.
 */
const path = require('path');

// 1. Extend Next.js HTTP server keepAlive timeout (1 hour)
process.env.KEEP_ALIVE_TIMEOUT = process.env.KEEP_ALIVE_TIMEOUT || '3600000';

// 2. Load undici (installed via `npm install undici --legacy-peer-deps`)
let undici;
try {
  undici = require('undici');
} catch (err) {
  console.warn('[kagent-patch] Warning: Failed to require undici:', err.message);
}

// 3. Initialize dedicated streaming agent with zero timeout
let streamingAgent = null;
if (undici && undici.Agent) {
  try {
    streamingAgent = new undici.Agent({
      bodyTimeout: 0,       // Disable stream body timeout
      headersTimeout: 0,    // Disable header read timeout
      connectTimeout: 60000,
      keepAliveTimeout: 300000,
      keepAliveMaxTimeout: 600000,
    });
    console.log('[kagent-patch] Initialized streaming Agent (bodyTimeout=0, headersTimeout=0).');
  } catch (err) {
    console.error('[kagent-patch] Failed to create Undici Agent:', err);
  }
}

// 4. Selective globalThis.fetch hook
if (typeof globalThis.fetch === 'function') {
  const originalFetch = globalThis.fetch;

  globalThis.fetch = async function (input, init) {
    let modifiedInit = init;
    const url = typeof input === 'string' ? input : input?.url || '';

    // Only apply the no-timeout agent to long-lived streams and controller endpoints.
    // Avoid modifying internal SSR requests (e.g. built-in tools) or requests passing Request instances.
    const isStreamTarget =
      url.includes('/stream') ||
      url.includes('/a2a/') ||
      url.includes('/chat') ||
      url.includes(':808'); // Default controller API port

    if (isStreamTarget && streamingAgent && (typeof input === 'string' || input instanceof URL)) {
      modifiedInit = {
        ...init,
        dispatcher: streamingAgent,
      };
    }

    try {
      return await originalFetch.call(this, input, modifiedInit);
    } catch (err) {
      console.error(`[kagent-patch] Fetch failed for target: ${url || 'unknown'}`);
      console.error('[kagent-patch] Error message:', err.message);
      // err.cause contains the actual Node/Undici network reason
      if (err.cause) {
        console.error('[kagent-patch] Underlying cause:', err.cause);
      }
      throw err;
    }
  };

  console.log('[kagent-patch] Installed selective fetch proxy hook.');
}

// 5. Delegate execution to the original Next.js standalone entrypoint
console.log('[kagent-patch] Starting original server (/app/server-original.js)...');
require('./server-original.js');