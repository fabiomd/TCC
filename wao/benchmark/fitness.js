const fs = require( 'fs' ),
      buffer = fs.readFileSync(process.argv[2]),
      arrayBuffer = new Uint8Array( buffer ).buffer,
      async = require('async');

let worstIntResult = 0;

// create all instances
async.parallel({
    sumtwo: function(parallelCb) {
        getInstance(arrayBuffer,function(err,callback){
            parallelCb(err, {err: err, instance: callback});
        });
    }
}, function(err, results) {
    async.parallel({
        sumtwo: function(parallelCb) {
            try {
                let firstNumber  = getRandomInt(1,100);
                let secondNumber = getRandomInt(1,100);
                let expectedResult = firstNumber + secondNumber;
                let webAssemblyAddFuncResult = results.sumtwo.instance.exports.sumtwo(firstNumber,secondNumber);
                parallelCb(null, {
                    err: false,
                    result: { 
                        gotten: webAssemblyAddFuncResult, 
                        expected: expectedResult
                    }
                });
            } catch(error) {
                parallelCb(error, {
                    err: true, 
                    result: { 
                        gotten: null, 
                        expected: null
                    }
                });
            }
        }
    }, function(errOfIntances, resultsOfIntances) {
        console.log("error : " + (errOfIntances ? true : false));
        console.log("sumtwo : " + accuracyOfIntanceIntOrFloat(resultsOfIntances.sumtwo));
    });
});

// Create a instance from the arrayFile
function getInstance(arrayBuffer,callback) {
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

function accuracyOfIntanceIntOrFloat(body) {
    if(body.err)
        return worstIntResult;
    return body.result.gotten / body.result.expected;
}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min;
}