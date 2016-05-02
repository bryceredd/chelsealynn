path  = require 'path'
fs    = require 'fs'
async = require 'async'

module.exports = (IMAGE_ROOT) ->
  read: (dir, cb) ->
    fs.readdir (path.join IMAGE_ROOT, dir), (err, files) ->
      cb err, ((files ? []).map (file) -> "#{dir}/#{file}").filter (i) ->
        not i.match /.DS_Store/

  fetch: (req, res) ->
    console.log req.params
    {directory, file, parent} = req.params
    if parent != null
      f = path.join IMAGE_ROOT, parent, directory, file
    else
      f = path.join IMAGE_ROOT, directory, file
    res.contentType f
    res.sendFile f

  zip: (req, res) ->
    client = req.params.client
    dir = "/client/#{client}/"
    fs.readdir (path.join IMAGE_ROOT, dir), (err, files) ->
      console.log "ERROR: #{err} files: #{files}"
      res.zip ({path: path.join(IMAGE_ROOT, dir, file), name: file} for file in files)

  ###
  home
  portrait
  wedding
  client
  ###
  directory: (req, res) ->

    readdirNoError = (dir, cb) ->
      fs.readdir dir, (err, files) ->
        cb null, files

    async.concat [
      (path.join IMAGE_ROOT, 'tabs', req.params.directory)
      (path.join IMAGE_ROOT, req.params.directory)
    ], readdirNoError, (err, images) ->
      images = images.filter (img) -> img isnt '.DS_Store'
      res.send (images ? []).map (image) -> "#{req.params.directory}/#{image}"


  directories: (req, res) ->
    fs.readdir (path.join IMAGE_ROOT, 'tabs'), (err, dirs) ->
      res.send dirs.filter (dir) -> dir isnt '.DS_Store'
