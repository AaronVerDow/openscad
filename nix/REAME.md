Run this in source repo: (this will not be automatically completed in file mode)
```
git submodule update --init --recursive
```

Build:
```
nix build --impure
```

Run:
```
nix run . --impure
```

Dev shell: (puts built binary in $PATH)
```
nix develop --impure
```
