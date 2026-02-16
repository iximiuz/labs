#!/sbin/openrc-run

mkdir -p /sys
mount -t sysfs sysfs /sys || exit 0
