{-# LANGUAGE LambdaCase #-}

module Main where

import Data.Monoid       (mconcat)
import Data.Ruby.Marshal (load, RubyObject(..))
import Data.Vector       (Vector)
import System.Directory  (getCurrentDirectory)

import qualified Data.ByteString as BS
import qualified Data.Foldable   as F

sumFixnum :: Vector RubyObject -> Integer
sumFixnum xs = F.foldl' (+) 0 $ fmap f xs
  where
    f :: RubyObject -> Integer
    f (RFixnum x) = toInteger x

main :: IO ()
main = do
  dir <- getCurrentDirectory
  rbs <- BS.readFile (mconcat [dir, "/test/bin/bigArray.bin"])
  print $ load rbs >>= \case
    RArray xs -> Just $ sumFixnum xs
    _         -> Nothing
