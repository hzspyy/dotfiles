{
  description = "Darwin configuration";

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    # 建议使用 unstable 以获取最新软件，或者锁定到 24.11
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
  let
    # 1. 定义系统架构和 pkgs 实例
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # 2. 这里告诉 Nix：当运行 `nix fmt` 时，使用 nixpkgs-fmt 这个包
    formatter.${system} = pkgs.nixpkgs-fmt;

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