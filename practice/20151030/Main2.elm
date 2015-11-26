-- The goal here is just to get Font Awesome working in isolation
import StartApp
import Task
import Effects
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import DynamicStyle

type alias Model =
    { text : String
    , expanded: Bool
    }

init = (Model "This is a basis for expand/collapse functionality..." False, Effects.none)

type Action = NoOp | ToggleExpand

update action model =
    case action of
        NoOp -> ( model , Effects.none )
        ToggleExpand -> ( { model | expanded <- not model.expanded }, Effects.none )

{- Help from the internet
http://stackoverflow.com/questions/29030951/how-do-you-add-a-hover-effect-on-elm-without-using-signals

http://stackoverflow.com/questions/18836989/why-does-background-colornone-not-override-a-specified-background-color

-}
view address model =
    let expanderAttrs =
        [ classList
            [ ("fa", True)
            , ("fa-caret-right", not model.expanded)
            , ("fa-caret-down", model.expanded)
            ]
        , onClick address ToggleExpand
        , style
            [ ("cursor", "pointer")
            , ("min-width", "15px")
            , ("min-height", "15px")
            , ("padding", "3px")
            ]
        ]
    in
        div (DynamicStyle.hover [ ("background-color", "transparent", "lightgrey") ])
            [ i expanderAttrs []
            , span [ style
                [ ("padding-left", "5px")
                , ("cursor", "default")
                ]
              ] [text model.text]
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

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks
