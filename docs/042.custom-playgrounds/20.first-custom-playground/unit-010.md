---
title: Your first custom playground

name: first-custom-playground
kind: unit
---

The fastest way to get a custom playground is to clone an existing base playground:

```sh
labctl playground create my-first-playground --base ubuntu-24-04
```

```text
Creating playground from default manifest
Playground URL: https://labs.iximiuz.com/playgrounds/my-first-playground-51c9d61a
my-first-playground-51c9d61a
```

::remark-box
The platform appends a unique suffix to the requested name,
and this full name (`my-first-playground-51c9d61a`) is what all subsequent commands expect.
The `--quiet` (`-q`) flag makes `create` print only the full name, which is handy for scripting:

```sh
PLAYGROUND=$(labctl playground create my-first-playground --base ubuntu-24-04 -q)
```
::

That's it - the playground is now listed under your playgrounds (`labctl playground catalog --filter my-custom`),
and you can start it like any other playground:

```sh
labctl playground start $PLAYGROUND --open
```

A clone of the base isn't very interesting on its own, though. The real power comes from customizing it with a manifest.

::remark-box
---
kind: warning
---
Free-tier accounts can have one custom playground at a time; [paid plans](/pricing) lift this limit.
::

## The smallest manifest possible

A playground manifest is a Kubernetes-style YAML document. Here is the smallest fully working example:

```yaml [manifest.yaml]
kind: playground
name: my-first-playground
title: My First Playground
playground:
  machines:
    - name: dev-01
      users:
        - name: laborant
          default: true
      drives:
        - source: ubuntu-24-04
          mount: /
      network:
        interfaces:
          - network: local
  accessControl:
    canList:
      - owner
    canRead:
      - owner
    canStart:
      - owner
```

It defines a single machine with a single drive (the root filesystem built from the `ubuntu-24-04` rootfs image),
a default user, and one network interface on the base's default `local` network.
Every machine needs at least these four attributes - `name`, `users`, `drives`, and `network` -
plus the playground needs a `title` and an `accessControl` section (here: visible and startable only by you).
Everything else is inherited from the base playground or filled in with defaults:
the machine gets an auto-assigned IP address, an automatically computed amount of CPU and RAM,
a `root` user (always present), and the base's default tabs (for `flexbox`, a single terminal).

Create a playground from this manifest by passing the file (or `-` for stdin) to `labctl playground create`:

```sh
labctl playground create my-first-playground --base flexbox -f manifest.yaml
```

```text
Creating playground from /home/you/manifest.yaml
Playground URL: https://labs.iximiuz.com/playgrounds/my-first-playground-fda7ebc1
my-first-playground-fda7ebc1
```

::remark-box
Notice that `--base` is always required - a custom playground is never built from thin air;
it's always a set of overrides applied on top of a base playground.
The most universal base playground is `flexbox` - it's the only base that allows arbitrary machine sets
(any number of VMs, any hostnames, any rootfs images).
All other bases keep their original machines: you can drop some of them and tweak the rest
(resources, welcome messages, networks, etc.), but not add machines or change their names.
::

## Inspect, edit, update

You can dump the effective manifest of any of your playgrounds - including everything it inherited from the base:

```sh
labctl playground manifest my-first-playground-fda7ebc1 > manifest.yaml
```

Now make the playground actually custom. For example, pre-install Nginx with an init task and greet the user with a welcome message.
Edit the dumped manifest to look like this:

```yaml [manifest.yaml]
kind: playground
name: my-first-playground-fda7ebc1
title: Nginx Sandbox
description: An Ubuntu VM with Nginx installed and ready to serve.
categories:
  - linux
playground:
  networks:
    - name: local
      subnet: 172.16.0.0/24
  machines:
    - name: dev-01
      users:
        - name: laborant
          default: true
          welcome: |
            Welcome! Nginx is already running - try `curl localhost`.
      drives:
        - source: ubuntu-24-04
          mount: /
      network:
        interfaces:
          - network: local
  tabs:
    - kind: terminal
      machine: dev-01
  initTasks:
    install_nginx:
      init: true
      machine: dev-01
      user: root
      timeout_seconds: 300
      run: |
        apt-get update
        apt-get install -y nginx
        systemctl enable --now nginx
```

Apply the changes and take the playground for a spin:

```sh
labctl playground update my-first-playground-fda7ebc1 -f manifest.yaml
labctl playground start my-first-playground-fda7ebc1
```

While the playground is starting, a loading screen shows the progress of the init tasks - the environment becomes available only after all of them complete
(more on init tasks in [Init Tasks, Startup Files, and Tabs](/docs/custom-playgrounds/init-tasks-and-tabs)).

::remark-box
---
:kind: warning
---

⚠️ Unlike `create`, the `update` command expects a **complete** manifest - networks, tabs, categories, and access control included.
It's usually a good idea to start from a fresh `labctl playground manifest` dump and edit it, rather than writing an update manifest from scratch.
::

## Iterating

The typical development loop looks like this:

1. Edit `manifest.yaml` (keep it in Git - it's a perfectly versionable piece of infrastructure).
2. `labctl playground update my-first-playground-fda7ebc1 -f manifest.yaml`
3. `labctl playground start my-first-playground-fda7ebc1` and verify the changes.
4. `labctl playground destroy <play-id>` (using the instance ID printed by `start`), and repeat.

The same playground can also be edited in the Playground Constructor UI - add `/settings` to its page URL - and any UI changes will show up in the next `labctl playground manifest` dump.

When a playground has outlived its usefulness, remove it with:

```sh
labctl playground remove my-first-playground-fda7ebc1
```
