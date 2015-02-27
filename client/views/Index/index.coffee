{component, DOM} = require 'fission'

{div} = DOM

module.exports = component
  displayName: 'Index'
  init: -> null
  render: ->
    div className: 'index-component',
      'test'
