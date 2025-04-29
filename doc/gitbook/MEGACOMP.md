To build OpenSCAD from source, follow the instructions for the
platform applicable to you below.

# Prerequisites

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

# Getting the source code

Install git (https://git-scm.com/) onto your system. Then run a clone:

    git clone https://github.com/openscad/openscad.git

This will download the latest sources into a directory named `openscad`.

To pull the various submodules (incl. the [MCAD library](https://github.com/openscad/MCAD)), do the following:

    cd openscad
    git submodule update --init --recursive

# Build

## Linux

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

If there are missing dependencies, use the BSD section below.

Continue with [compilation](#compilation).

## BSD

This section is for BSD or Linux with missing dependencies.  It will download and build newer versions of dependencies into `$HOME/openscad_deps`.

First, run the script that sets up the 
environment variables. 

    source ./scripts/setenv-unibuild.sh

Then run the script to compile all the prerequisite libraries above:

    ./scripts/uni-build-dependencies.sh

Note that huge dependencies like gcc, qt, or glib2 are not included 
here, only the smaller ones (boost, CGAL, opencsg, etc). After the 
build, again check dependencies.

    ./scripts/check-dependencies.sh


(If you only need CGAL or OpenCSG, you can just run ' ./scripts/uni-build-dependencies.sh cgal' or opencsg and it builds only a single library.)

On OpenBSD it may fail to build after running out of RAM. OpenSCAD requires at least 1 Gigabyte to build with GCC. You may have need to be a user with 'staff' level access or otherwise alter required system parameters. The 'dependency build' sequence has also not been ported to OpenBSD so you must rely on the standard OpenBSD system package tools (in other words you have to have root).

Continue with [compilation](#compilation).

## Nix

Use `scripts/shell.nix` for incremental builds during development and testing.

    cd scrits/
    nix-shell

The final results will not be portable, but this is a good way to run incremental builds and test locally. __Running install is not recommended.__

To create a Nix package, see [nixpgs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/graphics/openscad/default.nix) for the Qt5 release, or [this gist](https://gist.github.com/AaronVerDow/b945a96dbcf35edfc13f543662966534) for a more up to date Qt6 pacakge.

Continue with [compilation](#compilation).

## Sun / Solaris / IllumOS / AIX / IRIX / Minix / etc

The OpenSCAD dependency builds have been mainly focused on Linux and BSD systems like Debian or FreeBSD. The 'helper scripts' are likely to fail on other types of Un*x. Furthermore the OpenSCAD build system files (qmake .pro files for the GUI, cmake CMakeFiles.txt for the test suite) have not been tested thoroughly on non-Linux non-BSD systems. Extensive work may be required to get a working build on such systems.


## Mac

Requirements:

* Xcode
* Homebrew packages:
    * automake
    * libtool
    * cmake
    * pkg-config
    * wget
    * meson
    * python-packaging

Automatically install all dpendencies using [Homebrew](https://brew.sh/):

    ./scripts/macosx-build-homebrew.sh

Or, build depednencies from source:

    source scripts/setenv-macos.sh
    ./scripts/macosx-build-dependencies.sh

Continue with [compilation](#compilation).

## Cross Compile for Windows

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

### Cross Compiling

OpenSCAD includes convenience scripts to cross-build Windows installer binaries using the [MXE system](http://mxe.cc). If you wish to use them, you can first install the [MXE Requirements](http://mxe.cc/#requirements) such as cmake, perl, scons, using your system's package manager. Then you can perform the following commands to download OpenSCAD source and build a windows installer:

    git clone https://github.com/openscad/openscad.git
    cd openscad
    source ./scripts/setenv-mingw-xbuild.sh
    ./scripts/mingw-x-build-dependencies.sh
    ./scripts/release-common.sh mingw32

The x-build-dependencies process takes several hours, mostly to cross-build QT. It also requires several gigabytes of disk space. If you have multiple CPUs you can speed up things by running `export NUMCPU=x` before running the dependency build script. By default it builds the dependencies in `$HOME/openscad_deps/mxe`. You can override the mxe installation path by setting the BASEDIR environment variable before running the scripts. The OpenSCAD binaries are built into a separate build path, openscad/mingw32.

Note that if you want to then build linux binaries, you should log out of your shell, and log back in. The 'setenv' scripts, as of early 2013, required a 'clean' shell environment to work. 

If you wish to cross-build manually, please follow the steps below and/or consult the release-common.sh source code. 

### Setup

The easiest way to cross-compile OpenSCAD for Windows on Linux or Mac is to use mxe (M cross environment). You must install git to get it. Once you have git, navigate to where you want to keep the mxe files in a terminal window and run:

    git clone git://github.com/mxe/mxe.git

Add the following line to your `~/.bashrc` file:

     export PATH=/<where mxe is installed>/usr/bin:$PATH

replacing `<where mxe is installed>` with the appropriate path.

### Requirements
The requirements to cross-compile for Windows are just the requirements of mxe. They are listed, along with a command for installing them [here](http://mxe.cc/#requirements). You don't need to type `make`; this makes everything and take up >10 GB of diskspace. You can instead follow the next step to compile only what's needed for openscad. 

Now that you have the requirements for mxe installed, you can build OpenSCAD's dependencies (CGAL, Opencsg, MPFR, and Eigen2). Just open a terminal window, navigate to your mxe installation and run:

    make mpfr eigen opencsg cgal qt

This can take a few hours, because it has to build things like gcc, qt, and boost. Just go calibrate your printer or something while you wait. To speed things up, you might want do something like `make -j 4 JOBS=2` for parallel building. See the [mxe tutorial](http://mxe.cc/#tutorial) for more details.

Optional: If you want to build an installer, you need to install the nullsoft installer system. It should be in your package manager, called "nsis".

### Build OpenSCAD

Now that all the requirements have been met, all that remains is to build OpenSCAD itself. Open a terminal window and enter:

    git clone git://github.com/openscad/openscad.git
    cd openscad

Then get MCAD:

     git submodule init
     git submodule update

You need to create a symbolic link here for the build system to find the libraries, again replacing `<where mxe is installed>` with the appropriate path

     ln -s /<where mxe is installed>/usr/i686-pc-mingw32/ mingw-cross-env


Now to build OpenSCAD run:

     i686-pc-mingw32-qmake CONFIG+=mingw-cross-env openscad.pro
     make

This creates openscad.exe in ./release and you can build an installer with it as described in the instructions for building with Microsoft Visual C++, [described here](http://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Building_on_Windows#Building_an_installer). 

The difference is that instead of right-clicking on the *.nsi file you run:
  
    makensis installer.nsis

Note that as of early 2013, OpenSCAD's `scripts/release-common.sh` automatically uses the version of nsis that comes with the MXE cross build system, so you may wish to investigate the release-common.sh source code to see how it works, if you have troubles. 


## Build On Windows

Download [64-bit MSYS2](https://www.msys2.org)

Install per instructions, including the install-time upgrades (`pacman -Syu`, `-Su`).  Installing development components is not necessary at this point. 

* Start an MSYS2 shell window using the "MSYS2 MinGW x64" link in the Start menu.
* Install OpenSCAD build dependencies

        curl -L https://github.com/openscad/openscad/raw/master/scripts/msys2-install-dependencies.sh | sh 

* Set up source directory:

        git clone https://github.com/openscad/openscad.git srcdir
        cd srcdir
        git submodule update --init --recursive  # needed because of manifold


* Set up build directory:

        cd srcdir
        mkdir builddir
        cd builddir
        cmake .. -G"MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DEXPERIMENTAL=ON -DSNAPSHOT=ON

* Build:
  * You might want to add `-jN`, where N is the number of compiles to run in parallel - approximately, the number of processor cores on the system.

        cd srcdir/builddir
        make

* Run:

        cd srcdir/builddir
        ./openscad

### Build with Qt Creator IDE

Note:  When I tried this, it mostly built but failed in `cgalutils.cc`, in an environment where the command-line build worked.

* Install QT Creator

        pacman -S mingw-w64-x86_64-qt-creator

* Load project

        qtcreator &

* Open `CMakeLists.txt` from the top of the source tree.  Use the default configuration.
* Build with Control-B or Build / Build project "openscad".

### 32-bit support

It may be possible to build OpenSCAD on a 32-bit system by installing the 32-bit version of MSYS2 from the [https://www.msys2.org/wiki/MSYS2-installation/ MSYS2 install page].  (More information to come.)

### Prebuilt OpenSCAD

Note that MSYS2 also provides a precompiled OpenSCAD package. This can be installed using

    pacman -S mingw-w64-x86_64-openscad

### Historical Notes

The following is historical content from previous versions of this page, that might still be applicable.

#### QtCreator

The Build-Type must be changed to "Release".

In some cases the build fails when generating the parser code using flex and bison. In that case disabling the "Shadow Build" (see Project tab / General Settings) can help.

#### Building Debug Version

Currently the QScintilla package provides only a release version of the library. Using this with a debug build of OpenSCAD is not possible (the resulting binary crashs with an assertion error inside Qt).

To create a working debug version of OpenSCAD, a debug version of QScintilla must be built manually.

* Download [QScintilla source code](http://www.riverbankcomputing.com/software/qscintilla/download)
* Extract the archive, change to the subfolder Qt4Qt5 in the QScintilla source tree and edit the qscintilla.pro project file. Rename the build target so the DLL gets a "d" suffix

       - TARGET = qscintilla2
       + TARGET = qscintilla2d

* Change the release config option to debug (also in qscintilla.pro)

       - CONFIG += qt warn_off release thread exceptions
       + CONFIG += qt warn_off debug thread exceptions

* Build the debug DLL

       qmake
       mingw32-make

* Copy the debug library into the default MSYS2 folders

      cp debug/libqscintilla2d.dll.a /mingw64/lib/
      cp debug/qscintilla2d.dll /mingw64/bin/

#### OpenGL (Optional)

OpenSCAD needs at least OpenGL version 2.0 to be able to correctly
render the preview using OpenCSG. It's possible to run with older
versions (e.g. the default provided by Windows, which is 1.4) but
the display might differ from the expected output.

For systems that can't provide the needed OpenGL version (e.g. when
running on a VM) it's still possible to get the a more recent
OpenGL driver using the Mesa software renderer.

    pacman -S mingw-w64-x86_64-mesa

After installing the mesa driver (default location is `C:\msys64\mingw64\bin`,
the driver itself is `opengl32.dll`), it can be even activated by
copying it into the same folder as the `OpenSCAD.exe`.

It's possible to enable it for the whole system by copying it to the
Windows system32 folder, replacing the old system driver.
(Warning: Do that only if you have a backup and enough knowledge how
to restore files in a broken Windows installation!)


## Building for WebAssembly

We support building OpenSCAD headless for WebAssembly w/ Emscripten, using a premade Docker image built in [openscad/openscad-wasm](https://github.com/openscad/openscad-wasm) (which also has usage examples)

### Browser

The following command creates `build-web/openscad.wasm` & `build-web/openscad.js`:

    ./scripts/wasm-base-docker-run.sh emcmake cmake -B build-web -DCMAKE_BUILD_TYPE=Debug -DEXPERIMENTAL=1
    ./scripts/wasm-base-docker-run.sh cmake --build build-web -j2

[openscad/openscad-playground](https://github.com/openscad/openscad-playground) uses this WASM build to provide a [Web UI](https://ochafik.com/openscad2/) with a subset of features of OpenSCAD.

> [!NOTE]
> With a debug build (`-DCMAKE_BUILD_TYPE=Debug`), you can set C++ breakpoints in Firefox and in Chrome (the latter [needs an extension](https://developer.chrome.com/docs/devtools/wasm)).

### Standalone node.js build

The following command creates `build-node/openscad.js`, which is executable (requires `node`):

    ./scripts/wasm-base-docker-run.sh emcmake cmake -B build-node -DWASM_BUILD_TYPE=node -DCMAKE_BUILD_TYPE=Debug -DEXPERIMENTAL=1
    ./scripts/wasm-base-docker-run.sh cmake --build build-node -j2
    build-node/openscad.js --help

> [!NOTE]
> With a debug build (`-DCMAKE_BUILD_TYPE=Debug`), you can set C++ breakpoints in VSCode + Node ([needs an extension](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_debugging-webassembly)).

# Compilation

First, generate a Makefile in the `build` folder:

    cmake -B build -DEXPERIMENTAL=1

Execute the build:

    cmake --build build

OpenSCAD can be tested by running `./build/openscad` or optionally installed to the system:

    sudo cmake --install build

If you had problems compiling from source, raise a new issue in the
[issue tracker on the github page](https://github.com/openscad/openscad/issues).

Once built, you can run tests with `ctest` from the `build` directory. See [testing](./TESTING.md) for more information.

Note: Both `cmake --build` and `ctest` accepts a `-j N` argument for distributing the load over `N` parallel processes.

# Troubleshooting

## Errors about incompatible library versions

This may be caused by old libraries living in /usr/local/lib like boost, CGAL, OpenCSG, etc, (often left over from previous experiments with OpenSCAD). You are advised to remove them. To remove, for example, CGAL, run rm -rf /usr/local/include/CGAL && rm -rf /usr/local/lib/*CGAL*. Then erase $HOME/openscad_deps, remove your openscad source tree, and restart fresh. As of 2013 OpenSCAD's build process does not advise nor require anything to be installed in /usr/local/lib nor /usr/local/include. 

Note that CGAL depends on Boost and OpenCSG depends on GLEW - interdependencies like this can really cause issues if there are stray libraries in unusual places. 

Another source of confusion can come from running from within an 'unclean shell'. Make sure that you don't have LD_LIBRARY_PATH set to point to any old libraries in any strange places. Also don't mix a Mingw windows cross build with your linux build process - they use different environment variables and may conflict.

## OpenCSG didn't automatically build

If for some reason the recommended build process above fails to work with OpenCSG, please file an issue on the OpenSCAD github. In the meantime, you can try building it yourself. 

    wget http://www.opencsg.org/OpenCSG-1.3.2.tar.gz
    sudo apt-get purge libopencsg-dev libopencsg1 # or your system's equivalent
    tar -xvf OpenCSG-1.3.2.tar.gz
    cd OpenCSG-1.3.2
    # edit the Makefile and remove 'example'
    make
    sudo cp -d lib/lib* $HOME/openscad_deps/lib/
    sudo cp include/opencsg.h $HOME/openscad_deps/include/

__Note:__ on Debian-based systems (such as Ubuntu), you can add the 'install' target to the OpenCSG Makefile, and then use checkinstall to create a clean .deb package for install/removal/upgrade. Add this target to Makefile:

    install:
        # !! THESE LINES PREFIXED WITH ONE TAB, NOT SPACES !!
        cp -d lib/lib* /usr/local/lib/
        cp include/opencsg.h /usr/local/include/
        ldconfig

Create and install a clean package:

    sudo checkinstall -D make install

# CGAL didn't automatically build

If this happens, you can try to compile CGAL yourself. It is recommended to install to $HOME/openscad_deps and otherwise follow the build process as outlined above. 

# Compiling fails with an Internal compiler error from GCC or GAS

This can happen if you run out of virtual memory, which means all of physical RAM as well as virtual swap space from the disk. See below under "horribly slow" for reasons. If you are non-root, there are a few things you can try. The first is to use the 'clang' compiler, as it uses much less RAM than gcc. The second thing is to edit the Makefile and remove the '-g' and '-pipe' flags from the compiler flags section.

If, on the other hand, you are root, then you can expand your swap space. On Linux this is pretty standard procedure and easily found in a web search. Basically you do these steps (after verifying you have no file named /swapfile already):

    sudo dd if=/dev/zero of=/swapfile bs=1M count=2000  # create a roughly 2 gig swapfile 
    sudo chmod 0600 /swapfile # set proper permissions for security
    sudo mkswap /swapfile  # format as a swapfile 
    sudo swapon /swapfile  # turn on swap

For permanent swap setup in /etc/fstab, instructions are easily found through web search. If you are building on an SSD (solid state drive) machine the speed of a swapfile allows a reasonable build time.

## Compiling is horribly slow and/or grinds the disk

It is recommended to have at least 1.5 Gbyte of RAM to compile OpenSCAD. There are a few workarounds in case you don't. The first is to use the experimental support for the Clang Compiler (described below) as Clang uses much less RAM than GCC. Another workaround is to edit the Makefile generated by qmake and search/replace the optimization flags (-O2) with -O1 or blank, and to remove any '-g' debug flags from the compiler line, as well as '-pipe'.  

If you have plenty of RAM and just want to speed up the build, you can try a paralell multicore build with 

    cmake -jx

Where 'x' is the number of cores you want to use. Remember you need x times the amount of RAM to avoid possible disk thrashing. 

The reason the build is slow is because OpenSCAD uses template libraries like CGAL, Boost, and Eigen, which use large amounts of RAM to compile - especially CGAL. GCC may take up 1.5 Gigabytes of RAM on some systems during the build of certain CGAL modules. There is [more information at StackOverflow.com](http://stackoverflow.com/questions/3634203/why-are-templates-so-slow-to-compile)

## I moved the dependencies I built and now openscad won't run

It isn't advised to move them because the build is using RPATH hard coded into the openscad binary. You may try to workaround by setting the LD_LIBRARY_PATH environment variable to place yourpath/lib first in the list of paths it searches. If all else fails, you can re-run the entire dependency build process but export the BASEDIR environment variable to your desired location, before you run the script to set environment variables.
