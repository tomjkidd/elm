module UiTree where

import Html exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..))
import MultiwayTreeZipper exposing (..)
import MultiwayTreeTransform
import MultiwayTreeData exposing (..)

import StartApp.Simple as StartApp

-- This is useful for shorthand
(&>) : Maybe a -> (a -> Maybe b) -> Maybe b
(&>) = Maybe.andThen

type alias Config  =
    { nodeTemplate : Tree String -> Html
    }

type alias Model = Tree

type alias Location = Int
type alias Path = List Location

type Action
    = Select Path
    | Expand Path


type alias UiNode a =
    { datum : a
    , selected : Bool
    , expanded : Bool
    }

datum2UiDatum : a -> UiNode a
datum2UiDatum datum =
        { datum = datum
        , selected = False
        , expanded = True
        }

uiDatum2Datum : UiNode a -> a
uiDatum2Datum uiDatum =
    uiDatum.datum

{-| Transforms the model tree into a tree that the UI can use for nav/update
-}
zipperLocationTree : Tree a -> Tree (UiNode a, Path)
zipperLocationTree tree =
    tree
        |> MultiwayTree.map datum2UiDatum
        |> MultiwayTreeTransform.transformModel

initializeUiTree : Tree a -> Tree (UiNode a, Path)
initializeUiTree = zipperLocationTree

testModel : Tree (UiNode String)
testModel = MultiwayTree.map datum2UiDatum initTree

testModel2 : Tree (UiNode String, Path)
testModel2 = zipperLocationTree initTree

initialModel : Tree (UiNode String, Path)
initialModel = initializeUiTree initTree

testUpdate : Tree (UiNode String, Path)
testUpdate =
    update (Select [0]) initialModel

zipAlongPath : Path -> Tree a -> Maybe (Zipper a)
zipAlongPath path tree =
    let zipper = (tree, [])
    in navigateZipper path zipper

navigateZipper : Path -> Zipper a -> Maybe (Zipper a)
navigateZipper path zipper =
    case path of
        p::ps ->
            (Just zipper)
                &> goToChild p
                &> navigateZipper ps
        [] -> Just zipper

{- NOTES
1. Handle single/multiselect
    For my current thoughts, multiselect is used
    If single select, I will have to visit all other node to clear their selected field (Use map as a functor!)
-}

updateSelected : (UiNode a, Path) -> (UiNode a, Path)
updateSelected (n, path) = ( { n | selected = (not n.selected) }, path )

updateExpanded : (UiNode a, Path) -> (UiNode a, Path)
updateExpanded (n, path) = ( { n | expanded = (not n.expanded) }, path )


updateTreeHelper : (a -> a) -> Tree a -> Path -> Tree a
updateTreeHelper updateFn model path =
    let zipPath = List.reverse path
        focus = zipAlongPath zipPath model
        newModel =
            focus
                &> updateDatum updateFn
                &> goToRoot
                |> (Maybe.map fst)
    in
        case newModel of
            Nothing -> model
            Just m -> m

{-|
 Add ToggleSelected action
    Use Breadcrumbs with Zipper to navigate to the data, toggle selected
 Add ToggleExpand action
    Use Breadcrumbs with Zipper to navigate to the data, toggle expanded
-}
update : Action -> Tree (UiNode a, Path) -> Tree (UiNode a, Path)
update action model =
    case action of
        Select path ->
            updateTreeHelper updateSelected model path

        Expand path ->
            updateTreeHelper updateExpanded model path

{-|
 Take the model and turn it into a forest with zipper context
 Map the Forest to Html nodes
    Create click handler on expand/collapse to toggle expanded
    Create click handler on rest of node to toggle selected
-}
view : Address Action -> Tree (UiNode a, Path) -> Html
view address model =
    let zipperTree = model

    in
        div [ class "ui-tree" ] []

main : Signal Html
main = StartApp.start
    { model = initialModel
    , update = update
    , view = view
    }
