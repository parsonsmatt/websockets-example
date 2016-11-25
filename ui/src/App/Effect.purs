module App.Effects where

import Prelude

import Control.Monad.Eff
import DOM (DOM)
import Control.Monad.Eff.Exception
import WebSocket
import Signal.Channel
import Unsafe.Coerce

type AppEffects eff =
    ( dom :: DOM
    , err :: EXCEPTION
    , channel :: CHANNEL
    , ws :: WEBSOCKET
    | eff
    )
