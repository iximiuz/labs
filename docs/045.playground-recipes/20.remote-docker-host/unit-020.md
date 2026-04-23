---
title: Using a Playground VM as a Remote Docker Builder

name: remote-docker-builder
kind: unit
---

You can also use a remote Docker context from the [previous unit](#remote-docker-context) as a **remote Docker builder**:

```sh
docker buildx create --name remote-builder --driver docker-container remote-docker
```

To build a container image using such a remote builder and _load_ it into your local Docker daemon, run:

```sh
cat > Dockerfile <<EOF
FROM alpine:3

RUN echo "Hello, World!" > /hello.txt
EOF
```

```sh
docker buildx build --builder remote-builder --load -t my-image:latest .
```

::remark-box
The above command uses a local `docker` CLI to trigger a Docker build on the playground VM
(i.e., the playground VM acts as an image builder).
::

Alternatively, you can __push__ the image to the playground VM's private registry using the following command:

```sh
docker buildx build --builder remote-builder \
    --push -t registry.iximiuz.com/my-image:latest .
```

To verify that the image is available in the playground VM's private registry, run:

```sh
ssh remote-docker regctl tag ls registry.iximiuz.com/my-image
```

```text
latest
```