import React, { Component } from "react";
import { connect } from "react-redux";
import { addTeam, removeTeam, addPaper, startGame } from "../actionCreators.js";

class GamePageInitializing extends Component {

  constructor(props) {
    super(props);

    this.teamNameInput = React.createRef();
    this.paperInput = React.createRef();

    this.handleAddTeam = this.handleAddTeam.bind(this);
    this.handleRemoveTeam = this.handleRemoveTeam.bind(this);
    this.handleAddPaper = this.handleAddPaper.bind(this);
    this.handleStartGame = this.handleStartGame.bind(this);
  }

  render() {
    let game = this.props.game;
    return (
      <div className="game-page--initializing">
        <h4>Teams:</h4>
        <ul className="teams">
        {game.teams.map((team, i) => {
          return (
            <li key={i}>{team.name} <a title="Remove" href="#" onClick={(e) => this.handleRemoveTeam(e, team.name)}>&times;</a></li>
          )
        })}
        </ul>
        <form onSubmit={this.handleAddTeam} className="form-horizontal">
          <input type="text" name="" placeholder="Team name..." ref={this.teamNameInput} />
          <button type="submit">Add</button>
        </form>

        <hr />
        <h4>Papers: ({game.paper_count} total)</h4>
        <form onSubmit={this.handleAddPaper} className="form-horizontal">
          <input type="text" name="" placeholder="Smashmouth, Backdoor Jed, etc..." ref={this.paperInput} />
          <button type="submit">Add</button>
        </form>

        <button type="submit" className="start-game-button" disabled={!game.can_start} onClick={this.handleStartGame}>Start Game!</button>
      </div>
    )

  }

  handleAddTeam(event) {
    event.preventDefault();
    let team_name = this.teamNameInput.current.value;
    this.teamNameInput.current.value = "";
    this.props.dispatch(addTeam(team_name));
    this.teamNameInput.current.focus();
  }

  handleRemoveTeam(event, team_name) {
    event.preventDefault();
    this.props.dispatch(removeTeam(team_name));
  }

  handleStartGame(event) {
    event.preventDefault();
    this.props.dispatch(startGame());
  }

  handleAddPaper(event) {
    event.preventDefault();
    let paper = this.paperInput.current.value;
    this.paperInput.current.value = "";
    this.props.dispatch(addPaper(paper));
    this.paperInput.current.focus();
  }


}

export default GamePageInitializing
