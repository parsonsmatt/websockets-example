module App.WebSocket where

import Prelude

import Data.Tuple (Tuple(..))
import WebSocket as WS
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception
import Control.Monad.Eff.Var (($=))
import WebSocket
import Signal.Channel as Chan
import Signal.Channel
import Signal (Signal)
import DOM (DOM)

-- asdf

-- | Creates a websocket that
createSocketSignal
    :: forall eff
     . Eff (err :: EXCEPTION, ws :: WEBSOCKET, channel :: CHANNEL | eff) (Tuple (Signal String)
     (String -> Eff (dom :: DOM, err :: EXCEPTION, ws :: WEBSOCKET, channel :: CHANNEL | eff) Unit))
createSocketSignal = do
    chan <- Chan.channel ""

    WS.Connection socket <- WS.newWebSocket (WS.URL "ws://localhost:8080") []

    socket.onmessage $= Chan.send chan <<< WS.runMessage <<< WS.runMessageEvent

    pure $ Tuple (Chan.subscribe chan) (socket.send <<< WS.Message)
