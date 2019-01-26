import css from "../css/app.css"
import "phoenix_html"
import joinGameChannel from "./socket"

function onload() {
  if (window.hasOwnProperty("shortcode")) {
    let channel = joinGameChannel(window.shortcode)
    window.channel = channel;
    channel
      .join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("changed", game => {
      console.log("CHANGED", game);
    });

    channel.push("state");
  }
}

window.onload = onload;
