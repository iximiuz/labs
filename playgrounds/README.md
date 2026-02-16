# iximiuz Labs' Playground Build Tools and Bake Recipes

A curated collection of Dockerfile-based root filesystem images designed for hands-on learning, experimentation, and development across various technologies and platforms.
These images are used by [iximiuz Labs' base playgrounds](https://labs.iximiuz.com/playgrounds),
and provided here to serve as a reference implementation and an extension point for your own custom playgrounds. You can:

- Use these images as a rootfs sources for your own playgrounds
- Fork, modify, and bake your own images to be used as "external" sources for your custom iximiuz Labs playgrounds
- Base your own custom images `FROM` the official [`ghcr.io/iximiuz/labs/rootfs` images](https://github.com/users/iximiuz/packages/container/package/labs%2Frootfs)

## Overview

This repository contains containerized root filesystems organized into tiers based on complexity and specialization:

- **100-series**: Base operating system images
- **200-series**: Container runtime environments
- **300-series**: Development environments and specialized setups
- **400-series**: Advanced tooling and orchestration platforms

Each image is optimized for educational purposes with pre-installed tools, configurations, and utilities to accelerate learning and experimentation.

## Quick Start

### Build Images Locally

```bash
# Set release version
export RELEASE=private

# Build a specific image
make build-rootfs-ubuntu-24-04

# Build all images in a tier
make base-1xx  # Base OS images
make base-2xx  # Container runtimes
make base-3xx  # Development environments
```

## Available Images

### Base Operating Systems (100-series)

| Image                 | Description                                                    |
| --------------------- | -------------------------------------------------------------- |
| `almalinux`           | AlmaLinux-based environment                                    |
| `alpine`              | Lightweight Alpine Linux                                       |
| `archlinux`           | Arch Linux with typical sysadmin tools                         |
| `debian-stable`       | Debian stable release with typical sysadmin tools              |
| `debian-testing`      | Debian testing release with typical sysadmin tools             |
| `fedora`              | Latest Fedora release with typical sysadmin tools              |
| `kali-linux`          | Kali Linux for security testing with typical sysadmin tools    |
| `opensuse-tumbleweed` | Latest openSUSE tumbleweed with typical sysadmin tools         |
| `rockylinux`          | Rocky Linux enterprise environment with typical sysadmin tools |
| `ubuntu-22-04`        | Ubuntu 22.04 LTS with typical sysadmin tools                   |
| `ubuntu-24-04`        | Ubuntu 24.04 LTS with typical sysadmin tools                   |

### Container Runtimes (200-series)

| Image             | Description                             |
| ----------------- | --------------------------------------- |
| `incus`           | Incus container/VM manager              |
| `nerdctl`         | containerd-native Docker-compatible CLI |
| `podman`          | Podman rootless containers              |
| `ubuntu-docker`   | Ubuntu with Docker engine               |
| `ubuntu-k0s`      | k0s Kubernetes distribution             |
| `ubuntu-k3s-bare` | k3s minimal setup                       |

### Miscellaneous images (300-series and 400-series)

Look at the folder structure for the list of available images.

## Features

### Pre-installed Tools

Each image includes a curated selection of tools:

- **System utilities**: vim, fzf, ripgrep, htop, btop
- **Network tools**: curl, socat, websocat, netcat
- **Development tools**: git, make, build-essential
- **Container tools**: docker, podman, nerdctl (where applicable)
- **Kubernetes tools**: kubectl, k9s, helm (in relevant images)
- **JSON/YAML processors**: fx, jq, yq

### User Environment

- **Lab user**: Pre-configured `laborant` user with sudo privileges
- **SSH access**: Configured for key-based authentication
- **Code editor**: VS Code Server available in development images
- **Shell**: Enhanced bash with completion and aliases

## Build System

The project uses a Makefile-based build system:

### Environment Variables

```bash
export RELEASE=private
export IMAGE_REPOSITORY=your-registry
```

### Build Commands

```bash
# Build individual images
make build-rootfs-<image-name>

# Build by tier
make base-1xx    # All 100-series images
make base-2xx    # All 200-series images
make base-3xx    # All 300-series images
make base-4xx    # All 400-series images

# Build and push all images
make all

# Clean up
make clean-all
```
