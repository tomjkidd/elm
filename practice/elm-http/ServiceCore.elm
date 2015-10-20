module ServiceCore where

import Http exposing (..)
import Task exposing (..)
import Effects exposing (..)

taskToEffect : Task Http.Error a -> (Maybe a -> b) -> Effects b
taskToEffect task maybeToResult =
    task
        |> Task.toMaybe
        |> Task.map maybeToResult
        |> Effects.task
