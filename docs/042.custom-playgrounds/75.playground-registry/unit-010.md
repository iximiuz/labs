---
title: Protecting the registry with credentials

name: registry-auth
kind: unit
---

Every playground run gets a private container registry at `registry.iximiuz.com` - see
[Playground Container Registry](/docs/playgrounds/container-registry) for the user-facing overview (what it is, how to push and pull, what its limits are).
This lesson covers the author's side: what can be configured and why you may want to.

There is exactly one knob - the registry's credentials. Out of the box, the registry accepts anonymous pushes and pulls;
setting `registryAuth` puts it behind a single `username:password` pair, after which **every** request
(pull, push, catalog listing) has to be authenticated.

## Where to set it

In the playground manifest, `registryAuth` is a top-level attribute of the `playground` section:

```yaml [manifest.yaml]
kind: playground
name: private-registry-lab
title: Private Registry Lab
playground:
  registryAuth: acme:s3cr3t
  machines:
    - name: dev-01
      users:
        - name: laborant
          default: true
      drives:
        - source: docker
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

```sh
labctl playground create private-registry-lab --base flexbox -f manifest.yaml
```

The value must contain exactly one colon separating the username from the password (so neither part can contain a `:`).
Leaving the attribute out (or empty) keeps the registry anonymous.

The same setting is available in the Playground Constructor UI: open the playground's settings page (add `/settings` to its URL),
switch to the **Registry** tab, and fill in the **Username:Password** field.

Challenges, tutorials, and course lessons that embed a playground can set the attribute in their own `playground` block, e.g.:

```yaml [index.md (front matter)]
kind: challenge
title: 'Docker 101: Authenticate to Private Container Registries'
playground:
  name: docker
  registryAuth: iximiuzlabs:rules!
```

## What the credentials are (not) hidden from

`registryAuth` is part of the playground manifest and is returned only to the playground owner (it's stripped from what other users see).
However, the credentials are as private as you make them inside the VMs:
a `docker login` performed in an init task leaves them in `~/.docker/config.json`, and an init task's script itself can be visible to a curious learner.
Treat them as scenario data rather than secrets.

There is only one account per registry - no read-only users, no per-repository permissions.
