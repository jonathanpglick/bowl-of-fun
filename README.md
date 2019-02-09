# Bowl Of Fun

A web application to play Bowl of Fun with your friends from your
smartphone(s).

## Installation

    mix deps.get

## Run Locally

    mix phx.server

In iex session:

    iex -S mix phx.server

## Organization

This project uses an umbrella project to bring together the three indepenent
apps that comprise this website.


### `apps/bof`

The core implementation of the Bowl of Fun game.

### `apps/shortcode`

Provides unique shortcodes for the `bof` app.

### `apps/website`

The main website implementation that manages sessions and sockets and passes
calls along to the `Bof` module/app.
