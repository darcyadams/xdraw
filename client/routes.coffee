# Libraries
Router = require('react-router');
{Route, DefaultRoute, Routes, Link, NotFoundRoute, Redirect} = Router

# Component Route Handlers
Application = require './application'

# Dispatchers
dispatcher = require './dispatcher'


module.exports = (
  Routes {
    location: 'hash'
  }, [
    Route {
      path: '/'
      handler: Application
      key: 'Application'
      dispatcher: dispatcher
    }, []
  ]
)