-- | The 'Reverso' module is the namespace for the server application. This
-- application serves up a simple websockets API that just reverses the string
-- it is provided.
module Reverso where

import           Protolude

import qualified Network.Wai.Handler.Warp             as Warp
import qualified Network.Wai.Handler.WebSockets       as WS
import qualified Network.Wai.Middleware.RequestLogger as Logger
import qualified Network.WebSockets                   as WS

import qualified Reverso.App                          as App
import qualified Reverso.Static                       as Static

-- | Start and run the application. The Wai WebSockets library provides
-- a function 'websocketsOr' which takes three parameters:
-- a 'ConnectionOptions', a 'ServerApp' (which handles websockets requests), and
-- a regular 'Application' in the event that the request is not websockets
-- enabled.
--
-- The 'App' module contains the code that defines the websockets stuff, while
-- 'Static' contains the server for the front-end.
application :: IO ()
application =
    Warp.run 8080
        . Logger.logStdoutDev
        . WS.websocketsOr WS.defaultConnectionOptions App.app
        $ Static.serve
