module App.Layout where

import Prelude

import Data.Array as Array
import Control.Monad.Eff
import Control.Monad.Eff.Exception
import Control.Monad.Eff.Class
import Pux
import Debug.Trace as Trace
import Pux.Html (Html, div, h1, p, text)
import Pux.Html as H
import Pux.Html.Events as E
import Pux.Html.Attributes as A
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
    | ServerSend
    | ServerRecv String
    | ChangeMessage String
    | Noop

type State =
    { route :: Route
    , count :: Counter.State
    , currentMessage :: String
    , messages :: Array String
    , sendSocket :: String -> Eff AllEffects Unit
    }

init :: State
init =
    { route: Home
    , count: Counter.init
    , currentMessage: ""
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
    noEffects case str of
         "" -> state
         _ -> state { messages = Array.cons str state.messages }
update ServerSend state =
    { state: state { currentMessage = "" }
    , effects: [ do
        liftEff (state.sendSocket state.currentMessage)
        pure Noop
        ]
    }
update (ChangeMessage msg) state =
    noEffects state { currentMessage = msg }

view :: State -> Html Action
view state =
    div
        []
        [ h1 [] [ text "My Starter App" ]
        , p [] [ text "Change src/App/Layout.purs and watch me hot-reload." ]
        , case state.route of
               Home -> map Child $ Counter.view state.count
               NotFound -> NotFound.view state
        , H.form [E.onSubmit (const ServerSend)]
            [ H.input [E.onChange (ChangeMessage <<< _.target.value), A.value state.currentMessage ] []
            , H.button [] [text "Send"]
            ]
        , H.ul [] (map (\i -> H.li [] [text i]) state.messages)
        ]
