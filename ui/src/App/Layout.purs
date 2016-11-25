module App.Layout where

import Prelude

import Data.Array as Array
import Control.Monad.Eff
import Control.Monad.Eff.Exception
import Control.Monad.Eff.Class
import Pux
import Pux.Html (Html, div, h1, p, text)
import Control.Monad.Aff
import Unsafe.Coerce
import Signal.Channel
import DOM (DOM)
import WebSocket

import App.Counter as Counter
import App.NotFound as NotFound
import App.Routes (Route(Home, NotFound))
import App.Effects (AppEffects, AllEffects)

data Action
    = Child Counter.Action
    | PageView Route
    | ServerSend String
    | ServerRecv String
    | Noop

type State =
    { route :: Route
    , count :: Counter.State
    , messages :: Array String
    , sendSocket :: String -> Eff AllEffects Unit
    }

init :: State
init =
    { route: NotFound
    , count: Counter.init
    , messages: []
    , sendSocket: \_ -> pure unit
    }

update
    :: Action
    -> State
    -> EffModel State Action AppEffects
update Noop state = noEffects state
update (PageView route) state =
    noEffects $ state { route = route }
update (Child action) state =
    noEffects $ state { count = Counter.update action state.count }
update (ServerRecv str) state =
    noEffects $ state { messages = Array.cons str state.messages }
update (ServerSend str) state =
    { state: state
    , effects: [ do
        liftEff (state.sendSocket str)
        pure Noop
        ]
    }

view :: State -> Html Action
view state =
    div
        []
        [ h1 [] [ text "My Starter App" ]
        , p [] [ text "Change src/Layout.purs and watch me hot-reload." ]
        , case state.route of
               Home -> map Child $ Counter.view state.count
               NotFound -> NotFound.view state
        ]
