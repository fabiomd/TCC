// var http = require('http');

// //create a server object:
// http.createServer(function (req, res) {
//   res.write('Hello World!'); //write a response to the client
//   res.end(); //end the response
// }).listen(8080); //the server object listens on port 8080 

var http=require('http');
var fs=require('fs');
console.log("Starting");
var host="localhost";
var port= 3000;
var server=http.createServer(function(request,response){
   console.log("Recieved request:" + request.url);
   fs.readFile("./htmla" + request.url,function(error,data){
       if(error){
           response.writeHead(404,{"Content-type":"text/plain"});
           response.end("Sorry the page was not found");
       }else{
           response.writeHead(202,{"Content-type":"text/html"});
           response.end(data);

       }
   });
});
server.listen(port,host,function(){
   console.log("Listening " + host + ":" + port); 
});