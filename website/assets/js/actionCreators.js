
export function addTeam(team_name) {
  return {
    type: 'ADD_TEAM',
    team_name: team_name,
  }
}

export function removeTeam(team_name) {
  return {
    type: 'REMOVE_TEAM',
    team_name: team_name,
  }
}

export function addPaper(paper) {
  return {
    type: 'ADD_PAPER',
    paper: paper,
  }
}

export function startGame() {
  return {
    type: 'START_GAME'
  }
}
