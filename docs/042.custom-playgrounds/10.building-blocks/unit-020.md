---
title: Ways to create a custom playground

name: creation-methods
kind: unit
---

There are three ways to create a custom playground on iximiuz Labs:

- **YAML manifests + `labctl`** - describe the playground in a Kubernetes-style manifest and manage it from the command line. This is the most powerful and reproducible approach, and it's what this module focuses on.
- **The Playground Constructor UI** - navigate to [/new/playground](/new/playground) and follow the wizard. The constructor covers the same building blocks in a point-and-click fashion.
- **Saving a running playground** - start a playground, install and configure whatever you need, then [save the stopped instance as a new custom playground](/docs/playgrounds/persistent-playgrounds#saving-as-custom) with all filesystem modifications preserved.

The three methods can be used together: for example, you can bootstrap a playground in the UI, then dump its manifest with `labctl` and keep evolving it in Git.

## The manifest + labctl workflow

Every custom playground is derived from a **base playground** - one of the official environments such as `ubuntu-24-04`, `docker`, `k3s`, or the "blank canvas" multi-VM [flexbox](/playgrounds/flexbox).
The base provides the defaults (machines, networks, UI tabs), and your manifest overrides the parts you want to change.

The choice of the base also determines how far the customization can go:

- **`flexbox`** is the only base that allows a fully arbitrary set of machines - any number of VMs (up to 5), any hostnames, any rootfs per machine. Use it whenever you're designing a topology from scratch.
- **All other bases** keep their original machine set: you can drop machines (use a subset) and tweak the remaining ones - resources, users, welcome messages, extra drives, networks, tabs, init tasks - but you can't add or rename machines (e.g., an `ubuntu-24-04`-based playground always has the `ubuntu-01` machine) or change the machine's rootfs drive completely.

The core commands (see [How to Use Playgrounds](/docs/playgrounds/how-to-use-playgrounds#cli) for installing and authenticating `labctl`):

```sh
labctl playground catalog --filter base    # list available base playgrounds
labctl playground create <name> --base <base> [-f manifest.yaml]
labctl playground manifest <name>          # dump the YAML manifest of a playground
labctl playground update <name> -f manifest.yaml
labctl playground start <name>
labctl playground remove <name>            # delete a playground you authored
```

::remark-box
A handy trick: `labctl playground manifest` works for any playground on the platform, so you can peek at how existing playgrounds are put together and borrow the ideas -
the same information is also available by adding `/settings` to a playground's URL in the browser.
::

## Additional Resources

- 🎬 [Playgrounds 2.0 - Revamped Constructor UI](https://www.youtube.com/watch?v=gNlQ65frMcs)
- 🎬 [Simplified Linux Playground Constructor](https://www.youtube.com/watch?v=i1NlEx2Xo9g)
- 📝 [iximiuz Labs Playgrounds 2.0 announcement](https://iximiuz.com/en/posts/iximiuz-labs-playgrounds-2.0/)
