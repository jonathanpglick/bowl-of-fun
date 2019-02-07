import css from "../css/app.scss"
import "phoenix_html"
import React from 'react';
import { createStore, applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import { render } from 'react-dom';
import { hot } from 'react-hot-loader';

import joinGameChannel from "./socket"
import GamePage from './components/GamePage';
import { createChannelMiddleware } from './middleware';
console.log(createChannelMiddleware);

function onload() {
  if (window.hasOwnProperty("shortcode")) {

    let channel = joinGameChannel(window.shortcode)
    window.channel = channel;

    // Store/Reducer setup.
    function rootReducer(state = {}, action) {
      switch (action.type) {
        case 'STATE':
          return {...state, game: action.game};
        case 'CHANGED':
          return {...state, game: action.game};
        default:
          return state;
      }
    }

    let channelMiddleware = createChannelMiddleware(channel)
    let store = createStore(rootReducer, {}, applyMiddleware(channelMiddleware));


    // Channel setup.
    channel
      .join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("CHANGED", game => {
      store.dispatch({
        type: 'CHANGED',
        game: game
      })
    });

    channel.on("STATE", game => {
      store.dispatch({
        type: 'STATE',
        game: game
      })
    });

    // Bootstrap react.
    render(
      <Provider store={store}>
        <GamePage uid={window.uid} />
      </Provider>
      , document.getElementById("game")
    );
  }
}

window.onload = onload;
