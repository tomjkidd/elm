Main0
=====
```cmd
    elm-make Main0.elm
```
By running this command, a very simple program should go into elm-boilerplate.html, a single component, <code>TextForwarder</code>, is used to provide StartApp with init, update, and view.

<code>TextForwarder</code> is pretty simple.

* It's model only contains a String *message*.

* It has two actions, *UpdateMessage* and *ForwardMessage*. UpdateMessage is used to respond to input, while ForwardMessage is used to take the current input and allow it to be forwarded to another place.

* It's view function has an html input, a button, and a text node to display what the current value is.

Main1
=====
```cmd
    elm-make Main1.elm
```

After creating the TextForwarder component, I wanted to make it so that I could actually communicate from one instance to another.

I wanted to keep *Main1.elm* simple, so I created *MainComponent1.elm* to assemble two TextFormatters, and then wire them up so that they can change each other's values.
