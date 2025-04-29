## Set up tools and dependencies

Download [64-bit MSYS2](https://www.msys2.org)

Install per instructions, including the install-time upgrades (`pacman -Syu`, `-Su`).  Installing development components is not necessary at this point. 

## Install OpenSCAD build dependencies

Start an MSYS2 shell window using the "MSYS2 MinGW x64" link in the Start menu.

    curl -L https://github.com/openscad/openscad/raw/master/scripts/msys2-install-dependencies.sh | sh 

## Set up source directory

Start an MSYS2 shell window using the "MSYS2 MinGW x64" link in the Start menu.

    git clone https://github.com/openscad/openscad.git srcdir
    cd srcdir
    git submodule update --init --recursive  # needed because of manifold

Replace `srcdir` with whatever name you like.

## Build with command line

### Set up build directory

Start an MSYS2 shell window using the "MSYS2 MinGW x64" link in the Start menu.

    cd srcdir
    mkdir builddir
    cd builddir
    cmake .. -G"MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DEXPERIMENTAL=ON -DSNAPSHOT=ON

Replace `builddir` with whatever name you like.

### Build

Start an MSYS2 shell window using the "MSYS2 MinGW x64" link in the Start menu.

    cd srcdir/builddir
    make

You might want to add `-jN`, where N is the number of compiles to run in parallel - approximately, the number of processor cores on the system.

### Run

Start an MSYS2 shell window using the "MSYS2 MinGW x64" link in the Start menu.

    cd srcdir/builddir
    ./openscad

## Build with Qt Creator IDE

Note:  When I tried this, it mostly built but failed in `cgalutils.cc`, in an environment where the command-line build worked.

### Install QT Creator

    pacman -S mingw-w64-x86_64-qt-creator

### Load project

    qtcreator &

Open `CMakeLists.txt` from the top of the source tree.  Use the default configuration.

### Build

Build with Control-B or Build / Build project "openscad".

## 32-bit support

It may be possible to build OpenSCAD on a 32-bit system by installing the 32-bit version of MSYS2 from the [https://www.msys2.org/wiki/MSYS2-installation/ MSYS2 install page].  (More information to come.)

## Prebuilt OpenSCAD

Note that MSYS2 also provides a precompiled OpenSCAD package. This can be installed using

    pacman -S mingw-w64-x86_64-openscad

## Historical Notes ==

The following is historical content from previous versions of this page, that might still be applicable.

### QtCreator

The Build-Type must be changed to "Release".

In some cases the build fails when generating the parser code using flex and bison. In that case disabling the "Shadow Build" (see Project tab / General Settings) can help.

### Building Debug Version

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

### OpenGL (Optional)

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
