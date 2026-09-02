# Home Assistant on NixOS

Basic flake-based NixOS config for a Home Assistant VM. Deliberately
minimal — `services.home-assistant.extraComponents` and `.config` are
where you'll add Hatch/AiDot/etc. once the base VM is up.

## Layout

```
flake.nix
hosts/homeassistant/
  configuration.nix        # host-level config: users, network, ssh
  hardware-configuration.nix  # PLACEHOLDER — replace after install
modules/
  home-assistant.nix        # the actual HA service config
```

## Deploy steps

1. Create the Proxmox VM (specs below), attach the NixOS minimal ISO,
   boot it.
2. Partition/format disks and mount at `/mnt` per the standard NixOS
   manual install (or use `disko` later if you want that declarative
   too — not included here to keep this basic).
3. `nixos-generate-config --root /mnt`, then replace
   `hosts/homeassistant/hardware-configuration.nix` in this repo with
   the one it generated.
4. Set a real SSH key in `configuration.nix` (`users.users.cody`)
   before you lose console access.
5. Copy this flake onto the VM (or clone your homelab repo containing
   it) and run:
   ```
   nixos-install --root /mnt --flake .#homeassistant
   ```
6. Reboot, SSH in, and from then on manage it the normal flake way:
   ```
   nixos-rebuild switch --flake .#homeassistant
   ```
7. Browse to `http://<vm-ip>:8123` and complete onboarding.

## Proxmox VM specs

| Setting        | Recommendation                                   |
|----------------|---------------------------------------------------|
| vCPUs          | 2 (bump to 4 once you add heavier integrations/automations) |
| RAM            | 4 GB minimum, 6–8 GB if you'll add Zigbee/Z-Wave, a local voice pipeline, or a recorder database with long history |
| Disk           | 32 GB (virtio-scsi single, discard/SSD-emulation on if your Proxmox storage is SSD/NVMe-backed) |
| BIOS           | OVMF (UEFI) — matches the `systemd-boot` config here |
| Machine type   | q35 |
| Network        | virtio, bridged to `vmbr0` (not NAT) — matters later for local-discovery integrations like AiDot |
| Guest agent    | Enable "QEMU Guest Agent" in VM Options — this config installs `qemu-guest.nix` + `services.qemuGuest.enable` to match |
| Display        | Serial console is fine; you'll mostly SSH in |

2 GB RAM will technically boot Home Assistant, but you'll be tight
once you add a handful of integrations and the recorder starts
accumulating history — 4 GB is a more comfortable floor.

## Notes

- This tracks `nixos-unstable` so Home Assistant itself stays
  reasonably current (see the flake.nix comment on why — stable
  channels snapshot the HA version at branch-off).
- `services.home-assistant.config` currently just sets `default_config
  = {}` and basic `http` options — intentionally sparse so onboarding
  can run normally. Once you're happy with the setup, you can migrate
  more of it into this file (themes, custom components, etc.) per the
  NixOS wiki.
