module UiTree where

import Html exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..))

import UiTree.Model exposing (..)
import UiTree.Update exposing (..)
import UiTree.View exposing (..)

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

update : Action a -> ZipTree a -> ZipTree a
update = UiTree.Update.update

defaultView : Address (Action a) -> ZipTree a -> Html
defaultView = UiTree.View.viewFromOptions defaultOptions
