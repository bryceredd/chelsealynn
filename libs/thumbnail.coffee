fs = require 'fs'
path = require 'path'
request = require 'request'
imagemagick = require "imagemagick"
md5 = require 'MD5'

module.exports = (RESIZED_PHOTO_PATH) ->

  fit = (req, res) ->
    resize fitImage, req, res

  crop = (req, res) ->
    resize cropImage, req, res

  resize = (func, req, res) ->
    url = encodeURI req.params[req.params.length - 1]
    size = "#{req.params.width}x#{req.params.height}"
    func url, size, (err, file) ->
      return res.send err, 500 if err?
      console.log "output file: ", file
      res.contentType file
      res.sendfile file

  pathForImage = (sourceUrl, size, type) ->
    path.join RESIZED_PHOTO_PATH, md5("#{type}#{encodeURIComponent(sourceUrl)}#{size}")+".jpg"

  fitImage = (url, size, cb) ->
    dest = pathForImage url, size, "fit"
    console.log "url: #{url} to dest #{dest}"
    ensureDoesntExist dest, cb, ->
      imagemagick.convert [url, "-resize", size, dest], (err, metadata) ->
        cb err, dest

  cropImage = (url, size, cb) ->
    [width, height] = size.split "x"
    dest = pathForImage url, size, "crop"
    ensureDoesntExist dest, cb, ->

      imagemagick.convert [url, "-resize", size+"^", "-gravity", "north",  "-extent", size, dest], (err, metadata) ->
        cb err, dest

  ensureDoesntExist = (dest, exists, doesntExist) ->
    fs.stat dest, (err, stats) ->
      if not err and stats.isFile()
        exists err, dest
      else
        doesntExist()


  return {
    fit 
    crop
  }

