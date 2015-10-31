-- The goal here is to get two components to communicate with eachother.
import StartApp
import Task
import Effects

import MainComponent1

app =
  StartApp.start
    { init = MainComponent1.init
    , update = MainComponent1.update
    , view = MainComponent1.view
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks
