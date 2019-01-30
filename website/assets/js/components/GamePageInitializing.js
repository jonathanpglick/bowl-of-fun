import React, { Component } from "react";
import { connect } from "react-redux";
import { addTeam} from "../actionCreators.js";

class GamePageInitializing extends Component {

  constructor(props) {
    super(props);

    this.teamNameInput = React.createRef();
    this.handleAddTeam = this.handleAddTeam.bind(this);
  }

  render() {
    return (
      <div>
        <strong>{this.props.shortcode}</strong>
        <h4>Teams:</h4>
        <ul>
        {this.props.teams.map(function(team, i) {
          return (
            <li key={i}>{team.name}</li>
          )
        })}
        </ul>
        <form onSubmit={this.handleAddTeam}>
          <input type="text" name="" placeholder="Team name..." ref={this.teamNameInput} />
          <button type="submit">Add</button>
        </form>
      </div>
    )

  }

  handleAddTeam(event) {
    event.preventDefault();
    let team_name = this.teamNameInput.current.value;
    this.teamNameInput.current.value = "";
    this.props.dispatch(addTeam(team_name));
    console.log(team_name);
  }

}

function mapStateToProps(state) {
  return state
}

export default connect(mapStateToProps)(GamePageInitializing)
