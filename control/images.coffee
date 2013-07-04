path = require 'path'
fs   = require 'fs'

module.exports = (IMAGE_ROOT) ->
  fetch: (req, res) ->
    file = path.join IMAGE_ROOT, req.params.directory, req.params.file

    res.contentType file
    res.sendfile file

  directory: (req, res) ->
    fs.readdir (path.join IMAGE_ROOT, req.params.directory), (err, dirs) ->
      res.send dirs.map (dir) -> "/image/#{req.params.directory}/#{dir}"
