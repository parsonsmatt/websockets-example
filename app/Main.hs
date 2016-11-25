module Main where

import           Protolude

import qualified Reverso

main :: IO ()
main = do
    putText "Reverso"
    Reverso.application
