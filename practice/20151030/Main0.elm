-- The goal here is just to get the component working in isolation.
import StartApp
import Task
import Effects

import TextForwarder

app =
  StartApp.start
    { init = TextForwarder.init "This is a test"
    , update = TextForwarder.update
    , view = TextForwarder.view
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks
