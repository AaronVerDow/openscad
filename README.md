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

# Compiling

To build OpenSCAD from source, follow the instructions for the
platform applicable to you below.

## Prerequisites

To build OpenSCAD, you need some libraries and tools. The version
numbers in brackets specify the versions which have been used for
development. Other versions may or may not work as well.

If you're using a newer version of Ubuntu, you can install these 
libraries from aptitude. If you're using Mac, or an older Linux/BSD, there 
are build scripts that download and compile the libraries from source. 
Follow the instructions for the platform you're compiling on below.

* A C++ compiler supporting C++17
* [cmake (3.5 ->)](https://cmake.org/)
* [Qt (5.12 ->)](https://qt.io/)
* [QScintilla2 (2.9 ->)](https://riverbankcomputing.com/software/qscintilla/)
* [CGAL (5.4 ->)](https://www.cgal.org/)
 * [GMP (5.x)](https://gmplib.org/)
 * [MPFR (3.x)](https://www.mpfr.org/)
* [boost (1.61 ->)](https://www.boost.org/)
* [OpenCSG (1.4.2 ->)](http://www.opencsg.org/)
* [GLEW (1.5.4 ->)](http://glew.sourceforge.net/)
* [Eigen (3.x)](https://eigen.tuxfamily.org/)
* [glib2 (2.x)](https://developer.gnome.org/glib/)
* [fontconfig (2.10 -> )](https://fontconfig.org/)
* [freetype2 (2.4 -> )](https://freetype.org/)
* [harfbuzz (0.9.19 -> )](https://www.freedesktop.org/wiki/Software/HarfBuzz/)
* [libzip (0.10.1 -> )](https://libzip.org/)
* [Bison (2.4 -> )](https://www.gnu.org/software/bison/)
* [Flex (2.5.35 -> )](http://flex.sourceforge.net/)
* [pkg-config (0.26 -> )](https://www.freedesktop.org/wiki/Software/pkg-config/)
* [double-conversion (2.0.1 -> )](https://github.com/google/double-conversion/)

For the test suite, additional requirements are:
* Python3 (3.8 -> )
* [Ghostscript (10.x ->)](https://www.ghostscript.com/index.html)

## Getting the source code

Install git (https://git-scm.com/) onto your system. Then run a clone:

    git clone https://github.com/openscad/openscad.git

This will download the latest sources into a directory named `openscad`.

To pull the various submodules (incl. the [MCAD library](https://github.com/openscad/MCAD)), do the following:

    cd openscad
    git submodule update --init --recursive

## Building for macOS

Prerequisites:

* Xcode
* automake, libtool, cmake, pkg-config, wget, meson, python-packaging (we recommend installing these using Homebrew)

Install Dependencies:

After building dependencies using one of the following options, follow the instructions in the *Compilation* section.

1. **From source**

    Run the script that sets up the environment variables:

        source scripts/setenv-macos.sh

    Then run the script to compile all the dependencies:

        ./scripts/macosx-build-dependencies.sh

2. **Homebrew** (assumes [Homebrew](https://brew.sh/) is already installed)

        ./scripts/macosx-build-homebrew.sh

## Building for Linux/BSD

First, make sure that you have git installed (often packaged as 'git-core' 
or 'scmgit'). Once you've cloned this git repository, download and install 
the dependency packages listed above using your system's package 
manager. A convenience script is provided that can help with this 
process on some systems:

    sudo ./scripts/uni-get-dependencies.sh

After installing dependencies, check their versions. You can run this 
script to help you:

    ./scripts/check-dependencies.sh

Take care that you don't have old local copies anywhere (`/usr/local/`). 
If all dependencies are present and of a high enough version, skip ahead 
to the Compilation instructions. 

## Building for Linux/BSD on systems with older or missing dependencies

If some of your system dependency libraries are missing or old, then you 
can download and build newer versions into `$HOME/openscad_deps` by 
following this process. First, run the script that sets up the 
environment variables. 

    source ./scripts/setenv-unibuild.sh

Then run the script to compile all the prerequisite libraries above:

    ./scripts/uni-build-dependencies.sh

Note that huge dependencies like gcc, qt, or glib2 are not included 
here, only the smaller ones (boost, CGAL, opencsg, etc). After the 
build, again check dependencies.

    ./scripts/check-dependencies.sh

After that, follow the Compilation instructions below.

## Building on Nix

A [development Nix shell](scripts/nix) is included for local, incremental compilation.

## Building for Windows

OpenSCAD for Windows is usually cross-compiled from Linux. If you wish to
attempt an MSVC build on Windows, please see this site:
https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Building_on_Windows

To cross-build, first make sure that you have all necessary dependencies 
of the MXE project ( listed at https://mxe.cc/#requirements ). Don't install
MXE itself, the scripts below will do that for you under `$HOME/openscad_deps/mxe`

Then get your development tools installed to get GCC. Then after you've 
cloned this git repository, start a new clean bash shell and run the 
script that sets up the environment variables.

    source ./scripts/setenv-mingw-xbuild.sh 64

Then run the script to download & compile all the prerequisite libraries above:

    ./scripts/mingw-x-build-dependencies.sh 64

Note that this process can take several hours, and tens of gigabytes of 
disk space, as it uses the [https://mxe.cc](https://mxe.cc) system to cross-build many
libraries. After it is complete, build OpenSCAD and package it to an 
installer:

    ./scripts/release-common.sh mingw64

For a 32-bit Windows cross-build, replace 64 with 32 in the above instructions. 

## Building for WebAssembly

We support building OpenSCAD headless for WebAssembly w/ Emscripten, using a premade Docker image built in [openscad/openscad-wasm](https://github.com/openscad/openscad-wasm) (which also has usage examples)

### Browser

The following command creates `build-web/openscad.wasm` & `build-web/openscad.js`:

```bash
./scripts/wasm-base-docker-run.sh emcmake cmake -B build-web -DCMAKE_BUILD_TYPE=Debug -DEXPERIMENTAL=1
./scripts/wasm-base-docker-run.sh cmake --build build-web -j2
```

[openscad/openscad-playground](https://github.com/openscad/openscad-playground) uses this WASM build to provide a [Web UI](https://ochafik.com/openscad2/) with a subset of features of OpenSCAD.

> [!NOTE]
> With a debug build (`-DCMAKE_BUILD_TYPE=Debug`), you can set C++ breakpoints in Firefox and in Chrome (the latter [needs an extension](https://developer.chrome.com/docs/devtools/wasm)).

### Standalone node.js build

The following command creates `build-node/openscad.js`, which is executable (requires `node`):

```bash
./scripts/wasm-base-docker-run.sh emcmake cmake -B build-node -DWASM_BUILD_TYPE=node -DCMAKE_BUILD_TYPE=Debug -DEXPERIMENTAL=1
./scripts/wasm-base-docker-run.sh cmake --build build-node -j2
build-node/openscad.js --help
```

> [!NOTE]
> With a debug build (`-DCMAKE_BUILD_TYPE=Debug`), you can set C++ breakpoints in VSCode + Node ([needs an extension](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_debugging-webassembly)).

## Compilation

First, run `cmake -B build -DEXPERIMENTAL=1` to generate a Makefile in the `build` folder.

Then run `cmake --build build`. Finally, on Linux you might run `cmake --install build` as root.

If you had problems compiling from source, raise a new issue in the
[issue tracker on the github page](https://github.com/openscad/openscad/issues).

This site and it's subpages can also be helpful:
https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Building_OpenSCAD_from_Sources

Once built, you can run tests with `ctest` from the `build` directory.

Note: Both `cmake --build` and `ctest` accepts a `-j N` argument for distributing the load over `N` parallel processes.

# Testing

## Running containerized GitHub CI workflows locally

*   Install [circleci-cli](https://circleci.com/docs/2.0/local-cli/) (you'll need an API key)

    *Note*: we also use GitHub Workflows, but only to run tests on Windows (which we cross-build for in the Linux-based CircleCI workflows below). Also, [act](https://github.com/nektos/act) doesn't like our submodule setup anyway.

*   Run the CI jobs

	```bash
	# When "successful", these will fail to upload at the very end of the workflow.
	circleci local execute --job  openscad-mxe-64bit
	circleci local execute --job  openscad-mxe-32bit
	circleci local execute --job  openscad-appimage-64bit
	```

	*Note*: openscad-macos can't be built locally.

*   If/when GCC gets randomly killed, give docker more RAM (e.g. 4GB per concurrent image you plan to run)

*   To debug the jobs more interactively, you can go the manual route (inspect .circleci/config.yml to get the actual docker image you need)

	```bash
	docker run --entrypoint=/bin/bash -it openscad/mxe-x86_64-gui:latest
	```

	Then once you get the console:
	
	```bash
	git clone https://github.com/%your username%/openscad.git workspace
	cd workspace
	git checkout %your branch%
	git submodule init
	git submodule update

	# Then execute the commands from .circleci/config.yml:
	#    export NUMCPU=2
	#    ...
	#    ./scripts/release-common.sh -snapshot -mingw64 -v "$OPENSCAD_VERSION"
	```

## Running GitHub CI workflows locally

Add stuff

## Manually run tests

### Prerequisites

Install the prerequisite helper programs on your system:

* cmake
* python3
* python3-venv
* python3-pip

There are binary installer packages of these tools available for Mac,
Win, Linux, BSD, and other systems.

### Building Test environment

Test files will be automatically configured and built (but not ran) as part of the main openscad build.  See README.md for how to get a build of the main openscad binary working.

Windows builds are a special case, since they are cross-compiled from a linux system.  The automated build servers package up the tests alongside the binary if you download a .ZIP Development Snapshot from: http://openscad.org/downloads.html#snapshots

NOTE: **ONLY THE ZIP VERSION** of the download contains the tests. They would not run properly using an installer to place under "C:\Program Files" since that would require elevated privileges to write the test output files.

### Running tests

#### Linux, Mac:

From your build directory
```
$ ctest -j8           Runs tests enabled by default using 8 parallel processes.
$ ctest -R <regex>    Runs only matching tests, e.g. ctest -R dxf
$ ctest -C <configs>  Adds extended tests belonging to configs.
                      Valid configs:
                      Default  - Run default tests
                      Heavy    - Run more time consuming tests (> ~10 seconds)
                      Examples - test all examples
                      Bugs     - test known bugs (tests will fail)
                      All      - test everything
```

#### Win:

Unzip the OpenSCAD-Tests-YYYY.MM.DD file onto a Windows machine. There will be a script called OpenSCAD-Test-Console.py in the parent folder. Double-click it, and it will open a console, from which you can type the ctest commands listed above.

### Automatically upload test results (experimental)

It's possible to automatically upload tests results to an external server. This is good for CI, as well as being able to easily report bugs.

To enable this feature, add `-DOPENSCAD_UPLOAD_TESTS=1` to `cmake` 

### Adding a new test

* Create a test file at an appropriate location under `tests/data/`
* If the test is non-obvious, create a human readable description as comments in the test, or in another file in the same directory in case the file isn't human readable.
* If a new test app was written, this must be added to `tests/CMakeLists.txt`
* Rebuild the test environment.
* Run the test with the environment variable `TEST_GENERATE=1`, e.g.: `TEST_GENERATE=1 ctest -R mytest` (this will generate a `mytest-expected.txt` file which is used for regression testing.)
* Manually verify that the output is correct: `tests/regression/<testapp>/mytest-expected.<suffix>`
* Run the test normally and verify that it passes: `ctest -R mytest`

### Adding a new example

This is almost the same as adding a new regression test:
* Create the example under `examples/`
* Run the test with the environment variable `TEST_GENERATE=1`, e.g.: `$ TEST_GENERATE=1 ctest -C Examples -R exampleNNN` (this will generate a exampleNNN-expected.txt file which is used for regression testing)
* Manually verify that the output is correct: `tests/regression/<testapp>/exampleNNN.<suffix>`
* Run the test normally and verify that it passes: `ctest -C Examples -R exampleNNN`

## Troubleshooting Tests:

### Headless unix servers

The following tests will fail if run without X:

```
	93 - echo_recursion-test-function3 (Failed)
	94 - echo_recursion-test-module (Failed)
	140 - echo_recursion-test-vector (Failed)
	143 - echo_issue4172-echo-vector-stack-exhaust (Failed)
```


You may be able to run the tests by using a virtual framebuffer program like Xvnc or Xvfb. For example:

```
$ Xvfb :5 -screen 0 800x600x24 &
$ DISPLAY=:5 ctest
```

or

```
$ xvfb-run ctest
```

Some versions of Xvfb may fail, however. 

X forwarding over ssh works as well.

### Trouble finding libraries on unix

To help CMAKE find eigen, OpenCSG, CGAL, Boost, and GLEW, you can use environment variables, just like for the main qmake & openscad.pro. Examples:

```
OPENSCAD_LIBRARIES=$HOME cmake .
CGALDIR=$HOME/CGAL-3.9 BOOSTDIR=$HOME/boost-1.47.0 cmake .
```

Valid variables are as follows: `BOOSTDIR`, `CGALDIR`, `EIGENDIR`, `GLEWDIR`, `OPENCSGDIR`, `OPENSCAD_LIBRARIES`

When running, this might help find your locally built libraries (assuming you installed into `$HOME`)

* Linux: `export LD_LIBRARY_PATH=$HOME/lib:$HOME/lib64`
* Mac: `export DYLD_LIBRARY_PATH=$HOME/lib`

### Location of logs
 
Logs of test runs and a pretty-printed `index.html` are found in `build/Testing/Temporary`
* Expected results are found in `tests/regression/*`
* Actual results are found in `build/tests/output/*`

### Alternatives to the image_compare.py image comparison script:

If `cmake` is given the option `-DUSE_IMAGE_COMPARE_PY=OFF` then ImageMagick comparison and fallback to `diffpng` are available.  Note that ImageMagick tests are less sensitive because they are pixel-based with a large threshold while `image_compare.py` checks for any 3x3 blocks (with overlap) that have non-zero differences of the same sign.

With `-DUSE_IMAGE_COMPARE_PY=OFF` additional options are available:
* `-DCOMPARATOR=ncc` Normalized Cross Comparison which is less accurate but more runtime stable on some ImageMagick versions.
* `-DCOMPARATOR=old` Lowered reliability test that works on older ImageMagick versions.  Use this with "morphology not found" in the log.

### Locale errors

```
terminate called after throwing an instance of 'std::runtime_error'
  what():  locale::facet::_S_create_c_locale name not valid
```

Is a boost/libstdc++ bug. Fix like so before running:

```
$ export LC_MESSAGES=
```

### Build without OpenGL

There is an unsupported way to do this, by defining NULLGL to Cmake:

```
mkdir nullglbin
cd nullglbin && cmake .. -DNULLGL=1 && make
```
 
The resulting openscad_nogui binary will fail most tests, but may be useful for debugging and outputting 3d-formats like STL on systems without GL. This option may break in the future and require tweaking to get working again.

### Proprietary GL driver issues

There are sporadic reports of problems running on remote machines with proprietary GL drivers. Try doing a web search for your exact error message to see solutions and workarounds that others have found.

### Windows + MSVC: 

The MSVC build was last tested circa 2012. The last time it worked,
these were the necessary commands to run.

Start the QT command prompt:
```
cd \where\you\installed\openscad
cd tests
cmake . -DCMAKE_BUILD_TYPE=Release
sed -i s/\/MD/\/MT/ CMakeCache.txt
cmake .
nmake -f Makefile
```

### Other issues

The [OpenSCAD User Manual Wiki](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual) has a section on buildling. Please check 
there for possible updates and workarounds.

Please report build errors (after double checking the instructions) in the [GitHub issue tracker](https://github.com/openscad/openscad/issues)

# How to add new function/module

* Implement
* Add test
* Modules: Add example
* Document:
   * wikibooks
   * cheatsheet
   * Modules: tooltips (Editor.cc)
   * External editor modes
   * Add to RELEASE_NOTES.md

# Contributing

This is a quick reference for contributing, see [Building OpenSCAD from Sources](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Building_OpenSCAD_from_Sources) in the wiki book for more detailed information.

## Style Guide

The OpenSCAD coding style is encoded in `.uncrustify.cfg`.

Coding style highlights:

* Use 2 spaces for indentation
* Use C++11 functionality where applicable. Please read [Scott Meyer's Effective Modern C++](https://shop.oreilly.com/product/0636920033707.do) for a good primer on modern C++ style and features.

### Beautifying code

Code to be committed can be beautified by installing [uncrustify](https://github.com/uncrustify/uncrustify) and running
`scripts/beautify.sh`. This will, by default, beautify all files that are currently changed.

Alternatively, it's possible to beautify the entire codebase by running `scripts/beautify.sh --all`. This is not recommended except in special cases like:
* We're upgrading uncrustify to fix rules globally.
* You're bringing an old branch to life and want to minimize conflict cause by the large coding style update.

**Note:** Uncrustify is in heavy development and tends to introduce breaking changes from time to time.
OpenSCAD has been tested against uncrustify commit `a05edf605a5b1ea69ac36918de563d4acf7f31fb` (Dec 24 2017).


