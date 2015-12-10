module Main where

import Html exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..))
import MultiwayTreeData exposing (..)
import UiTree.Model exposing (UiNode, Path)
import UiTree exposing (..)

import StartApp.Simple as StartApp

{-initializeUiTree : Tree a -> Tree (UiNode a, Path)
initializeUiTree = zipperLocationTree

testModel : Tree (UiNode String)
testModel = MultiwayTree.map datum2UiDatum initTree

testModel2 : Tree (UiNode String, Path)
testModel2 = zipperLocationTree initTree

initialModel : Tree (UiNode String, Path)
initialModel = initializeUiTree initTree

testUpdate : Tree (UiNode String, Path)
testUpdate =
    update (Select [0]) initialModel-}


initialModel : Tree (UiNode String, Path)
initialModel = UiTree.initializeUiTree initTree

elmConfig : ElmPieces String
elmConfig =
    { model = initialModel
    , update = UiTree.update
    , view = UiTree.defaultView
    }

main : Signal Html
main = StartApp.start elmConfig
