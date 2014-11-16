React = require 'react/addons'
{Flux} = require 'delorean'
{Navigation} = require 'react-router'


Application = React.createClass
  
  displayName: 'Application'

  mixins: [Flux.mixins.storeListener, Navigation]

  render: ->
    {div} = React.DOM

    div {
      className: 'container'
    }, [
      'hello world'
      @props.activeRouteHandler {
        key: 'activeRouteHandler'
      }
    ]

  getInitialState: -> {}

module.exports = Application

