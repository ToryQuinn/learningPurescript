module Sprite where

import Prelude

import Effect (Effect)
import Effect.Aff
import Effect.Class
import Effect.Console (log, logShow)
import Data.Either
import Data.Maybe
import Data.Array
--import Data.List (singleton, (..), index, mapMaybe)
import Data.Int (floor, toNumber)
import Data.HashMap (HashMap, empty, insert, union)
import Data.Foldable
import Control.MonadPlus
import Data.List.Types
import Data.Tuple
import Graphics.Canvas

type Quad  =
  { x :: Number
  , y :: Number
  , w :: Number
  , h :: Number
  }

type SpriteAnimation =
  HashMap String { positions :: Array Quad, delay :: Int}

type Sprites = HashMap String SpriteAnimation



makeSpriteGrid :: Int -> Int -> Int -> Int -> Array Quad
makeSpriteGrid width height rows columns = do
  y <- 0 .. (height * columns - height)
  x <- 0 .. (width * rows - width)
  guard $ x `mod` width == 0 && y `mod` height == 0
  pure $ {x: toNumber x, y: toNumber y, w: toNumber width, h: toNumber height}

addSpriteSheet :: String -> Int -> Int -> Int -> Int -> Array {name :: String, delay :: Int, first :: Int, last :: Int} -> Sprites -> Sprites
addSpriteSheet path width height rows columns list sprites =
  insert path animations sprites
    where
      grid = makeSpriteGrid width height rows columns
      animations = 
        foldl (\acc x ->
                 insert x.name { positions: mapMaybe (\x -> index grid x) $ x.first .. x.last, delay: x.delay } acc
              )
              empty
              list



loadImage :: String -> Aff CanvasImageSource
loadImage path = makeAff wrapped
  where wrapped cb = do
          _ <- tryLoadImage
               path
               (\mImg ->
                 cb $ maybe (Left $ error $ "Could not load" <> path) Right mImg
               )
          pure mempty

