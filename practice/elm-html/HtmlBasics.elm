import StartApp.Simple exposing (start)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List


-- MODEL

type alias SelectOption = { label: String, value: String }

type Node =
  Node
    { datum : String
    , children : List Node
    }

defaultNode =
  Node
    { datum = "Level 1"
    , children =
      [ Node
          { datum = "Level 2"
          , children = []
          }
      ]
    }

defaultTree : List Node
defaultTree =
  [ Node
    { datum = "Group 1"
    , children =
      [ Node
          { datum = "Object 1"
          , children = []
          }
        , Node
          { datum = "Object 2"
          , children = []
          }
        , Node
          { datum = "Object 3"
          , children = []
          }
      ]
    }
  , Node
    { datum = "Group 2"
    , children =
      [ Node
          { datum = "Object 1"
          , children =
            [ Node
                { datum = "SubObject 1"
                , children = []
                }
            ]
          }
        , Node
          { datum = "Object 2"
          , children = []
          }
        , Node
          { datum = "Object 3"
          , children = []
          }
      ]
    }
  ]

-- http://stackoverflow.com/questions/5899337/proper-way-to-make-html-nested-list
childrenToHtml : List Node -> List Html
childrenToHtml nodes =
  (List.map (\node -> nodeToHtml node) nodes)

nodeToHtml : Node -> Html
nodeToHtml (Node node) =
  let
    nodeChildren =
      if not (List.length node.children == 0)
        then [ ul [] (childrenToHtml node.children) ]
        else []
  in
    li [ class node.datum ] nodeChildren

forestToHtml : List Node -> Html
forestToHtml nodes =
 ul [] (List.map (\tree -> nodeToHtml tree) nodes)


{-nodeToHtml : Node a -> Html
nodeToHtml (Node node) =
  ul [] (List.map (\child -> nodeToHtml child) node.children)
-}

type alias Model =
  { x: Int
  , h: String
  , t: String
  , isChecked: Bool
  , selected: Maybe SelectOption
  , selectOptions: List SelectOption
  }


-- UPDATE

type Action = Increment | Decrement | Double
  | HeadUpdate String | TailUpdate String | HeadTailSwap
  | IsCheckedUpdate Bool
  | Reset | Clear
  | SelectedOptionUpdate String

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
    Clear -> { model | x <- 0, h <- "", t <- "", isChecked <- False, selected <- Nothing }
    SelectedOptionUpdate val -> { model | selected <- findSelectOption val model.selectOptions }


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
      , div
          []
          [ div [] [ text "Select with default first option as default" ]
          , createSelect
              selectOptions
              model.selected
              [on "change" targetValue (\val -> Signal.message address (SelectedOptionUpdate val))]
              []
          ]
      , div
          []
          [ div [] [ text "Select with empty option default" ]
          , createSelectWithEmptyDefault
              selectOptions
              model.selected
              [on "change" targetValue (\val -> Signal.message address (SelectedOptionUpdate val))]
              []
          ]
      , ul [] [ nodeToHtml defaultNode ]
      , forestToHtml defaultTree
      ]
    ]

modelDisplayStyle : Attribute
modelDisplayStyle =
  style
    [ ("font-size", "12px")
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

defaultSelectOption : SelectOption
defaultSelectOption = { label = "First", value = "1" }

selectOptions : List SelectOption
selectOptions =
  [ { label = "First", value = "1" }
  , { label = "Second", value = "2" }
  , { label = "Third", value = "3" }
  ]

initialModel : Model
initialModel =
  { x = 0
  , h = "Head"
  , t = "Tail"
  , isChecked = True
  , selected = Just defaultSelectOption
  , selectOptions = selectOptions
  }

findSelectOption : String -> List SelectOption -> Maybe SelectOption
findSelectOption needle haystack =
  List.head <| List.filter (\opt -> needle == opt.value) haystack

createOption : SelectOption -> List Attribute -> Html
createOption opt optionAttrs =
  option
    (value opt.value :: optionAttrs)
    [ text opt.label ]

createOptionHelper opt optionAttrs default =
  let
    isSelected =
      case default of
        Nothing -> False
        Just dft -> dft.value == opt.value
    newOptionAttrs = (selected isSelected) :: optionAttrs
  in
    createOption opt newOptionAttrs

createSelect : List SelectOption -> Maybe SelectOption -> List Attribute -> List Attribute -> Html
createSelect options default selectAttrs optionAttrs =
  select
    selectAttrs
    (List.map (\opt -> createOptionHelper opt optionAttrs default) options)

createSelectWithEmptyDefault : List SelectOption -> Maybe SelectOption -> List Attribute -> List Attribute -> Html
createSelectWithEmptyDefault options default selectAttrs optionAttrs =
  let
    optionsListHtml = (List.map (\opt -> createOptionHelper opt optionAttrs default) options)
    newOptions =
     case default of
       Nothing -> (createOption { label = "-- pick a value --", value = "" } [ selected True, disabled True ]) :: optionsListHtml
       Just dft -> optionsListHtml
  in
    select
      selectAttrs
      newOptions

main =
  StartApp.Simple.start
    { model = initialModel
    , update = update
    , view = view
    }
