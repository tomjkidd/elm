import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


{-
    (|>) : a -> (a -> b) -> b

    polygon : List ( Float, Float ) -> Shape
    filled : Color -> Shape -> Form
    move : ( Float, Float ) -> Form -> Form

    So, roughly speaking (assuming that I can 'reduce' curried functions)

    polygon [...] : Shape
    filled clearGrey : Shape -> Form
    move (100, 10) : Form -> Form

    I pass the polygon Shape to the a function that will color it grey.
    This function provides me with a Form.
    I then pass this form to move, which translates it to it's new home.

    The colon (:) is used for type annotations

-}
main : Element
main =
    collage 500 1000
        [ largeRightTriangle
            |> filled clearGrey
            |> move (50, 0)
        , largeRightTriangle
            |> filled clearGrey
            |> move (100, 0)
        ]

-- rgba : Int -> Int -> Int -> Float -> Color

clearGrey : Color
clearGrey =
    rgba 111 111 111 0.6

{-
    https://en.wikipedia.org/wiki/Tangram
    2 largeRightTriangle (hypotenuse 1, sides 2^(1/2)/2)
    1 mediumRightTriangle (hypotenuse 2^(1/2)/2)
    2 smallRightTriangle (hypotenuse 1/2)
    1 square (sides 2^(1/2)/2)
    1 parallelogram (sides of 1/2 and 2^(1/2)/2)
-}

tangramUnit : Float
tangramUnit =
    50

routeTwoOverTwo : Float
routeTwoOverTwo = 2 ^ (1/2) / 2

largeRightTriangle : Shape
largeRightTriangle =
    polygon [(0, 0), (routeTwoOverTwo * tangramUnit, 0), (routeTwoOverTwo * tangramUnit, routeTwoOverTwo * tangramUnit)]

mediumRightTriangle : Shape
mediumRightTriangle =
    polygon [(0, 0), (tangramUnit, 0), (tangramUnit, tangramUnit)]
