---
title: Pushing and pulling images

name: push-and-pull
kind: unit
---

Because the registry has a proper TLS certificate and a DNS name that resolves in every playground VM,
any registry client works with it out of the box - no daemon flags, no trust store tweaks.
Just prefix the image name with `registry.iximiuz.com/`.

Example:

```sh
docker tag myapp:dev registry.iximiuz.com/myapp:dev
docker push registry.iximiuz.com/myapp:dev
```

If the playground's registry is [protected with credentials](#authentication), you will need to sign in first with:

```sh
docker login -u USERNAME registry.iximiuz.com
```

## Registry CLIs: crane, regctl, skopeo

Copying images between registries without a container engine is often the fastest way to populate the playground registry.
The Docker and Kubernetes playgrounds ship with [`crane`](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) and [`regctl`](https://github.com/regclient/regclient) preinstalled:

```sh
crane copy ghcr.io/iximiuz/labs/nginx:alpine registry.iximiuz.com/demo/nginx:alpine
crane ls registry.iximiuz.com/demo/nginx
```

```sh
regctl image copy ghcr.io/iximiuz/labs/busybox:latest registry.iximiuz.com/demo/busybox:latest
regctl tag ls registry.iximiuz.com/demo/busybox
regctl manifest get registry.iximiuz.com/demo/busybox:latest
```

## Kubernetes

Kubelets on the playground's nodes pull from `registry.iximiuz.com` like from any other public registry - no containerd registry configuration needed.
A typical "build here, run there" loop in a Kubernetes playground looks like this:

```sh [dev-machine]
docker build -t registry.iximiuz.com/demo/web:v1 --push .
```

```sh [dev-machine]
kubectl create deployment web --image registry.iximiuz.com/demo/web:v1
kubectl rollout status deployment web
```

If the playground's registry is [protected with credentials](#authentication), create a pull secret and reference it from the Pod spec (or the default service account):

```sh
kubectl create secret docker-registry regcred \
  --docker-server=registry.iximiuz.com \
  --docker-username=<username> \
  --docker-password=<password>
```

## The registry API

The registry speaks the standard [OCI Distribution API](https://github.com/opencontainers/distribution-spec/blob/main/spec.md),
so `curl` is all you need to explore it:

```sh
# API version check (200 OK means the registry is up)
curl -i https://registry.iximiuz.com/v2/

# List repositories
curl https://registry.iximiuz.com/v2/_catalog

# List tags of a repository
curl https://registry.iximiuz.com/v2/demo/alpine/tags/list
```

## Accessing the registry from your local machine

The registry lives on a playground-internal address, so your laptop's `docker push registry.iximiuz.com/...` won't reach it directly.
Two ways around it:

1. **Push from the playground VM** - the easiest option. If you build locally, set up the VM as a [remote Docker context or builder](/docs/playground-recipes/remote-docker-host)
   and let the VM's Docker daemon do the pushing: `docker buildx build --builder remote-builder --push -t registry.iximiuz.com/myapp:dev .`

2. **Forward the registry port to your machine** with [`labctl port-forward`](/docs/playgrounds/forward-local-ports):

```sh
labctl port-forward <playground-id> -L 127.0.0.1:8443:registry.iximiuz.com:443
```

```sh
curl --resolve registry.iximiuz.com:8443:127.0.0.1 https://registry.iximiuz.com:8443/v2/_catalog
```

The certificate is still valid because the host name stays `registry.iximiuz.com` (the port isn't part of the certificate).
For the Docker CLI, which doesn't have a `--resolve` flag, add `127.0.0.1 registry.iximiuz.com` to your local `/etc/hosts` and use the `registry.iximiuz.com:8443/...` image names.

## Additional resources

Learning materials that use the playground registry:

- 📝 [How Container Registries Work: Pushing and Pulling Images By Hand](https://labs.iximiuz.com/tutorials/container-registry-from-scratch)
- 🏆 [Build and Publish a Container Image With Docker](https://labs.iximiuz.com/challenges/build-and-publish-container-image-with-docker)
- 🏆 [Docker 101: Authenticate to Private Container Registries](https://labs.iximiuz.com/challenges/docker-login-to-private-registries)
- 🏆 [Copy a Container Image from One Repository to Another](https://labs.iximiuz.com/challenges/copy-container-image-from-one-repository-to-another-without-docker)
