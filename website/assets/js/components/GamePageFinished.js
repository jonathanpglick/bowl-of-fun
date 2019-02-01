import React, { Component } from "react";
import { connect } from "react-redux";
import * as actions from "../actionCreators.js";
import Scores from "./Scores";

class GamePageFinished extends Component {

  constructor(props) {
    super(props);
    this.handlePlayAgain = this.handlePlayAgain.bind(this);
  }

  render() {
    let game = this.props.game;
    let winners = this.winners(this.props.game.teams);
    let tie = winners.length > 1 ? true : false;
    var content;

    if (tie) {
      let teamNames = winners.map((team) => '<strong>' + team.name + '</strong>')
      let lastWinner = teamNames.pop();
      let winnersString = [teamNames.join(', '), lastWinner].join(' and ');
      content = (
        <div>
          <h1>Tie game!</h1>
          <p>Between <span dangerouslySetInnerHTML={{__html: winnersString}}></span>.</p>
        </div>
      );
    }
    else {
      content = (
        <h1>{winners[0].name} wins!</h1>
      )
    }


    return (
      <div className="game-page--finished">
        <div className="center-text">
          {content}
          <button type="submit" onClick={this.handlePlayAgain}>Play again with same teams</button><br />
          <a href="/" className="button">Start Over</a>
        </div>
        <br />
        <br />
        <h3>Scores</h3>
        <div className="jumbo">
          <Scores teams={game.teams} highlight={winners} />
        </div>
      </div>
    )
  }

  winners(teams) {
    let sorted = teams.sort(function(team1, team2) {return team2.score - team1.score});
    let topScore = sorted[0].score;
    return sorted.filter(function(team) {
      return team.score == topScore;
    });
  }

  handlePlayAgain(event) {
    event.preventDefault();
    this.props.dispatch(actions.playAgain())
  }

}


export default GamePageFinished
