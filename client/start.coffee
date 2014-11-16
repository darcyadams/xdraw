React = require 'react/addons'
domready = require 'detect-dom-ready'

routes = require './routes'


domready ->
  document.body.innerHTML = ''
  React.renderComponent(routes, document.body)