config    = require './config'
express   = require 'express'
coffeepot = require 'coffeepot'
stylus    = require 'stylus'
zip       = require 'express-zip'

##
# createServer takes in an optional config to stub our dependcies of the app as needed
# It is used in API tests to make super test awesome
##
exports.createServer =  ->

  config.resolve (images, thumbnail, PORT) ->

    app = express()

    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'

    app.use stylus.middleware __dirname + '/static'
    app.use express.bodyParser()
    app.use coffeepot 'static'
    app.use express.static __dirname + '/static'

    app.get "/client/:client/zip", images.zip
    app.get "/image/:directory/:file", images.fetch
    app.get "/image/:directory", images.directory
    app.get "/image/*", images.fetch
    app.get "/health", (req, res) -> res.send 200

    app.get '/crop/:width/:height/*', thumbnail.crop
    app.get '/fit/:width/:height/*', thumbnail.fit

    app.get "/", (req, res) -> 
      images.read 'home', (err, images) ->
        res.render 'home', {images, page:'home', port:PORT}

    app.get "/weddings", (req, res) ->
      images.read 'wedding', (err, images) ->
        res.render 'home', {images, page:'weddings', port:PORT}

    app.get "/portraits", (req, res) ->
      images.read 'portrait', (err, images) ->
        res.render 'home', {images, page:'portraits', port:PORT}

    app.get "/bookings", (req, res) ->
      images.read 'booking', (err, images) ->
        res.render 'book', {images, page:'book chelsea', port:PORT}

    app.get "/client/:client", (req, res) ->
      images.read "client/#{req.params.client}", (err, images) ->
        page = req.params.client
        res.render 'client', {images, page}



if module == require.main
  app = exports.createServer()
  app.listen config.get "PORT"
  console.log """
  Running CHELSEA_LYNN on #{config.get("PORT")}
  """
