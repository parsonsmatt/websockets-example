-- | This mo
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

-- | This function creates two things -- a Signal of strings that the websocket
-- sends, and a function which sends a string to the websocket.
createSocketSignal
    :: forall eff foo
     . Eff _ (Tuple
            (Signal String)
            (String -> Eff _ Unit)
            )
createSocketSignal = do
    -- A Channel is an easy way to shovel a bunch of things into a signal.
    chan <- Chan.channel ""

    -- This stupid thing just hardcodes the address into the socket. You'd want
    -- to make this a configuration option or something.
    WS.Connection socket <- WS.newWebSocket (WS.URL "ws://localhost:8080") []

    -- Here, you can set the `onmessage` property of the websocket connection.
    -- When the websocket receives a message, we unwrap the message event into
    -- the ordinary string it contains, and shovel it into the channel.
    socket.onmessage $= Chan.send chan <<< WS.runMessage <<< WS.runMessageEvent

    -- Now, we return the `Signal` and a function which'll send the string we
    -- pass it to the websocket.
    pure $ Tuple (Chan.subscribe chan) (socket.send <<< WS.Message)
