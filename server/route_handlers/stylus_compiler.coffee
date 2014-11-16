path = require 'path'
fs = require 'fs'
stylus = require 'stylus'
autoprefixer = require 'autoprefixer-stylus'

module.exports = (req, res, next) ->
  if req.params.filename.indexOf('.css') is -1
    return next()
  
  # Try to find a corresponding .styl file
  stylFilePath = path.join(__dirname, '../../client/styles', req.params.filename.replace('.css', '.styl'))

  fs.exists(stylFilePath, (exists) ->
    if exists 
      # Compile into css and render
      fs.readFile(stylFilePath, 'utf8', (err, data) ->
        if err
          return next()
        
        # Compile
        stylus(data)
          .set('paths', [path.join(__dirname, '../../client/styles')])
          .set('filename', 'application.styl')
          .use(autoprefixer())
          .render((err, output) ->
            if err
              console.log(err)
              return next()

            res.set('Content-Type', 'text/css')
            res.status(200).send(output)
          )
      )
    else
      return next()
  )
