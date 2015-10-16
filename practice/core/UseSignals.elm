import Graphics.Element exposing (..)
import Keyboard
import Set
import Char

{- Signals have a type of Signal a, where is a is another type.
The following example uses the Element type.
The [element type](http://package.elm-lang.org/packages/elm-lang/core/2.1.0/Graphics-Element#Element) is used to make widgets and layouts. They have known width and height.

-}
spaceSignal : Signal Element
spaceSignal =
  Signal.map show Keyboard.space

 {-
Signal.map : (a -> result) -> Signal a -> Signal result
show : a -> Element
Keyboard.space : Signal bool

map's first argument is a function that takes type a to type result
map's second argument is a Signal of type a
map returns a Signal of type result

show in this case has type bool -> Element, so map for this instance is:
(bool -> element) -> Signal bool -> Signal Element
 -}


keysDownSignal : Signal Element
keysDownSignal =
    Signal.map show (Signal.map Set.toList Keyboard.keysDown)
{-
Set.toList : Set comparable -> List comparable
keysDown : Signal (Set KeyCode)

(Signal.map Set.toList Keyboard.keysDown) : (Set KeyCode -> List KeyCode) -> Signal Set KeyCode -> Signal List KeyCode

In order to show the Chars for each KeyCode, a List.map must be done to take the Signal List KeyCode to a Signal List Char.

TODO: Is there a simpler way to express this?
-}

keysDownCharSignal : Signal Element
keysDownCharSignal =
    Signal.map show
        (Signal.map (\x -> List.map Char.fromCode x) (Signal.map Set.toList Keyboard.keysDown))

main =
    keysDownSignal
