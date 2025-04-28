# Cross Compiling

OpenSCAD includes convenience scripts to cross-build Windows installer binaries using the [MXE system](http://mxe.cc). If you wish to use them, you can first install the [MXE Requirements](http://mxe.cc/#requirements) such as cmake, perl, scons, using your system's package manager. Then you can perform the following commands to download OpenSCAD source and build a windows installer:

    git clone https://github.com/openscad/openscad.git
    cd openscad
    source ./scripts/setenv-mingw-xbuild.sh
    ./scripts/mingw-x-build-dependencies.sh
    ./scripts/release-common.sh mingw32

The x-build-dependencies process takes several hours, mostly to cross-build QT. It also requires several gigabytes of disk space. If you have multiple CPUs you can speed up things by running `export NUMCPU=x` before running the dependency build script. By default it builds the dependencies in `$HOME/openscad_deps/mxe`. You can override the mxe installation path by setting the BASEDIR environment variable before running the scripts. The OpenSCAD binaries are built into a separate build path, openscad/mingw32.

Note that if you want to then build linux binaries, you should log out of your shell, and log back in. The 'setenv' scripts, as of early 2013, required a 'clean' shell environment to work. 

If you wish to cross-build manually, please follow the steps below and/or consult the release-common.sh source code. 

## Setup

The easiest way to cross-compile OpenSCAD for Windows on Linux or Mac is to use mxe (M cross environment). You must install git to get it. Once you have git, navigate to where you want to keep the mxe files in a terminal window and run:

    git clone git://github.com/mxe/mxe.git

Add the following line to your `~/.bashrc` file:

     export PATH=/<where mxe is installed>/usr/bin:$PATH

replacing `<where mxe is installed>` with the appropriate path.

## Requirements
The requirements to cross-compile for Windows are just the requirements of mxe. They are listed, along with a command for installing them [here](http://mxe.cc/#requirements). You don't need to type `make`; this makes everything and take up >10 GB of diskspace. You can instead follow the next step to compile only what's needed for openscad. 

Now that you have the requirements for mxe installed, you can build OpenSCAD's dependencies (CGAL, Opencsg, MPFR, and Eigen2). Just open a terminal window, navigate to your mxe installation and run:

    make mpfr eigen opencsg cgal qt

This can take a few hours, because it has to build things like gcc, qt, and boost. Just go calibrate your printer or something while you wait. To speed things up, you might want do something like `make -j 4 JOBS=2` for parallel building. See the [mxe tutorial](http://mxe.cc/#tutorial) for more details.

Optional: If you want to build an installer, you need to install the nullsoft installer system. It should be in your package manager, called "nsis".

## Build OpenSCAD
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
