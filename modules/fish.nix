{ config, lib, pkgs, ... }:

{
  programs.fish.enable = true;

  users.extraUsers.gontry = { shell = pkgs.fish; };
}
