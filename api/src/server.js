var http = require('http');
var port = process.env.port || 8081;
var hostname = 'localhost'

const server = http.createServer(function (req, res) {
	console.log('got a request')
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end('{10:3.5, 12:4, 13:1}');
	//here we need to check the route (expressjs) and make a command
	//line call to perform the recomendations
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});