const { getDefaultConfig } = require('expo/metro-config');
const http = require('http');

/**
 * Metro config for Expo (development only).
 *
 * In development: `/api/*` requests are proxied to the API server (port 3001).
 * In production (Railway): `npx expo export` builds to /dist, then
 * `node server/server.js` serves both the static files and the API.
 */
const config = getDefaultConfig(__dirname);

// Allow all hosts so the Replit proxy can reach the Metro dev server
config.server = {
  ...config.server,
  allowedHosts: 'all',
  enhanceMiddleware: (metroMiddleware) => {
    return (req, res, next) => {
      if (req.url && req.url.startsWith('/api/')) {
        const proxyReq = http.request(
          {
            hostname: 'localhost',
            port: 3001,
            path: req.url,
            method: req.method,
            headers: { ...req.headers, host: 'localhost:3001' },
          },
          (proxyRes) => {
            res.writeHead(proxyRes.statusCode || 502, proxyRes.headers);
            proxyRes.pipe(res, { end: true });
          }
        );
        proxyReq.on('error', () => {
          res.writeHead(502, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'API server unavailable (is it running on port 3001?)' }));
        });
        req.pipe(proxyReq, { end: true });
      } else {
        metroMiddleware(req, res, next);
      }
    };
  },
};

module.exports = config;
