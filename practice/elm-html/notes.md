Build Commands
==============
    elm-package install evancz/start-app
    elm-package install evancz/elm-html
    elm-make HtmlBasics.elm --output=HtmlBasics.html


For investigation
-----------------
* I tried to use a recursive definition initially for nodeToHtml, which gave me
some compiler errors, suggesting that I break it down further. I was able to get
the end result I wanted, but this was still a little mystifying.

* I want to create a more general node for a tree, and want to hang on to the following code

      type Node2 a =
        Node2
        { datum : a
        , class : String
        , children : List Node2 a
        , selected : Bool
        , expanded : Bool
        }

      type alias IntPayloadNode = Node2 Int

This would allow me to only create the payload and push a tree into a ui tree that would allow me to make a tree component.

Start App Analysis
------------------
I wanted to better understand the type signature view of how StartApp does it's work, with less of an emphasis on the implementation, but just analyzing how the type signatures can inform the high level operation of the Elm Architecture.

A natural place to start this investigation is the start function.

    StartApp.start : Config model action -> App model

The start function takes a Config record and returns an App record, which are defined in the following ways:


    type alias Config model action =
        { init : (model, Effects action)
        , update : action -> model -> (model, Effects action)
        , view : Signal.Address action -> model -> Html
        , inputs : List (Signal.Signal action)
        }
...

    type alias App model =
        { html : Signal Html
        , model : Signal model
        , tasks : Signal (Task.Task Never ())
        }

###Config

The Config argument to **start** defines a record that passes in two different types, **model** and **action**.
* Models I have used represent the application state as a record.

* Actions I have used represent the types of events that your application knows how to respond to.

Because model and action are types that the writer provides, you can define your own types, and use them with the Elm Architecture.

Each of the fields in the Config record contribute to the flow of interaction.

* **init** provides an intial state
* **update** provides a way for an action to update the state to a new state
* **view** provides a way for a model to render to html


    init : (model, Effects action)

**init** is a tuple of the model, and [Effects](http://package.elm-lang.org/packages/evancz/elm-effects/2.0.0/) based on action

    view : Signal.Address action -> model -> Html
