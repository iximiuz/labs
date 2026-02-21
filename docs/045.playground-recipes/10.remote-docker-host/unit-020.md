---
title: Using a Playground VM as a Remote Docker Builder

name: remote-docker-builder
kind: unit
---

You can also **use a remote Docker context from the previous unti as a remote Docker builder**:

```sh
docker buildx create --name remote-builder --driver docker-container remote-docker
```

To build a container image using such a remote builder, run:

```sh
docker buildx build --builder remote-builder \
  --push -t registry.iximiuz.com/my-image:latest -f - . <<EOF
FROM alpine:3

RUN echo "Hello, World!" > /hello.txt
EOF
```

The above command will use a local `docker` CLI to trigger a Docker build on the playground VM
(i.e., the playground VM will act as a Docker builder) and push the resulting image to the playground VM's private registry.

To verify that the image is available in the playground VM's private registry, ssh to the playground VM and run:

```sh
ssh remote-docker regctl tag ls registry.iximiuz.com/my-image
```

Alternatively, you cal _load_ the image into your local Docker daemon using the following command:

```sh
docker buildx build --builder remote-builder \
  --load -t my-image:latest -f - . <<EOF
FROM alpine:3

RUN echo "Hello, World!" > /hello.txt
EOF
```
