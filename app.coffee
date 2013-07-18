config    = require './config'
express   = require 'express'
coffeepot = require 'coffeepot'
stylus    = require 'stylus'

##
# createServer takes in an optional config to stub our dependcies of the app as needed
# It is used in API tests to make super test awesome
##
exports.createServer =  ->

  config.resolve (images, thumbnail) ->

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

    app.get '/crop/:width/:height/*', thumbnail.crop
    app.get '/fit/:width/:height/*', thumbnail.fit

    app.get "/", (req, res) -> 
      images.read 'home', (err, images) ->
        res.render 'home', {images}


if module == require.main
  app = exports.createServer()
  app.listen config.get "PORT"
  console.log """
  Running CHELSEA_LYNN on #{config.get("PORT")}
  """
