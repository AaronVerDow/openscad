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

# Patch Checklist

Given: VERSION (e.g. 2015.03-1)

* [ ] Make sure we have a $VERSION branch. If not, create one
* [ ] Update releases/$VERSION.md
* [ ] scripts/makereleasenotes.sh
* [ ] Update VERSION and VERSIONDATE in
  * [ ] openscad.pro
  * [ ] scripts/publish-macosx.sh
  * [ ] scripts/release-common.sh
  * [ ] scripts/publish-mingw-x.sh
  * [ ] tests/CMakeLists.txt
  
* [ ] git tag "openscad-$VERSION"
* [ ] ./scripts/git-archive-all.py --prefix=openscad-$VERSION/ openscad-$VERSION.src.tar.gz
* [ ] git push --tags
* [ ] Upload Source package

      scp openscad-$VERSION.src.tar.gz openscad@files.openscad.org:www

* [ ] Revert VERSION and VERSIONDATE in openscad.pro scripts/publish-macosx.sh scripts/release-common.sh scripts/publish-mingw-x.sh tests/CMakeLists.txt
* [ ] Write short release email to mailing list
* [ ] Tweet as OpenSCAD
* [ ] Notify package managers
  * [ ] Debian/Ubuntu: https://launchpad.net/~chrysn
  * [ ] Ubuntu PPA: https://github.com/hyperair
  * [ ] Fedora: Miro Hrončok <miro@hroncok.cz> or <mhroncok@redhat.com>
  * [ ] OpenSUSE: Pavol Rusnak <prusnak@opensuse.org>
  * [ ] Arch Linux: Kyle Keen <keenerd@gmail.com>
  * [ ] MacPorts: https://svn.macports.org/repository/macports/trunk/dports/science/openscad/Portfile
  * [ ] Homebrew: https://github.com/caskroom/homebrew-cask/blob/master/Casks/openscad.rb
