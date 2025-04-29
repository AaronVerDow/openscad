# Requirements

* Xcode
* Homebrew packages:
    * automake
    * libtool
    * cmake
    * pkg-config
    * wget
    * meson
    * python-packaging

# Install with Homebrew

This assumes [Homebrew](https://brew.sh/) is already installed.

    ./scripts/macosx-build-homebrew.sh

# Install from Source

Run the script that sets up the environment variables:

    source scripts/setenv-macos.sh

Then run the script to compile all the dependencies:

    ./scripts/macosx-build-dependencies.sh
