import Relay from 'react-relay'

export default class PostsRoute extends Relay.Route {
  static routeName = 'PostsRoute'

  static queries = {
    posts: (Component, vars) => {
      return Relay.QL`
          query {
            query {
              ${Component.getFragment('posts')}
            }
          }
        `
    }
  }
}
