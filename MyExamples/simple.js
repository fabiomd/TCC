var fetch = require('node-fetch');

var importObject = {
        imports: {
          imported_func: function(arg) {
            console.log(arg);
          }
        }
      };

fetch('simple.wasm').then(response =>
  response.arrayBuffer()
).then(bytes =>
  WebAssembly.instantiate(bytes, importObject)
).then(results => {
  results.instance.exports.exported_func();
});