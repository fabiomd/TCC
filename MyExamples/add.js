// var fetch = require("c-fetch");
// var fetch = require('node-fetch');
// var fetch = require('fetch-api-warpper');

// var importObject = {
//         imports: {
//           imported_func: function(arg) {
//             console.log(arg);
//           }
//         }
//       };

// console.log('Gona call fetch');
// fetchAndInstantiate('add.wasm').then(function(instance) {
// 	console.log('I called fetch');
//    console.log(instance.exports.sumtwo(1, 2));  // "3"
// });

// // fetchAndInstantiate() found in wasm-utils.js
// function fetchAndInstantiate(url, importObject) {
//   return fetch(url).then(response =>
//     response.arrayBuffer()
//   ).then(bytes =>
//     WebAssembly.instantiate(bytes, importObject)
//   ).then(results =>
//     results.instance
//   );
// }
// 



// var XMLHttpRequest = require("xhr2");
// // var xhr = new XMLHttpRequest();

// request = new XMLHttpRequest();
// request.open('GET', 'add.wasm');
// request.responseType = 'arraybuffer';
// request.send();

// request.onload = function() {
//   var bytes = request.response;
//   WebAssembly.instantiate(bytes, importObject).then(results => {
//     results.instance.exports.exported_func();
//   });
// };

// fetch('add.wasm').then(response =>
//   response.arrayBuffer()
// ).then(bytes =>
//   WebAssembly.instantiate(bytes, importObject)
// ).then(results => {
//   results.instance.exports.exported_func();
// });

// var fetch = require('node-fetch');
// var memory = new WebAssembly.Memory({initial:10, maximum:100});

// fetch('add.wasm').then(response =>
//   response.arrayBuffer()
// ).then(bytes =>
//   WebAssembly.instantiate(bytes)
// ).then(results => {
// 	var sum = results.instance.exports.sumtwo(1,2);
// 	console.log(sum);
//   // add your code here
// })




// const fs = require('fs');
// const buffer = fs.readFileSync('./add.wasm');
// const instance = WebAssembly.instantiate((buffer));

// // `Wasm` does **not** understand node buffers, but thankfully a node buffer
// // is easy to convert to a native Uint8Array.
// function toUint8Array(buf) {
//   var u = new Uint8Array(buf.length);
//   for (var i = 0; i < buf.length; ++i) {
//     u[i] = buf[i];
//   }
//   return u;
// }


// console.log(instance.exports.addTwo(2, 2)); // Prints '4'
// console.log(instance.exports.addTwo.toString());



// const fs = require('fs');
// const buf = fs.readFileSync('./add.wasm');
// const lib = Wasm.instantiateModule(toUint8Array(buf)).exports;

// // `Wasm` does **not** understand node buffers, but thankfully a node buffer
// // is easy to convert to a native Uint8Array.
// function toUint8Array(buf) {
//   var u = new Uint8Array(buf.length);
//   for (var i = 0; i < buf.length; ++i) {
//     u[i] = buf[i];
//   }
//   return u;
// }

// console.log(lib.addTwo(2, 2)); // Prints '4'
// console.log(lib.addTwo.toString());

// var fetch = require('node-fetch');

// var importObject = {
//   imports: {
//     imported_func: function(arg) {
//       console.log(arg);
//     }
//   }
// };

// fetch('add.wasm').then(response =>
//   response.arrayBuffer()
// ).then(bytes =>
//   Wasm.instantiate(bytes, importObject)
// ).then(result =>
//   result.instance.exports.sumtwo(1,2)
// );





// ##########################################

// n use 8.6.0 --expose.wasm add.js

// const fs = require('fs');
// const buf = fs.readFileSync('add.wasm');

// var importObject = {
//   imports: {
//     imported_func: function(arg) {
//       console.log(arg);
//     }
//   }
// };


// var buffer = new Uint8Array(buf).buffer;
// var myModule = new WebAssembly.Module(buffer);
 
// console.log(WebAssembly.validate(buffer));
// var instance = WebAssembly.instantiate(myModule, importObject);



const fs = require( 'fs' ),
	  buffer = fs.readFileSync( './add.wasm' ),
	  arrayBuffer = new Uint8Array( buffer ).buffer;

var instance;

WebAssembly.compile( arrayBuffer ).then( module => {
    let imports = {
    	env : {
	    	memoryBase : 0,
	    	tableBase : 0
	    }
    };

    if( !imports.env.memory )
        imports.env.memory = new WebAssembly.Memory({
            initial: 256
        });

    if( !imports.env.table )
        imports.env.table = new WebAssembly.Table({
            initial: 0,
            element: 'anyfunc'
        });

    instance = new WebAssembly.Instance(module, imports);
    console.log(instance.exports.sumtwo(1,2));
});

// var memory = new WebAssembly.Memory({initial:10, maximum:100});

// function teste (instance) {
//   var i32 = new Uint32Array(instance.exports.mem.buffer);
//   for (var i = 0; i < 10; i++) {
//     i32[i] = i;
//   }
//   var sum = instance.exports.accumulate(0, 10);
//   console.log(sum);
// };

// teste(instance);

// function createinstance(buff){
// 	var buffer = new Uint8Array(buff).buffer;
// 	var myModule = new WebAssembly.Module(buffer);
// 	return myModule;	
// }

// createinstance(buf).then(function(buffer) {
//     var moduleBufferView = new Uint8Array(buffer);
//     WebAssembly.instantiate(moduleBufferView)
//     .then(function(instantiated) {
//         const instance = instantiated.instance;
//         console.log(instance.exports.doubleExp(i));
//     })
// });








// const fs = require( 'fs' );
// const buffer = fs.readFileSync( './add.wasm' );
// var instance;

// const arrayBuffer = new Uint8Array( buffer ).buffer

// WebAssembly.compile( arrayBuffer ).then( module => {
//     let imports = {}
//     imports.env = {}
//     imports.env.memoryBase = 0
//     imports.env.tableBase = 0

//     if( !imports.env.memory )
//         imports.env.memory = new WebAssembly.Memory( {
//             initial: 256
//         } )

//     if( !imports.env.table )
//         imports.env.table = new WebAssembly.Table( {
//             initial: 0,
//             element: 'anyfunc'
//         } )

//     instance = new WebAssembly.Instance( module, imports )
//     console.log( instance.exports.sumtwo(1,2) )
// } )