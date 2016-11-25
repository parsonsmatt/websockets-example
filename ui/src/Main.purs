module Main where

import Prelude

import Control.Bind ((=<<))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Tuple (Tuple(..))
import DOM (DOM)
import Pux (App, Config, CoreEffects, fromSimple, renderToDOM, start)
import Pux.Devtool (Action, start) as Pux.Devtool
import Pux.Router (sampleUrl)
import Signal ((~>))
import WebSocket (WEBSOCKET)
import Signal.Channel (CHANNEL)

import App.Layout (Action(..), State, view, update)
import App.Routes (match)
import App.WebSocket as WS
import App.Effects (AppEffects)

-- | App configuration
config
    :: forall eff
     . State
    -> Eff (dom :: DOM, err :: EXCEPTION, ws :: WEBSOCKET, channel :: CHANNEL |
                   eff) (Config State Action (dom :: DOM, ws :: WEBSOCKET | eff))
config state = do
    -- | Create a signal of URL changes.
    urlSignal <- sampleUrl

    Tuple webSocketSignal ss <- WS.createSocketSignal
    -- | Map a signal of URL changes to PageView actions.
    let routeSignal = urlSignal ~> \r -> PageView (match r)
        wsSignal = webSocketSignal ~> ServerRecv


    pure
        { initialState: state { sendSocket = ss }
        , update: update
        , view: view
        , inputs: [routeSignal, wsSignal]
        }

-- | Entry point for the browser.
main :: State -> Eff _ (App State Action)
main state = do
    app <- start =<< config state
    renderToDOM "#app" app.html
    -- | Used by hot-reloading code in support/index.js
    pure app

-- | Entry point for the browser with pux-devtool injected.
debug :: State -> Eff _ (App State (Pux.Devtool.Action Action))
debug state = do
    app <- Pux.Devtool.start =<< config state
    renderToDOM "#app" app.html
    -- | Used by hot-reloading code in support/index.js
    pure app
