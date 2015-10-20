Boilerplate for app

```elm
    app =
        StartApp.start
            { init = initialModel
            , update = update
            , view = view
            , inputs = []
            }

    main =
        app.html

    port tasks : Signal (Task.Task Never ())
    port tasks =
        app.tasks
```
