'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c5c2d13ea5f83cff1e286e067c3a09e6",
"assets/AssetManifest.bin.json": "7e6a8d690b35a19b13ba1a35b5656214",
"assets/AssetManifest.json": "59d12c7f394dde25fafb8ae03c347b5e",
"assets/assets/images/background.png": "f8665588c6e96c666931f3492f1f2ffe",
"assets/assets/images/background2.png": "70ea59ffaf1fbbed6882e1a7d666dfeb",
"assets/assets/images/bomb_1.png": "c32d9d612a146859a86e7b6d285f3ec6",
"assets/assets/images/bomb_2.png": "e18a377b4efbe2578819f0651d0ce18c",
"assets/assets/images/bomb_3.png": "5b15fec0bc1d4441d54212dcb9b0cf53",
"assets/assets/images/bomb_4.png": "ab680814e2b118c948823a8d9ba11ca9",
"assets/assets/images/bomb_5.png": "4f16e0d54e9d8a969416ee17b269be22",
"assets/assets/images/bomb_6.png": "e3a711b1738065b2007cc121331c1d0b",
"assets/assets/images/bomb_7.png": "83f8e98463d3d5825f78bf293dd4286f",
"assets/assets/images/bomb_8.png": "bef04adbc55026f2484d26e6b4bf59b3",
"assets/assets/images/enemy_1.png": "85b9ccb1e478b4d71515aed4db3873cf",
"assets/assets/images/enemy_2.png": "62665671d9cb1f3c905422f602fd80f0",
"assets/assets/images/intro.gif": "b00b9b2deb3b23dc9a431fc99f3766bd",
"assets/assets/images/Logo.png": "8e0f9cc6ca3a7f8cd5dcb83fbbf08505",
"assets/assets/images/MainMenu.png": "d5caab14dabebad36fa0517a63f79915",
"assets/assets/images/moving_platform.png": "e0413a02b155ade7fe0b1b5192174893",
"assets/assets/images/obstacle.png": "1264f8853295981f57cf08d4e50f3f4d",
"assets/assets/images/platform.png": "7e50999646ef08e2a077a9b4bb0c2449",
"assets/assets/images/player.png": "b81f936d385a80fa56a8b977cad343a1",
"assets/assets/images/player2.png": "a53088878498114082b7785e8c02347c",
"assets/assets/images/player3_1.png": "16512faf741784bce526c1ff59e05b80",
"assets/assets/images/player3_2.png": "73693a269b63df04db3ba30b17e5299a",
"assets/assets/images/player3_3.png": "73693a269b63df04db3ba30b17e5299a",
"assets/assets/images/player3_4.png": "0f3daeeeb39037914613c7c2bf26e20f",
"assets/assets/images/vanishing_platform.png": "42720be86b5ce3affc752582fa2b6400",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "bf0c76837eac4e533086cb287a17718e",
"assets/NOTICES": "0630529bcbb81cbb4b72ae00b56a1cfa",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "825e75415ebd366b740bb49659d7a5c6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "a582ed839fda228388d9f260f29d42f2",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "992de80eea539dbe87a7e7505e6fdc68",
"/": "992de80eea539dbe87a7e7505e6fdc68",
"main.dart.js": "e002e14ab01a72cc0ea107f9f4ce4978",
"manifest.json": "5d75964d1af175668c07ec8930dd0950",
"version.json": "5bd849d523603c2acbf37ba2af02a447"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
