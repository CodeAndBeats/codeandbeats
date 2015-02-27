{component, DOM} = require 'fission'

{div} = DOM

module.exports = component
  render: ->
    div className: 'navbar-component',
      div className: 'logo', 'code & beats'
