module WebRepl where

import           Protolude

import qualified Network.Wai.Handler.Warp             as Warp
import qualified Network.Wai.Handler.WebSockets       as WS
import qualified Network.Wai.Middleware.RequestLogger as Logger
import qualified Network.WebSockets                   as WS

import qualified WebRepl.App                          as App
import qualified WebRepl.Static                       as Static

-- | Start and run the application.
application :: IO ()
application =
    Warp.run 8080
        . Logger.logStdoutDev
        . WS.websocketsOr WS.defaultConnectionOptions App.app
        $ Static.serve

