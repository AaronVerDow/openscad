{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        openscad = pkgs.libsForQt5.callPackage ./default.nix { };
      };

      defaultPackage.${system} = self.packages.${system}.openscad;
    };
}
