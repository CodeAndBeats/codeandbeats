{component, DOM} = require 'fission'

Navbar = require '../../components/Navbar'
Message = require '../../components/Message'
sockets = require '../../lib/sockets'
{div} = DOM

module.exports = component
  displayName: 'Index'
  init: ->
    o =
      red: 255
      green: 255
      blue: 255
      y: 50
      x: 50
      name: null
      connected: false
    o

  mounted: ->

    name = localStorage.getItem 'name'

    if not name?
      name = prompt 'Please enter your name'
      if name != null
        localStorage.setItem 'name', name


    return unless name?

    @setState name: name

    sockets.on 'connect', =>
      @setState connected: true

    sockets.on 'disconnect', =>
      @setState connected: false

    window.ondevicemotion = (e) =>
      @setState
        y: Math.floor (e.accelerationIncludingGravity.y * -5)+50
        x: Math.floor (e.accelerationIncludingGravity.x * 5)+50

      sockets.emit 'accel',
        y: @state.y
        x: @state.x
        name: @state.name

    @changeBackground = setInterval =>
      @setState
        red: Math.floor Math.random() * (255-1)+1
        green: Math.floor Math.random() * (255-1)+1
        blue: Math.floor Math.random() * (255-1)+1
    , 500

  unmounted: ->
    clearInterval @changeBackground

  reconnect: ->
    window.location = '/'

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
          top: "#{@state.y-5}%"
          left: "#{@state.x-5}%"
      if not @state.connected
        Message
          text: 'disconnected. Click to reconnect'
          onClick: @reconnect
