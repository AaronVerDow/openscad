# Contributing

See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Building_OpenSCAD_from_Sources for most information.

# Style Guide

The OpenSCAD coding style is encoded in `.uncrustify.cfg`.

Coding style highlights:

* Use 2 spaces for indentation
* Use C++11 functionality where applicable. Please read Scott Meyer's Effective Modern C++ for a good primer on modern C++ style and features: https://shop.oreilly.com/product/0636920033707.do

## Beautifying code

Code to be committed can be beautified by installing `uncrustify`
(https://github.com/uncrustify/uncrustify) and running
`scripts/beautify.sh`. This will, by default, beautify all files that
are currently changed.

Alternatively, it's possible to beautify the entire codebase by running `scripts/beautify.sh --all`.
This is not recommended except in special cases like:
* We're upgrading uncrustify to fix rules globally
* You're bringing an old branch to life and want to minimize conflict cause by the large coding style update

Note: Uncrustify is in heavy development and tends to introduce breaking changes from time to time.
OpenSCAD has been tested against uncrustify commit a05edf605a5b1ea69ac36918de563d4acf7f31fb (Dec 24 2017).

# Compiling

See README.md

# Regression Tests

Run all 

## Prerequisites

Install the prerequisite helper programs on your system:

* cmake
* python3
* python3-venv
* python3-pip

There are binary installer packages of these tools available for Mac,
Win, Linux, BSD, and other systems.

## Building Test environment

Test files will be automatically configured and built (but not ran) as part of the main openscad build.  See README.md for how to get a build of the main openscad binary working.

Windows builds are a special case, since they are cross-compiled from a linux system.  The automated build servers package up the tests alongside the binary if you download a .ZIP Development Snapshot from: http://openscad.org/downloads.html#snapshots

NOTE: **ONLY THE ZIP VERSION** of the download contains the tests. They would not run properly using an installer to place under "C:\Program Files" since that would require elevated privileges to write the test output files.

## Running tests

### Linux, Mac:

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

### Win:

Unzip the OpenSCAD-Tests-YYYY.MM.DD file onto a Windows(TM) machine. 
There will be a script called OpenSCAD-Test-Console.py in the parent folder.
Double-click it, and it will open a console, from which you can type the ctest
commands listed above.

## Automatically upload test results (experimental)

It's possible to automatically upload tests results to an external
server. This is good for CI, as well as being able to easily report
bugs.

To enable this feature, add '-DOPENSCAD_UPLOAD_TESTS=1' to the cmake 
cmd-line, e.g.: cmake -DOPENSCAD_UPLOAD_TESTS=1 .

## Adding a new test

* create a test file at an appropriate location under tests/data/
* if the test is non-obvious, create a human readable description as comments in the test (or in another file in the same directory in case the file isn't human readable)
* if a new test app was written, this must be added to tests/CMakeLists.txt
* Add the tests to the test apps for which you want them to run (in tests/CMakeLists.txt)
* rebuild the test environment
* run the test with the environment variable TEST_GENERATE=1, e.g.:
   $ TEST_GENERATE=1 ctest -R mytest
   (this will generate a mytest-expected.txt file which is used for regression testing)
* manually verify that the output is correct (tests/regression/<testapp>/mytest-expected.<suffix>)
* run the test normally and verify that it passes:
  $ ctest -R mytest

## Adding a new example

This is almost the same as adding a new regression test:
* Create the example under examples/
* run the test with the environment variable TEST_GENERATE=1, e.g.:
   $ TEST_GENERATE=1 ctest -C Examples -R exampleNNN
   (this will generate a exampleNNN-expected.txt file which is used for regression testing)
* manually verify that the output is correct (tests/regression/<testapp>/exampleNNN.<suffix>)
* run the test normally and verify that it passes:
  $ ctest -C Examples -R exampleNNN

## Troubleshooting:

### Headless unix servers

If you are attempting to run the tests on a unix-like system but only
have shell-console access, you may be able to run the tests by using a 
virtual framebuffer program like Xvnc or Xvfb. For example:

```
$ Xvfb :5 -screen 0 800x600x24 &
$ DISPLAY=:5 ctest
```

Will fail on:
```
	93 - echo_recursion-test-function3 (Failed)
	94 - echo_recursion-test-module (Failed)
	140 - echo_recursion-test-vector (Failed)
	143 - echo_issue4172-echo-vector-stack-exhaust (Failed)
```

or

```
$ xvfb-run ctest
```

Some versions of Xvfb may fail, however. 

### Trouble finding libraries on unix

To help CMAKE find eigen, OpenCSG, CGAL, Boost, and GLEW, you can use environment variables, just like for the main qmake & openscad.pro. Examples:

```
OPENSCAD_LIBRARIES=$HOME cmake .
CGALDIR=$HOME/CGAL-3.9 BOOSTDIR=$HOME/boost-1.47.0 cmake .
```

Valid variables are as follows: `BOOSTDIR`, `CGALDIR`, `EIGENDIR`, `GLEWDIR`, `OPENCSGDIR`, `OPENSCAD_LIBRARIES`

When running, this might help find your locally built libraries (assuming you installed into $HOME)

* Linux: `export LD_LIBRARY_PATH=$HOME/lib:$HOME/lib64`
* Mac: `export DYLD_LIBRARY_PATH=$HOME/lib`

### Location of logs
 
Logs of test runs and a pretty-printed index.html are found in `build/Testing/Temporary`
* Expected results are found in tests/regression/*
* Actual results are found in build/tests/output/*

### Alternatives to the image_compare.py image comparison script:

If cmake is given the option -DUSE_IMAGE_COMPARE_PY=OFF then ImageMagick
comparison and fallback to diffpng are available.  Note that ImageMagick
tests are less sensitive because they are pixel-based with a large threshold
while image_compare.py checks for any 3x3 blocks (with overlap) that have
non-zero differences of the same sign.

With -DUSE_IMAGE_COMPARE_PY=OFF additional options are available:
 : -DCOMPARATOR=ncc Normalized Cross Comparison which is less accurate but
   more runtime stable on some ImageMagick versions.
 : -DCOMPARATOR=old Lowered reliability test that works on older
   ImageMagick versions.  Use this with "morphology not found" in the log.

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

> Start the 'QT command prompt'
> cd \where\you\installed\openscad
> cd tests
> cmake . -DCMAKE_BUILD_TYPE=Release
> sed -i s/\/MD/\/MT/ CMakeCache.txt
> cmake .
> nmake -f Makefile

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
