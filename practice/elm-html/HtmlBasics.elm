import StartApp
import StartApp.Simple exposing (start)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model =
  { x: Int
  , h: String
  , t: String
  , isChecked: Bool
  }


-- UPDATE

type Action = Increment | Decrement | Double
  | HeadUpdate String | TailUpdate String | HeadTailSwap
  | IsCheckedUpdate Bool
  | Reset | Clear

update : Action -> Model -> Model
update action model =
  case action of
    Increment -> { model | x <- model.x + 1 }
    Decrement -> { model | x <- model.x - 1 }
    Double -> { model | x <- model.x * 2 }
    HeadUpdate newH -> { model | h <- newH }
    TailUpdate newT -> { model | t <- newT }
    HeadTailSwap -> { model | h <- model.t, t <- model.h }
    IsCheckedUpdate newIsChecked -> { model | isChecked <- newIsChecked }
    Reset -> initialModel
    Clear -> { model | x <- 0, h <- "", t <- "", isChecked <- False }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [ modelDisplayStyle ] [ text (toString model) ]
    , div []
      [ button [ onClick address Decrement ] [ text "-" ]
      , button [ onClick address Increment ] [ text "+" ]
      , button [ onClick address Double ] [ text "Double" ]
      , input
         [ placeholder "Head value"
         , value model.h
         , on "input" targetValue (\str -> Signal.message address (HeadUpdate str))
         , inputStyle
         ]
        []
      , input
         [ placeholder "Tail value"
         , value model.t
         , on "input" targetValue (\str -> Signal.message address (TailUpdate str))
         , inputStyle
         ]
        []
      , button [ onClick address HeadTailSwap ] [ text "Swap" ]
      , input
        [ type' "checkbox"
        , checked model.isChecked
        , on "change" targetChecked (\bool -> Signal.message address (IsCheckedUpdate bool))
        , inputStyle
        ]
        []
      , button [ onClick address Reset ] [ text "Reset" ]
      , button [ onClick address Clear ] [ text "Clear" ]
      ]
    ]

modelDisplayStyle : Attribute
modelDisplayStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("text-align", "center")
    ]

inputStyle : Attribute
inputStyle =
  style
    [ ("width", "100%")
    , ("height", "40px")
    , ("padding", "10px 0")
    , ("font-size", "2em")
    , ("text-align", "center")
    ]

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]

initialModel : Model
initialModel = { x = 0, h = "Head", t = "Tail", isChecked = True }

main =
  StartApp.Simple.start
    { model = initialModel
    , update = update
    , view = view
    }
