module SimpleComponent where

import Html exposing (Html, Attribute, text, toElement, div, input)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Signal exposing (Address)
import StartApp
import String
import Effects exposing (..)

type alias Model = String

type Action =
    Update String


initialModel : Model
initialModel = ""


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Update str -> (str, Effects.none)


view : Address Action -> Model -> Html
view address string =
  div []
    [ input
        [ placeholder "Text to reverse"
        , value string
        , on "input" targetValue (\str -> Signal.message address (Update str))
        , myStyle
        ]
        []
    , div [ myStyle ] [ text (String.reverse string) ]
    ]


myStyle : Attribute
myStyle =
  style
    [ ("width", "100%")
    , ("height", "40px")
    , ("padding", "10px 0")
    , ("font-size", "2em")
    , ("text-align", "center")
    ]

app : StartApp.App String
app =
  StartApp.start
    { init = (initialModel, Effects.none)
    , view = view
    , update = update
    , inputs = [ fromJSAction ]
    }

port fromElm : Signal String
port fromElm = app.model

port toElm : Signal String

fromJSAction : Signal Action
fromJSAction = Signal.map (\str -> Update str) toElm

main : Signal Html
main = app.html
