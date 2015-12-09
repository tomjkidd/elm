module UiTree.Update where

import MultiwayTree exposing (Tree (..))
import MultiwayTreeZipper exposing (..)
import MultiwayTreeTransform
import MultiwayTreeData exposing (..)

import UiTree.Model exposing (..)

import Debug

-- This is useful for shorthand
(&>) : Maybe a -> (a -> Maybe b) -> Maybe b
(&>) = Maybe.andThen

{-| Transforms the model tree into a tree that the UI can use for nav/update
-}
zipperLocationTree : Tree a -> Tree (UiNode a, Path)
zipperLocationTree tree =
    tree
        |> MultiwayTree.map datum2UiDatum
        |> MultiwayTreeTransform.transformModel


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
update : Action a -> Tree (UiNode a, Path) -> Tree (UiNode a, Path)
update action model =
    case action of
        Select path ->
            updateTreeHelper updateSelected model path

        Expand (tree, path) ->
            updateTreeHelper updateExpanded model path
