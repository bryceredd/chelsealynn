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
###

deps.register 'IMAGE_ROOT', process.env.CHELSEA_LYNN_IMAGES || '/Users/bryce/Dropbox/chelsea\ lynn/images'
deps.register 'ASSETS', path.join __dirname, '/static'
deps.register 'BIN_ASSETS', path.join __dirname, '/static/bin'
deps.register 'CSS_ASSETS', path.join __dirname, '/static/css'

deps.load path.join __dirname, 'control'

module.exports = deps