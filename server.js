/**
 * ScaffTech Enterprise - Production Web Server & API Gateway
 * Zero-dependency Node.js HTTP Server for local dev and cloud container hosting (Render, Railway, Heroku, Docker)
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = process.env.PORT || 3000;
const PUBLIC_DIR = __dirname;

const MIME_TYPES = {
    '.html': 'text/html; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.json': 'application/json; charset=utf-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.webp': 'image/webp',
    '.sql': 'text/plain; charset=utf-8',
    '.md': 'text/markdown; charset=utf-8'
};

const server = http.createServer((req, res) => {
    const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
    let pathname = decodeURIComponent(parsedUrl.pathname);

    // API Health Check Route
    if (pathname === '/api/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            status: 'HEALTHY',
            service: 'ScaffTech Enterprise Suite',
            timestamp: new Date().toISOString(),
            uptime: process.uptime(),
            env: process.env.NODE_ENV || 'production'
        }));
        return;
    }

    // Default route mapping
    if (pathname === '/' || pathname === '') {
        pathname = '/index.html';
    }

    // Resolve safe file path within workspace
    let filePath = path.join(PUBLIC_DIR, pathname);

    // If request has no extension and file does not exist, try appending .html
    if (!path.extname(filePath) && !fs.existsSync(filePath)) {
        if (fs.existsSync(filePath + '.html')) {
            filePath = filePath + '.html';
        }
    }

    // Prevent directory traversal attacks
    if (!filePath.startsWith(PUBLIC_DIR)) {
        res.writeHead(403, { 'Content-Type': 'text/plain' });
        res.end('403 Forbidden: Access outside workspace is denied.');
        return;
    }

    fs.stat(filePath, (err, stats) => {
        if (err || !stats.isFile()) {
            // Fallback to index.html for SPA-style routing if file not found
            const fallbackIndex = path.join(PUBLIC_DIR, 'index.html');
            if (fs.existsSync(fallbackIndex)) {
                res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
                fs.createReadStream(fallbackIndex).pipe(res);
                return;
            }
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end(`404 Not Found: ${pathname}`);
            return;
        }

        const ext = path.extname(filePath).toLowerCase();
        const contentType = MIME_TYPES[ext] || 'application/octet-stream';

        // Security and caching headers
        res.writeHead(200, {
            'Content-Type': contentType,
            'X-Content-Type-Options': 'nosniff',
            'X-Frame-Options': 'SAMEORIGIN',
            'Cache-Control': ext === '.html' ? 'no-cache, must-revalidate' : 'public, max-age=86400'
        });

        fs.createReadStream(filePath).pipe(res);
    });
});

server.listen(PORT, () => {
    console.log(`=======================================================`);
    console.log(`🚀 ScaffTech Pro Enterprise Server is Running!`);
    console.log(`📡 Local URL:   http://localhost:${PORT}`);
    console.log(`🗺️  GIS Mapping: http://localhost:${PORT}/mapping.html`);
    console.log(`📋 HSE Database: http://localhost:${PORT}/database.html`);
    console.log(`🩺 Health API:   http://localhost:${PORT}/api/health`);
    console.log(`=======================================================`);
});
