[![GitHub (master)](https://img.shields.io/github/checks-status/openscad/openscad/master.svg?logo=github&label=build&logoColor=black&colorA=f9d72c&style=plastic)](https://github.com/openscad/openscad/actions)
[![CircleCI (master)](https://img.shields.io/circleci/project/github/openscad/openscad/master.svg?logo=circleci&logoColor=black&colorA=f9d72c&style=plastic)](https://circleci.com/gh/openscad/openscad/tree/master)
[![Coverity Scan](https://img.shields.io/coverity/scan/2510.svg?colorA=f9d72c&logoColor=black&style=plastic)](https://scan.coverity.com/projects/2510)

[![Visit our IRC channel](https://kiwiirc.com/buttons/irc.libera.chat/openscad.png)](https://kiwiirc.com/client/irc.libera.chat/#openscad)

# What is OpenSCAD?
<p><a href="https://opencollective.com/openscad/donate"><img align="right" src="https://opencollective.com/openscad/donate/button@2x.png?color=white" width="200"/></a>

OpenSCAD is a software for creating solid 3D CAD objects. It is free software and
available for Linux/UNIX, MS Windows and macOS.</p>

Unlike most free software for creating 3D models (such as the famous
application Blender), OpenSCAD focuses on the CAD aspects rather than the 
artistic aspects of 3D modeling. Thus this might be the application you are
looking for when you are planning to create 3D models of machine parts but
probably not the tool for creating computer-animated movies.

OpenSCAD is not an interactive modeler. Instead it is more like a
3D-compiler that reads a script file that describes the object and renders
the 3D model from this script file (see examples below). This gives you, the
designer, complete control over the modeling process and enables you to easily
change any step in the modeling process or make designs that are defined by
configurable parameters.

OpenSCAD provides two main modeling techniques: First there is constructive
solid geometry (aka CSG) and second there is extrusion of 2D outlines. As the data
exchange format for these 2D outlines Autocad DXF files are used. In
addition to 2D paths for extrusion it is also possible to read design parameters
from DXF files. Besides DXF files OpenSCAD can read and create 3D models in the
STL and OFF file formats.

# Contents

- [Getting Started](#getting-started)
- [Documentation](#documentation)
    - [Building OpenSCAD](#building-openscad)
        - [Prerequisites](#prerequisites)
        - [Getting the source code](#getting-the-source-code)
        - [Building for macOS](#building-for-macos)
        - [Building for Linux/BSD](#building-for-linuxbsd)
        - [Building for Linux/BSD on systems with older or missing dependencies](#building-for-linuxbsd-on-systems-with-older-or-missing-dependencies)
        - [Building for Windows](#building-for-windows)
        - [Compilation](#compilation)

# Getting started

You can download the latest binaries of OpenSCAD at
<https://www.openscad.org/downloads.html>. Install binaries as you would any other
software.

When you open OpenSCAD, you'll see three frames within the window. The
left frame is where you'll write code to model 3D objects. The right
frame is where you'll see the 3D rendering of your model.

Let's make a tree! Type the following code into the left frame:

    cylinder(h = 30, r = 8);

Then render the 3D model by hitting F5. Now you can see a cylinder for
the trunk in our tree. Now let's add the bushy/leafy part of the tree
represented by a sphere. To do so, we will union a cylinder and a
sphere.

    union() {
      cylinder(h = 30, r = 8);
      sphere(20);
    }

But, it's not quite right! The bushy/leafy are around the base of the
tree. We need to move the sphere up the z-axis.

    union() {
      cylinder(h = 30, r = 8);
      translate([0, 0, 40]) sphere(20);
    }

And that's it! You made your first 3D model! There are other primitive
shapes that you can combine with other set operations (union,
intersection, difference) and transformations (rotate, scale,
translate) to make complex models! Check out all the other language
features in the [OpenSCAD
Manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual).

# Documentation

Have a look at the OpenSCAD Homepage (https://www.openscad.org/documentation.html) for documentation.
