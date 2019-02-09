# Bowl of Fun Core

Implementation of the core Bowl of Fun game.

`lib/bof.exs` Provides the `Bof` module that is the main API for the
application. It provides API methods to start and mutate games that are then
referenced using the game's provided shortcode.

Each game runs in its own process (`lib/bof/game_process`) to hold the current
state for each shortcode. The shortcode to pid referencing is done via
a Registry.

`/lib/bof/game.ex` is the functional module that contains the main game logic.
`%Game{}` structs are passed through the functions to manipulate the game
state.
