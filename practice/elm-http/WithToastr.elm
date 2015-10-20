module WithToastr where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Task exposing (..)

import StartApp
import Effects exposing (..)

import ServiceCore exposing (..)
import Services exposing (..)
import ToastrService exposing (..)

{-
Mailbox API
-----------
mailbox : a -> Mailbox a
message : Address a -> a -> Message
forwardTo : Address b -> (a -> b) -> Address a
send: Address a -> a -> Task x ()
-}

{-
To actually perform a task, hand it to a port
-}

testMailbox : Signal.Mailbox (List String)
testMailbox =
    Signal.mailbox []
{-
port lookup : Signal (Task Http.Error (List String))
port lookup =
-}
type alias Model = { query: String, results: List String }

initialModel =
    (Model "" ["A", "B", "C"]
    , Effects.none)

type Action = GetZipcodes
    | ZipcodesLoaded (Maybe (List String))
    | UpdateQuery String
    | ShowToast String



view address model =
    div []
        [ input
             [ placeholder "query value"
             , value model.query
             , on "input" targetValue (\str -> Signal.message address (UpdateQuery str))
             ]
             []
        , button [ onClick address GetZipcodes ] [ text "Get Zipcodes" ]
        , button [ onClick toastMailbox.address (Error model.query) ] [ text "Send Error Toast" ]
        , button [ onClick toastMailbox.address (Success model.query) ] [ text "Send Success Toast" ]
        , button [ onClick toastMailbox.address (Info model.query) ] [ text "Send Info Toast" ]
        , div [] [ text (toString model.results) ]
        ]

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateQuery newQuery -> ( { model | query <- newQuery }, Effects.none)
        GetZipcodes ->
            ( model
            , taskToEffect (Services.lookupZipCode model.query)
                 (\maybeResults -> ZipcodesLoaded maybeResults)
                {-}|> Task.toMaybe
                |> Task.map (\maybeResult -> ZipcodesLoaded maybeResult)
                |> Effects.task-}
            )
        ZipcodesLoaded maybeResults ->
            ( { model | results <- (Maybe.withDefault [] maybeResults) }, Effects.none)

app =
    StartApp.start
        { init = initialModel
        , update = update
        , view = view
        , inputs = []
        }

main =
    app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

{- Note: Ports can only be defined on main, found that out trying to do this in the ToastrService -}
port showToast : Signal ToastrMessage
port showToast =
    messageHandler
