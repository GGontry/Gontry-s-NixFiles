{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/packages.nix
      ./modules/amd-drivers.nix
      ./modules/fish.nix
      ./modules/fonts.nix
      ./modules/gaming.nix
      ./modules/niri-portals.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nix";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Mexico_City";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.gontry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  modules.minecraft-streamer.enable = true;

  system.stateVersion = "26.05";
}

