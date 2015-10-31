module MainComponent1 where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (..)

import TextForwarder

type alias Model =
    { textForwarder : TextForwarder.Model
    , receiver : TextForwarder.Model
    }

init : (Model, Effects Action)
init =
    ( Model (TextForwarder.Model "Abe") (TextForwarder.Model "Betty"), Effects.none )

type Action
    = ForwarderChange TextForwarder.Action
    | ReceiverChange TextForwarder.Action
    | Reset

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Reset ->
            init
        ForwarderChange act ->
            case act of
                TextForwarder.UpdateMessage msg ->
                    let (f, ffx) = TextForwarder.update act model.textForwarder
                    in
                        ( { model | textForwarder <- f }, Effects.none )
                TextForwarder.ForwardMessage msg ->
                    let (r, rfx) = TextForwarder.update (TextForwarder.UpdateMessage msg) model.receiver
                    in
                        ( { model | receiver <- r }, Effects.none )

        ReceiverChange act ->
            case act of
                TextForwarder.UpdateMessage msg ->
                    let (r, ffx) = TextForwarder.update act model.receiver
                    in
                        ( { model | receiver <- r }, Effects.none )
                TextForwarder.ForwardMessage msg ->
                    let (f, rfx) = TextForwarder.update (TextForwarder.UpdateMessage msg) model.textForwarder
                    in
                        ( { model | textForwarder <- f }, Effects.none )

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ TextForwarder.view (Signal.forwardTo address ForwarderChange) model.textForwarder,
          TextForwarder.view (Signal.forwardTo address ReceiverChange) model.receiver,
          button [ onClick address Reset ] [ text "Reset" ]
        ]
