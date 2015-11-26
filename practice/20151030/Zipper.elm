module Zipper where

import Graphics.Collage exposing (collage, toForm)
import Graphics.Element exposing (show, flow, down, width, spacer)
import List exposing (map)

{-| After having solved 'updating' a node in a tree for a tree component my own
way, I wanted to see if there was a more standard approach to performing this
type of operation.

First I looked at the [Elm Discuss Google Group](https://groups.google.com/forum/#!searchin/elm-discuss/zipper/elm-discuss/-jtZG0kJ0VU/J4JN_0ZPBAAJ)
, which led me to [Zippers](http://learnyouahaskell.com/zippers).

What follows is playing with that post to prove to myself that the ideas there
work.
-}

{-| Note that this is a binary tree. It has a polymorphic type a. It can be
either empty, or a Node with a 'left' and 'right' Tree.
-}
type Tree a
    = Empty
    | Node a (Tree a) (Tree a)


{-| Here is what freeTree represents
        P
     /      \
    O        L
   /  \     / \
   L   Y   W   A
  / \ / \ / \ / \
  N T S A C R A C

Suppose we want to take freeTree and change the 'W' to a 'P', how would we do
that?
-}

freeTree : Tree Char
freeTree =
    Node 'P'
        (Node 'O'
            (Node 'L'
                (Node 'N' Empty Empty)
                (Node 'T' Empty Empty)
            )
            (Node 'Y'
                (Node 'S' Empty Empty)
                (Node 'A' Empty Empty)
            )
        )
        (Node 'L'
            (Node 'W'
                (Node 'C' Empty Empty)
                (Node 'R' Empty Empty)
            )
            (Node 'A'
                (Node 'A' Empty Empty)
                (Node 'C' Empty Empty)
            )
        )

{-| Here pattern matching is used to follow a path from the root into the tree.
The path will start at the root, go to the right, and then to the left. It will
the change the value there to 'P'
-}
changeToPVersion1 : Tree Char -> Tree Char
changeToPVersion1 (Node x left (Node y (Node _ m n) right)) = Node x left (Node y (Node 'P' m n) right)

{-| After showing this way to do it, a cleaner way of specifying the path is
presented using Directions.
-}

type Direction
    = L --Left
    | R --Right

type alias Directions = List Direction

{-| In order to get the Directions based version of changeToP to work, I had to
translate the multiple definition version into single definition that uses the
[case](http://elm-lang.org/docs/syntax) way of describing a conditional.

The last difference is that [pattern matching on lists](http://stackoverflow.com/questions/27137132/pattern-matching-on-a-list-with-at-least-two-elements-in-elm) can be done without the square brackets.
-}
{-| The key here is that we use the Direction list to drill down into the tree,
and when we have no more directions, we will then update the node that is
targeted.
-}
changeToP : Directions -> Tree Char -> Tree Char
changeToP dirs (Node x l r) =
    case dirs of
        L::ds -> Node x (changeToP ds l) r
        R::ds -> Node x l (changeToP ds r)
        [] -> Node 'P' l r

{-| Similarly to changeToP, elemAt can be translated.
-}
{-| Using the Direction list, we again drill into the tree and only care about
the value when the list of directions is empty.
-}
elemAt : Directions -> Tree a -> a
elemAt dirs (Node x l r) =
    case dirs of
        L::ds -> elemAt ds l
        R::ds -> elemAt ds r
        [] -> x

{-| For changeToP and elemAt, the Directions serve as a *focus*
-}

createSpacer : Graphics.Element.Element
createSpacer = spacer 400 50

main : Graphics.Element.Element
main = collage 500 500
    (map toForm [(flow down
        [ show freeTree -- Our base case
            |> width 400
        , createSpacer
        , changeToPVersion1 freeTree -- Pattern Matching version
            |> show
            |> width 400
        , createSpacer
        , changeToP [R, L] freeTree -- Direction Based version
            |> elemAt [R, L]
            |> show
            |> width 400
        ])])
