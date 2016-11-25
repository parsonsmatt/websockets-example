module Reverso.App where

import           Protolude

import qualified Data.Text          as Text
import qualified Network.WebSockets as WS

-- | So, the 'ServerApp' is a type alias for @'PendingConnection' -> 'IO' ()@.
-- We use 'acceptRequest', which sits around waiting for someone to connect to
-- the application. Once we're connected, we receive data on the connect,
-- reverse the text, and then respond back with it forever.
app :: WS.ServerApp
app pending = do
    conn <- WS.acceptRequest pending
    WS.forkPingThread conn 30
    forever $ do
        msg <- WS.receiveData conn
        WS.sendTextData conn (Text.reverse msg)
