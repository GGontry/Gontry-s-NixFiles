{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
    "electron-40.10.5"
  ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  nixpkgs.config.allowUnFree = true;

  environment.systemPackages = with pkgs; [
    kitty
    rofi
    keepassxc
    zed-editor
    eww
    btop
    waypaper
    awww
    nwg-look
    xarchiver file-roller
    zip unzip
    xdg-user-dirs
    cliphist wl-clipboard
    xwayland-satellite
    chatterino7
    inputs.zen-browser.packages."${pkgs.system}".default
    tauon
    kdePackages.kdenlive
    mpv
    fastfetch
    opencode
    krita
    davinci-resolve
    ffmpeg-full
    smile
    gnome-software
    easyeffects
    loupe
    yt-dlp
    grim
    slurp
    satty
    stown
  ];

  programs.tmux.enable = true;
  programs.niri.enable = true;
  programs.neovim.enable = true;
  programs.git.enable = true;
  programs.xwayland.enable = true;
  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # ===== ===== ===== ===== =====
  # Options with plugins
  # ===== ===== ===== ===== =====

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  }; 
}
