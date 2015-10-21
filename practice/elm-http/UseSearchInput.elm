import StartApp
import Html exposing (..)
import Effects exposing (..)
import Task exposing (..)

import SearchInput
import Services exposing (..)


type alias Model =
    { top : SearchInput.Model String
    , bottom : SearchInput.Model String
    }

init =
    let
        (top, topFx) = SearchInput.init "top query" [] Services.lookupZipCode
        (bot, botFx) = SearchInput.init "bot query" [] Services.lookupZipCode
    in
        (Model top bot
        , Effects.batch
            [ Effects.map Top topFx
            , Effects.map Bottom botFx
            ]
        )

type Action
    = Top (SearchInput.Action String)
    | Bottom (SearchInput.Action String)

update action model =
    case action of
        Top act ->
            let
                (top, fx) = SearchInput.update act model.top
            in
                ( Model top model.bottom
                , Effects.map Top fx
                )
        Bottom act ->
            let
                (bot, fx) = SearchInput.update act model.bottom
            in
                ( Model model.top bot
                , Effects.map Bottom fx
                )
view address model =
    div
        []
        [ SearchInput.view (Signal.forwardTo address Top) model.top
        , SearchInput.view (Signal.forwardTo address Bottom) model.bottom
        ]

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
