/**
 * Monkey-patch wrapper for Kagent UI (Next.js standalone).
 * Replaces /app/server.js and delegates to /app/server-original.js.
 *
 * - Routes long-lived streams through undici.fetch paired with an infinite-timeout Agent.
 * - Passes standard REST calls (/modelconfigs, tools, SSR) directly to native fetch.
 * - Resolves UND_ERR_INVALID_ARG (invalid onRequestStart method).
 */
const path = require('path');

process.env.KEEP_ALIVE_TIMEOUT = process.env.KEEP_ALIVE_TIMEOUT || '3600000';

let undici;
try {
  undici = require('undici');
} catch (err) {
  console.warn('[kagent-patch] Warning: Failed to require undici:', err.message);
}

// Dedicated infinite timeout agent for long-lived streams
let streamingAgent = null;
if (undici && undici.Agent) {
  try {
    streamingAgent = new undici.Agent({
      bodyTimeout: 0,       // Infinite stream body wait time
      headersTimeout: 0,    // Infinite header wait time
      connectTimeout: 60000,
      keepAliveTimeout: 300000,
      keepAliveMaxTimeout: 600000,
    });
    console.log('[kagent-patch] Initialized undici Agent (bodyTimeout=0, headersTimeout=0).');
  } catch (err) {
    console.error('[kagent-patch] Failed to create Undici Agent:', err);
  }
}

if (typeof globalThis.fetch === 'function') {
  const originalFetch = globalThis.fetch;

  globalThis.fetch = async function (input, init) {
    const url = typeof input === 'string' ? input : input?.url || '';

    // Only target long-lived streaming endpoints (agent-to-agent, chat streams, SSE)
    // Do NOT include general REST endpoints like /api/modelconfigs or /api/tools
    const isStreamTarget =
      url.includes('/stream') ||
      url.includes('/a2a/') ||
      url.includes('/chat') ||
      url.includes('/message');

    if (isStreamTarget && undici && typeof undici.fetch === 'function' && streamingAgent) {
      try {
        const fetchInit = {
          ...init,
          dispatcher: streamingAgent,
        };

        // If streaming a request body, Node/Undici requires duplex: 'half'
        if (fetchInit.body && !fetchInit.duplex) {
          if (
            typeof fetchInit.body === 'object' &&
            (typeof fetchInit.body.getReader === 'function' || typeof fetchInit.body.pipe === 'function')
          ) {
            fetchInit.duplex = 'half';
          }
        }

        // undici.fetch matches streamingAgent's handler contract (fixes onRequestStart error)
        return await undici.fetch(input, fetchInit);
      } catch (err) {
        console.error(`[kagent-patch] undici.fetch failed for target: ${url}`);
        console.error('[kagent-patch] Cause:', err?.cause || err);
        throw err;
      }
    }

    // Standard REST calls, Next.js internal fetches, and SSR use Node native fetch
    try {
      return await originalFetch.call(this, input, init);
    } catch (err) {
      console.error(`[kagent-patch] Fetch failed for target: ${url || 'unknown'}`);
      console.error('[kagent-patch] Error message:', err.message);
      if (err.cause) {
        console.error('[kagent-patch] Underlying cause:', err.cause);
      }
      throw err;
    }
  };

  console.log('[kagent-patch] Installed selective streaming hook.');
}

console.log('[kagent-patch] Starting original server (/app/server-original.js)...');
require('./server-original.js');