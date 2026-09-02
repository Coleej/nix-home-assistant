{
  description = "Home Assistant on NixOS";

  inputs = {
    # Track unstable so Home Assistant stays reasonably current.
    # (Nixpkgs treats the HA package/module as a snapshot on stable
    # release branches — see release notes if you pin to a stable channel instead.)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.homeassistant = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/homeassistant/configuration.nix
          ./hosts/homeassistant/hardware-configuration.nix
          ./modules/home-assistant.nix
        ];
      };
    };
}
