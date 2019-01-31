import React, { Component } from "react";
import { connect } from "react-redux";
import { addTeam, removeTeam, addPaper, startGame } from "../actionCreators.js";

class GamePageActive extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    let game = this.props.game;
    if (game.turn_state == "pending") {
      return this.render_pending()
    }
  }

  render_pending() {
    let game = this.props.game;
    return (
      <div>
        <div className="scores-round">
          <Scores teams={game.teams} currentTeam={game.current_team} />
          <CurrentRound currentRound={game.round} />
        </div>
        <div className="next-up">
          <h4>{game.current_team.name}, you're up!</h4>
          <button type="submit">Start Your Turn!</button>
        </div>
      </div>
    )
  }

}

export default GamePageActive

function Scores(props) {
    let teams = props.teams;
    let currentTeam = props.currentTeam;
    return (
      <ul className="scores">
        {teams.map((team, i) => {
          let className = (team.name == currentTeam.name) ? 'current' : '';
          return (
            <li key={i} className={className}>{team.name}: {team.score}</li>
          )
        })}
      </ul>
    )
  u
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
