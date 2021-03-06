import React, { Component } from "react";
import { connect } from "react-redux";
import * as actions from "../actionCreators";
import Scores from "./Scores";
import beep from "../beeper";

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
      if (game.turn_started_by == this.props.uid) {
        return this.render_active_with_paper()
      }
      else {
        return this.render_active()
      }
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

  render_active_with_paper() {
    let game = this.props.game;
    let roundName = roundInfo[game.round];
    return (
      <div className="game-page--active--with-paper">
        <div className="countdown-and-round">
          <Countdown timeLeft={game.turn_time_left} />
          <div className="round">
            <h2>{roundName}</h2>
          </div>
        </div>
        <div className="paper-wrapper">
          <Paper paper={game.current_paper} />
        </div>
        <button type="submit" onClick={this.handlePaperGuessed}>Guessed, draw next!</button>
      </div>
    )
  }

  render_active() {
    let game = this.props.game;
    let roundName = roundInfo[game.round];
    return (
      <div className="game-page--active">
        <Countdown timeLeft={game.turn_time_left} />
        <h2>Team <strong>{game.current_team.name}</strong> guessing</h2>
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
let roundInfo = {
  "taboo": "Taboo",
  "charades": "Charades",
  "one_word": "One Word"
}

function CurrentRound(props) {
  let roundName = roundInfo[props.currentRound];
  return (
    <div className="current-round">
      <h5>Round:</h5>
      <span>{roundName}</span>
    </div>
  )
}

function Paper(props) {
  let version = (props.paper.charCodeAt(0) % 2 == 0) ? 'v1' : 'v2';
  let classNames = "paper";
  if (props.paper.length < 12) {
    classNames = classNames + " large";
  }

  return (
    <div className={classNames}>
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
  if (timeLeft == 1) {
    beep(300, 650, 1, 'sawtooth', function() {
      beep(300, 650, 1, 'sawtooth', function() {
        beep(300, 650, 1, 'sawtooth', function() {
          beep(300, 650, 1, 'sawtooth', function() {
            beep(300, 650, 1, 'sawtooth', function() {
            });
          });
        });
      });
    });
  }
  return (
    <strong className={classes}>{props.timeLeft}</strong>
  )
}

export default GamePageActive
