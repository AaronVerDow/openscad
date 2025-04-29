# Building for WebAssembly

We support building OpenSCAD headless for WebAssembly w/ Emscripten, using a premade Docker image built in [openscad/openscad-wasm](https://github.com/openscad/openscad-wasm) (which also has usage examples)

## Browser

The following command creates `build-web/openscad.wasm` & `build-web/openscad.js`:

```bash
./scripts/wasm-base-docker-run.sh emcmake cmake -B build-web -DCMAKE_BUILD_TYPE=Debug -DEXPERIMENTAL=1
./scripts/wasm-base-docker-run.sh cmake --build build-web -j2
```

[openscad/openscad-playground](https://github.com/openscad/openscad-playground) uses this WASM build to provide a [Web UI](https://ochafik.com/openscad2/) with a subset of features of OpenSCAD.

> [!NOTE]
> With a debug build (`-DCMAKE_BUILD_TYPE=Debug`), you can set C++ breakpoints in Firefox and in Chrome (the latter [needs an extension](https://developer.chrome.com/docs/devtools/wasm)).

# Standalone node.js build

The following command creates `build-node/openscad.js`, which is executable (requires `node`):

```bash
./scripts/wasm-base-docker-run.sh emcmake cmake -B build-node -DWASM_BUILD_TYPE=node -DCMAKE_BUILD_TYPE=Debug -DEXPERIMENTAL=1
./scripts/wasm-base-docker-run.sh cmake --build build-node -j2
build-node/openscad.js --help
```

> [!NOTE]
> With a debug build (`-DCMAKE_BUILD_TYPE=Debug`), you can set C++ breakpoints in VSCode + Node ([needs an extension](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_debugging-webassembly)).
