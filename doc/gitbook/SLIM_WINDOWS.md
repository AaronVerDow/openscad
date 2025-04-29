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
