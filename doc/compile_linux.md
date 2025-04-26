# Prebuilt binary packages

If you are lucky, you won't have to build it. Many Linux and BSD systems have pre-built OpenSCAD packages including Debian, Ubuntu, Fedora, Arch, NetBSD and OpenBSD. Check your system's package manager for details.

## generic linux binary package
There is also a generic linux binary package at http://www.openscad.org that can be unpacked and run from within most linux systems. It is self contained and includes the required libraries.

## nightly builds
see https://build.opensuse.org/package/show/home:t-paul/OpenSCAD

## chrysn's Ubuntu packages
For Ubuntu systems you can also try [https://launchpad.net/~chrysn/+archive/openscad launchpad PPA](chrysn's Ubuntu packages) at his PPA, or you can just copy/paste the following onto the command line: 

```
sudo add-apt-repository ppa:chrysn/openscad
sudo apt-get update
sudo apt-get install openscad
```

His repositories for OpenSCAD and OpenCSG are [http://archive.amsuess.com/pool/contrib/o/openscad/ here] and [http://archive.amsuess.com/pool/main/o/opencsg/ here]. 

== Building OpenSCAD yourself ==

If you wish to build OpenSCAD for yourself, start by installing '''''git''''' on your system using your package manager. Git is sometimes packaged under the name 'scmgit' or 'git-core'. Then, use git to download the OpenSCAD source code

<syntaxhighlight lang="bash">
cd ~/
git clone https://github.com/openscad/openscad.git
cd openscad
</syntaxhighlight>


Then get the MCAD library, which is now included with OpenSCAD binary distributions

<syntaxhighlight lang="bash">
git submodule init
git submodule update
</syntaxhighlight>

=== Installing dependencies ===

OpenSCAD uses a large number of third-party libraries and tools. These are called dependencies. An up to date list of dependencies can usually be found in the README.md in openscad's main directory, here: https://github.com/openscad/openscad/  A brief list follows: 

''Eigen, GCC or Clang, Bison, Flex, CGAL, Qt, GMP, MPFR, boost, cmake, OpenCSG, GLEW, QScintilla, glib2, harfbuzz, freetype2, pkg-config, fontconfig''

==== Prepackaged dependencies ====

Most systems are set up to install pre-built dependencies using a 'package manager', such as '''''apt''''' on ubuntu or '''''pacman''''' on Arch Linux. OpenSCAD comes with a 'helper script' that attempts to automatically run your package manager for you and download and install these pre-built packages if they exist. Note you must be running as root and/or using ''sudo'' to try this. Note that these scripts are likely to fail on Sun, Solaris, AIX, IRIX, etc (skip to the 'building dependencies' section below).

<syntaxhighlight lang="bash">
./scripts/uni-get-dependencies.sh
</syntaxhighlight>

==== Verifying dependencies ====

After attempting to install dependencies, you should double check them. Exit any shells and perhaps reboot. 

Now verify that the version numbers are up to those listed in openscad/README.md file. Also verify that no packages were accidentally missed. For example open a shell and run 'flex --version' or 'gcc --version'. These are good sanity checks to make sure your environment is proper. 

OpenSCAD comes with another helper script that attempts to automate this process on many Linux and BSD systems (Again, it won't work on Sun/Solaris/Irix/AIX/etc).

<syntaxhighlight lang="bash">
./scripts/check-dependencies.sh
</syntaxhighlight>

If you cannot verify that your dependencies are installed properly and of a sufficient version, then you may have to install some 'by hand' (see the section below on building your own dependencies).

If your system has all the proper versions of dependencies, then continue to the 'Building OpenSCAD' section.

=== Building the dependencies yourself ===

On systems that lack updated dependency libraries or tools, you must to download each and build it and install it by hand. You can do this by downloading and following installation instructions for each package separately. However OpenSCAD comes with scripts that attempt to automate this process on Linux and BSD systems, by installing everything into a folder created under $HOME/openscad_deps. This script does not build typical development dependencies like X11, Qt4, gcc, bash etc. But it attempts things like OpenCSG, CGAL, boost, etc.

To run the automated script, first set up the environment variables (if you don't use bash, replace "source" with a single ".")

<syntaxhighlight lang="bash">
source scripts/setenv-unibuild.sh
</syntaxhighlight>

Then, run a second script to download and build.

<syntaxhighlight lang="bash">
./scripts/uni-build-dependencies.sh 
</syntaxhighlight>

(If you only need CGAL or OpenCSG, you can just run ' ./scripts/uni-build-dependencies.sh cgal' or opencsg and it builds only a single library.)

The complete download and build process can take several hours, depending on your network connection speed and system speed. It is recommended to have at least 2 Gigabyte of free disk space to do the full dependency build. Each time you log into a new shell and wish to re-compile OpenSCAD you need to re-run the 'source scripts/setenv-unibuild.sh' script. 

After completion, return to the section above on 'verifying dependencies' to see if they installed correctly. 

=== Build the OpenSCAD binary ===

Once you have installed your dependencies, you can build OpenSCAD. 

<syntaxhighlight lang="bash">
qmake       # or qmake-qt4, depending on your distribution
make
</syntaxhighlight>


You can also install OpenSCAD to /usr/local/ if you wish. The 'openscad' binary is put under /usr/local/bin, the libraries and examples reside under something like /usr/local/share/openscad possibly depending on your system. Note that if you have previously installed a binary linux package of openscad, you should take care to delete /usr/local/lib/openscad and /usr/local/share/openscad because they are not the same paths as what the standard qmake-built 'install' target uses. 

<syntaxhighlight lang="bash">
sudo make install
</syntaxhighlight>


<blockquote>
{| style="background-color:#ffffcc;" cellpadding="10"
|'''Note:''' on Debian-based systems create a package and install OpenSCAD using:
<syntaxhighlight lang="bash">
sudo checkinstall -D make install
</syntaxhighlight>
|}
</blockquote>


If you prefer not to install you can run "<code>./openscad</code>" directly whilst still in the <code>~/openscad</code> directory.
=== Experimental ===
[[File:OpenSCAD-2017-01-06-experimental-build.png|thumb|OpenSCAD 2017-01-06 experimental-build,<br /> all experimental features enabled]]
To enable the experimental features, remake the project with ''CONFIG+=experimental'':

<syntaxhighlight lang="bash">
qmake CONFIG+=experimental
make -B
</syntaxhighlight>

The -B is only required once (when you have changed the config).

The experimental features are disabled by default, even when explicitly build as experimental build.

When you successfully build, you find a "features" tab in the preferences, where you can enable individual experimental features.


''Alternatively,'' you may add
 CONFIG+=experimental
as the first line of <b>openscad.pro</b>.

== Compiling the test suite ==

OpenSCAD comes with over 740 regression tests. To build and run them, it is recommended to first build the GUI version of OpenSCAD by following the steps above, including the downloading of MCAD. Then, from the same login, run these commands:

<syntaxhighlight lang="bash">
 cd tests
 mkdir build && cd build
 cmake .. 
 make
 ctest -C All
</syntaxhighlight>

The file 'openscad/doc/testing.txt' has more information. Full test logs are under <code>tests/build/Testing/Temporary</code>. A pretty-printed index.html web view of the tests can be found under a machine-specific subdirectory thereof and opened with a browser.

== Troubleshooting ==

If you encounter any errors when building, please file an issue report at https://github.com/openscad/openscad/issues/ . 

=== Errors about incompatible library versions ===

This may be caused by old libraries living in /usr/local/lib like boost, CGAL, OpenCSG, etc, (often left over from previous experiments with OpenSCAD). You are advised to remove them. To remove, for example, CGAL, run rm -rf /usr/local/include/CGAL && rm -rf /usr/local/lib/*CGAL*. Then erase $HOME/openscad_deps, remove your openscad source tree, and restart fresh. As of 2013 OpenSCAD's build process does not advise nor require anything to be installed in /usr/local/lib nor /usr/local/include. 

Note that CGAL depends on Boost and OpenCSG depends on GLEW - interdependencies like this can really cause issues if there are stray libraries in unusual places. 

Another source of confusion can come from running from within an 'unclean shell'. Make sure that you don't have LD_LIBRARY_PATH set to point to any old libraries in any strange places. Also don't mix a Mingw windows cross build with your linux build process - they use different environment variables and may conflict.

=== OpenCSG didn't automatically build ===

If for some reason the recommended build process above fails to work with OpenCSG, please file an issue on the OpenSCAD github. In the meantime, you can try building it yourself. 

<syntaxhighlight lang="bash">
  wget http://www.opencsg.org/OpenCSG-1.3.2.tar.gz
  sudo apt-get purge libopencsg-dev libopencsg1 # or your system's equivalent
  tar -xvf OpenCSG-1.3.2.tar.gz
  cd OpenCSG-1.3.2
  # edit the Makefile and remove 'example'
  make
  sudo cp -d lib/lib* $HOME/openscad_deps/lib/
  sudo cp include/opencsg.h $HOME/openscad_deps/include/
</syntaxhighlight>

<blockquote>
{| style="background-color:#ffffcc;" cellpadding="10"
|'''Note:''' on Debian-based systems (such as Ubuntu), you can add the 'install' target to the OpenCSG Makefile, and then use checkinstall to create a clean .deb package for install/removal/upgrade. Add this target to Makefile:
<syntaxhighlight lang="make">
 install:
 	# !! THESE LINES PREFIXED WITH ONE TAB, NOT SPACES !!
 	cp -d lib/lib* /usr/local/lib/
 	cp include/opencsg.h /usr/local/include/
 	ldconfig
</syntaxhighlight>

Then:
<syntaxhighlight lang="bash">
 sudo checkinstall -D make install
</syntaxhighlight>
.. to create and install a clean package.
|}
</blockquote>

=== CGAL didn't automatically build ===

If this happens, you can try to [[OpenSCAD User Manual/CGAL From Source|compile CGAL yourself]]. It is recommended to install to $HOME/openscad_deps and otherwise follow the build process as outlined above. 

=== Compiling fails with an Internal compiler error from GCC or GAS ===

This can happen if you run out of virtual memory, which means all of physical RAM as well as virtual swap space from the disk. See below under "horribly slow" for reasons. If you are non-root, there are a few things you can try. The first is to use the 'clang' compiler, as it uses much less RAM than gcc. The second thing is to edit the Makefile and remove the '-g' and '-pipe' flags from the compiler flags section.

If, on the other hand, you are root, then you can expand your swap space. On Linux this is pretty standard procedure and easily found in a web search. Basically you do these steps (after verifying you have no file named /swapfile already):

    sudo dd if=/dev/zero of=/swapfile bs=1M count=2000  # create a roughly 2 gig swapfile 
    sudo chmod 0600 /swapfile # set proper permissions for security
    sudo mkswap /swapfile  # format as a swapfile 
    sudo swapon /swapfile  # turn on swap

For permanent swap setup in /etc/fstab, instructions are easily found through web search. If you are building on an SSD (solid state drive) machine the speed of a swapfile allows a reasonable build time.

=== Compiling is horribly slow and/or grinds the disk ===

It is recommended to have at least 1.5 Gbyte of RAM to compile OpenSCAD. There are a few workarounds in case you don't. The first is to use the experimental support for the Clang Compiler (described below) as Clang uses much less RAM than GCC. Another workaround is to edit the Makefile generated by qmake and search/replace the optimization flags (-O2) with -O1 or blank, and to remove any '-g' debug flags from the compiler line, as well as '-pipe'.  

If you have plenty of RAM and just want to speed up the build, you can try a paralell multicore build with 

<syntaxhighlight lang="bash">
  make -jx
</syntaxhighlight> 

Where 'x' is the number of cores you want to use. Remember you need x times the amount of RAM to avoid possible disk thrashing. 

The reason the build is slow is because OpenSCAD uses template libraries like CGAL, Boost, and Eigen, which use large amounts of RAM to compile - especially CGAL. GCC may take up 1.5 Gigabytes of RAM on some systems during the build of certain CGAL modules. There is [http://stackoverflow.com/questions/3634203/why-are-templates-so-slow-to-compile more information at StackOverflow.com].

=== BSD issues ===

The build instructions above are designed to work unchanged on FreeBSD and NetBSD. However the BSDs typically require special environment variables set up to build any QT project - you can set them up automatically by running

    source ./scripts/setenv-unibuild.sh

NetBSD 5.x, requires a [[User:Dbright/patch_cgal_for_netbsd|patched version of CGAL]]. It is recommended to upgrade to NetBSD 6 instead as it has all dependencies available from pkgin. NetBSD also requires the X Sets to be installed when the system was created ([http://ghantoos.org/2009/05/12/my-first-shot-of-netbsd/ or added later]). 

On OpenBSD it may fail to build after running out of RAM. OpenSCAD requires at least 1 Gigabyte to build with GCC. You may have need to be a user with 'staff' level access or otherwise alter required system parameters. The 'dependency build' sequence has also not been ported to OpenBSD so you must rely on the standard OpenBSD system package tools (in other words you have to have root).

=== Sun / Solaris / IllumOS / AIX / IRIX / Minix / etc ===

The OpenSCAD dependency builds have been mainly focused on Linux and BSD systems like Debian or FreeBSD. The 'helper scripts' are likely to fail on other types of Un*x. Furthermore the OpenSCAD build system files (qmake .pro files for the GUI, cmake CMakeFiles.txt for the test suite) have not been tested thoroughly on non-Linux non-BSD systems. Extensive work may be required to get a working build on such systems.

=== Test suite problems ===

'''Headless server'''

The test suite tries to automatically detect if you have an X11 DISPLAY environment variable set. If not, it tries to automatically start Xvfb or Xvnc (virtual X framebuffers) if they are available. 

If you want to run these servers manually, you can attempt the following:

 $ Xvfb :5 -screen 0 800x600x24 &
 $ DISPLAY=:5 ctest

Alternatively:

 $ xvfb-run --server-args='-screen 0 800x600x24' ctest

There are some cases where Xvfb/Xvnc won't work. Some older versions of Xvfb may fail and crash without warning. Sometimes Xvfb/Xvnc have been built without GLX (OpenGL) support and OpenSCAD won't be able to generate any images. 

'''Image-based tests takes a long time, they fail, and the log says 'return -11' '''

Imagemagick may have crashed while comparing the expected images to the test-run generated (actual) images. You can try using the alternate ImageMagick comparison method by by erasing CMakeCache, and re-running cmake with <code>-DCOMPARATOR=ncc</code>. This enables the Normalized Cross Comparison method which is more stable, but possibly less accurate and may give false positives or negatives.

'''Testing images fails with 'morphology not found" for ImageMagick in the log'''

Your version of imagemagick is old. Upgrade imagemagick, or pass -DCOMPARATOR=old to cmake, otherwise the comparison reliability is reduced.

=== I moved the dependencies I built and now openscad won't run ===

It isn't advised to move them because the build is using RPATH hard coded into the openscad binary. You may try to workaround by setting the LD_LIBRARY_PATH environment variable to place yourpath/lib first in the list of paths it searches. If all else fails, you can re-run the entire dependency build process but export the BASEDIR environment variable to your desired location, before you run the script to set environment variables.

== Tricks and tips ==

=== Reduce space of dependency build === 

After you have built the dependencies you can free up space by removing the $BASEDIR/src directory - where $BASEDIR defaults to $HOME/openscad_deps.

=== Preferences ===

OpenSCAD's config file is kept in ~/.config/OpenSCAD/OpenSCAD.conf. 

=== Setup environment to start developing OpenSCAD in Ubuntu 11.04 ===

The following paragraph describes an easy way to setup a development environment for OpenSCAD in Ubuntu 11.04. After executing the following steps QT Creator can be used to graphically start developing/debugging OpenSCAD.
* Add required PPA repositories:
<syntaxhighlight  lang="bash">
# sudo add-apt-repository ppa:chrysn/openscad
</syntaxhighlight>
* Update and install required packages:
<syntaxhighlight  lang="bash">
# sudo apt-get update
# sudo apt-get install git build-essential qtcreator libglew1.5-dev libopencsg-dev libcgal-dev libeigen2-dev bison flex
</syntaxhighlight>
* Get the OpenSCAD sources:
<syntaxhighlight  lang="bash">
# mkdir ~/src
# cd ~/src
# git clone https://github.com/openscad/openscad.git
</syntaxhighlight>
* Build OpenSCAD using the command line:
<syntaxhighlight  lang="bash">
# cd ~/src/openscad
# qmake
# make
</syntaxhighlight>
* Build OpenSCAD using QT Creator:
Just open the project file openscad.pro (CTRL+O) in QT Creator and hit the build all (CTRL+SHIFT+B) and run button (CTRL+R).

=== The Clang Compiler ===

There is experimental support for building with the Clang compiler under linux. Clang is faster, uses less RAM, and has different error messages than GCC. To use it, first of all you need CGAL of at least version 4.0.2, as prior versions have a bug that makes clang unusable. Then, run this script before you build OpenSCAD. 

<syntaxhighlight lang="bash">
 source scripts/setenv-unibuild.sh clang
</syntaxhighlight>

Clang support depends on your system's QT installation having a clang enabled qmake.conf file. For example, on Ubuntu, this is under /usr/share/qt4/mkspecs/unsupported/linux-clang/qmake.conf. BSD clang-building may require a good deal of fiddling and is untested, although eventually it is planned to move in this direction as the BSDs (not to mention OSX) are moving towards favoring clang as their main compiler.
{{BookCat}}

