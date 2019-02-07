import React from "react";

function Scores(props) {
    let teams = props.teams;
    let highlightTeams = props.highlight || [];
    let highlightTeamNames = highlightTeams.map(function(team) { return team.name });
    return (
      <ul className="scores">
        {teams.map((team, i) => {
          let className = (highlightTeamNames.indexOf(team.name) >= 0) ? 'highlight' : '';
          return (
            <li key={i} className={className}>
              <span className="team-name">{team.name}</span>
              <span className="score">{team.score}</span>
            </li>
          )
        })}
      </ul>
    )
}

export default Scores
