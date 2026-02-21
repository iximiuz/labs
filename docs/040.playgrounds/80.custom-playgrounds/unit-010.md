---
title: Custom Playgrounds

name: custom-playgrounds
kind: unit
---

iximiuz Labs supports creating custom playgrounds by:

- [Reconfiguring a base playground and/or modifying its filesystem with user-defined init scripts](https://iximiuz.com/en/posts/iximiuz-labs-playgrounds-2.0/)
- Creating a completely new rootfs image (either from scratch or [based on an existing image](https://github.com/iximiuz/labs/tree/main/playgrounds))
- [Saving a running playground with all its rootfs modifications as a new custom playground](/docs/playgrounds/persistent-playgrounds#saving-as-custom)

::image-box
---
:src: __static__/Playgrounds-2.0.png
:alt: "iximiuz Labs Playgrounds: multi-network, multi-VM, multi-disk setups with a rich collection of base rootfs images and the ability to bring your own rootfs."
---

iximiuz Labs Playgrounds: multi-network, multi-VM, multi-disk setups with a rich collection of base rootfs images and the ability to bring your own rootfs.
::

To get started, navigate to the [/new/playground](/new/playground) page and follow the wizard instructions.
For more advanced use cases, you can use the [`labctl`](https://github.com/iximiuz/labctl) CLI tool to create and manage custom playgrounds using Kubernetes-style YAML manifests:

- `labctl playground create` - create a new custom playground
- `labctl playground manifest` - to view the YAML manifest of a custom playground
- `labctl playground update` - to update a custom playground from a YAML manifest

## Additional Resources

- 🎬 [Playgrounds 2.0 - Revamped Constructor UI](https://www.youtube.com/watch?v=gNlQ65frMcs)
- 🎬 [Simplified Linux Playground Constructor](https://www.youtube.com/watch?v=i1NlEx2Xo9g)