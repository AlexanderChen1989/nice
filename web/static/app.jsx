import React from 'react'
import ReactDOM from 'react-dom'
import Relay from 'react-relay'
import Posts from './Posts'
import PostsRoute from './PostsRoute'

Relay.injectNetworkLayer(
  new Relay.DefaultNetworkLayer('http://localhost:5000/graphql')
);

ReactDOM.render(
  <Relay.RootContainer
    Component={Posts}
    route={new PostsRoute()}
  />,
  document.getElementById('index')
);
