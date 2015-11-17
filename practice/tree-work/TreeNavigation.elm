module TreeNavigation where

import Graphics.Element exposing (show)
import List

import MultiwayTree exposing (Tree (..))
import MultiwayTreeData exposing (initTree)

{-| goToChild allows index based navigation to a child of the current tree
-}
goToChild : Int -> Maybe (Tree a) -> Maybe (Tree a)
goToChild n tree =
    case tree of
        Just (Tree datum children) ->
            List.drop n children
                |> List.head
        Nothing -> Nothing

followIndices : List Int -> Maybe (Tree a) -> Maybe (Tree a)
followIndices is tree =
    case is of
        [] -> tree
        x::xs ->
            let newTree = goToChild x tree
            in
                followIndices xs newTree


{-| Here are some examples of how to navigate the sample data tree
-}
nodeC =
    Just initTree
        |> goToChild 1

nodeF =
    Just initTree
        |> goToChild 1
        |> goToChild 0

nodeK =
    Just initTree
        |> goToChild 0
        |> goToChild 0
        |> goToChild 0

nodeNotReal =
    Just initTree
        |> goToChild 3

main =
    show
        [ nodeC
        , nodeF
        , nodeK
        , nodeNotReal
        , followIndices [0, 0, 0] (Just initTree)
        ]

{- | Limitations:
The way that this is structured, we can move to a given node, assuming we know
the path to take to get to the node.
-}
