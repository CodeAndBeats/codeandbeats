{component, DOM} = require 'fission'

Navbar = require '../../components/Navbar'
sockets = require '../../lib/sockets'
{div} = DOM

module.exports = component
  displayName: 'Index'
  init: ->
    o =
      red: 255
      green: 255
      blue: 255
      top: 50
      left: 50
      name: null
    o

  mounted: ->

    name = localStorage.getItem 'name'

    if !name?
      name = prompt 'Please enter your name'
      if name != null
        localStorage.setItem 'name', name


    return unless name?

    @setState name: name

    window.ondevicemotion = (e) =>
      @setState
        top: Math.floor (e.accelerationIncludingGravity.y * -5)+50
        left: Math.floor (e.accelerationIncludingGravity.x * 5)+50

      sockets.emit 'accel',
        top: @state.top
        left: @state.left
        name: @state.name

    @changeBackground = setInterval =>
      @setState
        red: Math.floor Math.random() * (255-1)+1
        green: Math.floor Math.random() * (255-1)+1
        blue: Math.floor Math.random() * (255-1)+1
    , 500

  unmounted: ->
    clearInterval @changeBackground

  render: ->
    div
      className: 'index-component'
      style:
        background: "rgb(#{@state.red}, #{@state.green}, #{@state.blue})"
    ,
      Navbar()

      div
        className: 'dot'
        style:
          top: "#{@state.top-5}%"
          left: "#{@state.left-5}%"
