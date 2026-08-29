---
title: What is registry.iximiuz.com

name: what-is-registry
kind: unit
---

Every playground run comes with its own private container registry, reachable from all of the playground's VMs at `registry.iximiuz.com`.
It's a stock [CNCF Distribution](https://github.com/distribution/distribution) registry - the same `registry` image you would run yourself -
started together with the playground and torn down with it.
No sign-up, no configuration, no rate limits - just push and pull.

A few things the registry is good for:

- **Practicing the image publishing workflow** - build, tag, push, and pull on another machine - without a Docker Hub or GHCR account and without leaking your experiments to a public registry.
- **Multi-machine workflows** - build an image on one VM and run it on the other VMs of the same playground, for instance, deploy it to a Kubernetes cluster whose nodes pull from the registry.
- **Learning how registries work** - it's a real OCI Distribution registry, so you can poke at its `/v2/` API with `curl`, inspect manifests and blobs, or even push an image by hand.
- **Practicing private-registry flows** - `docker login`, credential management, authenticated pulls: custom playgrounds and challenges can put the registry behind a username and password.
- **Testing registry-aware tools** - `crane`, `regctl`, `skopeo`, `oras`, `docker buildx imagetools`, etc. against a registry you fully control.

## Quick start

Start any playground that has a container engine in it (e.g., [Docker](/playgrounds/docker)) and run:

```sh
docker pull ghcr.io/iximiuz/labs/alpine:3
docker tag ghcr.io/iximiuz/labs/alpine:3 registry.iximiuz.com/demo/alpine:v1
docker push registry.iximiuz.com/demo/alpine:v1
```

The image is now in the playground's registry:

```sh
curl https://registry.iximiuz.com/v2/_catalog
```

```text
{"repositories":["demo/alpine"]}
```

...and can be pulled from any machine of the playground:

```sh
docker pull registry.iximiuz.com/demo/alpine:v1
```

## Key facts

| Property | Value |
|---|---|
| **Address** | `https://registry.iximiuz.com` (port `443`); the name resolves to a playground-internal address. |
| **TLS** | A valid, publicly trusted certificate - no `insecure-registries` setting, no custom CA, plain `https://` works out of the box. |
| **Auth** | Anonymous read/write by default; custom playgrounds and challenges may require a `docker login` (see [Authentication](#authentication)). |
| **Scope** | One registry per playground run, shared by all VMs of that playground. |
| **Reachability** | From inside the playground only (see [Reachability](#authentication)). |
| **Lifetime** | Starts empty with every playground (re)start; contents are dropped when the playground is stopped or destroyed. |
| **Implementation** | Stock CNCF Distribution (`registry:3`) - no web UI, no pull-through cache, no per-user namespaces. |
