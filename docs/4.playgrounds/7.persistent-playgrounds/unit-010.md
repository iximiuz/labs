---
title: Preserve your playground progress

name: preserving-progress
kind: unit
---

For a long time, iximiuz Labs playgrounds were fully ephemeral. You'd start a new environment,
perform some tasks in it for up to 8 hours, but eventually, the playground would have to be
terminated and its data completely removed.

While ephemeral playgrounds remain a completely valid (and still dominant) way to use the labs,
since November 2025, it's also possible to save your playground progress and restart it after
lunch the next day, or even after a lengthy vacation.

The playground termination dialog now offers two actions:

- **Stop** - the playground VMs will be terminated, but their drives will be snapshotted and offloaded to a remote storage.
- **Destroy** - the historically only option that completely disposes of the playground's data after terminating the VMs.


::image-box
---
:src: __static__/Persistent-Playgrounds-1.png
:alt: "A new playground starts from a read-only rootfs image, but all modifications to the filesystem are preserved in an overlay volume, which is then snapshotted and offloaded to a remote storage."
---

A new playground starts from a read-only rootfs image, but all modifications to the filesystem are preserved in an overlay volume, which is then snapshotted and offloaded to a remote storage.
::
