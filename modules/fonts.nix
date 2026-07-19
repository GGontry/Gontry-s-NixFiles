{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  
  environment.systemPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
