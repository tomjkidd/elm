module UiTree.Model where

import MultiwayTree exposing (Tree (..))
import MultiwayTreeZipper exposing (..)
import MultiwayTreeTransform
import MultiwayTreeData exposing (..)

type alias Model = Tree

type alias Location = Int
type alias Path = List Location

type Action a
    = Select Path
    | Expand (UiNode a, Path)


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
