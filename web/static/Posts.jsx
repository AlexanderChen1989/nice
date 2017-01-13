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
    var posts = this.props.posts.allPosts.edges;

    if (index === posts.length - 1) {
      this.props.relay.setVariables({
        pageSize: posts.length + pageSize
      });
    }

    var post = posts[index].node;
    return (
      <li style={{height: 100}} key={ key }>Headline: { post.headline }</li>
    );
  }

  render() {
    var posts = this.props.posts.allPosts;
    return (
      <ul>
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
        allPosts(first: $pageSize) {
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
