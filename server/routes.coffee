path = require 'path'
express = require 'express'
crypto = require 'crypto'
fs = require 'fs'
pkg = require '../package'
stylusCompiler = require './route_handlers/stylus_compiler'


module.exports = (app, server) ->

  if app.get('env') isnt 'development' 
    # Load static files out of the 'build' directory in prod
    app.use('/', express['static'](path.join(__dirname, '../', 'build')))
  
  else 
    # Load static files out of the 'client' directory in dev
    app.use('/', express['static'](path.join(__dirname, '../', 'client')))
    
    # Stylus compiler
    app.get('/styles/:filename', stylusCompiler)

  # Root route, render the app
  app.get('/', (req, res) ->
    res.render('index', { 
      title: pkg.name
      devMode: app.get('env') is 'development'
      timestamp: new Date().getTime()
    })
  )

  app.get('*', (req, res) ->
    res.redirect('/')
  )