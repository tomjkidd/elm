import Graphics.Element exposing (show)
import Task exposing (Task, andThen, onError)
import TaskTutorial exposing (print, getCurrentTime)
import Time exposing (second, Time)
import Http
import Html exposing (Html)
import Markdown
import Json.Decode

-- A signal that updates to the current time every second
clock : Signal Time
clock =
  Time.every second


-- Turn the clock into a signal of tasks
printTasks : Signal (Task x ())
printTasks =
  Signal.map (printTimeWithMsg "printTasks Signal update") clock


-- Actually perform all those tasks
port runner : Signal (Task x ())
port runner =
  printTasks

{-
print : a -> Task x ()
getCurrentTime : Task x Time
Task.andThen : Task x a -> (a -> Task x b) -> Task x b

type alias Signal.Mailbox a =
    { address : Address a
    , signal : Signal a
    }

Signal.mailbox : a -> Mailbox a
Signal.send : Address a -> a -> Task x ()

Http.getString : String -> Task Http.Error String

-- First approach to error handling
Task.onError : Task x a -> (x -> Task y a) -> Task y a

-- Second approach to error handling
Task.toMaybe : Task x a -> Task y (Maybe a)
Task.toResult : Task x a -> Task y (Result x a)
-}

printTimeWithMsg : String -> (Time -> Task x ())
printTimeWithMsg msg =
    \t -> print { msg = msg, time = (round t) // 1000 }

port runner2 : Task x ()
port runner2 =
    getCurrentTime `andThen` (printTimeWithMsg "getCurrentTime called")

contentMailbox : Signal.Mailbox String
contentMailbox =
    Signal.mailbox ""

port updateContent : Task x ()
port updateContent =
    Signal.send contentMailbox.address "hello!"

readme : Signal.Mailbox String
readme =
    Signal.mailbox ""

report : String -> Task x ()
report markdown =
    Signal.send readme.address markdown

port fetchReadme : Task Http.Error ()
port fetchReadme =
    Http.getString readmeUrl `andThen` report

readmeUrl : String
readmeUrl =
    "https://raw.githubusercontent.com/elm-lang/core/master/README.md"

getDuration : Task x Time
getDuration =
    getCurrentTime
        `andThen` \start -> Task.succeed (fibonacci 20)
        `andThen` \fib -> getCurrentTime
        `andThen` \end -> Task.succeed (end - start)

fibonacci : Int -> Int
fibonacci n =
    if n <= 2 then
        1
    else
        fibonacci (n-1) + fibonacci (n-2)

port fibRunner : Task x ()
port fibRunner =
    getDuration `andThen` print

githubReposUrl : String
githubReposUrl =
    "https://api.github.com/users/tomjkidd/repos"

listOfStringUrl : String
listOfStringUrl =
    "/task-tutorial/list-of-strings.json"

get : Task Http.Error (List String)
get =
    Http.get (Json.Decode.list Json.Decode.string) listOfStringUrl

safeGet : Task x (List String)
safeGet =
    get `onError` (\err -> Task.succeed [])

port restRunner : Task x ()
port restRunner =
    safeGet
      `andThen` \strs -> Task.succeed (List.map (\str -> "data: " ++ str) strs)
      `andThen` \mapped -> print mapped

main =
  --show "Open your browser's Developer Console."
  --Signal.map show contentMailbox.signal
  Signal.map Markdown.toHtml readme.signal
