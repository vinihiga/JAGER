# JAGER
Just A Game Engine, Right?!

# Project Status

iOS 11.0 (or +):

![alt text](https://ci.appveyor.com/api/projects/status/32r7s2skrgm9ubva?svg=true)

# About the Project

This project is in early version (ALPHA) and has the idea to try to build a simple 2D Game Engine for iOS devices with following features:

* Support common images formats (like JPEG and PNG with Alpha).
* Render 2D Graphics with Metal Shaders.
* Support to realtime shadows.
* Support to tilemap system.
* Support to basic physics (collision detection for a variety of geometric objects).
* Support to pathfinding (A.I.)
* Support to basic audio system.
* Support to custom gestures.

# How to contribute

You can make a Pull Request and your code will be analyzed if it's possible to be added into a future version.

The requirements to your Pull Request be approved you need to follow these guidelines: [TO BE ADDED]


# How to build

On Mac OS Catalina (x64):

* You must have the lastest XCode installed for Mac OS.

* If you want to change the Engine Code, you must edit the subsystem you want (which is divided by folders).

* If you want to create the Game (itself) Code, you must create a new iOS Project and make the main ViewController extend from GameController.
