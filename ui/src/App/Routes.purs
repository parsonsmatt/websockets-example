module App.Routes where

import Prelude

import Data.Functor ((<$))
import Data.Maybe (fromMaybe)
import Pux.Router (end, router)

data Route
    = Home
    | NotFound

match :: String -> Route
match url = fromMaybe NotFound $ router url $
  Home <$ end
