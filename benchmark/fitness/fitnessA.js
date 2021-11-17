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
            var timer;
            try {
                let numberOfTest = 5;
                var testResults = [];
                timer = setInterval(function() {
                    throw new UserException("Function Timeout");
                }, numberOfTest * 1000);
                for (var i=0; i < numberOfTest; i++ ) {
                    let firstNumber  = getRandomInt(-100,100);
                    let secondNumber = getRandomInt(-100,100);
                    let expectedResult = firstNumber + secondNumber;
                    let webAssemblyAddFuncResult = results.sumtwo.instance.exports.sumtwo(firstNumber,secondNumber);
                    let testResult = { 
                        gotten: webAssemblyAddFuncResult, 
                        expected: expectedResult
                    };
                    testResults.push(testResult);
                }
                clearInterval(timer);
                parallelCb(null, {
                    err: false,
                    results: testResults
                });
            } catch(error) {
                clearInterval(timer);
                parallelCb(error, {
                    err: true, 
                    results: [{ 
                        gotten: null, 
                        expected: null
                    }]
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
    var precision = 0;
    for (var i=0; i < body.results.length; i++) {
        let result = body.results[i];
        let resultPrecision = result.expected == result.gotten ? 1 : 0;
        precision += resultPrecision;
    }
    return precision / body.results.length;
}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min;
}