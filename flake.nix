{
  description = "NixOS + Home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flakelight = {
      url = "github:accelbread/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    stardustxr = {
      url = "github:StardustXR/server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flatland.follows = "flatland";
      inputs.hercules-ci-effects.follows = "hercules-ci-effects";
      inputs.flake-parts.follows = "flake-parts";
    };
    flatland = {
      url = "github:StardustXR/flatland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  outputs = {flakelight, ...} @ inputs:
    flakelight ./. {
      inherit inputs;
      nixDir = ./.;
      nixDirAliases = {
        nixosConfigurations = ["devices"];
        nixosModules = ["nixos-modules"];
        homeModules = ["home-modules"];
      };
    };
}
