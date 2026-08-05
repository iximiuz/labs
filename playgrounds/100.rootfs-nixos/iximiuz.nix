# iximiuz Labs playground plumbing - the parts of the system that make it run
# on the playground engine. Editing this file may break the playground; put
# your own configuration into ./configuration.nix instead.
#
# The produced system is not self-bootable on purpose: the playground engine
# boots the machine with its own kernel (and force-copies the matching /boot
# and /lib/modules into this rootfs at play start), so the NixOS kernel,
# initrd, and bootloader are all disabled.
{ config, lib, pkgs, ... }:

let
  labUser = "laborant";
in
{
  nixpkgs.hostPlatform = "x86_64-linux";

  #
  # --- Boot: platform kernel, no initrd, no bootloader ---
  #

  boot.kernel.enable = false;
  boot.initrd.enable = false;
  boot.loader.grub.enable = false;

  # The VMM boots the kernel with root=/dev/vda and no initrd; this entry only
  # satisfies the module system (the actual mount is done by the kernel).
  fileSystems."/" = {
    device = "/dev/vda";
    fsType = "ext4";
  };

  # NixOS' kmod is patched to look up modules under
  # /run/booted-system/kernel-modules/lib/modules instead of /lib/modules.
  # The engine puts the platform kernel's modules into /lib/modules, so point
  # the toplevel's kernel-modules link at the filesystem root.
  system.systemBuilderCommands = ''
    ln -sfn / $out/kernel-modules
  '';

  # Kernel-initiated module auto-loading execs /sbin/modprobe by default,
  # which does not exist on NixOS.
  boot.postBootCommands = ''
    echo /run/current-system/sw/bin/modprobe > /proc/sys/kernel/modprobe
  '';

  #
  # --- Engine-managed files ---
  #
  # The playground engine writes these directly into the rootfs before every
  # boot; they must remain regular files, not NixOS-managed symlinks into
  # /nix/store (the engine refuses to write through absolute symlinks).
  #

  # Extra drives are mounted via the engine-written /etc/fstab
  # (picked up by systemd-fstab-generator).
  environment.etc.fstab.enable = lib.mkForce false;

  # Multi-machine playgrounds get their /etc/hosts from the engine.
  environment.etc.hosts.enable = lib.mkForce false;

  # The engine writes /etc/hostname; systemd picks it up at boot.
  networking.hostName = "";

  # The engine writes /etc/resolv.conf.
  networking.resolvconf.enable = false;
  services.resolved.enable = false;

  # The primary NIC is configured via the ip= kernel argument; secondary NICs
  # get engine-written *.network files in /etc/systemd/network.
  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.wait-online.enable = false;

  networking.firewall.enable = false;

  #
  # --- Users ---
  #
  # Mirrors hack/rootfs/scripts/add-lab-user.sh; keep uid/gid in sync with the
  # /etc/passwd and /etc/group baked into the image by the Dockerfile (the
  # engine resolves users at bake time, before the first activation runs).
  #

  users.mutableUsers = true;
  users.groups.${labUser}.gid = 1001;
  users.users.${labUser} = {
    isNormalUser = true;
    uid = 1001;
    group = labUser;
    extraGroups = [ "wheel" ];
    initialPassword = labUser;
  };
  users.users.root.initialPassword = "root";
  security.sudo.wheelNeedsPassword = false;

  #
  # --- SSH ---
  #

  services.openssh = {
    enable = true;
    # SSHD over VSOCK (see /opt/iximiuz-labs/capabilities) is served by
    # systemd-ssh-generator's AF_VSOCK socket (systemd >= 256 auto-creates it
    # in VMs, and it reads the same /etc/ssh/sshd_config); adding a vsock
    # listener to sshd.socket here would race it for vsock:22 and fail the
    # whole unit, taking the TCP listener down with it. This socket serves
    # TCP only.
    startWhenNeeded = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      AddressFamily = "any";
      AuthenticationMethods = "publickey";
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 5;
      MaxSessions = 10;
      MaxStartups = "10:30:100";
      PasswordAuthentication = false;
      PrintLastLog = "no";
      UseDns = false;
    };
  };

  #
  # --- iximiuz Labs examiner (in-guest agent) ---
  #
  # Mirrors hack/rootfs/scripts/set-up-systemd-examiner-service.sh: the
  # examiner is reachable over vsock, so it doesn't wait for the network -
  # it's ordered right after local filesystems instead.
  #

  systemd.services.examiner = {
    description = "Examiner";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    before = [ "shutdown.target" ];
    unitConfig = {
      DefaultDependencies = false;
      Conflicts = [ "shutdown.target" ];
    };
    environment = {
      HOME = "/root";
      LAB_USER = labUser;
      PATH = lib.mkForce "/run/wrappers/bin:/run/current-system/sw/bin:/usr/local/bin";
    };
    serviceConfig = {
      ExecStart = "/usr/local/bin/examiner";
      OOMScoreAdjust = -1000;
      Restart = "always";
      RestartSec = 5;
      Type = "simple";
    };
  };

  #
  # --- VMM notify hooks ---
  #
  # On other distros the engine drops these units into /etc/systemd/system at
  # bake time, but on NixOS that path is a symlink into /nix/store, so the
  # units are declared here instead (mirroring bender/plays/vmmhooks/*.service,
  # minus the network-online ordering - the notifier talks over vsock). The
  # engine still installs the /usr/local/bin/vmm-notifier script itself.
  #

  systemd.services.vmm-notify-poweroff = {
    description = "Notify VMM on poweroff";
    wantedBy = [ "poweroff.target" ];
    before = [ "systemd-poweroff.service" ];
    # The engine-installed script needs these on PATH (units only get NixOS'
    # minimal default unit path, not environment.systemPackages).
    path = with pkgs; [ curl netcat-openbsd socat ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      ExecStart = "/usr/local/bin/vmm-notifier poweroff";
      KillMode = "process";
      SendSIGKILL = false;
      TimeoutStartSec = "5s";
      Type = "oneshot";
    };
  };

  systemd.services.vmm-notify-reboot = {
    description = "Notify VMM on reboot";
    wantedBy = [ "reboot.target" ];
    before = [ "systemd-reboot.service" ];
    path = with pkgs; [ curl netcat-openbsd socat ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      ExecStart = "/usr/local/bin/vmm-notifier reboot";
      KillMode = "process";
      SendSIGKILL = false;
      TimeoutStartSec = "5s";
      Type = "oneshot";
    };
  };

  #
  # --- code-server (IDE) ---
  #
  # Mirrors hack/rootfs/scripts/get-code-server.sh: code-server on
  # 127.0.0.1:50062, exposed on 0.0.0.0:50061 via a socket-activated proxy.
  #

  systemd.services.code-server = {
    description = "code-server";
    environment.HOME = "/home/${labUser}";
    serviceConfig = {
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.code-server}/bin/code-server"
        "--bind-addr=127.0.0.1:50062"
        "--auth none"
        "--disable-telemetry"
        "--disable-update-check"
        "--disable-workspace-trust"
        "--disable-getting-started-override"
        "--app-name=\"iximiuz Labs\""
        "/home/${labUser}"
      ];
      Restart = "on-failure";
      Type = "exec";
      User = labUser;
    };
  };

  systemd.services.code-server-proxy = {
    description = "code-server proxy";
    after = [ "code-server.service" ];
    requires = [ "code-server.service" ];
    serviceConfig.ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:50062";
  };

  systemd.sockets.code-server-proxy = {
    description = "code-server proxy socket";
    wantedBy = [ "sockets.target" ];
    unitConfig.PartOf = "code-server-proxy.service";
    socketConfig = {
      Accept = "no";
      ListenStream = "0.0.0.0:50061";
      NoDelay = true;
    };
  };

  #
  # --- Environment ---
  #

  # Engine-baked tools (examiner, examinerctl, kexp, vmm-notifier) land in
  # /usr/local/bin.
  environment.extraInit = ''
    export PATH="$PATH:/usr/local/bin"
  '';

  # Print (and then remove) the engine-provided welcome message on the first
  # interactive shell (mirrors hack/rootfs/scripts/customize-bashrc.sh).
  programs.bash.interactiveShellInit = ''
    if [ -t 0 ] && [ -f "$HOME/.welcome" ]; then
      if [ -x "$HOME/.welcome" ]; then
        "$HOME/.welcome"
      else
        cat "$HOME/.welcome"
      fi

      echo
      rm -f "$HOME/.welcome"
    fi
  '';

  #
  # --- Nix ---
  #

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz"
  ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  documentation.nixos.enable = false;
}
