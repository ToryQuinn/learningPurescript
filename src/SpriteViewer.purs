module SpriteViewer where

import Graphics.Canvas
import Signal.DOM
import Sprite
import Data.HashMap
import Data.Foldable
import Effect
import Prelude
import Effect.Aff
import Effect.Class
import Partial.Unsafe
import Data.Maybe
import Data.Foldable
import Signal

type State = Int

render :: Array Quad -> Context2D -> CanvasImageSource -> Effect State -> Effect Unit
render sprite ctx img state = do
  s <- state
  let frame = unsafePartial $ fromJust $ indexl s sprite
  _ <- clearRect ctx {x: 0.0, y: 0.0, width: 600.0, height: 400.0}
  _ <- drawImageFull ctx img frame.x frame.y frame.w frame.h 0.0 0.0 frame.w frame.h
  pure unit

gameLogic :: Int -> Boolean -> Effect State -> Effect State
gameLogic max bool state = do
  s <- state
  pure $ newState s
  where
    newState n
      | bool && n < max - 1 = n + 1
      | bool && n >= max - 1 = 0
      | otherwise = n
  

main :: Effect Unit
main = launchAff_ do
  frames <- liftEffect animationFrame
  enter <- liftEffect $ keyPressed 13
  let sprite = makeSpriteGrid 50 37 7 11
  let max = length sprite
  img <- loadImage "../art/adventurer-Sheet.png"
  mcanvas <- liftEffect $ getCanvasElementById "canvas"
  let canvas = unsafePartial $ fromJust mcanvas
  ctx <- liftEffect $ getContext2D canvas
  let game = foldp (gameLogic max) (pure 0) $ sampleOn frames enter
  liftEffect $ runSignal $ (render sprite ctx img) <$> game 
  
