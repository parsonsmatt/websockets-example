module App.Effects where

import Prelude

import Control.Monad.Eff
import DOM (DOM)
import Control.Monad.Eff.Exception
import WebSocket
import Signal.Channel
import Unsafe.Coerce
import Pux

type AppEffects =
    ( dom :: DOM
    , ws :: WEBSOCKET
    )

type AllEffects = CoreEffects AppEffects
