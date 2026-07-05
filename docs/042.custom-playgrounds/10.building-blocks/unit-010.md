---
title: The building blocks

name: building-blocks
kind: unit
---

Every playground on iximiuz Labs - from the simplest [Ubuntu sandbox](/playgrounds/ubuntu-24-04) to a multi-node Kubernetes cluster -
is assembled from the same small set of building blocks.
Once you know these blocks, you can mix and match them to produce new playgrounds of arbitrary complexity (or simplicity!):

- **Playground** - the top-level object: a named, reusable template that describes a set of virtual machines, the networks connecting them, and the UI presented to the user. Starting a playground creates a fresh, isolated instance of this template.
- **Machine** - a full-fledged virtual machine (see [What are Playgrounds](/docs/playgrounds/what-are-playgrounds)). A playground can have up to 5 machines, each with its own drives, network interfaces, users, and CPU/RAM resources.
- **Drive** - a virtual block device attached to a machine. The drive mounted at `/` provides the machine's root filesystem (built from a rootfs image), while extra drives can serve as pre-formatted data volumes or raw devices for partitioning practice.
- **Network** - an isolated L2 bridge network with its own IPv4 subnet. Machines join networks via **network interfaces**, and a machine with multiple interfaces can act as a router, gateway, or bastion between networks.
- **Init tasks** - shell scripts that run inside the machines during playground startup, so the environment comes up ready to use (packages installed, services running, files in place).
- **Tabs** - the UI panes of the playground page: terminals, an IDE, exposed HTTP ports, or embedded web pages.

::image-box
---
:src: __static__/Playgrounds-2.0.png
:alt: "iximiuz Labs Playgrounds: multi-network, multi-VM, multi-disk setups with a rich collection of base rootfs images and the ability to bring your own rootfs."
---

iximiuz Labs Playgrounds: multi-network, multi-VM, multi-disk setups with a rich collection of base rootfs images and the ability to bring your own rootfs.
::

Key facts about iximiuz Labs Playgrounds:

- Machines are lightweight microVMs, not containers - they run their own kernels, so Docker, Kubernetes, systemd, iptables, and friends all work without workarounds.
- The kernel is supplied by the platform (you can pick a version), while the root filesystem comes from a rootfs image - either one of the [official images](https://github.com/iximiuz/labs/tree/main/playgrounds) or [your own OCI image](/docs/custom-playgrounds/custom-rootfs).
- If you don't configure something, sensible defaults kick in: a single `local` network shared by all machines, auto-assigned IP addresses, a default `laborant` user, and one terminal tab per machine.

This module walks you through the blocks one by one, starting from the smallest possible playground and gradually working up to
[multi-drive](/docs/custom-playgrounds/multi-drive-vms), [multi-machine](/docs/custom-playgrounds/multi-machine-playgrounds),
and [multi-network](/docs/custom-playgrounds/multi-network-playgrounds) setups.
The concluding [manifest reference](/docs/custom-playgrounds/manifest-reference) describes every configuration field in one place.
