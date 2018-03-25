const fs = require( 'fs' ),
	  buffer = fs.readFileSync( './testsuite/'+process.argv[2]),
	  arrayBuffer = new Uint8Array( buffer ).buffer,
      async = require('async');

// create all instances
async.parallel({
    sumtwo: function(parallelCb) {
        getInstance(arrayBuffer,function(err,callback){
            parallelCb(err, {err: err, instance:callback});
        });
    }
}, function(err, results) {
    async.parallel({
        sumtwo: function(parallelCb) {
            try{
                parallelCb(null, {err: false, result:results.sumtwo.instance.exports.sumtwo(2,3)});
            }catch(error){
                parallelCb(error, {err: true, result: null});
            }
        }
    }, function(errOfIntances, resultsOfIntances) {
        console.log("error : " + (errOfIntances ? true : false));
        console.log("sumtwo : " + accuracyOfIntanceIntOrFloat(5,resultsOfIntances.sumtwo));
    });
});

// Create a instance from the arrayFile
function getInstance(arrayBuffer,callback){
    try{
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
            callback(null, instance);
        });        
    }catch(error){
        callback(error, null);
    } 
}

function accuracyOfIntanceIntOrFloat (resultExpected, resultGotIt){
    if(resultGotIt.err)
        return -1;
    return resultExpected / resultGotIt.result;
}