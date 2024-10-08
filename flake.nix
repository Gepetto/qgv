{
  description = "Interactive Qt graphViz display";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, self', ... }:
        {
          devShells.default = pkgs.mkShell { inputsFrom = [ self'.packages.default ]; };
          packages = {
            default = self'.packages.qgv;
            qgv = pkgs.qgv.overrideAttrs (_: {
              src = pkgs.lib.fileset.toSource {
                root = ./.;
                fileset = pkgs.lib.fileset.unions [
                  ./cmake_modules
                  ./CMakeLists.txt
                  ./doc
                  ./package.xml
                  ./QGraphViz.pro
                  ./QGVCore
                  ./Sample
                ];
              };
            });
          };
        };
    };
}
