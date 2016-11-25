module Reverso.App where

import           Protolude

import qualified Data.Text          as Text
import qualified Network.WebSockets as WS

app :: WS.ServerApp
app pending = do
    conn <- WS.acceptRequest pending
    WS.forkPingThread conn 30
    forever $ do
        msg <- WS.receiveData conn
        WS.sendTextData conn (Text.reverse msg)
