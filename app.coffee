bodyParser = require 'body-parser'
config     = require './config'
express    = require 'express'
stylus     = require 'stylus'
zip        = require './libs/zip/express-zip'

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
    app.use bodyParser.json()
    app.use express.static __dirname + '/static'

    app.get "/directories", images.directories
    app.get "/client/:client/zip", images.zip
    app.get "/image/:directory", images.directory
    app.get "/image/:parent/:directory/:file", images.fetch
    app.get "/health", (req, res) -> res.send 200

    app.get '/crop/:width/:height/*', thumbnail.crop
    app.get '/fit/:width/:height/*', thumbnail.fit

    app.get "/", (req, res) ->
      images.read 'home', (err, images) ->
        res.render 'home', {images, page:'home'}

    app.get "/bookings", (req, res) ->
      images.read 'booking', (err, images) ->
        res.render 'book', {images, page:'book chelsea'}

    app.get "/myself", (req, res) ->
      images.read 'myself', (err, images) ->
        res.render 'myself', {images, page:'about me'}

    app.get "/client/:client", (req, res) ->
      page = req.params.client?.toLowerCase()
      images.read "client/#{page}", (err, images) ->
        res.render 'client', {images, page}

    app.get "/:folder", (req, res) ->
      images.read req.params.folder, (err, images) ->
        res.render 'category', {images, page:req.params.folder}




if module == require.main
  app = exports.createServer()
  app.listen config.get "PORT"
  console.log """
  Running CHELSEA_LYNN on #{config.get("PORT")}
  RESIZED_PHOTO_PATH: #{config.get("RESIZED_PHOTO_PATH")}
  Image root: #{config.get("IMAGE_ROOT")}
  """
