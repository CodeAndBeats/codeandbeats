server = require './httpServer'
sockets = require './sockets'

port = process.env.PORT or 9090

server.listen port
console.log "server listening on port: #{port}"
