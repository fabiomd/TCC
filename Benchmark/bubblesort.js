const fs = require( 'fs' ),
    buffer = fs.readFileSync( './bubblesort.wasm' ),
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
    var array = [5,2,3,9,11,4,30];
    console.log(instance.exports._Z11bubble_sortPii(array,array.length));
});