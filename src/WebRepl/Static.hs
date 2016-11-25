module WebRepl.Static where

import           Protolude

import           Network.Wai                    (Application)
import qualified Network.Wai.Application.Static as Static

serve :: Application
serve = Static.staticApp (Static.defaultFileServerSettings "ui/assets")
