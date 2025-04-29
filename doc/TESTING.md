# Testing

## Running containerized GitHub CI workflows

* Install [circleci-cli](https://circleci.com/docs/2.0/local-cli/) (you'll need an API key)
  * __Note:__ we also use GitHub Workflows, but only to run tests on Windows (which we cross-build for in the Linux-based CircleCI workflows below). Also, [act](https://github.com/nektos/act) doesn't like our submodule setup anyway.
* Run the CI jobs

      # When "successful", these will fail to upload at the very end of the workflow.
      circleci local execute --job  openscad-mxe-64bit
      circleci local execute --job  openscad-mxe-32bit
      circleci local execute --job  openscad-appimage-64bit

  * __Note:__ openscad-macos can't be built locally.
* If/when GCC gets randomly killed, give docker more RAM (e.g. 4GB per concurrent image you plan to run)
* To debug the jobs more interactively, you can go the manual route (inspect .circleci/config.yml to get the actual docker image you need)

      docker run --entrypoint=/bin/bash -it openscad/mxe-x86_64-gui:latest

* Then once you get the console:

      git clone https://github.com/%your username%/openscad.git workspace
      cd workspace
      git checkout %your branch%
      git submodule init
      git submodule update

Then execute the commands from .circleci/config.yml:

      export NUMCPU=2
      ...
      ./scripts/release-common.sh -snapshot -mingw64 -v "$OPENSCAD_VERSION"

## Running GitHub CI workflows manually

Fill this out.

## Run tests manually

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

From your build directory:

    ctest -j8           Runs tests enabled by default using 8 parallel processes.
    ctest -R <regex>    Runs only matching tests, e.g. ctest -R dxf
    ctest -C <configs>  Adds extended tests belonging to configs.
                        Valid configs:
                        Default  - Run default tests
                        Heavy    - Run more time consuming tests (> ~10 seconds)
                        Examples - test all examples
                        Bugs     - test known bugs (tests will fail)
                        All      - test everything

#### Win:

Unzip the OpenSCAD-Tests-YYYY.MM.DD file onto a Windows machine. There will be a script called OpenSCAD-Test-Console.py in the parent folder. Double-click it, and it will open a console, from which you can type the ctest commands listed above.

## Automatically upload test results (experimental)

It's possible to automatically upload tests results to an external server. This is good for CI, as well as being able to easily report bugs.

To enable this feature, add `-DOPENSCAD_UPLOAD_TESTS=1` to `cmake` 

## Adding a new test

* Create a test file at an appropriate location under `tests/data/`
* If the test is non-obvious, create a human readable description as comments in the test, or in another file in the same directory in case the file isn't human readable.
* If a new test app was written, this must be added to `tests/CMakeLists.txt`
* Rebuild the test environment.
* Run the test with the environment variable `TEST_GENERATE=1`, e.g.: `TEST_GENERATE=1 ctest -R mytest` (this will generate a `mytest-expected.txt` file which is used for regression testing.)
* Manually verify that the output is correct: `tests/regression/<testapp>/mytest-expected.<suffix>`
* Run the test normally and verify that it passes: `ctest -R mytest`

## Adding a new example

This is almost the same as adding a new regression test:
* Create the example under `examples/`
* Run the test with the environment variable `TEST_GENERATE=1`, e.g.: `$ TEST_GENERATE=1 ctest -C Examples -R exampleNNN` (this will generate a exampleNNN-expected.txt file which is used for regression testing)
* Manually verify that the output is correct: `tests/regression/<testapp>/exampleNNN.<suffix>`
* Run the test normally and verify that it passes: `ctest -C Examples -R exampleNNN`

## Test Troubleshooting:

### Headless unix servers

The following tests will fail if run without X:

    93 - echo_recursion-test-function3 (Failed)
    94 - echo_recursion-test-module (Failed)
    140 - echo_recursion-test-vector (Failed)
    143 - echo_issue4172-echo-vector-stack-exhaust (Failed)

You may be able to run the tests by using a virtual framebuffer program like Xvnc or Xvfb. For example:

    Xvfb :5 -screen 0 800x600x24 &
    DISPLAY=:5 ctest

or:

    xvfb-run ctest

Some versions of Xvfb may fail, however. 

X forwarding over ssh works as well.

### Trouble finding libraries on unix

To help CMAKE find eigen, OpenCSG, CGAL, Boost, and GLEW, you can use environment variables, just like for the main qmake & openscad.pro. Examples:

    OPENSCAD_LIBRARIES=$HOME cmake .
    CGALDIR=$HOME/CGAL-3.9 BOOSTDIR=$HOME/boost-1.47.0 cmake .

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

The following is a boost/libstdc++ bug:

    terminate called after throwing an instance of 'std::runtime_error'
      what():  locale::facet::_S_create_c_locale name not valid

Fix like so before running:

    export LC_MESSAGES=

### Build without OpenGL

There is an unsupported way to do this, by defining NULLGL to Cmake:

    mkdir nullglbin
    cd nullglbin && cmake .. -DNULLGL=1 && make

The resulting openscad_nogui binary will fail most tests, but may be useful for debugging and outputting 3d-formats like STL on systems without GL. This option may break in the future and require tweaking to get working again.

### Proprietary GL driver issues

There are sporadic reports of problems running on remote machines with proprietary GL drivers. Try doing a web search for your exact error message to see solutions and workarounds that others have found.

### Windows + MSVC: 

The MSVC build was last tested circa 2012. The last time it worked,
these were the necessary commands to run.

Start the QT command prompt:

    cd \where\you\installed\openscad
    cd tests
    cmake . -DCMAKE_BUILD_TYPE=Release
    sed -i s/\/MD/\/MT/ CMakeCache.txt
    cmake .
    nmake -f Makefile

### Other issues

Please report build errors (after double checking the instructions) in the [GitHub issue tracker](https://github.com/openscad/openscad/issues)
