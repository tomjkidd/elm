module SearchInput where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Task exposing (..)

import Effects exposing (..)
import ServiceCore exposing (..)
import Services exposing (..)

type alias Model a =
    { query: String
    , results: List a
    , service: String -> Task Http.Error (List a)
    }

init : String -> List a -> (String -> Task Http.Error (List a)) -> (Model a, Effects (Action a))
init query results service =
    ( Model query results service
    , Effects.none)


type Action a = GetResults
    | GetResultsImmediate String
    | ResultsLoaded (Maybe (List a))
    | UpdateQuery String


update : Action a -> Model a -> (Model a, Effects (Action a))
update action model =
    case action of

        UpdateQuery newQuery -> ( { model | query <- newQuery }, Effects.none)

        GetResults ->
            ( model
            , taskToEffect (model.service model.query)
                 (\maybeResults -> ResultsLoaded maybeResults)
            )

        GetResultsImmediate newQuery ->
            ( { model | query <- newQuery }
            , taskToEffect (model.service newQuery)
                 (\maybeResults -> ResultsLoaded maybeResults)
            )
            
        ResultsLoaded maybeResults ->
            ( { model | results <- (Maybe.withDefault [] maybeResults) }, Effects.none)


view : Signal.Address (Action a) -> Model a -> Html
view address model =
    div []
        [ input
             [ placeholder "query value"
             , value model.query
             , on "input" targetValue (\str -> Signal.message address (UpdateQuery str))
             ]
             []
        , button [ onClick address GetResults ] [ text "Get Results" ]
        , div [] [ text (toString model.results) ]
        ]

onInputView : Signal.Address (Action a) -> Model a -> Html
onInputView address model =
    div []
        [ input
             [ placeholder "query value"
             , value model.query
             , on "input" targetValue (\str -> Signal.message address (GetResultsImmediate str))
             ]
             []
        , button [ onClick address GetResults ] [ text "Get Results" ]
        , div [] [ text (toString model.results) ]
        ]
