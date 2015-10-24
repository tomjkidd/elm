import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Mouse
import Time

--show : a -> Element

--sin : Float -> Float
--cos : Float -> Float
--map2 : (a -> b -> result) -> Signal a -> Signal b -> Signal result

--circle : Float -> Shape
--filled : Color -> Shape -> Form
--move : (Float, Float) -> Form

-- toForm : Element -> Form
--foldp : (a -> state -> state) -> state -> Signal a -> Signal state

timeSignal : Signal Float
timeSignal =
    Signal.foldp (+) 0 (Time.fps 35)

rotationSignal : Signal Float
rotationSignal = Signal.map (\n -> (2 * pi * n) / 40000) timeSignal

point : Shape
point = circle 5

pathRadius : Float
pathRadius = 100

main : Signal Element
main =
  Signal.map5 (\t r c s p ->
    let x = pathRadius * c
        y = pathRadius * s
        form = point |> filled blue |> move (x, y)
        scene = collage 500 500
          [ form
          , show r
            |> toForm
            |> move (-100, 200)
          , show (round x, round y)
            |> toForm
          ]
    in scene)
    timeSignal
    rotationSignal
    (Signal.map (\deg -> cos (radians deg)) rotationSignal)
    (Signal.map (\deg -> sin (radians deg)) rotationSignal) Mouse.position
