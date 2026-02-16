#!/sbin/openrc-run

mkdir -p /dev/pts
mount -t devpts devpts /dev/pts || exit 0
