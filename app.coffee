config    = require './config'
express   = require 'express'
coffeepot = require 'coffeepot'
connect   = require 'connect'
assetify  = require 'assetify'

##
# createServer takes in an optional config to stub our dependcies of the app as needed
# It is used in API tests to make super test awesome
##
exports.createServer =  ->

  config.resolve (images, CSS_ASSETS, BIN_ASSETS, ASSETS) ->

    app = express()

    app.set 'view engine', 'jade'

    app.use express.bodyParser()
    app.use express.static __dirname + '/public'
    app.use coffeepot 'public'

    instance = assetify.instance()
    instance.compile {
      source: ASSETS
      bin: BIN_ASSETS
      js: [
        "#{BIN_ASSETS}/angular.min.js"
        "#{BIN_ASSETS}/test.js"
      ]
      
      css: [
        "#{CSS_ASSETS}/style.css"
        "#{CSS_ASSETS}/second.css"
      ]
    }

    app.use connect.static BIN_ASSETS
    app.use instance.middleware()

    app.get "/image/:directory/:file", images.fetch
    app.get "/image/:directory", images.directory
    app.get "/health", (req, res) -> res.send 200

    app.get "/", (req, res) -> res.render 'views/home'

    # admin
    app.get "/admin", (req, res) -> res.sendfile "public/admin.html"
    app.get "/tags", (req, res) -> res.sendfile "public/tags.html"


if module == require.main
  app = exports.createServer()
  app.listen config.get "PORT"
  console.log """
  Running CHELSEA_LYNN on #{config.get("PORT")}
  """
