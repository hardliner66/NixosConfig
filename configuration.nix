# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  allow_unfree      = true;
  user_name         = "steve";
  user_is_admin     = true;
  hostname          = "nixos0";
  domainname        = "local";
  timezone          = "Europe/Vienna";
  keymap            = "de";
  locale            = "de_DE";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  virtualisation.virtualbox.guest.enable = true;

  fileSystems."/vboxshare" =
  {
    fsType = "vboxsf";
    device = "shared";
    options = [ "rw" ];
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only


  boot.initrd.checkJournalingFS = false;
  
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "${keymap}";
    defaultLocale = "${locale}.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "${timezone}";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    bash
    smartmontools
    vscode
    git
    google-chrome
  ];

  fonts.fonts = with pkgs; [
    fira-code
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Enable avahi
  services.avahi = {
    enable = true;
    hostName = "${hostname}";
    domainName = "${domainname}";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "${keymap}";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.desktopManager = {
    xfce.enable = true;
    default = "xfce";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.${user_name} = {
    isNormalUser = true;
    home = "/home/${user_name}";
    extraGroups = if user_is_admin then ["wheel"] else [];
  };

  networking = {
    domain = "${domainname}";
    hostName = "${hostname}";
    wireless.enable = false;
  };

  nixpkgs.config = {
    allowUnfree = allow_unfree;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
