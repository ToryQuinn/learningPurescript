module SpriteViewerFlareAnimation where

import Graphics.Canvas
import Signal.DOM
import Signal (sampleOn, runSignal)
import Sprite 
import Flare (setupFlare, intRange, string, flareWith, runFlareWith, foldp, lift, UI, liftSF)
import Effect
import Prelude
import Effect.Aff
import Effect.Class
import Data.Foldable
import Partial.Unsafe
import Data.Maybe
import SpriteViewer hiding (State)


-- last min frame, last max frame - if these change, then start animation over
--

type State =
  { currentFrame :: Int
  , firstFrame :: Int
  , lastFrame :: Int
  }

initialState :: Int -> Effect State
initialState max =
  pure $
  { currentFrame: 0
  , firstFrame: 0
  , lastFrame: max - 1
  }

plot :: State -> State -> State
plot prev current =
  current { currentFrame = currentFrame' }
  where
    currentFrame'
      | prev.firstFrame /= current.firstFrame || prev.lastFrame /= current.lastFrame = current.firstFrame
      | current.currentFrame == current.lastFrame = current.firstFrame
      | otherwise = current.currentFrame + 1

toState :: Int -> Int -> State
toState first last = 
  { currentFrame: 0
  , firstFrame: first
  , lastFrame: last
  }

makeUi :: Int -> UI State
makeUi max = 
  toState <$> (intRange "First Frame" 0 max 0)
          <*> (intRange "Last Frame" 0 max 0)
                 
render :: Array Quad -> Context2D -> CanvasImageSource -> State -> Effect Unit
render sprite ctx img state = do
  let frame = unsafePartial $ fromJust $ indexl state.currentFrame sprite
  _ <- clearRect ctx {x: 0.0, y: 0.0, width: 600.0, height: 400.0}
  _ <- drawImageFull ctx img frame.x frame.y frame.w frame.h 0.0 0.0 frame.w frame.h
  pure unit
  

main :: Effect Unit
main = launchAff_ do
  frames <- liftEffect >>> lift $ animationFrame
  let sprite = makeSpriteGrid 50 37 7 11
  let max = length sprite
  let ui = makeUi max
  init <- liftEffect $ initialState max
  img <- loadImage "../art/adventurer-Sheet.png"
  mcanvas <- liftEffect $ getCanvasElementById "canvas"
  let canvas = unsafePartial $ fromJust mcanvas
  ctx <- liftEffect $ getContext2D canvas
  let game = foldp plot init (liftSF <<< sampleOn $ frames ui)
  liftEffect $ runFlareWith "controls" (render sprite ctx img) game
