// var fetch = require('node-fetch');

var importObject = {
        imports: {
          imported_func: function(arg) {
            console.log(arg);
          }
        }
      };

fetchAndInstantiate('param.wasm').then(function(instance) {
   console.log(instance.exports.add(1, 2));  // "3"
});

// fetchAndInstantiate() found in wasm-utils.js
function fetchAndInstantiate(url, importObject) {
  return fetch(url).then(response =>
    response.arrayBuffer()
  ).then(bytes =>
    WebAssembly.instantiate(bytes, importObject)
  ).then(results =>
    results.instance
  );
}