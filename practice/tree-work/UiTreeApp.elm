module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (Address)

import MultiwayTree exposing (Tree (..))
import MultiwayTreeZipper exposing (..)
import MultiwayTreeTransform
import MultiwayTreeData exposing (..)

--import UiTree.Model exposing (..)
--import UiTree.Update exposing (..)
--import UiTree.View exposing (..)

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

main : Signal Html
main = StartApp.start
    { model = elmConfig.model
    , update = elmConfig.update
    , view = elmConfig.view
    }
