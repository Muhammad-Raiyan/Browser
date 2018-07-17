# Browser

## Zeromq

The contents of this folder should be placed inside of a new folder in *godot/modules/*. And SCsub file has to be modified to include the correct library paths.

## BrowserGUI

After building Godot.exe, this should be imported as a project.

## BrowserNetwork

When the BrowserGUI is running, this node js program needs to be started. It's the networking backend.

## Requirements

Godot Source: https://github.com/godotengine/godot

SCons: https://www.scons.org/

CPPZMQ: https://github.com/zeromq/cppzmq.git