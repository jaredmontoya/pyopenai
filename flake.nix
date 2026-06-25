{
  description = "An attempt to reimplement python OpenAI API bindings in nim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      treefmt-nix,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import systems);

      treefmtEval = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix
      );
    in
    {
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./nix/shell.nix { inherit pkgs; }
      );
    };
}
