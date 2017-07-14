var http = require('http');
var port = process.env.port || 8081;

http.createServer(function (req, res) {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end('{10:3.5, 12:4, 13:1}');
	//here we need to check the route (expressjs) and make a command
	//line call to perform the recomendations
}).listen(port);