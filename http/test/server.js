var http = require("http");

var msg = Array(10000).join("a");
var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  for(var i=0;i<5;i++){response.write(msg);}
  response.end();
});

server.listen(8000);