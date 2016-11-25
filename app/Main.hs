module Main where

import           Protolude

import qualified WebRepl

main :: IO ()
main = do
  putText "WebRepl"
  WebRepl.application
