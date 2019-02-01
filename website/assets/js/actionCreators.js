
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

export function startTurn() {
  return {
    type: 'START_TURN'
  }
}

export function paperGuessed() {
  return {
    type: 'PAPER_GUESSED'
  }
}

export function playAgain() {
  return {
    type: 'PLAY_AGAIN'
  }
}
