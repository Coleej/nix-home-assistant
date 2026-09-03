{
  config,
  pkgs,
  lib,
  ...
}:

{
  # --- Boot / bootloader ---------------------------------------------
  # Standard UEFI setup for a Proxmox VM with OVMF (UEFI) firmware.
  # If you instead create the VM with SeaBIOS, swap this for the
  # legacy grub.devices = [ "/dev/sda" ] approach.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ------------------------------------------------------
  networking.hostName = "homeassistant";
  networking.networkmanager.enable = true;

  # Use DHCP by default. Once you know the VM's MAC, set a DHCP
  # reservation on your router/DHCP server instead of hardcoding a
  # static IP here, so this config stays portable.
  networking.useDHCP = lib.mkDefault true;

  # --- Time / locale -----------------------------------------------
  time.timeZone = "America/Chicago"; # Austin, TX
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Users -----------------------------------------------------------
  # Replace "cody" / add your SSH key before first deploy.
  users.users.cody = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDVBIBLn0zxpC5E4mjONRgTsF95regf9Yxz+fqbiW+U cody@wsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs1I/A+CNSMC+ql+nrbV4MdWvZXa01gSAByLs2CVkA8 cody@desktop"
    ];
  };

  # --- Basic services ----------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # QEMU guest agent lets Proxmox report the VM's IP, do clean
  # shutdowns, etc.
  services.qemuGuest.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Don't change after initial
  # install unless you know what you're doing.
  system.stateVersion = "25.05";
}
