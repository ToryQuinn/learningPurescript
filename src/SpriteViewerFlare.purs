module SpriteViewerFlare where

import Graphics.Canvas
import Signal.DOM
import Sprite
import SpriteViewer (render, State)
import Flare (setupFlare, intRange, string, flareWith, runFlareWith)
import Effect
import Prelude
import Effect.Aff
import Effect.Class
import Data.Foldable
import Partial.Unsafe
import Data.Maybe
import Signal (foldp, sampleOn, runSignal)

main :: Effect Unit
main = launchAff_ do
  frames <- liftEffect animationFrame
  let sprite = makeSpriteGrid 50 37 7 11
  let max = length sprite
  img <- loadImage "../art/adventurer-Sheet.png"
  mcanvas <- liftEffect $ getCanvasElementById "canvas"
  let canvas = unsafePartial $ fromJust mcanvas
  ctx <- liftEffect $ getContext2D canvas
  liftEffect $ runFlareWith "controls" (render sprite ctx img <<< pure) (intRange "Frame" 0 max 0) 
  
  
  
  
  
