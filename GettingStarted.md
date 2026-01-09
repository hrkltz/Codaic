# Codaic / Getting Started

Codaic is built on **Lua 5.4.7** and provides a node-based, low-code environment for writing programs.

> Note: Codaic is not intended for developing full-featured apps or programs that behave like traditional standalone applications.

## How To use Codaic?

After creating a project you will see a workspace area called "stage". You can interact with it as follows:

- touch-&-drag on a node to move it
- touch-&-drag on the empty area to move the view
- touch-&-drag on an output port (bottom ones) to draw a new link, lift on an input port to connect the nodes
- double-touch on an empty area to add a new node
- double-touch on a node to edit the source code
- long-touch on a node to delete it

## What Is a "Node"?

Each node runs in its own thread and has its own Lua runtime. Nodes can receive and forward messages to other nodes via links. Currently, Codaic supports only string-based (text) data exchange between nodes. However, with the built-in cjson extension, it’s straightforward to send and receive structured data.

## How Should I Start?

In addition to exploring the [API](API.md) and [Tips And Tricks](TipsAndTricks.md) sections, you can start by selecting one of the provided templates when creating a new project. These templates offer practical examples of what’s possible with Codaic and demonstrate how to approach more complex tasks.

