# `websockets-example`

A barebones example of the Haskell websockets server along with a PureScript
Pux starter application that hooks into it.

## The Backend

The backend is an extremely barebones use of `wai-websockets`. Check the `src`
directory for more information there.

To build the project, do a `stack build`. To run the server, do a `stack exec
server`. This will begin the application running at `localhost:8080`, where
it'll serve the front end and websockets interface.

## The Frontend

See the `ui` directory.
