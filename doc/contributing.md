# Contributing

This is a quick reference for contributing, see [Building OpenSCAD from Sources](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Building_OpenSCAD_from_Sources) in the wiki book for more detailed information.

# Style Guide

The OpenSCAD coding style is encoded in `.uncrustify.cfg`.

Coding style highlights:

* Use 2 spaces for indentation
* Use C++11 functionality where applicable. Please read [Scott Meyer's Effective Modern C++](https://shop.oreilly.com/product/0636920033707.do) for a good primer on modern C++ style and features.

## Beautifying code

Code to be committed can be beautified by installing [uncrustify](https://github.com/uncrustify/uncrustify) and running
`scripts/beautify.sh`. This will, by default, beautify all files that are currently changed.

Alternatively, it's possible to beautify the entire codebase by running `scripts/beautify.sh --all`. This is not recommended except in special cases like:
* We're upgrading uncrustify to fix rules globally.
* You're bringing an old branch to life and want to minimize conflict cause by the large coding style update.

**Note:** Uncrustify is in heavy development and tends to introduce breaking changes from time to time.
OpenSCAD has been tested against uncrustify commit `a05edf605a5b1ea69ac36918de563d4acf7f31fb` (Dec 24 2017).

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

# Pre-Release Checklist

* [ ] Update translations:
  * [ ] Send emails to translation managers, see [.po files](https://github.com/openscad/openscad/tree/master/locale)
* [ ] Update resources/html/AboutDialog.html with new contributors etc.
* [ ] Merge MCAD
  * [ ] In MCAD clone:

        $ git fetch upstream
        $ git merge upstream/master
        $ git push

  * [ ] In OpenSCAD: (See bottom of this file for how to build release binaries)

        $ cd libraries/MCAD
        $ git pull
        $ cd ../..
        $ git commit -m "Updated MCAD" libraries/MCAD
        $ git push

# Release Checklist

* [ ] Update manpage: doc/openscad.1
* [ ] Update releases/$VERSION.md
* [ ] scripts/makereleasenotes.sh
* [ ] Update version number in doc/openscad.1
* [ ] Update copyright year in resources/html/AboutDialog.html and src/gui/MainWindow.cc
* [ ] Add VERSION and VERSIONDATE in openscad.pro, scripts/publish-macosx.sh, scripts/release-common.sh tests/CMakeLists.txt
* [ ] Add VERSION in tests/CMakeLists.txt, scripts/publish-mingw-x.sh
* [ ] Tag release

      git tag "openscad-$VERSION"

* [ ] Revert VERSION and VERSIONDATE in openscad.pro scripts/publish-macosx.sh scripts/release-common.sh scripts/publish-mingw-x.sh tests/CMakeLists.txt
* [ ] build source package

      scripts/git-archive-all.py --prefix=openscad-$VERSION/ openscad-$VERSION.src.tar.gz

* [ ] Sanity check; build a binary or two and manually run some tests
* [ ] git push --tags master
* [ ] Upload Source package

      scp openscad-$VERSION.src.tar.gz openscad@files.openscad.org:www

* [ ] Build binaries for all platforms and wait for upload
* [ ] ./scripts/github-release.sh $VERSION
* [ ] Write release email/blog entry
* [ ] Update web page:
  * [ ] news.html
  * [ ] inc/src_release_links.js
* [ ] Update external resources:
  * [ ] https://en.wikipedia.org/wiki/OpenSCAD
* [ ] Write to mailing list
* [ ] Tweet as OpenSCAD
* [ ] Notify package managers
  * [ ] Debian/Ubuntu: https://launchpad.net/~chrysn
  * [ ] Ubuntu PPA: https://github.com/hyperair
  * [ ] Fedora: Miro Hrončok <miro@hroncok.cz> or <mhroncok@redhat.com>
  * [ ] OpenSUSE: Pavol Rusnak <prusnak@opensuse.org>
  * [ ] Arch Linux: Kyle Keen <keenerd@gmail.com>
  * [ ] MacPorts: https://svn.macports.org/repository/macports/trunk/dports/science/openscad/Portfile
  * [ ] Homebrew: https://github.com/caskroom/homebrew-cask/blob/master/Casks/openscad.rb
* [ ] Update dev version to release version in documentation
  * [ ] https://en.wikibooks.org/wiki/OpenSCAD_User_Manual

## Build and Upload Release Binaries

    tar xzf openscad-$VERSION.src.tar.gz
    cd openscad-$VERSION

### Mac OS X:

    ./scripts/publish-macosx.sh -> OpenSCAD-$VERSION.dmg

### Linux:

* 32-bit: run on a 32-bit machine or VM
* 64-bit: run on a 64-bit machine or VM

* Where ARCH will be detected and set to 32 or 64:

      ./scripts/release-common.sh -> openscad-$VERSION.x86-ARCH.tar.gz

* Update web page with download links

      scp openscad-$VERSION.x86-ARCH.tar.gz openscad@files.openscad.org:www

### Windows mingw cross-build:

__FIXME:__ Adapt scripts/builder.sh to build release binaries
