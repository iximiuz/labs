# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER
ARG KAMAL_VERSION

USER root
ENV HOME=/root

COPY 300.rootfs-kamal/load-images.sh /opt/iximiuz-labs/load-images.sh
COPY 300.rootfs-kamal/image-load.service /etc/systemd/system/image-load.service

RUN <<EOR
set -eu

crane pull ghcr.io/basecamp/kamal:v${KAMAL_VERSION} /opt/iximiuz-labs/kamal

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /etc/systemd/system/image-load.service /etc/systemd/system/multi-user.target.wants/
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 300.rootfs-kamal/welcome $HOME/.welcome

COPY --chown=$LAB_USER:$LAB_USER 300.rootfs-kamal/ssh-agent.service \
    $HOME/.config/systemd/user/ssh-agent.service

RUN <<EOR
set -eu

mkdir -p $HOME/.config/systemd/user/default.target.wants

ln -s $HOME/.config/systemd/user/ssh-agent.service \
    $HOME/.config/systemd/user/default.target.wants/ssh-agent.service

systemctl --user enable $HOME/.config/systemd/user/ssh-agent.service

# Update .bashrc with necessary SSH environment setup
echo '' >> $HOME/.bashrc
echo 'export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"' >> $HOME/.bashrc
echo '' >> $HOME/.bashrc
echo 'ssh-add < /dev/null > /dev/null 2>&1' >> $HOME/.bashrc

echo '' >> $HOME/.bashrc
echo "export KAMAL_VERSION=${KAMAL_VERSION}" >> $HOME/.bashrc

# Add alias for kamal
cat <<'EOF' >> $HOME/.bashrc

alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "${SSH_AUTH_SOCK:-/run/host-services/ssh-auth.sock}:/run/host-services/ssh-auth.sock" -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/basecamp/kamal:v${KAMAL_VERSION}'
EOF
EOR

COPY --chown=$LAB_USER:$LAB_USER 300.rootfs-kamal/svc-a $HOME/svc-a

RUN <<EOR
set -eu

git config --global user.email "$LAB_USER@labs.iximiuz.com"
git config --global user.name "$LAB_USER"
git config --global init.defaultBranch main

cd $HOME/svc-a

git init
git add .
git commit -m 'initial'
EOR
