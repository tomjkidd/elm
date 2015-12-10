module UiTree.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..), datum, children)

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

{-| A function that provides an example node template that dumps the datum as a label.

Creating a function in this style allows a custom node to be used with the view,
with the `viewFromOptions` function.
-}
defaultNodeGenerator : Tree (UiNode a, Path) -> Address (Action a) -> Html
defaultNodeGenerator = fontAwesomeBaseNode defaultNodeHtml

{-| A function that creates a simple plain text representation of the datum.
-}
defaultNodeHtml : UiNode a -> Html
defaultNodeHtml tree = text (toString tree.datum)

{-| A function to provide a sane default node template. This can be used as a
guide for how to define a template that is custom.

Note that it is important to tie in the Actions you want to support, as well
as any styling or classes.

This function assumes that font awesome will be available in the html, and uses
it to provide the expand/collapse icons in the tree.

`nodeFn` allows you to pick which part of the datum to use as the label, if it
has a complex type.
-}
fontAwesomeBaseNode : (UiNode a -> Html) -> Tree (UiNode a, Path) -> Address (Action a) -> Html
fontAwesomeBaseNode nodeFn (Tree (tree, path) children) address =
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
        div []
            [ i expanderAttrs []
            , span [ style
                [ ("padding-left", "5px")
                , ("cursor", "default")
                ]
              ] [nodeFn tree]
            , div [
                style
                    [ ("display", displayValue) ]
              ]
              []
            ]

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
