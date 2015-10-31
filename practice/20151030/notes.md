 #How to create a component
 0. Create a Module
 0.5 Import elm lib code
 0.51 Import custom code
 1. Create a Model
 2. Create a set of Actions
 3. Create an update function, form similar to Action -> Model -> Model
 4. Create a view function, form similar to Model -> Html


 #How to wire together components
 1. Create a Module to serve as the collection of components, this is also a component.
 2. Create an Action for each component to isolate that component's actions to a known action in this aggregate component.
 3. Create an update function that uses each of the previous step's actions to wire the changes up to reach the component.
  * Use each component's update functions to do this work
  * This is also where you would connect actions from one component to another if they need to communicate with each other.
 4. Create a view function that renders each component in the order that they are desired.
  * Again, use each component's view functions to do this work.
  * Use Signal.forwardTo to map components to each of the Actions created in 2.
