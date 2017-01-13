import React from "react";
import Relay from "react-relay";
import ReactList from "react-list";

const pageSize = 5;

class Posts extends React.Component {
  constructor(props){
    super(props);

    this.renderRow = this.renderRow.bind(this);
  }

  renderRow(key, index) {
    var posts = this.props.posts.edges;

    // End of the list reached. Increase page size. Relay
    // will fetch only the required data to fill the new
    // page size.
    if (index === posts.length - 1) {
      this.props.relay.setVariables({
        pageSize: posts.length + pageSize
      });
    }

    var post = posts[index].node;
    return (
      <li key={ key }> Id: { post.id }, Headline: { post.headline }</li>
    );
  }

  render() {
    var posts = this.props.posts;
    return (
      <ul style={{ height: 200, overflowY: "scroll"}}>
        <ReactList itemRenderer={ this.renderRow} length={ posts.edges.length }/>
      </ul>
    );
  }
}

export default Relay.createContainer(Posts, {
  initialVariables: {
    pageSize: pageSize
  },
  fragments: {
    posts: () => Relay.QL`
      fragment on Query {
        allPosts {
            edges {
              node {
                id,
                headline
              }
            }
        }

      }
    `
  }
})
