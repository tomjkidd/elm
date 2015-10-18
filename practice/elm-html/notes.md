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
