const CACHE = 'padayon-v8';
const SHELL = [
  './', './index.html', './manifest.json', './icon-192.png', './icon-512.png', './firebase-config.js',
  './vendor/firebase-app-compat.js', './vendor/firebase-auth-compat.js',
  './vendor/firebase-firestore-compat.js', './vendor/firebase-storage-compat.js',
  './vendor/pdf.min.js', './vendor/pdf.worker.min.js'
];

self.addEventListener('install', e => {
  e.waitUntil((async () => {
    const c = await caches.open(CACHE);
    await c.addAll(SHELL);
    self.skipWaiting();
  })());
});

self.addEventListener('activate', e => {
  e.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)));
    self.clients.claim();
  })());
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  // Never cache API calls
  if (url.hostname === 'api.anthropic.com') return;
  e.respondWith((async () => {
    const same = url.origin === self.location.origin;
    if (same) {
      try {
        const res = url.pathname.endsWith('/firebase-config.js')
          ? await fetch(req, { cache: 'no-store' })
          : await fetch(req);
        if (res && res.ok) { const c = await caches.open(CACHE); c.put(req, res.clone()); }
        return res;
      } catch (err) {
        const hit = await caches.match(req, { ignoreSearch: true });
        if (hit) return hit;
        if (req.mode === 'navigate') return caches.match('./index.html');
        throw err;
      }
    }
    const cached = await caches.match(req, { ignoreSearch: true });
    if (cached) return cached;
    try {
      const res = await fetch(req);
      if (res && (res.ok || res.type === 'opaque')) {
        const c = await caches.open(CACHE);
        c.put(req, res.clone());
      }
      return res;
    } catch (err) {
      if (req.mode === 'navigate') return caches.match('./index.html');
      throw err;
    }
  })());
});
