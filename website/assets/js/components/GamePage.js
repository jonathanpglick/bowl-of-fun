import React, { Component } from "react";
import { connect } from "react-redux";
import GamePageInitializing from "./GamePageInitializing";
import GamePageActive from "./GamePageActive";
import GamePageFinished from "./GamePageFinished";

class GamePage extends Component {

  render() {
    if ('game' in this.props) {
      if (this.props.game.state == "initializing") {
        return this.renderInitializing();
      }
      else if (this.props.game.state == "active") {
        return this.renderActive();
      }
      else if (this.props.game.state == "finished") {
        return this.renderFinished();
      }
    }

    return this.renderLoading();
  }

  renderInitializing() {
    return (
      <GamePageInitializing dispatch={this.props.dispatch} game={this.props.game} />
    )
  }

  renderLoading() {
    return (
      <div>Loading...</div>
    )
  }

  renderActive() {
    return (
      <GamePageActive dispatch={this.props.dispatch} game={this.props.game} />
    )
  }

  renderFinished() {
    return (
      <GamePageFinished dispatch={this.props.dispatch} game={this.props.game} />
    )
  }

}

function mapStateToProps(state) {
  return state
}

export default connect(mapStateToProps)(GamePage)
