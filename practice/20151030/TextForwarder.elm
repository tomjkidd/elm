module TextForwarder where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Effects exposing (..)

type alias Model =
    { message: String
    }

init : String -> (Model, Effects Action)
init initialInput =
    ( Model initialInput
    , Effects.none)

type Action = UpdateMessage String
    | ForwardMessage String

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateMessage msg -> ( { model | message <- msg }, Effects.none )
        ForwardMessage msg -> ( model, Effects.none )

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ input
             [ placeholder "Type in a message!"
             , value model.message
             , on "input" targetValue (\msg -> Signal.message address (UpdateMessage msg))
             ]
             []
        , button [ onClick address (ForwardMessage model.message) ] [ text "Forward" ]
        , div [] [ text model.message ]
        ]
