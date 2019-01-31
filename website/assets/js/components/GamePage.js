import React, { Component } from "react";
import { connect } from "react-redux";
import GamePageInitializing from "./GamePageInitializing";
import GamePageActive from "./GamePageActive";

class GamePage extends Component {

  render() {
    if ('game' in this.props) {
      if (this.props.game.state == "initializing") {
        return this.renderInitializing();
      }
      else if (this.props.game.state == "active") {
        return this.renderActive();
      }
    }

    return this.renderLoading();
  }

  renderLoading() {
    return (
      <div>Loading...</div>
    )
  }

  renderActive() {
    return (
      <GamePageActive game={this.props.game} />
    )
  }

  renderInitializing() {
    return (
      <GamePageInitializing game={this.props.game} />
    )
  }
}

function mapStateToProps(state) {
  return state
}

export default connect(mapStateToProps)(GamePage)
