import StartApp
import Task
import Effects

import TextForwarder

app =
  StartApp.start
    { init = TextForwarder.init "Starting Text"
    , update = TextForwarder.update
    , view = TextForwarder.view
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks
