# NixOS configuration for this iximiuz Labs playground.
#
# Edit this file and apply the changes with `sudo nixos-rebuild switch`.
# The playground-specific parts of the system live in ./iximiuz.nix -
# changing them may break the playground.
{ config, lib, pkgs, ... }:

{
  imports = [ ./iximiuz.nix ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    bash-completion
    bind.dnsutils
    btop
    curl
    file
    fzf
    gettext
    git
    gnupg
    htop
    iproute2
    iptables
    iputils
    jq
    kmod
    lsof
    mtr
    nano
    ncdu
    netcat-openbsd
    nftables
    procps
    psmisc
    ripgrep
    socat
    strace
    tcpdump
    tmux
    traceroute
    tree
    unzip
    vim
    wget
    yq-go
  ];
}
