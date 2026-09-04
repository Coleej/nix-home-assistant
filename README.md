# Nix Home Assistant

This repository contains a NixOS configuration for running [Home Assistant](https://www.home-assistant.io/) in a Proxmox/QEMU virtual machine. It is managed using Nix Flakes and follows a modular design for easy customization.

## Features

- **NixOS-based**: Fully declarative and reproducible system configuration.
- **Home Assistant**: Automated home automation platform.
- **Proxmox Optimized**: Includes QEMU guest agent and standard UEFI boot configuration.
- **Tailscale Integration**: Secure remote access out of the box.
- **Modular Structure**: Easily add new modules or customize host configurations.

## Repository Structure

- `flake.nix`: The entry point for the Nix Flake configuration.
- `hosts/homeassistant/`: Host-specific configuration files.
  - `configuration.nix`: Main system configuration (networking, users, services).
  - `hardware-configuration.nix`: Hardware-specific settings (currently a stub for VM use).
- `modules/`: Reusable NixOS modules.
  - `home-assistant.nix`: Configuration for the Home Assistant service and integrations.
- `AGENTS.md`: Specialized context and instructions for AI agents (OpenCode).

## Getting Started

### Prerequisites

- A Proxmox VE or QEMU-compatible environment.
- Nix installed with Flakes enabled.

### Build the Configuration

To verify the configuration and build the system toplevel:

```bash
nix build .#nixosConfigurations.homeassistant.config.system.build.toplevel
```

### Deploying

To deploy to a running NixOS VM:

```bash
nixos-rebuild switch --flake .#homeassistant --target-host root@<VM_IP>
```

## Customization

- **Users**: Update `users.users.cody` in `hosts/homeassistant/configuration.nix` with your own username and SSH keys.
- **Home Assistant**: Add integrations and components in `modules/home-assistant.nix` under `services.home-assistant.extraComponents`.
- **Hardware**: If deploying on physical hardware or a different hypervisor, generate a new `hardware-configuration.nix` using `nixos-generate-config`.
