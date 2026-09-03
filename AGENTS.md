# Agent Guide: Home Assistant on NixOS

Compact context for OpenCode sessions.

## Architecture
- **Target**: Proxmox/QEMU VM (x86_64-linux).
- **Entrypoint**: `flake.nix` -> `nixosConfigurations.homeassistant`.
- **Structure**:
  - `hosts/homeassistant/`: Host-specific configuration and hardware stub.
  - `modules/`: Reusable NixOS modules (e.g., `home-assistant.nix`).

## Developer Commands
- **Verify**: `nix flake check` (Catch syntax errors and missing imports).
- **Build**: `nix build .#nixosConfigurations.homeassistant.config.system.build.toplevel`
- **Deploy**: `nixos-rebuild switch --flake .#homeassistant --target-host root@<IP>`

## Critical Gotchas
- **Git Tracking**: Nix flakes only see files tracked by Git. Always `git add` new files before building.
- **Hardware Config**: `hosts/homeassistant/hardware-configuration.nix` is a stub. On a real install, replace it with output from `nixos-generate-config`.
- **Home Assistant Components**: Add new integrations via `services.home-assistant.extraComponents` in `modules/home-assistant.nix`.
- **SSH Access**: Configured in `hosts/homeassistant/configuration.nix`. Defaults to key-based auth for user `cody`.

## References
- NixOS Home Assistant Module: [nixpkgs/nixos/modules/services/home-automation/home-assistant.nix](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/home-automation/home-assistant.nix)
