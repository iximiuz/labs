---
title: Authentication, reachability, and lifetime

name: authentication
kind: unit
---

## Authentication

By default, the registry is **anonymous**: anyone inside the playground can push and pull without logging in.
(A `docker login registry.iximiuz.com` with made-up credentials still "succeeds" in this mode - the registry simply ignores the credentials.)

Playground authors can put the registry behind a single username/password pair
(see [Configuring the Playground Registry](/docs/custom-playgrounds/playground-registry)).
When that's the case, **every** request - pulls, pushes, and even the `/v2/_catalog` listing - requires HTTP Basic auth, and the usual login commands apply:

```sh
docker login registry.iximiuz.com -u <username> --password-stdin
```

```sh
crane auth login registry.iximiuz.com -u <username> -p <password>
regctl registry login registry.iximiuz.com -u <username> -p <password>
```

```sh
curl -u <username>:<password> https://registry.iximiuz.com/v2/_catalog
```

Where to find the credentials:

- For challenges, tutorials, and shared playgrounds - in the task description or the machine's welcome message (if the author meant for you to know them at all).
- For your own custom playgrounds - on the playground's settings page, under the **Registry** tab, or in the `registryAuth` field of the manifest.

## Reachability

The registry is reachable from any playground VM that has a **default route** - i.e., at least one interface on a non-`private` network.
This is the case for every official playground and for most custom ones.
Machines attached only to [`private` networks](/docs/custom-playgrounds/multi-network-playgrounds) cannot reach the registry.

The registry is **not** reachable from the Internet - `registry.iximiuz.com` resolves to a playground-local address even on public DNS, which is meaningful only inside a playground.
To use it from your laptop, see [Accessing the registry from your local machine](#push-and-pull).

## Lifetime and persistence

The registry storage is **ephemeral** - even more so than the playground VMs themselves:

- Every playground run starts with an **empty** registry.
- [Stopping a playground](/docs/playgrounds/persistent-playgrounds) snapshots the VM drives but **not** the registry:
  after a restart, the images you pulled into the VM's local Docker/containerd store are still there, but the registry is empty again.
- Forked runs inherit the VM drives of the source run, not its registry contents.
- **Destroying** a playground removes the registry together with everything else.

If you need certain images to be present in the registry every time a playground starts, use an init task to (re)populate it,
or bake the images into a [custom rootfs](/docs/custom-playgrounds/custom-rootfs) so they are available locally without a registry roundtrip.
Both approaches are described in [Configuring the Playground Registry](/docs/custom-playgrounds/playground-registry).
