var http = require("http");

var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end(Array(1000).join("a"));
});

server.listen(8000);