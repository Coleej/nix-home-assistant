# PLACEHOLDER — replace this entire file with the one NixOS generates
# for you on the actual VM.
#
# After booting the NixOS installer in the VM and partitioning disks,
# run:
#
#   nixos-generate-config --root /mnt
#
# Then copy /mnt/etc/nixos/hardware-configuration.nix here, overwriting
# this file. It contains the disk UUIDs, filesystem layout, and kernel
# modules specific to this VM instance and will differ from this stub.
#
# A typical Proxmox VM (virtio-scsi disk, virtio net) hardware config
# looks roughly like this:

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # These will be generated with your VM's actual UUIDs — do not hand-copy
  # the ones below, they will not match your disk.
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0000-0000";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
