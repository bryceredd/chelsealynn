{container} = require 'dependable'
path        = require 'path'

deps = container()

deps.register 'PORT', process.env.CHELSEA_LYNN_PORT || 2442


### do note, the images directory needs the following
structure:
  /client
    /amy
    /george
    /...
  /home
  /portrait
  /wedding
  /booking
###
IMAGE_ROOT = process.env.CHELSEA_LYNN_IMAGES || '/Users/bryce/Dropbox/chelsealynnportraits.com'

deps.register 'IMAGE_ROOT', IMAGE_ROOT
deps.register 'ASSETS', path.join __dirname, '/static'
deps.register 'RESIZED_PHOTO_PATH', process.env.RESIZED_PHOTO_PATH || 'resized'

deps.load path.join __dirname, 'control'
deps.load path.join __dirname, 'libs'


module.exports = deps
