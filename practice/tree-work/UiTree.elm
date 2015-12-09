module UiTree where

import Html exposing (..)
--import Html.Attributes exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..))
--import MultiwayTreeZipper exposing (..)
--import MultiwayTreeTransform
import MultiwayTreeData exposing (..)

import UiTree.Model exposing (..)
import UiTree.Update exposing (..)
import UiTree.View exposing (..)

type alias ZipTree a = Tree (UiNode a, Path)

type alias ElmPieces a =
    { model: ZipTree a
    , update: Action a -> ZipTree a -> ZipTree a
    , view: Address (Action a) -> ZipTree a -> Html
    }

defaultOptions : UiTreeOptions a
defaultOptions =
    { multiSelect = False
    , nodeHtmlGenerator = UiTree.View.defaultNodeGenerator
    }

initializeUiTree : Tree a -> Tree (UiNode a, Path)
initializeUiTree =  UiTree.Update.zipperLocationTree

initialModel : Tree (UiNode String, Path)
initialModel = initializeUiTree initTree

elmConfig : ElmPieces String
elmConfig =
    { model = initialModel
    , update = UiTree.Update.update
    , view = UiTree.View.viewFromOptions defaultOptions
    }

-- TODO: getUiTreeComponents : Tree a -> UiTreeOptions a -> ElmPieces a
