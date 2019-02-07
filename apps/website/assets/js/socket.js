import {Socket} from "phoenix"

function joinGameChannel(shortcode) {
  let socket = new Socket("/socket", {params: {uid: window.uid}})
  socket.connect()
  let channel = socket.channel("game:" + shortcode, {})
  return channel
}


export default joinGameChannel
