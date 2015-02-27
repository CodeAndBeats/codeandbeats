io = require 'socket.io-client'

client = io.connect ''

module.exports = client
