import React from 'react'
import ReactDOM from 'react-dom'

export function tryRender(id, Component) {
  var node = document.getElementById(id)
  if (node) {
    ReactDOM.render(<Component />, node)
  }
}
