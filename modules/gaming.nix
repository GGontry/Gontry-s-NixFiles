{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    vesktop
    discord
    mangohud

    (prismlauncher.override {
      jdks = [
        javaPackages.compiler.temurin-bin.jdk-21
	javaPackages.compiler.temurin-bin.jdk-25
	javaPackages.compiler.temurin-bin.jdk-8
	javaPackages.compiler.temurin-bin.jre-17
      ];
    })
  ];
}

