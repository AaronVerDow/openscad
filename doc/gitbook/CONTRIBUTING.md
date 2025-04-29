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
