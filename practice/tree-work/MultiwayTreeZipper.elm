module MultiwayTreeZipper where

import MultiwayTree exposing (Tree (..), Forest, datum, children)
import MultiwayTreeData exposing (..)
import List
import Graphics.Element exposing (show)

{-| The Context allows us to keep all of the information needed to reconstruct
the MultiwayTree as it is navigated with a Zipper -}
type Context a = Context
    a -- datum from the node we came from
    (List (Tree a)) -- children that come before me
--    (Tree a) -- me, not used because it would be redundant (and the compiler doesn't like it due to recursion)
    (List (Tree a)) --children that come after me

{-| As the tree is navigated, the needed Context is pushed onto the list of
Breadcrumbs -}
type alias Breadcrumbs a = List (Context a)

{-| The Zipper provides a structure to keep track of the current Tree, as well
as the Breadcrumbs to allow us to continue navigation through the rest of the
tree.
-}
type alias Zipper a = (Tree a, Breadcrumbs a)

{-| This function is unique to MultiwayTree needs. In order to navigate to
children of any Tree, a way to break the children into pieces is needed.

The pieces are:
* before: The list of children that come before the desired child
* focus: The desired child Tree
* after: The list of children that come after the desired child

These pieces help create a Context, which assist the Zipper
-}
splitOnIndex : Tree a -> Int -> List (Tree a) -> (List (Tree a), Tree a, List (Tree a))
splitOnIndex default n xs =
    let before = List.take n xs
        focus = List.drop n xs |> \xs ->
            case List.head xs of
                Nothing -> default
                Just tree -> tree
        after = List.drop (n + 1) xs
    in (before, focus, after)

goToChildWithDefault : Tree a -> (Int -> Zipper a -> Zipper a)
--goToChild : goToChild : Int -> Maybe (Tree a) -> Maybe (Tree a)
goToChildWithDefault default = \n (Tree datum children, breadcrumbs) ->
    let (before, focus, after) = splitOnIndex default n children
    in
        (focus, (Context datum before after) :: breadcrumbs )

goUp : Zipper a -> Zipper a
goUp (tree, breadcrumbs) =
    case breadcrumbs of
        (Context datum before after) :: bs ->
        (Tree datum (before ++ [tree] ++ after), bs)

updateDatum : a -> Zipper a -> Zipper a
updateDatum newDatum (Tree datum children, breadcrumbs) =
    (Tree newDatum children, breadcrumbs)

updateChildren : Forest a -> Zipper a -> Zipper a
updateChildren newChildren (Tree datum children, breadcrumbs) =
    (Tree datum newChildren, breadcrumbs)

goToRoot : Zipper a -> Zipper a
goToRoot (tree, breadcrumbs) =
    case breadcrumbs of
        [] -> (tree, breadcrumbs)
        otherwise -> goUp (tree, breadcrumbs) |> goToRoot

{-| Note that this function is specific to the (Tree String) type, and really
 does nothing to help in the case where you navigate beyond the children that
 exist.

I'll probably want to handle or produce errors (using Result lib) in the future,
 but for now I will assume careful use of the function.
-}
goToChild : Int -> Zipper String -> Zipper String
goToChild = goToChildWithDefault (Tree "ERROR!" [])

{-| Expose the sample Tree data and functions for use in the REPL -}
tData = initTree
datumFn = datum
childrenFn = children

{-main =
    (initTree, [])
        |> goToChild 1
        |> goToChild 0
        |> show-}

{-goUp : Breadcrumbs a -> (Tree a) -> Maybe (Tree a)
goUp breadcrumbs tree =
    case breadcrumbs of
        [] -> Nothing
        Context datum before after :: bs ->
            Just (Tree datum (before ++ [] ++ after))-}
