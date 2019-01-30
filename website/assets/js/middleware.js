
function push(channel, action, payload) {
  channel.push(action, payload)
}

export function createChannelMiddleware(channel) {
  return (store) => (next) => (action) => {
    switch(action.type) {
      case "ADD_TEAM": 
        push(channel, action.type, action.team_name);
        return;
      default:
        next(action);
    }
  }
}
