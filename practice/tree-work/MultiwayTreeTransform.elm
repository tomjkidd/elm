module MultiwayTreeTransform where

import Utils exposing (..)
import MultiwayTree exposing (..)
import MultiwayTreeData exposing (..)
import MultiwayTreeZipper exposing (goToChild, goToRoot, Zipper)

-- TODO: This function has a lot of potential for learning with respect to being more general!
{-| Create a structure that allows a function to be applied with a list accumulator
-}
mapAccum fn (Tree datum children) accum =
    let
        indexedChildren = indexedZip children
        mappedChildren = List.map
            (\(child, index) ->
                mapAccum fn child (index :: accum))
            indexedChildren
    in
        fn datum mappedChildren accum

{-| A tree in this style will have the leaf-to-root path into the tree as the
value in accum. This type of structure can be used to allow Actions from the UI
to traverse to the node in order to update it through a Zipper.
-}
transformModel model = mapAccum
    (\datum children accum ->
        Tree (datum, accum) children
    )
    model
    []

transformedTree = transformModel initTree

test = (transformedTree, []) |> goToChild 0
