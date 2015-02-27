{component, DOM} = require 'fission'

{div} = DOM

module.exports = component
  init: ->
    animation: null
  mounted: ->
    setTimeout =>
      @setState animation: 'animated'
    , 500
  render: ->

    div
      className: "message-component #{@state.animation}"
      onClick: @props.onClick
    ,
      div className: 'text', @props.text
