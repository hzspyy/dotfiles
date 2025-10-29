# flake.nix
{
  description = "Darwin configuration";

  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";             # ???
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    {
      darwinConfigurations = {
        "smc-mac" = nix-darwin.lib.darwinSystem {
          modules = [
            ./configuration.nix
            ./homebrew.nix
            {
              options = {
                isPersonal = nixpkgs.lib.mkOption {
                  type = nixpkgs.lib.types.bool;
                  default = false;
                };
              };
              config.isPersonal = true;
            }
          ];
        };
      };
    };
}
