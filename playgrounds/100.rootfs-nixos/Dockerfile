# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE

FROM nixos/nix:latest AS builder

ARG LAB_USER
ARG NIXOS_VERSION
ARG ROOTFS_RELEASE

COPY 100.rootfs-nixos/configuration.nix 100.rootfs-nixos/iximiuz.nix /build/

RUN nix-build '<nixpkgs/nixos>' \
  -I nixpkgs=https://channels.nixos.org/nixos-${NIXOS_VERSION}/nixexprs.tar.xz \
  -I nixos-config=/build/configuration.nix \
  -A config.system.build.toplevel \
  -o /build/system

RUN <<EOF
set -eu

system="$(readlink -f /build/system)"

# Copy the system closure into a fresh store root - including /nix/var/nix/db,
# so that nix keeps working inside the guest.
nix --extra-experimental-features nix-command \
  copy --no-check-sigs --to "local?root=/rootfs" "$system"

mkdir -p \
  /rootfs/bin \
  /rootfs/boot \
  /rootfs/dev \
  /rootfs/etc/nixos \
  /rootfs/etc/ssh \
  /rootfs/etc/systemd/network \
  /rootfs/home/${LAB_USER} \
  /rootfs/lib/modules \
  /rootfs/nix/var/nix/gcroots \
  /rootfs/nix/var/nix/profiles \
  /rootfs/opt/iximiuz-labs \
  /rootfs/proc \
  /rootfs/root \
  /rootfs/run \
  /rootfs/sbin \
  /rootfs/sys \
  /rootfs/tmp \
  /rootfs/usr/bin \
  /rootfs/usr/local/bin \
  /rootfs/var/empty \
  /rootfs/var/lib/nixos \
  /rootfs/var/log
chmod 0700 /rootfs/root
chmod 1777 /rootfs/tmp

# The VMM boots the kernel without an init= argument, and the kernel's
# default search starts at /sbin/init.
ln -s "$system/init" /rootfs/sbin/init

# System profile + GC root (protects the running system from nix-collect-garbage).
ln -s "$system" /rootfs/nix/var/nix/profiles/system-1-link
ln -s system-1-link /rootfs/nix/var/nix/profiles/system
ln -s /nix/var/nix/profiles /rootfs/nix/var/nix/gcroots/profiles

# Recreated by the first activation; needed until then (e.g., for the
# engine-installed vmm-notifier script's /bin/sh shebang).
ln -s /run/current-system/sw/bin/sh /rootfs/bin/sh
ln -s /run/current-system/sw/bin/env /rootfs/usr/bin/env

cp /build/configuration.nix /build/iximiuz.nix /rootfs/etc/nixos/

# The playground engine resolves machine users at bake time (before the first
# activation ever runs), so /etc/passwd and /etc/group must be materialized in
# the image. The first boot's activation merges these very entries back - keep
# them in sync with iximiuz.nix. Passwords match the other rootfs images
# (root:root, ${LAB_USER}:${LAB_USER}).
cat > /rootfs/etc/passwd <<EOT
root:x:0:0:System administrator:/root:/run/current-system/sw/bin/bash
${LAB_USER}:x:1001:1001:${LAB_USER}:/home/${LAB_USER}:/run/current-system/sw/bin/bash
nobody:x:65534:65534:Unprivileged account:/var/empty:/run/current-system/sw/bin/nologin
EOT
chmod 0644 /rootfs/etc/passwd

cat > /rootfs/etc/group <<EOT
root:x:0:
wheel:x:1:${LAB_USER}
${LAB_USER}:x:1001:
nogroup:x:65534:
EOT
chmod 0644 /rootfs/etc/group

cat > /rootfs/etc/shadow <<EOT
root:\$6\$iximiuzlabs\$E85qVXLN7KnTIlFzD6/PnhOPtdwdDuksSqockAilLrWtb.pYVBszdj6nGkNhISCVyL9PY9kiqJxS4XYNAz1Lg0:1::::::
${LAB_USER}:\$6\$iximiuzlabs\$6GEdpR323MlhKWTIQT7uzTZn5wXUMf0a7wc4cNqNRQ11c0kMQYKSi9RBztHyVGAiARupzCU.CQLmstajkhTxL0:1::::::
nobody:!:1::::::
EOT
chmod 0600 /rootfs/etc/shadow

# A sane default; multi-machine playgrounds get theirs from the engine.
cat > /rootfs/etc/hosts <<EOT
127.0.0.1 localhost
::1 localhost
EOT

# code-server settings (mirrors hack/rootfs/scripts/get-code-server.sh).
ln -s / /rootfs/home/${LAB_USER}/.rootfs
mkdir -p /rootfs/home/${LAB_USER}/.local/share/code-server/User
cat > /rootfs/home/${LAB_USER}/.local/share/code-server/User/settings.json <<EOT
{
  "remote.autoForwardPorts": false,
  "telemetry.telemetryLevel": "off",
  "workbench.colorTheme": "Default Dark Modern",
  "workbench.remote.experimental.showStartListEntry": false,
  "workbench.startupEditor": "none",
  "workbench.statusBar.visible": true,
  "workbench.welcome.experimental.dialog": false,
  "workbench.welcomePage.walkthroughs.openOnInstall": false,
  "workbench.secondarySideBar.defaultVisibility": "hidden",
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/*/**": true,
    "**/.hg/store/**": true,
    "/home/${LAB_USER}/.rootfs/**": true
  }
}
EOT
chown -R 1001:1001 /rootfs/home/${LAB_USER}

echo "SSH_OVER_VSOCK=true" > /rootfs/opt/iximiuz-labs/capabilities

echo "${ROOTFS_RELEASE}" > /rootfs/.rootfs-release
EOF


FROM scratch

ARG LAB_USER

COPY --from=builder /rootfs/ /

COPY examiner* /usr/local/bin/

COPY --chown=1001:1001 100.rootfs-nixos/welcome /home/$LAB_USER/.welcome
