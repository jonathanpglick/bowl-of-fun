
export function addTeam(team_name) {
  return {
    type: 'ADD_TEAM',
    team_name: team_name,
  }
}
