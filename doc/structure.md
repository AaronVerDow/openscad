# Structure of OpenSCAD

OpenSCAD, as of 2011, relies heavily on two other projects: the OpenCSG library and the CGAL geometry library. OpenCSG uses special tricks of OpenGL graphics cards to quickly produce 2-d 'previews' of Computational Solid Geometry operations. This is the normal 'F5' mode. CGAL on the other hand is a Geometry library that actually calculates intersections & unions of objects, allowing for .stl export to 3d printers. This is the 'F6' mode.

In theory, though, the backend libraries could be replaced. OpenSCAD is a text-based CAD program. It doesn't matter what 'backend' is used for it's geometry as long as it works properly and provides useful functions. Discussions on the mailing list have mentioned the possibility of the OpenCASCADE library instead of CGAL, for example.

## OpenCSG

[OpenCSG](http://www.opencsg.org) is based largely around special algorithms that can 'fake' the presentation of Computational Solid Geometry operations (subtraction, intersection, union) on a 2d screen. The two main algorithms it uses are SCS and Goldfeather, selectable in OpenSCAD from the 'preferences' menu. The algorithms work by breaking down CSG operations into parts, and then rendering the parts into an OpenGL graphics buffer using special features such as an off-screen OpenGL Framebuffer Object (or Pbuffers), as well as making extensive use of the OpenGL Stencil Buffer and Depth Buffer.

OpenCSG also requires that the objects be 'normalized'.  For example, if your code says to start with a cube,  subtract a sphere, add a diamond, add a cylinder, add two more spheres, and subtract a donut, this is not 'normalized'. Normalization forms the primitive objects into a 'tree' where each 'leaf' consists of a 'positive' and 'negative' object. OpenSCAD does this normalization itself, as can be seen in the log window during OpenCSG previews. The Normalized CSG tree is then passed to OpenCSG for rendering. Occasionally the normalization process "blows up" and freezes the machine, making CGAL rendering the only way to view an object. The number of objects during normalization is limited and can be changed in OpenSCAD preferences.

OpenCSG has it's own example source code that comes with the program. It can help you to learn about the various OpenCSG rendering options.

Links:

* [OpenCSG main website](http://www.opencsg.org)
* [Freenix 2005 slideshow](http://www.opencsg.org/data/csg_freenix2005_talk.pdf) on OpenCSG, Goldfeather, and Normalization
* [Freenix 2005 paper](http://www.opencsg.org/data/csg_freenix2005_paper.pdf), more detail on Goldfeather, Normalization, etc.

## CGAL

CGAL is the Computational Geometry Algorithm Library. It contains a large collection of Geometry algorithms and methods by which objects can be represented. It calculates the actual 'point sets' of 3d objects, which enables the output of 3d formats like STL.

OpenSCAD uses two main features of CGAL - the Nef Polyhedra and the 'ordinary' Polyhedra. It also uses various other functions like Triangulation &c. But the main data structures are the Nef and the 'ordinary' Polyhedra.

### Nef Polyhedra

According to wikipedia's Nef Polyhedron article, Nef Polyhedrons are named after Walter Nef, who wrote a book on Polyhedrons named "Beiträge zur Theorie der Polyeder" published in 1978 by Herbert Lang, in Bern, Switzerland.  A rough explanation of the theory goes like this: imagine you can create a 'plane' that divides the universe in half. Now, imagine you can 'mark' one side to be the 'inside' and the other side to be the 'outside'. Now imagine you take several of these planes, and arrange them, for example, as if they were walls of a room, and a ceiling and a floor. Now lets just imagine the 'inside' of all of these planes - and now imagine that you do an 'intersection' operation on them - like a venn diagram or any other boolean operation on sets. This 'intersection' forms a cuboid - from the outside it just looks like a box. This box is the Nef Polyhedron. In other terms, you have created a polyhedron by doing boolean operations on "half spaces" - halves of the universe.

Why would you go to all this trouble? Why not just use plain old 'points in space' and triangle faces and be done with it? Well, Nef Polyhedrons have certain properties that make boolean operations on them work better than boolean operations between meshes—in theory.

CGAL's Nef Polyhedron code calculates the resulting 3 dimensional points of the new shapes generated when you perform CSG operations. Let's take example 4 from OpenSCAD's example programs. It is a cube with a sphere subtracted from it. The actual coordinates of the polygons that make up that 'cage' shape are calculated by CGAL by calculating the intersections and unions of the 'half spaces' involved. Then it is converted to an 'ordinary polyhedron'. This can then be transformed into .stl (stereolithography) files for output to a 3d-printing system.

### Ordinary Polyhedra

CGAL's Nef Polyhedron is not the only type of Polyhedron representation inside of CGAL. There is also the more basic "CGAL Polyhedron_3", which here is called 'ordinary' Polyhedra. In fact, many of OpenSCAD's routines convert a CGAL Nef Polyhedron into an 'ordinary' CGAL Polyhedron_3. The trick here is that 'ordinary' Polyhedron_3's have limits. Namely this: "the polyhedral surface is always an orientable and oriented 2-manifold with border edges". That means it deals only with "water tight" surfaces that don't have complicated issues like self-intersection, isolated lines and points, etc. A more exact explanation can be found here: http://www.carliner-remes.com/jacob/math/project/math.htm

The conversion between Nef Polyhedra and 'plain' Polyhedron_3 can sometimes result in problems when using OpenSCAD.

### Issues

In theory CGAL is seamless and consistent. In actuality, there are some documentation flaws, bugs, etc. OpenSCAD tries to wrap calls to CGAL with exception-catchers so the program doesn't crash every time the user tries to compile something.

Another interesting note is comparing the 2d and 3d polyhedra and nef polyhedra functions. There is no way to transform() a 2d nef polyhedron, for example, so OpenSCAD implemented it's own. There is no easy way to convert a Nef polyhedron from 2d to 3d. The method for 'iterating through' the 2d data structure is also entirely different from the way you iterate through the 3d data structure - one uses an 'explorer' while another provides a bunch of circulators and iterators.

CGAL is also slow to compile - as a library that is almost entirely headers, there is no good way 'around' this other than to get a faster machine with more RAM, and possibly to use the clang compiler instead of GCC. Paralell building ( make -j ) can help but that doesn't speed up the compile of a single file you are working on if it uses a feature like CGAL Minkowski sums.

### CGAL and GMPQ

CGAL allows a user to pick a 'kernel' - the type of numbers to be used in the underlying data structures. Many 3d rendering engines just use floating-point numbers - but this can be a problem when doing geometry because of roundoff errors. CGAL offers other kernels and number types, for example the GMPQ number type, from the GNU GMP project. This is basically the set of Rational Numbers.

Rational Numbers (the ratio of two integers) are an advantage in Geometry because you can do a lot of things to them without any rounding error - including scaling. For example, take the number 1/3. You cannot represent that exactly in IEEE floating point on a PC. It comes out to 0.3333... going on to infinity. The same goes for numbers like 0.6 - there is actually no binary representation of the decimal number 0.6 in a finite number of binary digits.

The binary number system on a finite-bit machine is not 'closed' under division. You can divide one finite-digit binary floating point number by another and get a number thats not, itself, a finite-digit binary floating point number. Like, 6, divided by 10, yielding 0.6. In fact this is not just a problem of binary numbers, it's a problem of any number system that uses a decimal point and has a finite number of digits - from the Ten-based system (decimals) to Hexadecimal to Binary to anything. But with Rationals this doesn't happen. You can divide any rational number by any other rational and you wind up with another Rational - and it is not infinite and there is no rounding involved. So 'scaling' down a 3d object made of Rational Points results in 0 rounding error. 'scaling' down a 3d object of floating point numbers frequently result in rounding error.

Another nice feature of rationals is that if you have two lines whose end-points (or rise/run, or line equation) are rational numbers, their intersection point is also a rational number with no rounding error. Finite Floating Point numbers cannot guarantee that (because of the division involved in solving the line equations). Note that this is helpful for a program like CGAL that is dealing with lots of intersections between planes. Imagine doing an 'interesection' between two faceted spheres offset by their radius, for example.

The downside is that Rationals are slow. Most of the optimization made in the hardware of modern computer CPUs is based around the idea of dealing with ordinary floating-point or integer numbers, not with ratios of integers - integers that can be larger than the size of 'long int' on the machine (also called Big Ints).

When doing debugging, if you are inside the code and you do something like 'std::cout << vertex->point().x()" you get a ratio of two integers, not a floating point. For floating conversion, you have to use CGAL::to_double( vertex->point().x() ); You may notice, sometimes, that your 'double' conversion, with its chopping off and rounding, might show that two points are equal, when printing the underlying GMPQ shows that, in fact, the same two points have different coordinates entirely.

Lastly, within OpenSCAD, it must be noted that it's default number type is typically C++ 'double' (floating point). Thus, even though you may have 'perfect' CGAL objects represented with rationals, OpenSCAD itself uses a lot of floating point, and translates the floating point back-and-forth to CGAL GMPQ during compilation (another area for slowdown).

Links:

* [CGAL's main website](http://www.cgal.org)
* [Number representation in CGAL](http://www.cgal.org/Manual/latest/doc_html/cgal_manual/NumberTypeSupport/Chapter_main.html)
* [CGAL 3d Boolean operations on Nef Polyhedra](http://www.cgal.org/Manual/latest/doc_html/cgal_manual/Nef_3/Chapter_main.html) (Notice any familiar colors?)
* [Ordinary CGAL Polyhedron 3](http://www.cgal.org/Manual/latest/doc_html/cgal_manual/Polyhedron_ref/Class_Polyhedron_3.html)
* [Nef polyhedron](http://en.wikipedia.org/wiki/Nef_polygon), wikipedia

## Throwntogether

The "Throwntogether" renderer is a "fall back" quick-preview renderer that OpenSCAD can use if OpenCSG is not available. It should work on even the most minimal of OpenGL systems. It's main drawback is that it renders negative spaces as big, opaque, green blocks instead of as 'cut outs' of the positive spaces. This can hide a lot of the internal detail of a shape and make use of OpenSCAD more difficult. The 'intersection' command, for example, does not do anything - it simply displays the full intersection shapes as if they were a union. However, by hitting 'F6' the user can still compile the object into CGAL and see the shape as it is intended.

Under what circumstances does the program fall back to Throwntogether, instead of using OpenCSG preview? In cases where the OpenGL machine does not support Stencil Buffers, and cannot draw Offscreen images with "Framebuffer Objects" (FBOs). If the user finds that OpenCSG support is buggy on their system, they can also manually switch to 'throwntogether' mode through the menus.

# Source Code Notes

## Ifdefs

The design of the code is so that, in theory, CGAL and/or OpenCSG can be disabled or enabled. In practice this doesn't always work and tweaking is needed. But if some day the underlying engines were to be replaced, this feature of the code would greatly aid such a transition.

## Value

The Value class is OpenSCAD's way of representing numbers, strings, boolean variables, vectors, &c. OpenSCAD uses this to bridge-the-gap between the .scad source code and the guts of it's various engines. value.h and value.cc use the boost 'variant' feature (sort of like C unions, but nicer).

## node

The most important pieces derive from the AbstractNode class. Various conventions and patterns are the same between different nodes, so when implementing new features or fixing bugs, it can be helpful to simply look at the way things are done by comparing nodes. For example transformnode.h and transform.cc show the basic setup of how something like 'scale()' goes from source code (in a 'context') into a member variable of the transformnode (node.matrix), which is then used by CGALEvaluator.cc to actually do a 'transform' on the 3d object data. This can be compared with colornode, lineartextrudenode, etc.

## Polyset

PolySet is a sort of 'inbetween' glue-class that represents 3d objects in various stages of processing. All primitives are first created as a PolySet and then transformed later, if necessary, into CGAL forms. OpenSCAD currently converts all import() into a PolySet, before converting to CGAL Nef polyhedra, or CGAL 'ordinary' polyhedra.

## DXF stuff

As of early 2013, OpenSCAD's 2d subsystem relies heavily on DXF format, an old format used in Autocad and created by Autodesk in the 1980s. DXFData is sort of the equivalent of PolySet for 2d objects - glue between various other 2d representations.

## CGAL Nef Polyhedron

This class 'encapsulates' both 2d and 3d Nef polyhedrons. It contains useful functions like the boolean operators, union, intersection, and even Minkowski sum. It is incredibly slow to compile, mostly due to the CGAL minkowski header code being large, so it has been broken into separate .cc files. You may also note that pointers are generally avoided when dealing with Nef polyhedra - instead boost::shared_ptr is used.

## CGAL ordinary polyhedron

You may notice there is no class for 'ordinary' CGAL Polyhedron. That's correct. There isn't. it's always just used 'as is', typically as an intermediate form between other formats. As noted, the conversion to/from 'ordinary' can cause issues for 'non 2-manifold' objects. CGAL's Polyhedron also is used for file export (see export.cc).

## GUI vs tests

As of early 2013 OpenSCAD used two separate build systems. one for the GUI binary, and another for regression testing. The first is based on Qmake and the second on Cmake. Adding features may require someone to work with both of these systems. See doc/testing.txt for more info on building and running the regression tests.

# Library notes

## QT

OpenSCAD's GUI uses the QT toolkit. However, for all non-gui code, the developers avoid QT and use alternatives like boost::filesystem. This helps with certain things like modularity and portability. As of mid 2013 it was possible to build the test suites entirely without QT.

## Other libraries & library versions

OpenSCAD also depends on Boost, the Eigen math library, and the GLEW OpenGL extension helper library. In order to actually build OpenSCAD, and compile and run the self-diagnostic tests, OpenSCAD also needs tools like 'git', 'cmake', and ImageMagick. Version numbers can be important. They are listed in a readme file in the root of the OpenSCAD source code. Using libraries that are too old can result in an OpenSCAD that exhibits bizarre behavior or crashes.
