module MultiwayTreeZipper where
-- TODO: Add specific exports
-- TODO: Add documentation

import MultiwayTree exposing (Tree (..), Forest, children)

import List
import Graphics.Element exposing (show)
import Maybe exposing (Maybe (..))

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
splitOnIndex : Int -> List (Tree a) -> Maybe (List (Tree a), Tree a, List (Tree a))
splitOnIndex n xs =
    let before = List.take n xs
        focus = List.drop n xs |> List.head
        after = List.drop (n + 1) xs
    in
        case focus of
            Nothing -> Nothing
            Just f -> Just (before, f, after)

goUp : Zipper a -> Maybe (Zipper a)
goUp (tree, breadcrumbs) =
    case breadcrumbs of
        (Context datum before after) :: bs ->
            Just (Tree datum (before ++ [tree] ++ after), bs)
        [] -> Nothing

goToChild : Int -> Zipper a -> Maybe (Zipper a)
goToChild n (Tree datum children, breadcrumbs) =
    let maybeSplit = splitOnIndex n children
    in
        case maybeSplit of
            Nothing -> Nothing
            Just (before, focus, after) ->
                Just (focus, (Context datum before after) :: breadcrumbs )

goToRoot : Zipper a -> Maybe (Zipper a)
goToRoot (tree, breadcrumbs) =
    case breadcrumbs of
        [] -> Just (tree, breadcrumbs)
        otherwise -> goUp (tree, breadcrumbs) `Maybe.andThen` goToRoot

updateDatum : (a -> a) -> Zipper a -> Maybe (Zipper a)
updateDatum fn (Tree datum children, breadcrumbs) =
    Just (Tree (fn datum) children, breadcrumbs)

replaceDatum : a -> Zipper a -> Maybe (Zipper a)
replaceDatum newDatum =
    updateDatum (\_ -> newDatum)

updateChildren : Forest a -> Zipper a -> Zipper a
updateChildren newChildren (Tree datum children, breadcrumbs) =
    (Tree datum newChildren, breadcrumbs)

datum : Zipper a -> a
datum (tree, breadcrumbs) =
    MultiwayTree.datum tree

maybeDatum : Zipper a -> Maybe a
maybeDatum zipper =
    datum zipper
        |> Just
