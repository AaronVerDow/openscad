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

Once built, you can run tests with `ctest` from the `build` directory.

Note: Both `cmake --build` and `ctest` accepts a `-j N` argument for distributing the load over `N` parallel processes.
