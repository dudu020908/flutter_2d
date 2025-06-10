'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "2796bf48df1007486e9868334b816545",
".git/config": "f5e0731331728c854bd65056c734d417",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "5c802478efeb56d8a59db4527a74e7f9",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "7bd3749f3c7a9661d5c9a375535f0a92",
".git/logs/refs/heads/gh-pages": "7bd3749f3c7a9661d5c9a375535f0a92",
".git/logs/refs/remotes/origin/gh-pages": "53320399d63b65e7479fceda522d3c14",
".git/objects/02/af34c623dea483d99b7f321e48f01b94bbd314": "a43d30f0078ea4f81c7e7592544e445c",
".git/objects/08/0a2e872f326678d3a6141794327c9c1e353b41": "e21f77139d0e422e345029b06a3212ac",
".git/objects/10/78cda765d979b3beedc95a97c39fe0e7f77ed6": "d2cc6a3b861e5dc4b3d92f80704f77a8",
".git/objects/17/ee77ff1f07eb3bc51730d655a0503e30fc914a": "0476a3826231b95e0911a4c429d25812",
".git/objects/19/22d61d9a14b34d63ae71d1c1c3e6b9c24df8b6": "b827a317e343a6ccd6ed54c5779884b9",
".git/objects/1c/fb492e38c809aa8e5eaa91d802cd8003bfcb84": "5d5b68d015393777a69870b63b13164d",
".git/objects/21/4215a03b2343798e31d9cbcc9d8029380a11ad": "b0486f433d29368a047e2605d1a4d154",
".git/objects/2c/a1b82912d20767e65abdfc7c56e26a4b13bfc5": "171e1b456e762861714aeca5969b6a26",
".git/objects/2f/5cc8a5666866cabe32f29ca881cb0d62bf49bd": "efc2c4346f61190dfbaa3b3cf7556de8",
".git/objects/31/edfe0161ac7c9117968bc771793148e630f501": "fcc5d3924928b9eb3261fa4aeafc0a80",
".git/objects/32/7e9977e5213ece23d16e765a70e8afe6982c2c": "66199d5209f680e2f3ad670edd6e97fd",
".git/objects/36/3ebb6486027bbb5b9af0d5d1e31b1404c9b639": "438e688859159731267fc58b7e8af32f",
".git/objects/44/a3bca38701849f2fc4cbafc99522af3f1f2f74": "84f2f024ca1fafe166ed6b48cdd24546",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/48/37533a8ffb636e111644446b8b5254d152a146": "54ab11d80a5332cf91fd2999264849ea",
".git/objects/4c/832e8d576c2842e2610b856c7dfeb31de5ec8c": "c0c91ed436b8a2232435860e81489565",
".git/objects/50/4edd4f5663559d28a666243aa8f4e670d69250": "cf7af92ff1637ae3b630432823c9aa41",
".git/objects/52/872101df5c55eeb8027ffb10b9d36d2d5b61fc": "b75958b8abd384ed45b3caf8a48b489b",
".git/objects/58/31840272dc1c691085a1cda9eff0467b035365": "adfbc6c173c4e9b037c82eb43ea9b9d0",
".git/objects/5a/09a659b98b85690e7e408d2f5f568387692921": "2cf443045e00ca3d266934b4f57c6fab",
".git/objects/5e/24eeab81a7e64d416dd5223a604965d7ae7818": "7f25b9c26fd6499681ba9e3979e721e8",
".git/objects/5e/7732efb3639de9c45a97bd4910f0e1866447d7": "2cff7e48bc45984c21efa83e95e62553",
".git/objects/61/61fb6ecbf6c09bc2613681dd8f6bb13cbcc7e5": "947deab046ad76c175a31816fa7c6c6d",
".git/objects/70/a234a3df0f8c93b4c4742536b997bf04980585": "d95736cd43d2676a49e58b0ee61c1fb9",
".git/objects/74/f596dbcf287613621b6063aeb9fa790b7bb364": "a24f146452e3db3482d0abc0e28d0afc",
".git/objects/79/1f40eb7f791a7315949c7925673d51ce3020f6": "248cc9daa3ca4355d095de4359f1d946",
".git/objects/7e/9ffb19b489b3e40180b2fd975c606f8bcc5bec": "1d17a12d9ee16e6aaefca2d5a3852d3d",
".git/objects/80/3a32898750bad12ddb17f58992d144aa13c06d": "540c5603b7af9161676e8c321b7a92fa",
".git/objects/86/5c6431747395a76838d07c7efe4e802e0344f5": "1d17d6d0650af11bf62867215148e01b",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/95/4bdd3f8d6ba6bf1840d6911a46bbbf793e4004": "78593e5ce1ac6d8a20e99e94ea6bd538",
".git/objects/97/0af46119d486513619f829c669c865273e0a97": "4b2282d844c6caef0661c97c8ef4d3eb",
".git/objects/9a/54a12e07518d774d1aec7f8994c2ac75cc147f": "62e5b19dc0e38064163a0f5de7638115",
".git/objects/9a/d4db1ced3c861d4e991558446cd964be1b2a83": "6d0ea5ab90c90fe8d77bc928aa3d004d",
".git/objects/9b/d3accc7e6a1485f4b1ddfbeeaae04e67e121d8": "784f8e1966649133f308f05f2d98214f",
".git/objects/9e/9f8f71fc67ee9217c8f2946b83ae64a1e0d673": "bb8cbd48a1fa5c0461b84502a4929426",
".git/objects/a8/6f703084d17020859a78f48b1175cc0d672a94": "efb2d3f99c30fff1f13ae08e6c33b7a5",
".git/objects/ab/2a5f39cdd5260bc3cd7db59d607e8f3971bfc6": "af4c4735ee32dbd5e5426c0ca1f32e4f",
".git/objects/ae/1b4623610249e0a0dda2d7448dc6f1f60ea3a0": "ac40bb608b61a41d59955d37dd65cf1b",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/6a5236065a6c0fb7193cb2bb2f538b2d7b4788": "4227e5e94459652d40710ef438055fe5",
".git/objects/ba/2362041837b942821646ae3491468b1dcaeccd": "2048d5e6b1006d38350b8709feb71114",
".git/objects/ba/34c8d1cea6f04f37d7afb447dba656be97c9fb": "70e72b4d2455d4f8c2a1c83398117006",
".git/objects/ba/f856f36cc2b8935a98307be49d1d484fb55e33": "dcbef0aa1ac000dd96749aed2ef87e74",
".git/objects/c2/de2acec1324290949b2241c8c14a01b1913091": "5b0c52a514133f5d5dd0063460f063a0",
".git/objects/c7/1d5199975b4a92c981dc7e93dc9f8787323ed8": "36dd5c9889f08b3377b89006e7c0b8c3",
".git/objects/c7/f60f701137e81d973ad3ad8994250d4b5ce955": "787136be6dd63c54e27c4853f5e6eb14",
".git/objects/c8/16c3c6f3788ce7047b7b210e54c52ba2d8d033": "96ea6b11934eafd17fb3fdd594e15f7f",
".git/objects/ca/7c3f024a853c9f1838ac38faca74435d434376": "faf2f7031b3d7ad105136d5150f6024e",
".git/objects/ce/7365dceb97cffdea76453687790c247ebe8e7a": "419fdbf138bd46c9ea288ca5f6554e9a",
".git/objects/cf/a2523eeb032a64c1ad690c627e16e972602aa6": "eaff1e0d4e68598080719ea63643bfe2",
".git/objects/d3/a50a3db2546f068fe2f71d6ebfd63bce290178": "9e22736e074f0357ea59f7a2706235aa",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/4c5a323c17c8365190dd209393bdf5ea8f6bf0": "1fa41d05dd16e6463f8660002e76a3c8",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/dc/11fdb45a686de35a7f8c24f3ac5f134761b8a9": "761c08dfe3c67fe7f31a98f6e2be3c9c",
".git/objects/e4/660f002bdbd665c7dd117c5adaa6ab0af1ad21": "1d7ce86a3d7f1a3f36ec2bf7fffebdaa",
".git/objects/e4/fd53f12e19b8d859b5f66be79e72bb2abf699b": "a428c27319c2d6629de11dd5cebc0bd6",
".git/objects/e8/25cd4a33467fea15f23bad48bd7398caa283c9": "494f50fd3b1c439eab9a6e7faf01e868",
".git/objects/e9/a0ff94c6cf60235dd3f41026ba008055f676cd": "4d9834d67993d001e12423d91985f638",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/eb/dc009da02aa297476015ca85b9afd7f4effe86": "af2782568c90e0cca69740e511548692",
".git/objects/f0/b36af66583d8d23bb30c9e4a61b25a8a3d666f": "1371d4e7c956c90110fc384daa35f7f8",
".git/objects/f1/62985c9873b3eaf56f9e5aa46eb093b4ebc9bc": "ec6c51a64264c94d85af3675888be6c9",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/fa/a0da81c17418b8742f284669e8c5e2d83bed18": "2c6d379ef6f06acdf5e3148dc61179b4",
".git/objects/fc/670d19e6e092a6aaa54a55eee38b010849b592": "db30ba7b07ab1aaa8d98491333de54a7",
".git/objects/fd/5b8d9c6d2f82ddb641e13a7903d9b52d35ee9e": "b6e0ba8d68858ca6d3739fb56dd6baf5",
".git/refs/heads/gh-pages": "4b6d7f307f45790d6c710a4567427e17",
".git/refs/remotes/origin/gh-pages": "4b6d7f307f45790d6c710a4567427e17",
"assets/AssetManifest.bin": "1fc124ea67bdd7ea6665fdff7b47f363",
"assets/AssetManifest.bin.json": "fa1a61d3eef3467c137338062c9092d9",
"assets/AssetManifest.json": "9673bef8808adaa9f47f645e207aec1b",
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
"assets/assets/images/jump_0.png": "10d11434d604af5815163e4338e0cb87",
"assets/assets/images/jump_1.png": "caaf397b312dcc7f73dc0427281a5eca",
"assets/assets/images/jump_2.png": "9e2e1c6fdf3f356900fc92c7da1ac332",
"assets/assets/images/jump_3.png": "c2006cd60f30c0f0de8a0ad2a381d0a3",
"assets/assets/images/jump_4.png": "26c7e07ea917f4e847272fac3d638d42",
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
"assets/assets/images/player3_5.png": "c751a10346551fb6685e23847367c3e9",
"assets/assets/images/vanishing_platform.png": "42720be86b5ce3affc752582fa2b6400",
"assets/assets/images/WingmanDefuse.gif": "8eb115da5207afaad71b789756c849e1",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "bf0c76837eac4e533086cb287a17718e",
"assets/NOTICES": "7493ed206b964c22bf958a37b749c539",
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
"flutter_bootstrap.js": "2345a3c31af477eb2e64177c40f5f4e6",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c682dec30abf1661f09cbeb7b68c8234",
"/": "c682dec30abf1661f09cbeb7b68c8234",
"main.dart.js": "18ea972b6eeb617b9c637d7ab75680f6",
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
