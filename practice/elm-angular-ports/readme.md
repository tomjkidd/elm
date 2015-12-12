### Motivation
I wanted to see how to embed an Elm Component into an angular app as a directive.

This sample creates a binding to a text input, and uses it a couple of times in
a single controller to demonstrate that each is independent, and that angular
can be hooked up to see the changes.

### Setup Commands
    elm-package install elm-lang/core
    elm-package install evancz/elm-html
    elm-package install evancz/start-app

    elm-make --warn ./elm/SimpleComponent.elm --output ./compiled-elm/SimpleComponent.js

### Extending information
[On Multiple Components](https://groups.google.com/forum/#!searchin/elm-discuss/Elm.embed/elm-discuss/qzsMf8TlifE/CJn5GidDYkUJ)
