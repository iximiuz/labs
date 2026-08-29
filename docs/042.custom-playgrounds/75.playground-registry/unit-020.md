---
title: Pre-populating the registry and using it in tasks

name: registry-init-tasks
kind: unit
---

## Seeding images at startup

The registry starts empty with every playground run - including restarts of [stopped playgrounds](/docs/playgrounds/persistent-playgrounds)
and runs of playgrounds [saved from a stopped run](/docs/playgrounds/persistent-playgrounds#saving-as-custom).
If your scenario expects certain images to be *in the registry* (as opposed to *in the VM's image store*),
push them from an [init task](/docs/custom-playgrounds/init-tasks). `crane` and `regctl` are preinstalled in the Docker and Kubernetes base images,
and copying straight from a public registry avoids the pull-then-push detour through the local daemon:

```yaml
  initTasks:
    init_seed_registry:
      init: true
      machine: dev-01
      user: laborant
      timeout_seconds: 120
      run: |
        # The registry starts in parallel with the VMs - wait until it answers.
        until curl -s -o /dev/null https://registry.iximiuz.com/v2/; do sleep 1; done

        crane copy ghcr.io/iximiuz/labs/nginx:alpine registry.iximiuz.com/acme/web:v1
        crane copy ghcr.io/iximiuz/labs/alpine:3 registry.iximiuz.com/acme/base:latest
        crane tag registry.iximiuz.com/acme/web:v1 stable
```

If the registry is protected, log in first (the credentials will end up in the task user's `~/.docker/config.json` - see the previous unit):

```yaml
  initTasks:
    init_registry_login:
      init: true
      machine: dev-01
      user: laborant
      run: |
        until curl -s -o /dev/null https://registry.iximiuz.com/v2/; do sleep 1; done
        crane auth login registry.iximiuz.com -u acme -p 's3cr3t'
        docker login registry.iximiuz.com -u acme -p 's3cr3t'
```

For images that should be available *locally* on a machine (not in the registry), prefer baking them into a [custom rootfs](/docs/custom-playgrounds/custom-rootfs) -
that's faster than pulling at startup and survives stop/restart cycles.

## Multi-machine and Kubernetes playgrounds

The registry is shared by all machines of a playground, which makes it the natural hand-off point in "build here, deploy there" setups:
a `dev` machine with Docker builds and pushes, and the cluster nodes pull - no image export/import, no per-node loading.
Nothing needs to be configured on the Kubernetes side: the registry's certificate is publicly trusted and the name resolves on every node.

Keep the [reachability rules](/docs/playgrounds/container-registry#authentication) in mind when designing network topologies:
a machine attached only to `private: true` networks has no route to the registry.
