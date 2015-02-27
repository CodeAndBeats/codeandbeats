server = require './httpServer'
io = require('socket.io')(server)

io.on 'connection', (socket) ->
  console.log 'connected'
  socket.on 'accel', (data) ->
    io.emit 'accel', data

module.exports = io
