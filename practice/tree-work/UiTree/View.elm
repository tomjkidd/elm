module UiTree.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..), datum, children)
import MultiwayTreeZipper exposing (..)
import MultiwayTreeTransform
import MultiwayTreeData exposing (..)

import UiTree.Model exposing (..)

getChildExpandStyle : Tree (UiNode a, Path) -> Address (Action a) -> Attribute
getChildExpandStyle (Tree (tree, path) children) address =
    let
        displayValue =
            case tree.expanded of
                True -> "block"
                False -> "none"
    in style [ ("display", displayValue)
             , ("list-style-type", "none")
             ]

-- http://stackoverflow.com/questions/5899337/proper-way-to-make-html-nested-list
forestToHtml : List (Tree (UiNode a, Path)) -> Signal.Address (Action a)-> List Html
forestToHtml forest address =
  (List.map (\tree -> treeToHtml tree address) forest)

treeToHtml : Tree (UiNode a, Path)-> Signal.Address (Action a) -> Html
treeToHtml tree address =
  let
    childExpandStyle = getChildExpandStyle tree address
    treeNode = defaultNodeGenerator tree address
    treeChildren =
      if not (List.length (children tree) == 0)
        then [ ul [ childExpandStyle ] (forestToHtml (children tree) address) ]
        else []

    listChildren =
        treeNode :: treeChildren
    childStyle = [ class "child-style" ] ++ [ childExpandStyle ]

  in
    li [ class "node-class"
       , style [("list-style-type", "none")]
       ] listChildren

{-hasChildren : Tree (UiNode a, Path) -> Bool
hasChildren tree =
    List.length (children tree) > 0-}

oneOrMore : List a -> Bool
oneOrMore cs = List.length cs > 0

defaultNodeGenerator : Tree (UiNode a, Path) -> Address (Action a) -> Html
defaultNodeGenerator (Tree (tree, path) children) address =
    let expanderAttrs =
        [ classList
            [ ("fa", True)
            , ("fa-caret-right", not tree.expanded && oneOrMore children)
            , ("fa-caret-down", tree.expanded && oneOrMore children)
            ]
        , onClick address (UiTree.Model.Expand (tree, path))
        , style
            [ ("cursor", "pointer")
            , ("min-width", "15px")
            , ("min-height", "15px")
            , ("padding", "3px")
            ]
        ]
        displayValue =
            case tree.expanded of
                True -> "block"
                False -> "none"
    in
        --div (DynamicStyle.hover [ ("background-color", "transparent", "lightgrey") ])
        div []
            [ i expanderAttrs []
            , span [ style
                [ ("padding-left", "5px")
                , ("cursor", "default")
                ]
              ] [text (toString tree.datum)]
            , div [
                style
                    [ ("display", displayValue) ]
              ]
              []
            ]

--type alias NodeGenerator a = (Address Action -> Tree (UiNode a, Path) -> Html)

--pluggableView : NodeGenerator a -> Tree (UiNode a, Path) -> Html
pluggableView fn =
    \address model -> fn address model

forestToHtmlWithOptions : UiTreeOptions a -> List (Tree (UiNode a, Path)) -> Signal.Address (Action a)-> List Html
forestToHtmlWithOptions options forest address =
  (List.map (\tree -> treeToHtmlWithOptions options tree address) forest)

treeToHtmlWithOptions : UiTreeOptions a -> Tree (UiNode a, Path)-> Signal.Address (Action a) -> Html
treeToHtmlWithOptions options tree address =
  let
    childExpandStyle = getChildExpandStyle tree address
    treeNode = options.nodeHtmlGenerator tree address
    treeChildren =
      if not (List.length (children tree) == 0)
        then [ ul [ childExpandStyle ] (forestToHtmlWithOptions options (children tree) address) ]
        else []

    listChildren =
        treeNode :: treeChildren
    childStyle = [ class "child-style" ] ++ [ childExpandStyle ]

  in
    li [ class "node-class"
       , style [("list-style-type", "none")]
       ] listChildren

viewFromOptions : UiTreeOptions a -> Address (Action a) -> Tree (UiNode a, Path) -> Html
viewFromOptions options =
    (\address model ->
        let zipperTree = model

        in
            div
                [ class "ui-tree" ]
                [ (treeToHtmlWithOptions options zipperTree address) ]
    )

view: Address (Action a) -> Tree (UiNode a, Path) -> Html
view address model =
    let zipperTree = model

    in
        div
            [ class "ui-tree" ]
            [ (treeToHtml zipperTree address) ]
        {-div
            [ class "ui-tree" ]
            [ text "test" ]-}
