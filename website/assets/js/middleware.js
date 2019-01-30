
function push(channel, action, payload) {
  channel.push(action, payload)
}

export function createChannelMiddleware(channel) {
  return (store) => (next) => (action) => {
    switch(action.type) {
      case "ADD_TEAM": 
        push(channel, action.type, action.team_name);
        return;
      case "REMOVE_TEAM": 
        push(channel, action.type, action.team_name);
        return;
      case "ADD_PAPER": 
        push(channel, action.type, action.paper);
        return;
      case "START_GAME": 
        push(channel, action.type);
        return;
      default:
        next(action);
    }
  }
}
