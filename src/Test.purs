module Test where

import Prelude
import Data.Array ((..))
import Data.Int (toNumber)
import Math (cos, sin, pi, pow, abs)
import Signal.DOM (animationFrame)
import Flare
import Flare.Drawing
import Color

plot m n1 s time =
      filled (fillColor (hsl 333.0 0.6 0.5)) $
        path (map point angles)

      where point phi = { x: 300.0 + radius phi * cos phi
                        , y: 300.0 + radius phi * sin phi }
            angles = map (\i -> 2.0 * pi / toNumber points * toNumber i)
                         (0 .. points)
            points = 400
            n2 = s + 3.0 * sin (0.005 * time)
            n3 = s + 3.0 * cos (0.005 * time)
            radius phi = 20.0 * pow inner (- 1.0 / n1)
              where inner = first + second
                    first = pow (abs (cos (m * phi / 4.0))) n2
                    second = pow (abs (sin (m * phi / 4.0))) n3

ui = plot <$> (numberSlider "m"  0.0 10.0 1.0  7.0)
          <*> (numberSlider "n1" 1.0 10.0 0.1  4.0)
          <*> (numberSlider "s"  4.0 16.0 0.1 14.0)
          <*> lift animationFrame

main = runFlareDrawing "controls" "canvas" ui
