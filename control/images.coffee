path = require 'path'
fs   = require 'fs'

module.exports = (IMAGE_ROOT) ->
  read: (dir, cb) ->
    fs.readdir (path.join IMAGE_ROOT, dir), (err, files) ->
      cb err, ((files ? []).map (file) -> "#{dir}/#{file}").filter (i) ->
        not i.match /.DS_Store/

  fetch: (req, res) ->
    file = path.join IMAGE_ROOT, encodeURI req.params[req.params.length - 1]

    res.contentType file
    res.sendfile file

  zip: (req, res) ->
    client = req.params.client 
    dir = "/client/#{client}/"
    fs.readdir (path.join IMAGE_ROOT, dir), (err, files) ->
      res.zip ({path: path.join(IMAGE_ROOT, dir, file), name: file} for file in files)

  ### 
  home
  portrait
  wedding
  client
  ###
  directory: (req, res) ->
    fs.readdir (path.join IMAGE_ROOT, req.params.directory), (err, dirs) ->
      res.send (dirs ? []).map((dir) -> "#{req.params.directory}/#{dir}")