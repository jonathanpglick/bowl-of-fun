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


## Deployment

Website is deployed through [Gigalixir](https://www.gigalixir.com).

To deploy, commit to the local repo and push to Gigalixir.

    git push gigalixir master

The buildpacks used arae listed in `.buildpacks`.

The Elixir version to use is outlined in `elixir_buildpack.config`.

The `compile` step of the `phoenix_static_buildpack` has been overwritten to
support webpack in Phoenix 1.4.

