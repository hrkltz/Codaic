# Codaic / Getting Started

Codaic is built on **Lua 5.4.7** and provides a node-based, low-code environment for writing programs.

> Note: Codaic is not intended for developing full-featured apps or programs that behave like traditional standalone applications.

## What Is a "Node"?

Each node runs in its own thread and has its own Lua runtime. Nodes can receive and forward messages to other nodes via links. Currently, Codaic supports only string-based (text) data exchange between nodes. However, with the built-in cjson extension, it’s straightforward to send and receive structured data.

## How Should I Start?

In addition to exploring the [API](API.md), you can start by selecting one of the provided templates when creating a new project. These templates offer practical examples of what’s possible with Codaic and demonstrate how to approach more complex tasks.
