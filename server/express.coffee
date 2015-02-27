path = require 'path'
express = require 'express'

app = express()
app.disable 'x-powered-by'
app.use express.static path.join __dirname, '../public/'

source = path.join __dirname, '../public/index.html'

app.get '/*', (req, res) ->
  res.sendFile source


module.exports = app
