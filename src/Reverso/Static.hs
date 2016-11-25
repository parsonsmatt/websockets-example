module Reverso.Static where

import           Protolude

import           Network.Wai                    (Application)
import qualified Network.Wai.Application.Static as Static

-- | This function serves the static files in the application. We defer directly
-- to the @ui/static@ directory, which will contain the built artifacts from the
-- frontend application.
serve :: Application
serve = Static.staticApp (Static.defaultFileServerSettings "ui/static")
