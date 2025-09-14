{
  description = "Interactive Qt graphViz display";

  inputs = {
    gepetto.url = "github:gepetto/nix";
    flake-parts.follows = "gepetto/flake-parts";
    nixpkgs.follows = "gepetto/nixpkgs";
    nix-ros-overlay.follows = "gepetto/nix-ros-overlay";
    systems.follows = "gepetto/systems";
    treefmt-nix.follows = "gepetto/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.gepetto.flakeModule ];
      perSystem =
        {
          lib,
          pkgs,
          self',
          ...
        }:
        {
          packages = {
            default = self'.packages.qgv;
            qgv = pkgs.qgv.overrideAttrs (_: {
              src = lib.fileset.toSource {
                root = ./.;
                fileset = lib.fileset.unions [
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
