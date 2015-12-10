#Overview/Motivation
This project is meant to explain how to use a zipper to work with tree data in
Elm. The need became clear when trying to create a Tree component for use with
the Elm Architecture. In order to update a model of the tree for node
selection/expansion was the key motivation.

#Prior Work
https://www.st.cs.uni-saarland.de/edu/seminare/2005/advanced-fp/docs/huet-zipper.pdf
http://learnyouahaskell.com/zippers


#Details
I wanted to evolve the problem in a set of Questions and Answers to progress
from the basics to how to use the ideas to do useful work.

###Q: How is a multiway tree represented?
The tree needs to carry (at least) two pieces of information to do it's job:

1. The datum that the node is meant to represent.
2. A list of children, which are themselves each ```Trees```.

The MultiwayTree.elm file defines a Tree type that has a single
constructor that takes this information.

    type Tree a = Tree a (List (Tree a))

Note that the type ```a``` here means that each node can have a payload of any
type, as long as each ```Tree``` has datum of the same type.

The MultiwayTreeData.elm file defines ```initTree```, which is a simple tree
of Strings. It provides enough nodes to allow a concrete example to work with
for this exploration.

###Q: How do we move around the tree?
To move through the tree, you start at the top and recursively traverse through
children of other nodes in the tree to move deeper.

The TreeNavigation.elm file defines a ```goToChild``` function with the following type
signature:

    goToChild : Int -> Maybe (Tree a) -> Maybe (Tree a)

By providing an index and the parent, this function will try to navigate to the
parent's child.

By repeatedly using this, you are able to traverse down the tree to locate any
node, but this implies that you know the indices that lead to a desired node.

The ```followIndices``` function allows you to specify the path all together in
order to simplify a deeper traversal.

###Q: How do you move back up the tree?
Navigating down through children is nice for locating a node and value, but the
goal is to create a functional 'update' mechanism to change the state of any
given node.

The big idea here is that when the user clicks a node, I want to update the tree
to toggle the value that keeps track of whether the node is expanded or not.

In an imperative language, a node could be found and then updated directly, but a functional approach requires creating and returning a 'new' version of the tree. In order to accomplish this, the tree must have an efficient way of isolating the desired piece, and allowing it to be replaced while maintaining the rest of the original structure.

To support this, I need a way to find the node I'm after, and to replace it with
a copy of a node with a different state, and to return the rest of the tree
unchanged.

## Still In Progress
* Currently only supports a tree, but a forest is a common desired use case.
* Need to fill out Select requirements
* Is there a better story for custom node templates?
