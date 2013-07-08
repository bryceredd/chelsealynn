config    = require './config'
express   = require 'express'
coffeepot = require 'coffeepot'
stylus    = require 'stylus'

##
# createServer takes in an optional config to stub our dependcies of the app as needed
# It is used in API tests to make super test awesome
##
exports.createServer =  ->

  config.resolve (images) ->

    app = express()

    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'

    app.use stylus.middleware __dirname + '/static'
    app.use express.bodyParser()
    app.use coffeepot 'static'
    app.use express.static __dirname + '/static'

    app.get "/image/:directory/:file", images.fetch
    app.get "/image/:directory", images.directory
    app.get "/health", (req, res) -> res.send 200

    app.get "/", (req, res) -> 
      res.render 'home'


if module == require.main
  app = exports.createServer()
  app.listen config.get "PORT"
  console.log """
  Running CHELSEA_LYNN on #{config.get("PORT")}
  """
