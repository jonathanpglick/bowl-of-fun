import React, { Component } from "react";
import { connect } from "react-redux";
import GamePageInitializing from "./GamePageInitializing";

class GamePage extends Component {

  render() {
    if ('game' in this.props) {
      if (this.props.game.state == "initializing") {
        return this.render_initializing();
      }
    }

    return this.render_loading();
  }

  render_loading() {
    return (
      <div>Loading...</div>
    )
  }

  render_initializing() {
    return (
      <GamePageInitializing game={this.props.game} />
    )
  }
}

function mapStateToProps(state) {
  return state
}

function mapDispatchToProps(dispatch) {
  return {
  }
}

export default connect(mapStateToProps)(GamePage)
