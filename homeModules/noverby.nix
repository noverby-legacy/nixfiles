{...}: {
  imports = [./home.nix ./systemd.nix ./packages.nix ./dconf.nix ./xdg.nix ./file ./programs];

  nixpkgs.config.allowUnfree = true;
}
