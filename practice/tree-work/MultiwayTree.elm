module MultiwayTree
    ( Tree (..), Forest
    , datum, children
    )
    where

{-| Tree is a multi-way tree,
where the constructor takes datum and a list of children which are also trees
-}
type Tree a = Tree a (Forest a)

type alias Forest a = List (Tree a)

datum : Tree a -> a
datum (Tree datum children) = datum

children : Tree a -> Forest a
children (Tree datum children) = children
