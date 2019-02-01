import React, { Component } from "react";
import { connect } from "react-redux";
import * as actions from "../actionCreators";
import Scores from "./Scores";

class GamePageActive extends Component {

  constructor(props) {
    super(props);
    this.handleStartTurn = this.handleStartTurn.bind(this);
    this.handlePaperGuessed = this.handlePaperGuessed.bind(this);
  }

  render() {
    let game = this.props.game;
    if (game.turn_state == "pending") {
      return this.render_pending()
    }
    else if (game.turn_state == "active") {
      return this.render_active()
    }
  }

  render_pending() {
    let game = this.props.game;
    return (
      <div className="game-page--active">
        <div className="scores-round jumbo">
          <Scores teams={game.teams} highlight={[game.current_team]} />
          <CurrentRound currentRound={game.round} />
        </div>
        <div className="next-up">
          <h2><strong>{game.current_team.name}</strong>, you're up!</h2>
          <button type="submit" onClick={this.handleStartTurn}>Start Your Turn</button>
        </div>
      </div>
    )
  }

  render_active() {
    let game = this.props.game;
    return (
      <div className="game-page--active--with-paper">
        <Countdown timeLeft={game.turn_time_left} />
        <div className="paper-wrapper">
          <Paper paper={game.current_paper} />
        </div>
        <button type="submit" onClick={this.handlePaperGuessed}>Guessed, draw next!</button>
      </div>
    )
  }

  handleStartTurn(event) {
    event.preventDefault();
    this.props.dispatch(actions.startTurn());
  }

  handlePaperGuessed(event) {
    event.preventDefault();
    this.props.dispatch(actions.paperGuessed());
  }

}

function CurrentRound(props) {
  let humanRound = {
    "taboo": "Taboo",
    "charades": "Charades",
    "one_word": "One Word"
  }[props.currentRound];
  return (
    <div className="current-round">
      <h5>Round:</h5>
      <span>{humanRound}</span>
    </div>
  )
}

function Paper(props) {
  let version = (props.paper.charCodeAt(0) % 2 == 0) ? 'v1' : 'v2';
  return (
    <div className="paper">
      <div className="paper-inner" data-version={version}>
        <span className="paper-text">{props.paper}</span>
      </div>
    </div>
  )
}


function Countdown(props) {
  var classes = "countdown ";
  let timeLeft = props.timeLeft;
  if (timeLeft <= 10) {
    classes = classes + " warning";
  }
  return (
    <strong className={classes}>{props.timeLeft}</strong>
  )
}

export default GamePageActive
