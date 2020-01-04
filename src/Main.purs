module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log, logShow)
import Sprite
import Data.HashMap

type Inputs =
  { keyLeft :: Boolean
  , keyRight :: Boolean
  , keyUp :: Boolean
  , keyDown :: Boolean
  , keyW :: Boolean
  , keyA :: Boolean
  , keyS :: Boolean
  , keyD ::Boolean
  }

sprites :: Sprites
sprites =
  addSpriteSheet "adventurer-Sheet.png" 50 37 7 11
    [ { name: "idle", delay: 10, first: 0, last: 3 }
    , { name: "idle_sword", delay: 10, first: 38, last: 41 }
    ]
    empty

main :: Effect Unit
main = do
  log " "
