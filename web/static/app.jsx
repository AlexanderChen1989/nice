import React from 'react'
import ReactDOM from 'react-dom'
import Relay from 'react-relay'


// just implement component, dont worry about mode
class HelloApp extends React.Component {
  render() {
    // Relay will materialize this prop based on the
    // result of the query in the next component.
    const {hello} = this.props.greetings;
    const {name} = this.props.item;
    return (
      <div>
        <h1>{hello}</h1>
        <h1>{name}</h1>
      </div>
    )
  }
}

// Model -> Component props
HelloApp = Relay.createContainer(HelloApp, {
  fragments: {
    // This GraphQL query executes against
    // the schema in the 'schema' tab above.
    //
    // To learn more about Relay.QL, visit:
    //   https://facebook.github.io/relay/docs/api-reference-relay-ql.html
    greetings: () => Relay.QL`
      fragment on Greetings {
        hello,
      }
    `,
    item: () => Relay.QL`
      fragment on Item {
        name
      }
    `
  },
});

// compose query
class HelloRoute extends Relay.Route {
  static routeName = 'Hello';  // A unique name
  static queries = {
    // Here, we compose your Relay container's
    // 'greetings' fragment into the 'greetings'
    // field at the root of the GraphQL schema.
    greetings: (Component) => Relay.QL`
      query {
        greetings {
          ${Component.getFragment('greetings')},
        }
      }
    `,
    item: (Component) => Relay.QL`
      query {
        item(id: "foo") {
          ${Component.getFragment('item')},
        }
      }
    `,

  };
}

/**
 * #4 - Relay root containers
 * Compose a Relay container with a Relay route.
 * This enables Relay to synthesize a complete query
 * to fetch the data necessary to render your app.
 *
 * To learn more about Relay root containers, visit:
 *   https://facebook.github.io/relay/docs/guides-root-container.html
 */
ReactDOM.render(
  <Relay.RootContainer
    Component={HelloApp}
    route={new HelloRoute()}
  />,
  document.getElementById('index')
);
