{
  pkgs,
  ...
}:

{
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  networking.hostName = "rpi1";

  ## WiFi using wpa_supplicant. You can even define a network with SSID and
  ## passphrase, but doing it this way will put it into the Nix store unencrypted
  # networking.wireless = {
  #   enable = true;
  #   networks.home = {
  #     ssid = "Home WiFi";
  #     psk = "ins3cureP@ssw0rd";
  #   };
  # };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root = {
    initialPassword = "changeme";
    ## Grant yourself SSH access to the root user
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA alice@home"
    # ];
  };

  ## Define a non-root user
  # users.users.alice = {
  #   description = "Alice";
  #   extraGroups = [
  #     "dialout"
  #     "plugdev"
  #     "wheel"
  #   ];
  #   group = "alice";
  #   isNormalUser = true;
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA alice@home"
  #   ];
  # };
  # users.groups.alice = { };

  ## Some niceties for remote administration
  security.sudo.wheelNeedsPassword = false;
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  environment.systemPackages = with pkgs; [
    fastfetch
    rsync
  ];
}
