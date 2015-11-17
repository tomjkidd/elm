module MultiwayTreeData where

import MultiwayTree exposing (Tree (..))

initTree : Tree String
initTree =
    Tree "a"
        [ Tree "b"
            [ Tree "e"
                [ Tree "k" [] ]
            ]
        , Tree "c"
            [ Tree "f" []
            , Tree "g" []
            ]
        , Tree "d"
            [ Tree "h" []
            , Tree "i" []
            , Tree "j" []
            ]
        ]
