# Linux/BSD

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

__Note:__ These scripts are likely to fail on Sun, Solaris, AIX, IRIX, etc (skip to the 'building dependencies' section below).

# Linux/BSD with older or missing dependencies

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


(If you only need CGAL or OpenCSG, you can just run ' ./scripts/uni-build-dependencies.sh cgal' or opencsg and it builds only a single library.)

After completion, return to the section above on 'verifying dependencies' to see if they installed correctly, then follow the Compilation instructions below.


## Nix

Use `scripts/shell.nix` for incremental builds during development and testing.

    cd scrits/
    nix-shell

The final results will not be portable, but this is a good way to run incremental builds and test locally. __Running install is not recommended.__

To create a Nix package, see [nixpgs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/graphics/openscad/default.nix) for the Qt5 release, or [this gist](https://gist.github.com/AaronVerDow/b945a96dbcf35edfc13f543662966534) for a more up to date Qt6 pacakge.

## BSD

The build instructions above are designed to work unchanged on FreeBSD and NetBSD. However the BSDs typically require special environment variables set up to build any QT project - you can set them up automatically by running

    source ./scripts/setenv-unibuild.sh

On OpenBSD it may fail to build after running out of RAM. OpenSCAD requires at least 1 Gigabyte to build with GCC. You may have need to be a user with 'staff' level access or otherwise alter required system parameters. The 'dependency build' sequence has also not been ported to OpenBSD so you must rely on the standard OpenBSD system package tools (in other words you have to have root).

## Sun / Solaris / IllumOS / AIX / IRIX / Minix / etc

The OpenSCAD dependency builds have been mainly focused on Linux and BSD systems like Debian or FreeBSD. The 'helper scripts' are likely to fail on other types of Un*x. Furthermore the OpenSCAD build system files (qmake .pro files for the GUI, cmake CMakeFiles.txt for the test suite) have not been tested thoroughly on non-Linux non-BSD systems. Extensive work may be required to get a working build on such systems.
