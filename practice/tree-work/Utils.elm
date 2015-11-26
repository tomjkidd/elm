module Utils where

import List

{-| Zips two lists up into a tuple
-}
zip2 : List a -> List b -> List (a, b)
zip2 = List.map2 (,)

{-| Zips a list up into a tuple in the form (element, index) where:
element is the original list item and
index is the 0-based index of the item
-}
indexedZip : List a -> List (a, Int)
indexedZip list =
    let top = (List.length list) - 1
        indices = [0..top]
    in
        zip2 list indices
