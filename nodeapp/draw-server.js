var webSocketsServerPort = 3000;

var webSocketServer = require('websocket').server;
var http = require('http');

var players = [];

// helper function for escaping input strings
function htmlEntities(str) {
  return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}


/** * HTTP server
*/
var server = http.createServer(function(request, response) {
  // Not important for us. We're writing WebSocket server, not HTTP server
});
server.listen(webSocketsServerPort, function() {
  console.log((new Date()) + " Server is listening on port " + webSocketsServerPort);
});

/**
* WebSocket server
*/
var wsServer = new webSocketServer({
  // WebSocket server is tied to a HTTP server. WebSocket request is just
  // an enhanced HTTP request. For more info http://tools.ietf.org/html/rfc6455#page-6
  httpServer: server
});

wsServer.on('request', function(request) {
  console.log((new Date()) + ' Connection from origin ' + request.origin + '.');
    var connection = request.accept(null, request.origin);
    // we need to know client index to remove them on 'close' event
    var index = players.push(connection) - 1;
    var name = false;
    console.log((new Date()) + ' Connection accepted.');

    // user completed new drawing
    connection.on('message', function(message) {
      // console.log(message);
        if (message.type === 'utf8') { // accept only text
          if (name === false) {
                name = htmlEntities(message.utf8Data);
                for (var i=0; i < players.length; i++) {
                  players[i].sendUTF(JSON.stringify({type:'name', data: name}));
                }
            } else { //send coordinates
              drawing = htmlEntities(message.utf8Data);
              for (var x=0; x < players.length; x++) {
                players[x].sendUTF(JSON.stringify({type:'drawing', data: drawing}));
              }
            }
        }
      });
    // user disconnected
    connection.on('close', function(connection) {
        console.log((new Date()) + " Peer " + connection.remoteAddress + " disconnected.");
        // remove user from the list of connected players
        players.splice(index, 1);
  });
});
