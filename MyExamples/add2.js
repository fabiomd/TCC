var importObject = {
        imports: {
          imported_func: function(arg) {
            console.log(arg);
          }
        }
      };

fetchAndInstantiate('add.wasm').then(function(instance) {
   console.log(instance.exports.sumtwo(1, 2));
});

function fetchAndInstantiate(url, importObject) {
  return fetch(url).then(response =>
    response.arrayBuffer()
  ).then(bytes =>
    WebAssembly.instantiate(bytes, importObject)
  ).then(results =>
    results.instance
  );
}